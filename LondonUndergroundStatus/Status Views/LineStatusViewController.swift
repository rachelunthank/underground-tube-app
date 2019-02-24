//
//  Copyright © 2019 rachelunthank. All rights reserved.
//

import UIKit
import RealmSwift

class LineStatusViewController: UIViewController {

    @IBOutlet var tubeLineCollectionView: UICollectionView!
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var statusToolbar: UIToolbar!

    var lastUpdatedToolbarItem: UIBarButtonItem?

    let cellIdentifier = "tubeLineCellIdentifier"

    var latestLineStates: List<LineState>?
    var lastUpdated: Date? {
        didSet {
            updateLastUpdatedToolbar(with: lastUpdated)
        }
    }

    let networkService: NetworkService
    let storageService: StorageInteractor

    var lineOrder: [String]? {
        return UserDefaults.standard.object(forKey: "lineOrder") as? [String]
    }

    init(service: NetworkService, storage: StorageInteractor) {
        self.networkService = service
        self.storageService = storage
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
        tubeLineCollectionView.refreshControl = refreshControl

        configureToolbar()

        let collectionViewNib = UINib(nibName: "LineStatusCollectionViewCell", bundle: nil)
        tubeLineCollectionView.register(collectionViewNib, forCellWithReuseIdentifier: cellIdentifier)

        tubeLineCollectionView.delegate = self
        tubeLineCollectionView.dataSource = self

        let cellSize = UIScreen.main.bounds.width / 3
        collectionViewFlowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0

        if let savedState = storageService.readFromStorage() {
            self.latestLineStates = savedState.lineStates
            self.lastUpdated = savedState.lastUpdated
       }

        fetchUpdateFromNetwork(completion: nil)
    }

    @objc func reloadStatus() {

        fetchUpdateFromNetwork(completion: {

            DispatchQueue.main.async {
                self.tubeLineCollectionView.refreshControl?.endRefreshing()
            }
        })
    }

    func fetchUpdateFromNetwork(completion: (() -> Void)?) {

        networkService.update(completion: { (lines) in

            guard let lineStates = lines else {
                completion?()
                return
            }
            self.storageService.saveToStorage(lines: lineStates,
                                              lastUpdated: Date())

            DispatchQueue.main.async {

                if let savedState = self.storageService.readFromStorage() {
                    self.latestLineStates = savedState.lineStates
                    self.lastUpdated = savedState.lastUpdated
                }

                self.tubeLineCollectionView.reloadData()
                completion?()
            }
        })

    }
}

// MARK: - Collection view delegate
extension LineStatusViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestLineStates?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let lineIdentifier = lineOrder?[indexPath.row],
            let line = latestLineStates?.first(where: { $0.identifier == lineIdentifier }) else {
            return UICollectionViewCell()
        }

        let cell = tubeLineCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                               for: indexPath) as? LineStatusCollectionViewCell
        cell?.lineNameLabel?.attributedText = NSAttributedString(string: line.name)
        let status = line.serviceStatus

        cell?.lineStatusLabel?.text = status
        let goodStatus = status == "Good Service"
        cell?.lineStatusIcon?.image = goodStatus ? UIImage(named: "GoodService") : UIImage(named: "Warning")
        cell?.backgroundColor = TubeLineColors(rawValue: line.identifier)?.value

        return cell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let lineIdentifier = lineOrder?[indexPath.row],
            let line = latestLineStates?.first(where: { $0.identifier == lineIdentifier }) else {
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

    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {

        var newLineOrder = lineOrder
        guard let movedLine = newLineOrder?.remove(at: sourceIndexPath.row) else { return }
        newLineOrder?.insert(movedLine, at: destinationIndexPath.row)

        UserDefaults.standard.set(newLineOrder, forKey: "lineOrder")
    }
}

// MARK: - Gesture Recognizer Functions
extension LineStatusViewController {

    @IBAction func editLineOrder(_ sender: UILongPressGestureRecognizer) {

        switch sender.state {
        case .began:
            let location = sender.location(in: tubeLineCollectionView)
            guard let selectedPath = tubeLineCollectionView.indexPathForItem(at: location) else {
                break
            }
            tubeLineCollectionView.beginInteractiveMovementForItem(at: selectedPath)
        case .changed:
           let location = sender.location(in: tubeLineCollectionView)
           tubeLineCollectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            tubeLineCollectionView.endInteractiveMovement()
        default:
            tubeLineCollectionView.cancelInteractiveMovement()
        }
    }
}

extension LineStatusViewController {

    func configureToolbar() {

        lastUpdatedToolbarItem = UIBarButtonItem(title: String(.lastUpdated),
                                                 style: .plain,
                                                 target: nil,
                                                 action: nil)

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .light)]
        lastUpdatedToolbarItem?.setTitleTextAttributes(attributes, for: [.normal])
        lastUpdatedToolbarItem?.tintColor = UIColor.black

        let spacingButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)

        guard let toolbarItem = lastUpdatedToolbarItem else { return }

        statusToolbar.items = [spacingButtonItem, toolbarItem, spacingButtonItem]
    }

    func updateLastUpdatedToolbar(with lastUpdated: Date?) {

        guard let lastUpdatedString = lastUpdated?.timeElapsedSinceDate() else { return }
        lastUpdatedToolbarItem?.title = lastUpdatedString
    }
}
