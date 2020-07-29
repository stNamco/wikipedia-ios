/// ModernCollectionViewUpdater handles UICollectionView updates via NSDiffableDataSourceSnapshots
@available(iOS 13, *)
class ModernCollectionViewUpdater<T: NSFetchRequestResult>: NSObject, CollectionViewUpdater, NSFetchedResultsControllerDelegate {
    var delegate: CollectionViewUpdaterDelegate?
    var isGranularUpdatingEnabled: Bool = true
    var isSpringAnimationEnabled: Bool = false
    private let collectionView: UICollectionView
    let fetchedResultsController: NSFetchedResultsController<T>
    let diffableDataSourceReference: UICollectionViewDiffableDataSourceReference
    
    required init(fetchedResultsController: NSFetchedResultsController<T>,
                  collectionView: UICollectionView,
                  cellProvider: @escaping UICollectionViewDiffableDataSourceReferenceCellProvider,
                  supplementaryViewProvider: @escaping UICollectionViewDiffableDataSourceReferenceSupplementaryViewProvider) {
        self.fetchedResultsController = fetchedResultsController
        self.collectionView = collectionView
        self.diffableDataSourceReference = UICollectionViewDiffableDataSourceReference(collectionView: collectionView, cellProvider: cellProvider)
        self.diffableDataSourceReference.supplementaryViewProvider = supplementaryViewProvider
        super.init()
        self.fetchedResultsController.delegate = self
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        delegate?.collectionViewUpdater(self, willUpdate: collectionView)
        if isGranularUpdatingEnabled {
            if isSpringAnimationEnabled {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                    self.diffableDataSourceReference.applySnapshot(snapshot, animatingDifferences: true)
                })
            } else {
                diffableDataSourceReference.applySnapshot(snapshot, animatingDifferences: true)
            }
        } else {
            collectionView.reloadData()
        }
        delegate?.collectionViewUpdater(self, didUpdate: collectionView)
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            assert(false)
            DDLogError("Error fetching \(String(describing: fetchedResultsController.fetchRequest.predicate)) for \(String(describing: self.delegate)): \(error)")
        }
    }
}
