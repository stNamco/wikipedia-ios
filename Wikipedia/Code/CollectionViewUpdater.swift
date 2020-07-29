import Foundation

public protocol CollectionViewUpdater: NSObjectProtocol {
    /// When isGranularUpdatingEnabled is set to false, individual updates won't be animated on the collection view
    var isGranularUpdatingEnabled: Bool { get set }
    
    /// When isSpringAnimationEnabled is set to true, a spring animation block will wrap collection view animations
    var isSpringAnimationEnabled: Bool { get set }
    
    /// The CollectionViewUpdaterDelegate is notified of changes applied by this CollectionViewUpdater
    var delegate: CollectionViewUpdaterDelegate? { get set }
    
    /// performFetch performs the initial fetch of data
    func performFetch()
}

public protocol CollectionViewUpdaterDelegate: NSObjectProtocol {
    func collectionViewUpdater(_ updater: CollectionViewUpdater, willUpdate collectionView: UICollectionView)
    func collectionViewUpdater(_ updater: CollectionViewUpdater, didUpdate collectionView: UICollectionView)
}

public func CollectionViewUpdaterForTheCurrentPlatform<T>(with fetchedResultsController: NSFetchedResultsController<T>, collectionView: UICollectionView, dataSource: UICollectionViewDataSource) -> CollectionViewUpdater {
    if #available(iOS 13, *) {
        return ModernCollectionViewUpdater(fetchedResultsController: fetchedResultsController, collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) in
            return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
        }, supplementaryViewProvider: {  (collectionView, kind, indexPath) in
            return dataSource.collectionView?(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        })
    } else {
        return LegacyCollectionViewUpdater(fetchedResultsController: fetchedResultsController, collectionView: collectionView)
    }
}

public extension CollectionViewUpdaterDelegate {
    func collectionViewUpdater(_ updater: CollectionViewUpdater, willUpdate collectionView: UICollectionView) {
        
    }
    
    func collectionViewUpdater(_ updater: CollectionViewUpdater, didUpdate collectionView: UICollectionView) {
        
    }
}
