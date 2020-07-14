import Foundation

public struct FeedDay: Codable {
    public struct TopRead: Codable {
        let date: Date
        let articles: [ArticleSummary]
    }
    public struct PictureOfTheDay: Codable {
        struct Description: Codable {
            let text: String
            let lang: String
        }
        struct Image: Codable {
            let source: String
        }
        struct Thumbnail: Codable {
            let source: String
        }
        let canonicalPageTitle: String
        let description: Description
        let image: Image
        let thumbnail: Thumbnail
    }
    public struct NewsStory: Codable {
        let story: String
        let links: [ArticleSummary]
        let featuredArticlePreview: ArticleSummary
    }
    let featuredArticle: ArticleSummary
    let topRead: TopRead
    let pictureOfTheDay: PictureOfTheDay
    let newsStories: [NewsStory]
    enum CodingKeys: String, CodingKey {
        case featuredArticle = "tfa"
        case topRead = "mostread"
        case pictureOfTheDay = "image"
        case newsStories = "news"
    }
}

struct FeedOnThisDayEvent {
    let year: Int
    let text: String
    let pages: [ArticleSummary]
}
