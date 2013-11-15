//
//  TTNetworkExtral.m
//  SohuColor
//
//  Created by tengsong on 11-3-29.
//  Copyright 2011 sohu.com. All rights reserved.
//

#import "SHThree20Extral.h"

#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import "TTURLCache.h"

const CGFloat ttkDefaultTransitionDuration      = 0.3;

///////////////////////////////////////////////////////////////////////////////////////////////////
CGAffineTransform TTRotateTransformForOrientation(UIInterfaceOrientation orientation) {
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
		
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
		
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
		
	} else {
		return CGAffineTransformIdentity;
	}
}



// No-ops for non-retaining objects.
static const void* TTRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void TTReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

NSMutableArray* TTCreateNonRetainingArray() 
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = TTRetainNoOp;
	callbacks.release = TTReleaseNoOp;
	return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect TTApplicationFrame() {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSLocale* TTCurrentLocale() {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    if (languages.count > 0) {
        NSString* currentLanguage = [languages objectAtIndex:0];
        return [[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] autorelease];
        
    } else {
        return [NSLocale currentLocale];
    }
}

@implementation SHThree20Extral
+ (TTURLCache *)sharedDocsCache
{
    TTURLCache *cache = [TTURLCache cacheWithName:kDirCommonCacheDocument];
    cache.disableImageCache = YES;
    return cache;
}

+ (TTURLCache *)sharedImgsCache
{
    TTURLCache *cache = [TTURLCache cacheWithName:kDirCommonCacheImage];
    cache.disableImageCache = YES;
    return cache;
}

+ (NSDate *)getCacheFileModifyAttributesForUrl:(NSString *)url {
    NSError *error = nil;
    NSDate *fileDate = nil;
    TTURLCache *cache = [self sharedDocsCache];
    NSString *filePath = [cache cachePathForURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
		if (attributes != nil) {
			fileDate = [attributes fileModificationDate];
		}
	}
    return fileDate;
}
@end
