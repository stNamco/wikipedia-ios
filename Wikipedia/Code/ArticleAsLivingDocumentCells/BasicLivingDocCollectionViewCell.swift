import UIKit

//class TimelineView: UIView {
//
//    var horizontalMiddleOfView: CGFloat {
//        return frame.midX
//    }
//    var topOfView: CGFloat {
//        return frame.minY
//    }
//    var bottomOfView: CGFloat {
//        return frame.maxY
//    }
//
//    let middleOfTimestampLabel: CGFloat = 30.0
//
//    private let lineColor = UIColor.red
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        UIColor.white.setFill() // need to update this to theme
//        UIRectFill(rect)
//
//        drawLine()
//        drawDot()
//    }
//
//    func drawLine() {
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: horizontalMiddleOfView, y: topOfView))
//        path.addLine(to: CGPoint(x: horizontalMiddleOfView, y: bottomOfView))
//        lineColor.setStroke()
//        path.lineWidth = 3.0
//        path.stroke()
//    }
//
//    func drawDot() {
//        let circleDiameter: CGFloat = 15
//        let rect = CGRect(x: horizontalMiddleOfView - (circleDiameter/2.0), y: middleOfTimestampLabel - (circleDiameter/2.0), width: circleDiameter, height: circleDiameter)
//        let circle = UIBezierPath(ovalIn: rect)
//        lineColor.setFill()
//        circle.fill()
//    }
//}

class BasicLivingDocCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timelineView: TimelineView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var snippetTitleButton: UIButton!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var snippetHolderView: UIView!
    @IBOutlet weak var editorButton: UIButton!
    @IBOutlet weak var actionChipsView: UIView!

    override func awakeFromNib() {
        snippetTitleButton.titleLabel?.numberOfLines = 0
        editorButton.titleLabel?.numberOfLines = 0

        timelineView.timelineColor = .systemGreen // UPDATE THIS TO THEME LATER ON
        timelineView.backgroundColor = .white // UPDATE THIS TO THEME LATER ON
        timelineView.verticalLineWidth = 1.75
        timelineView.decoration = .squiggle
        timelineView.dotsY = 40

        super.awakeFromNib()
    }

    override func layoutSubviews() {
        timelineView.dotsY = timestampLabel.convert(timestampLabel.bounds, to: timelineView).midY
        super.layoutSubviews()
    }

    override public func layoutSublayers(of layer: CALayer) {
        timelineView.dotsY = timestampLabel.convert(timestampLabel.bounds, to: timelineView).midY
        super.layoutSublayers(of: layer)
    }
}
