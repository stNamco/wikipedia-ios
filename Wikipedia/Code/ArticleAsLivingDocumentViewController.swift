import UIKit

@available(iOS 13.0, *)
class ArticleAsLivingDocumentViewController: ColumnarCollectionViewController {

    enum LivingDocType: CaseIterable {
        case header, reference, newDiscussion, smallChange, charactersAdded, vandalismReverted
    }

    let articleHeaderReuseIdentifier = "ArticleHeader"
    let cellReuseIdentifier = "BasicArticleCell"
    let dateHeaderReuseIdentifier = "DateHeader"
    lazy var dataSource: UICollectionViewDiffableDataSource = createDataSource()

    override init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        startNetworkRequestAndActivityIndicator()
        configureLayout()
        collectionView.dataSource = dataSource
        addMockData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = WMFLocalizedString("recent-changes", value: "Recent changes", comment: "Title of modal view showing recent article changes")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
    }

    private func configureLayout() {
        collectionView.register(UINib(nibName: "ArticleAsLivingDocHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: articleHeaderReuseIdentifier)
        collectionView.register(UINib(nibName: "BasicLivingDocCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: dateHeaderReuseIdentifier)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let cellSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
            let item = NSCollectionLayoutItem(layoutSize: cellSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: cellSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        })
    }

    private func startNetworkRequestAndActivityIndicator() {
        // start activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        collectionView.wmf_addSubviewWithConstraintsToEdges(activityIndicator)
        activityIndicator.startAnimating()

        // maybe should move this to the main ViewController class for reuse? - used in my lead image peek/pop that is yet to be merged

        let completion: ((Data?, URLResponse?, Error?) -> Void) = { _, _, _ in
            // remove activity indicator when it resumes
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
            }
        }

        // make network request
        let fakeRequest = Session.shared.request(with: URL(string: "http://www.duckduckgo.com")!, method: .get)
        let fakeTask = Session.shared.dataTask(with: fakeRequest, completionHandler: completion)
        fakeTask?.resume()
    }

    @objc func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

    private func createDataSource() -> UICollectionViewDiffableDataSource<LivingDocType, String> {
        let cellProvider: ((UICollectionView, IndexPath, String) -> UICollectionViewCell) = { (collectionView, indexPath, title) in
            let sectionData = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            // TODO: change this to be a header, not a cell. :facepalm:
            if sectionData == .header, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.articleHeaderReuseIdentifier, for: indexPath) as? ArticleAsLivingDocHeaderCollectionViewCell {
                return cell
            }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as? BasicLivingDocCollectionViewCell else {
                assertionFailure("Could not dequeue cell for collectionView")
                return UICollectionViewCell()
            }
            cell.timelineView.extendTimelineAboveDot = (indexPath.row != 0)
            return cell
        }
        let dataSource = UICollectionViewDiffableDataSource<LivingDocType, String>(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = { collectionView, type, indexPath in
            let sectionData = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]

            // Remove this after change header from cell to view.
//            if sectionData == .header {
//                return nil
//            }

            guard type == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.dateHeaderReuseIdentifier, for: indexPath) as? CollectionViewHeader else {
              return nil
            }
            header.title = "Yesterday"
            header.subtitle = "December 7, 1941"
            header.style = .explore
            return header
        }
        return dataSource
    }

    private func addMockData() {
        var snapshot = NSDiffableDataSourceSnapshot<LivingDocType, String>()
        snapshot.appendSections(LivingDocType.allCases)
        LivingDocType.allCases.forEach({
            if $0 != .header {
                snapshot.appendItems(["Test1\($0.hashValue)","Test2\($0.hashValue)","Test3\($0.hashValue)"], toSection: $0)
            } else {
                snapshot.appendItems(["Test1"], toSection: $0)
            }
        })

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
