import UIKit

class ArticleAsLivingDocHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var countsLabel: UILabel!
    @IBOutlet weak var sparkLine: WMFSparklineView!
    @IBOutlet weak var viewFullArticleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.font = UIFont.wmf_font(.semiboldSubheadline, compatibleWithTraitCollection: traitCollection)
        pageTitleLabel.font = UIFont.wmf_font(.boldTitle1, compatibleWithTraitCollection: traitCollection)
        countsLabel.font = UIFont.wmf_font(.subheadline, compatibleWithTraitCollection: traitCollection)
    }

}
