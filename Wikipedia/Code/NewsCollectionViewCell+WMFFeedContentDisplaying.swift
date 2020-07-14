import UIKit

extension NewsCollectionViewCell {
    public func configure(with story: FeedDay.NewsStory, dataStore: MWKDataStore, showArticles: Bool = true, theme: Theme, layoutOnly: Bool) {
        let previews = story.links ?? []
        descriptionHTML = story.story
        
        if showArticles {
            articles = previews.map { (articlePreview) -> CellArticle in
                return CellArticle(articleURL:articlePreview.articleURL, title: articlePreview.displayTitle, titleHTML: articlePreview.displayTitle, description: articlePreview.descriptionOrSnippet, imageURL: articlePreview.thumbnail?.url)
            }
        }

        
        let articleLanguage = story.links?.first?.articleURL.wmf_language
        descriptionLabel.accessibilityLanguage = articleLanguage
        semanticContentAttributeOverride = MWLanguageInfo.semanticContentAttribute(forWMFLanguage: articleLanguage)
        
        let imageWidthToRequest = traitCollection.wmf_potdImageWidth
        if let articleURL = story.featuredArticlePreview?.articleURL ?? previews.first?.articleURL, let article = dataStore.fetchArticle(with: articleURL), let imageURL = article.imageURL(forWidth: imageWidthToRequest) {
            isImageViewHidden = false
            if !layoutOnly {
                imageView.wmf_setImage(with: imageURL, detectFaces: true, onGPU: true, failure: {(error) in }, success: { })
            }
        } else {
            isImageViewHidden = true
        }
        apply(theme: theme)
        resetContentOffset()
        setNeedsLayout()
    }    
}
