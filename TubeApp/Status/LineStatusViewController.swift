//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import UIKit

class LineStatusViewController: UIViewController {
    
    @IBOutlet var tubeLineCollectionView: UICollectionView?
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout?

    let cellIdentifier = "tubeLineCellIdentifier"
    var currentLineStatus: [Line]?
    var lastUpdatedTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Live Status"
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadStatus), for: .valueChanged)
        tubeLineCollectionView?.refreshControl = refreshControl
        
        let collectionViewNib = UINib(nibName: "LineStatusCollectionViewCell", bundle: nil)
        tubeLineCollectionView?.register(collectionViewNib, forCellWithReuseIdentifier: cellIdentifier)
        
        tubeLineCollectionView?.delegate = self
        tubeLineCollectionView?.dataSource = self
        
        let cellSize = UIScreen.main.bounds.width / 3
        collectionViewFlowLayout?.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionViewFlowLayout?.minimumLineSpacing = 0
        collectionViewFlowLayout?.minimumInteritemSpacing = 0

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(changeLineOrder(gesture:)))
        tubeLineCollectionView?.addGestureRecognizer(longPressGesture)

        let savedState = readSavedLineState()
        self.currentLineStatus = savedState?.lineStatus
        self.lastUpdatedTime = savedState?.lastUpdatedTimestamp

        LineStatusFetcher.update(completion: { (status, updateTime) in

            guard let updatedStatus = self.sortedLineArray(status), let updateTime = updateTime else {
                print("Status update returned empty status")
                if self.currentLineStatus == nil {
                    // show error screen?
                }
                return
            }

            self.currentLineStatus = updatedStatus
            self.lastUpdatedTime = updateTime
            self.save(linesState: updatedStatus, forTimestamp: updateTime)

            DispatchQueue.main.async {
                self.tubeLineCollectionView?.reloadData()
            }
        })
    }
    
    @objc func reloadStatus() {
        tubeLineCollectionView?.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        LineStatusFetcher.update(completion: { (status, updateTime) in

            guard let updatedStatus = self.sortedLineArray(status), let updateTime = updateTime else {
                print("Status update returned empty status / timestamp")
                return
            }

            self.currentLineStatus = updatedStatus
            self.lastUpdatedTime = updateTime
            self.save(linesState: updatedStatus, forTimestamp: updateTime)

            DispatchQueue.main.async {
                self.tubeLineCollectionView?.reloadData()
                self.tubeLineCollectionView?.refreshControl?.endRefreshing()
                self.tubeLineCollectionView?.refreshControl?.attributedTitle = NSAttributedString(string:"Last Updated: \(updateTime)")
            }
        })
    }

    func save(linesState state: [Line], forTimestamp lastUpdated: Date) {
        let saveState = LinesState(withStatus: state, timestamp: lastUpdated)
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: saveState)
        UserDefaults.standard.set(encodedObject, forKey: "savedState")
        UserDefaults.standard.synchronize()
    }

    func readSavedLineState() -> LinesState? {
        guard let encodedObject = UserDefaults.standard.object(forKey: "savedState") as? Data else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: encodedObject) as? LinesState
    }

    @objc func changeLineOrder(gesture: UILongPressGestureRecognizer) {

        switch gesture.state {
        case .began:

            guard let selectedPath = tubeLineCollectionView?.indexPathForItem(at: gesture.location(in: tubeLineCollectionView)) else {
                break
            }

            tubeLineCollectionView?.beginInteractiveMovementForItem(at: selectedPath)
        case .changed:
            tubeLineCollectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: tubeLineCollectionView))
        case .ended:
            tubeLineCollectionView?.endInteractiveMovement()
        default:
            tubeLineCollectionView?.cancelInteractiveMovement()
        }
    }

    func sortedLineArray(_ unsortedStatus: [Line]?) -> [Line]? {
        guard let currentSortedStatus = currentLineStatus else {
            return unsortedStatus
        }

        let lineOrder = currentSortedStatus.map { $0.name }

        var sortedArray = [Line]()

        for line in lineOrder {
            if let lineinfo = unsortedStatus?.first(where: { $0.name == line }) {
                sortedArray.append(lineinfo)
            }
        }

        return sortedArray
    }

}

// MARK: - Collection view delegate
extension LineStatusViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentLineStatus?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let line = currentLineStatus?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        let cell = tubeLineCollectionView?.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? LineStatusCollectionViewCell
        cell?.lineNameLabel?.attributedText = NSAttributedString(string: line.name)
        cell?.lineStatusLabel?.text = line.status
        cell?.lineStatusIcon?.image = line.status == "Good Service" ? UIImage(named: "GoodService") : UIImage(named: "Warning")
        cell?.backgroundColor = TubeLineColors(rawValue: line.name.lowercased())?.value
        
        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let line = currentLineStatus?[indexPath.row] else {
            return
        }

        let lineInfoViewController = LineInfoViewController(line: line)
        lineInfoViewController.modalPresentationStyle = .overCurrentContext
        lineInfoViewController.modalTransitionStyle = .crossDissolve
        present(lineInfoViewController, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        guard let movedLine = currentLineStatus?.remove(at: sourceIndexPath.row) else {
            return
        }

        currentLineStatus?.insert(movedLine, at: destinationIndexPath.row)

        if let currentState = currentLineStatus, let timestamp = lastUpdatedTime {
            save(linesState: currentState, forTimestamp: timestamp)
        }
    }
}
