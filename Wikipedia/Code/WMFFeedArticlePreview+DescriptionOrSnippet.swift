
public extension ArticleSummary {
    var descriptionOrSnippet: String? {
        if let wikidataDescription = articleDescription, !wikidataDescription.isEmpty,
            let articleLanguage = articleURL?.wmf_language {
            return wikidataDescription.wmf_stringByCapitalizingFirstCharacter(usingWikipediaLanguage: articleLanguage)
        }
        if let extract = extract, !extract.isEmpty {
            return String(extract.prefix(128))
        }
        return nil
    }
}
