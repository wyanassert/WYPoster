//
//  WYEstimateFontSizeManager.m
//  WYPoster
//
//  Created by wyan assert on 2017/8/7.
//  Copyright © 2017年 wyan assert. All rights reserved.
//

#import "WYEstimateFontSizeManager.h"
#import "UIFont+wy_customFont.h"

static NSString *kWYPosterFontDictIdentifier = @"kWYPosterFontDictIdentifier";

@interface WYEstimateFontSizeManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, WYPosterFont *>         *fontDict;
@property (nonatomic, strong, nonnull) dispatch_queue_t                               ioQueue;

@end

@implementation WYEstimateFontSizeManager

+ (instancetype)shareedInstance {
    static WYEstimateFontSizeManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WYEstimateFontSizeManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        _ioQueue = dispatch_queue_create("com.wyanassert.me.WYEstimateFontSizeManagerFontIOQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc {
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_ioQueue);
#endif
}

- (CGSize)estimateWYPosterFont:(WYPosterFont *)font {
    @synchronized (self) {
        WYPosterFont *tmpFont = [self.fontDict objectForKey:font.fontName];
        if(tmpFont) {
            return CGSizeMake(tmpFont.heightPerPoint * font.size, tmpFont.widthPerPoint * font.size);
        } else {
            UIFont *calFont = [UIFont wy_customFontWithName:font.fontName size:font.size];
            tmpFont = [[WYPosterFont alloc] initWithUIFont:calFont andFontName:font.fontName];
            [self saveFontDict:tmpFont];
            return CGSizeMake(tmpFont.heightPerPoint * font.size, tmpFont.widthPerPoint * font.size);
        }
        return CGSizeZero;
    }
}

- (void)saveFontDict:(WYPosterFont *)font {
    NSAssert(font, @"Font Parameter should not be nil when save");
    [self.fontDict setObject:font forKey:font.fontName];
    dispatch_barrier_async(self.ioQueue, ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.fontDict];
        if(data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kWYPosterFontDictIdentifier];
        }
    });
}


#pragma mark - Getter
- (NSMutableDictionary<NSString *,WYPosterFont *> *)fontDict {
    if(!_fontDict) {
        __block NSData *data = nil;
        dispatch_barrier_sync(self.ioQueue, ^{
            data = [[NSUserDefaults standardUserDefaults] objectForKey:kWYPosterFontDictIdentifier];
        });
        if(data) {
            NSDictionary *tmpDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            _fontDict = [NSMutableDictionary dictionaryWithDictionary:tmpDict];
        } else {
            _fontDict = [NSMutableDictionary dictionary];
        }
    }
    return _fontDict;
}

@end
