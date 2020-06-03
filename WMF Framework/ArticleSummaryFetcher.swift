import Foundation

@objc(WMFArticleSummaryImage)
class ArticleSummaryImage: NSObject, Codable {
    let source: String
    let width: Int
    let height: Int
    var url: URL? {
        return URL(string: source)
    }
}

@objc(WMFArticleSummaryURLs)
class ArticleSummaryURLs: NSObject, Codable {
    let page: String?
    let revisions: String?
    let edit: String?
    let talk: String?
}

@objc(WMFArticleSummaryContentURLs)
class ArticleSummaryContentURLs: NSObject, Codable {
    let desktop: ArticleSummaryURLs?
    let mobile: ArticleSummaryURLs?
}

@objc(WMFArticleSummaryCoordinates)
class ArticleSummaryCoordinates: NSObject, Codable {
    @objc let lat: Double
    @objc let lon: Double
}

@objc(WMFArticleSummary)
public class ArticleSummary: NSObject, Codable {
    @objc public class Namespace: NSObject, Codable {
        let id: Int?
        let text: String?

        @objc public var number: NSNumber? {
            guard let id = id else {
                return nil
            }
            return NSNumber(value: id)
        }
    }
    let id: Int64?
    let wikidataID: String?
    let revision: String?
    let timestamp: String?
    let index: Int?
    @objc let namespace: Namespace?
    let title: String?
    let displayTitle: String?
    let articleDescription: String?
    let extract: String?
    let extractHTML: String?
    let thumbnail: ArticleSummaryImage?
    let original: ArticleSummaryImage?
    @objc let coordinates: ArticleSummaryCoordinates?
    
    enum CodingKeys: String, CodingKey {
        case id = "pageid"
        case revision
        case index
        case namespace
        case title
        case timestamp
        case displayTitle = "displaytitle"
        case articleDescription = "description"
        case extract
        case extractHTML = "extract_html"
        case thumbnail
        case original = "originalimage"
        case coordinates
        case contentURLs = "content_urls"
        case wikidataID = "wikibase_item"
    }
    
    let contentURLs: ArticleSummaryContentURLs
    
    var articleURL: URL? {
        guard let urlString = contentURLs.desktop?.page else {
            return nil
        }
        return URL(string: urlString)
    }
    
    var key: String? {
        return articleURL?.wmf_databaseKey // don't use contentURLs.desktop?.page directly as it needs to be standardized
    }
}


@objc(WMFArticleSummaryFetcher)
public class ArticleSummaryFetcher: Fetcher {
    @discardableResult public func fetchArticleSummaryResponsesForArticles(withKeys articleKeys: [String], cachePolicy: URLRequest.CachePolicy? = nil, priority: Float = URLSessionTask.defaultPriority, completion: @escaping ([String: ArticleSummary]) -> Void) -> [URLSessionTask] {
        
        var tasks: [URLSessionTask] = []
        articleKeys.asyncMapToDictionary(block: { (articleKey, asyncMapCompletion) in
            let task = fetchSummaryForArticle(with: articleKey, cachePolicy: cachePolicy, priority: priority, completion: { (responseObject, response, error) in
                asyncMapCompletion(articleKey, responseObject)
            })
            if let task = task {
                tasks.append(task)
            }
        }, completion: completion)
        
        return tasks
    }
    
    @discardableResult public func fetchSummaryForArticle(with articleKey: String, cachePolicy: URLRequest.CachePolicy? = nil, priority: Float = URLSessionTask.defaultPriority, completion: @escaping (ArticleSummary?, URLResponse?, Error?) -> Swift.Void) -> URLSessionTask? {
        guard
            let articleURL = URL(string: articleKey),
            let title = articleURL.percentEncodedPageTitleForPathComponents
        else {
            completion(nil, nil, Fetcher.invalidParametersError)
            return nil
        }
        
        let pathComponents = ["page", "summary", title]
        return performRESTBaseGET(for: articleURL, pathComponents: pathComponents, cachePolicy: cachePolicy, priority: priority) { (summary: ArticleSummary?, response: URLResponse?, error: Error?) in
            completion(summary, response, error)
        }
    }
    
    /// Makes periodic HEAD requests to the mobile-html endpoint until the etag no longer matches the one provided.
    @discardableResult public func waitForSummaryChange(with articleKey: String, eTag: String, attempt: Int = 0, maxAttempts: Int, cancellationKey: CancellationKey? = nil, completion: @escaping (Result<String, Error>) -> Void) -> CancellationKey? {
        guard attempt < maxAttempts else {
            completion(.failure(ArticleFetcherError.updatedContentRequestTimeout))
            return nil
        }
        guard
            let articleURL = URL(string: articleKey),
            let title = articleURL.percentEncodedPageTitleForPathComponents
        else {
            completion(.failure(Fetcher.invalidParametersError))
            return nil
        }
        
        let pathComponents = ["page", "summary", title]
        let taskURL = configuration.pageContentServiceAPIURLComponentsForHost(articleURL.host, appending: pathComponents).url
        
        let key = cancellationKey ?? UUID().uuidString
        
        let maybeTask = session.dataTask(with: taskURL, method: .head, headers: [URLRequest.ifNoneMatchHeaderKey: eTag], cachePolicy: .reloadIgnoringLocalCacheData) { (_, response, error) in
            defer {
                self.untrack(taskFor: key)
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            let bail = {
                completion(.failure(RequestError.unexpectedResponse))
            }
            guard let httpURLResponse = response as? HTTPURLResponse else {
                bail()
                return
            }
            
            let retry = {
                // Exponential backoff
                let delayTime = 0.25 * pow(2, Double(attempt))
                dispatchOnMainQueueAfterDelayInSeconds(delayTime) {
                    self.waitForSummaryChange(with: articleKey, eTag: eTag, attempt: attempt + 1, maxAttempts: maxAttempts, cancellationKey: key, completion: completion)
                }
            }

            // Check for 200. The server returns 304 when the ETag matches the value we provided for `If-None-Match` above
            switch httpURLResponse.statusCode {
            case 200:
                break
            case 304:
                retry()
                return
            default:
                bail()
                return
            }
            
            guard
                let updatedETag = httpURLResponse.allHeaderFields[HTTPURLResponse.etagHeaderKey] as? String,
                updatedETag != eTag // Technically redundant. With If-None-Match provided, we should only get a 200 response if the ETag has changed. Included here as an extra check against a server behaving incorrectly
            else {
                assert(false, "A 200 response from the server should indicate that the ETag has changed")
                retry()
                return
            }
            
            DDLogDebug("ETag for \(articleURL) changed from \(eTag) to \(updatedETag)")
            completion(.success(updatedETag))
        }
        guard let task = maybeTask else {
            completion(.failure(RequestError.unknown))
            return nil
        }
        track(task: task, for: key)
        task.resume()
        return key
    }
}

