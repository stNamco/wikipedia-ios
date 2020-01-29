import Foundation

@objc(WMFRandomArticleFetcher)
public final class RandomArticleFetcher: Fetcher {
    @objc public func fetchRandomArticle(withSiteURL siteURL: URL, completion: @escaping (Error?, URL?, ArticleSummary?) -> Void) {
        let pathComponents = ["page", "random", "summary"]
        guard let taskURL = configuration.wikipediaMobileAppsServicesAPIURLComponentsForHost(siteURL.host, appending: pathComponents).url else {
            completion(Fetcher.invalidParametersError, nil, nil)
            return
        }
        session.jsonDecodableTask(with: taskURL) { (result: Result<ArticleSummary, Error>, response) in
            
            switch result {
            case .success(let summary):
                guard let articleURL = summary.articleURL else {
                    completion(Fetcher.unexpectedResponseError, nil, nil)
                    return
                }
                completion(nil, articleURL, summary)
            case .failure(let error):
                completion(error, nil, nil)
            }
        }
    }
}
