
import UIKit

//TODO:
// - add "Try to keep descriptions short so users can understand the article's subject at a glance"
// - remove testing didReceiveMemoryWarning triggers here and in other VCs
// - toggle placeholder label visibility when description field empty? or instead just set its text to placeholder text, and if text is placeholder text make its color change AND make giving it focus clear the text?


class DescriptionEditViewController: WMFScrollViewController, Themeable, UITextViewDelegate {
    @objc var article: WMFArticle? = nil

    private lazy var whiteSpaceNormalizationRegex: NSRegularExpression? = {
        guard let regex = try? NSRegularExpression(pattern: "\\s+", options: []) else {
            assertionFailure("Unexpected failure to create regex")
            return nil
        }
        return regex
    }()

    
    
override func didReceiveMemoryWarning() {
    guard view.superview != nil else {
        return
    }
    dismiss(animated: true, completion: nil)
}
    

    public func textViewDidChange(_ textView: UITextView) {
        guard let username = descriptionTextView.text else{
            enableProgressiveButton(false)
            return
        }
        if let text = descriptionTextView.text, let whiteSpaceNormalizationRegex = whiteSpaceNormalizationRegex {
            descriptionTextView.text = whiteSpaceNormalizationRegex.stringByReplacingMatches(in: text, options: [], range: NSMakeRange(0, text.count), withTemplate: " ")
        }
        enableProgressiveButton(username.count > 0)
    }

    @IBOutlet private var learnMoreButton: UIButton!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var descriptionTextView: UITextView! //ThemeableTextField!
    @IBOutlet private var orLabel: UILabel!
    @IBOutlet private var divider: UIView!

    @IBOutlet private var resetPasswordButton: WMFAuthButton!

    private var theme = Theme.standard
/*
    let tokenFetcher = WMFAuthTokenFetcher()
    let passwordResetter = WMFPasswordResetter()
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"close"), style: .plain, target:self, action:#selector(closeButtonPushed(_:)))
        navigationItem.leftBarButtonItem?.accessibilityLabel = CommonStrings.closeButtonAccessibilityLabel

//      descriptionTextView.placeholder = WMFLocalizedString("field-username-placeholder", value:"enter username", comment:"Placeholder text shown inside username field until user taps on it")
        resetPasswordButton.setTitle(WMFLocalizedString("description-edit-publish", value:"Publish description", comment:"Title for publish description button"), for: .normal)
        orLabel.text = WMFLocalizedString("forgot-password-username-or-email-title", value:"Or", comment:"Title shown between the username and email text fields. User only has to specify either username \"Or\" email address\n{{Identical|Or}}")
        
        learnMoreButton.setTitle(WMFLocalizedString("description-edit-learn-more", value:"Learn more", comment:"Title text for description editing learn more button"), for: .normal)
        title = WMFLocalizedString("description-edit-title", value:"Edit description", comment:"Title text for description editing screen")

        view.wmf_configureSubviewsForDynamicType()
        apply(theme: theme)
        
        if let existingDescription = article?.wikidataDescription {
          descriptionTextView.text = existingDescription
        }
    }
    
    private var titleDescriptionFor: NSAttributedString {
        let formatString = WMFLocalizedString("description-edit-for-article", value: "Title description for %1$@", comment: "String describing which article title description is being edited. %1$@ is replaced with the article title")
        return String.localizedStringWithFormat(formatString, article?.displayTitleHTML ?? "").byAttributingHTML(with: .subheadline, matching: traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        subTitleLabel.attributedText = titleDescriptionFor
    }
    
    @IBAction func showAboutWikidataPage() {
        wmf_openExternalUrl(URL(string: "https://m.wikidata.org/wiki/Wikidata:Introduction"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableProgressiveButton(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        enableProgressiveButton(false)
    }

    func enableProgressiveButton(_ highlight: Bool) {
        resetPasswordButton.isEnabled = highlight
    }

    @IBAction private func resetPasswordButtonTapped(withSender sender: UIButton) {
        save()
    }

    private func save() {
        wmf_hideKeyboard()
        
        // Final trim to remove leading and trailing space
        let descriptionToSave = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
print("'\(descriptionToSave)'")
// TODO: call new method to save `descriptionToSave` here - on success dismiss and show new `Description published` panel, on error show alert with server error msg
        
    }
    
    @objc func closeButtonPushed(_ : UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func apply(theme: Theme) {
        self.theme = theme
        guard viewIfLoaded != nil else {
            return
        }
        
        view.backgroundColor = theme.colors.paperBackground
        view.tintColor = theme.colors.link
        
        let labels = [subTitleLabel, orLabel]
        for label in labels {
            label?.textColor = theme.colors.secondaryText
        }
        
        descriptionTextView.textColor = theme.colors.secondaryText
        divider.backgroundColor = theme.colors.border

        resetPasswordButton.apply(theme: theme)
    }
}
