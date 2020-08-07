import UIKit

class DateHeaderReusableView: UICollectionReusableView {

    let relativeDateLabel: UILabel = {
        return UILabel()
    }()

    let absoluteDateLabel: UILabel = {
        return UILabel()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [relativeDateLabel, absoluteDateLabel].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })

        NSLayoutConstraint.activate([
            relativeDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            relativeDateLabel.bottomAnchor.constraint(equalTo: absoluteDateLabel.topAnchor, constant: -10),
            absoluteDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            relativeDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            relativeDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            absoluteDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            absoluteDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
        ])

        relativeDateLabel.font = UIFont.wmf_font(.semiboldSubheadline)
        absoluteDateLabel.font = UIFont.wmf_font(.subheadline)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
