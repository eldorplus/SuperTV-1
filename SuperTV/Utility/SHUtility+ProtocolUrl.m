//
//  SHUtility+ProtocolUrl.m
//  SohuNews2
//
//  Created by Gao Yongyue on 13-9-5.
//  Copyright (c) 2013年 Sohu Inc. All rights reserved.
//

#import "SHUtility+ProtocolUrl.h"


@implementation SHUtility_ProtocolUrl

+ (NSDictionary *)openProtocolURL:(NSString *)link
{
    //news://subId=864&termId=123290
    NSString *protocolType = @"";
    NSString *classType = @"";
    if ([link hasPrefix:kNewsProtocol])
    {
        protocolType = kNewsProtocol;
        classType = @"SHNewsContentController";
    }
    else if ([link hasPrefix:kPhotoProtocol])
    {
        protocolType = kPhotoProtocol;
        classType = @"SHNewsContentController";
    }
    else if ([link hasPrefix:kVoteProtocol])
    {
        protocolType = kVoteProtocol;
    }
    else if ([link hasPrefix:kLiveProtocol])
    {
        protocolType = kLiveProtocol;
    }
    else if ([link hasPrefix:kHttpProtocol])
    {
        //外部资源 网页
        //外部订阅
        protocolType = kHttpProtocol;
        classType = @"SHNewsPaperWebViewController";
    }
    else if ([link hasPrefix:kSubProtocol])
    {
        protocolType = kSubProtocol;
        classType = @"SHNewsPaperWebViewController";
    }
    else if ([link hasPrefix:kPaperProtocol])
    {
        protocolType = kPaperProtocol;
        classType = @"SHNewsPaperWebViewController";
    }
    else if ([link hasPrefix:kSpecialProtocol])
    {
        protocolType = kSpecialProtocol;
        classType = @"SHSpecialViewController";
    }
    else if ([link hasPrefix:kWeiboProtocol])
    {
        protocolType = kWeiboProtocol;
    }
    else if ([link hasPrefix:kDataFlowProtocol])
    {
        protocolType = kDataFlowProtocol;
        classType = @"SHNewsPaperWebViewController";
    }
    else if ([link hasPrefix:kNewsChannelProtocol])
    {
        protocolType = kNewsChannelProtocol;
        classType = @"SHFeedViewController";
    }
    else if ([link hasPrefix:kWeiboChannelProtocol])
    {
        protocolType = kWeiboChannelProtocol;
    }
    else if ([link hasPrefix:kGroupPicChannelProtocol])
    {
        protocolType = kGroupPicChannelProtocol;
    }
    else if ([link hasPrefix:kLiveChannelProtocol])
    {
        protocolType = kLiveChannelProtocol;
    }
    else if ([link hasPrefix:kSearhProtocol])
    {
        protocolType = kSearhProtocol;
    }
    else if ([link hasPrefix:kSocialShareProtocol])
    {
        protocolType = kSocialShareProtocol;
    }
    else if ([link hasPrefix:kCommentProtocol])
    {
        //直接评论某个正文
        //回复某个评论
        protocolType = kCommentProtocol;
        classType = @"";
    }
    else if ([link hasPrefix:kUserinfoProtocol])
    {
        protocolType = kUserinfoProtocol;
    }
    else
    {
        
    }

    NSString *paramString = [link substringFromIndex:[protocolType length]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:[SHUtility_ProtocolUrl paramDict:paramString]];
    if (classType)
    {
        paramDict[@"classType"] = classType;
    }
    
    if (link) {
        paramDict[@"link"] = link;
    }

    return paramDict;
}

+ (NSDictionary *)paramDict:(NSString *)link
{
    //subId=864&termId=123290
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSArray *paramArray = [link componentsSeparatedByString:@"&"];
    [paramArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *param = (NSString *)obj;
        NSArray *keyObject = [param componentsSeparatedByString:@"="];
        paramDict[keyObject[0]] = keyObject[1];
    }];
    return paramDict;
    //{
    //subId=864
    //termId=123290
    //}
}
@end
