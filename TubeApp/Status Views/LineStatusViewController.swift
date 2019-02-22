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

    let networkService: NetworkService

    init(service: NetworkService) {
        self.networkService = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("live.status", comment: "")
        
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

        if let savedState = readSavedLineState() {
            self.currentLineStatus = savedState.lineStatus
            self.lastUpdatedTime = savedState.lastUpdatedTimestamp
        }

        fetchUpdateFromNetwork(completion: nil)
    }
    
    @objc func reloadStatus() {

        fetchUpdateFromNetwork(completion: {
            self.tubeLineCollectionView?.refreshControl?.endRefreshing()
        })
    }

    func fetchUpdateFromNetwork(completion: (() -> Void)?) {

        networkService.update(completion: { (status, updateTime) in

            guard let updatedStatus = self.sortedLineArray(status), let updateTime = updateTime else {
                print("Status update returned empty status / timestamp")
                return
            }

            self.currentLineStatus = updatedStatus
            self.lastUpdatedTime = updateTime
            self.save(linesState: updatedStatus, forTimestamp: updateTime)

            DispatchQueue.main.async {
                self.tubeLineCollectionView?.reloadData()
                completion?()
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
        cell?.lineStatusIcon?.image = line.status == String(.goodService) ? UIImage(named: "GoodService") : UIImage(named: "Warning")
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

// MARK: - Gesture Recognizer Functions
extension LineStatusViewController {

    @IBAction func editLineOrder(_ sender: UILongPressGestureRecognizer) {

        switch sender.state {
        case .began:
            let location = sender.location(in: tubeLineCollectionView)
            guard let selectedPath = tubeLineCollectionView?.indexPathForItem(at: location) else {
                break
            }
            tubeLineCollectionView?.beginInteractiveMovementForItem(at: selectedPath)
        case .changed:
           let location = sender.location(in: tubeLineCollectionView)
           tubeLineCollectionView?.updateInteractiveMovementTargetPosition(location)
        case .ended:
            tubeLineCollectionView?.endInteractiveMovement()
        default:
            tubeLineCollectionView?.cancelInteractiveMovement()
        }

    }
}
