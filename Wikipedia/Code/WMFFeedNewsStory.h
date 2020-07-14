@import Mantle.MTLModel;
@import Mantle.MTLJSONAdapter;

@class WMFFeedArticlePreview;

NS_ASSUME_NONNULL_BEGIN

@interface WMFFeedNewsStory

+ (nullable NSDate *)midnightUTCMonthAndDayFromStoryHTML:(NSString *)storyHTML;

+ (nullable NSString *)semanticFeaturedArticleTitleFromStoryHTML:(NSString *)storyHTML siteURL:(NSURL *)siteURL;

@end

NS_ASSUME_NONNULL_END
