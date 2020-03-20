#import "WMFSecureCodingMTLModel.h"

@implementation WMFSecureCodingMTLModel

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [super encodeWithCoder:coder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return [super initWithCoder:coder];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [super copyWithZone:zone];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    return [super modelWithDictionary:dictionaryValue error:error];
}

+ (NSSet *)propertyKeys {
    return [super propertyKeys];
}

- (BOOL)validate:(NSError *__autoreleasing *)error {
    return [super validate:error];
}

@end
