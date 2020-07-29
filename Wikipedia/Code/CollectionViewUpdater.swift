import Foundation

protocol CollectionViewUpdater: NSObjectProtocol {
    var isGranularUpdatingEnabled: Bool { get set }
    var isSpringAnimationEnabled: Bool { get set }
    var delegate: CollectionViewUpdaterDelegate? { get set }
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
