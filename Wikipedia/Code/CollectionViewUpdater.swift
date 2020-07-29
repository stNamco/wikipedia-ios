import Foundation

protocol CollectionViewUpdater: NSObjectProtocol {
    /// When isGranularUpdatingEnabled is set to false, individual updates won't be animated on the collection view
    var isGranularUpdatingEnabled: Bool { get set }
    
    /// When isSpringAnimationEnabled is set to true, a spring animation block will wrap collection view animations
    var isSpringAnimationEnabled: Bool { get set }
    
    /// The CollectionViewUpdaterDelegate is notified of changes applied by this CollectionViewUpdater
    var delegate: CollectionViewUpdaterDelegate? { get set }
    
    /// performFetch performs the initial fetch of data
    func performFetch()
}

protocol CollectionViewUpdaterDelegate: NSObjectProtocol {
    func collectionViewUpdater(_ updater: CollectionViewUpdater, willUpdate collectionView: UICollectionView)
    func collectionViewUpdater(_ updater: CollectionViewUpdater, didUpdate collectionView: UICollectionView)
}

extension CollectionViewUpdaterDelegate {
    func collectionViewUpdater(_ updater: CollectionViewUpdater, willUpdate collectionView: UICollectionView) {
        
    }
    
    func collectionViewUpdater(_ updater: CollectionViewUpdater, didUpdate collectionView: UICollectionView) {
        
    }
}
