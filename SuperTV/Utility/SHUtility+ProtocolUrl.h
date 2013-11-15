//
//  SHUtility+ProtocolUrl.h
//  SohuNews2
//
//  Created by Gao Yongyue on 13-9-5.
//  Copyright (c) 2013年 Sohu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNewsProtocol             @"news://"              //新闻  3，6，7
#define kPhotoProtocol            @"photo://"             //组图  4,
#define kVoteProtocol             @"vote://"              //投票  12
#define kLiveProtocol             @"live://"              //直播  9
#define kHttpProtocol             @"http://"              //网页  8   外部订阅 37
#define kSubProtocol              @"sub://"               //订阅  30
#define kPaperProtocol            @"paper://"             //报纸  11
#define kSpecialProtocol          @"special://"           //专题  10
#define kWeiboProtocol            @"weibo://"             //微热议（微闻，微博）13
#define kDataFlowProtocol         @"dataFlow://"          //数据流 32
#define kNewsChannelProtocol      @"newsChannel://"       //新闻频道列表 33
#define kWeiboChannelProtocol     @"weiboChannel://"      //微热议频道列表 34
#define kGroupPicChannelProtocol  @"groupPicChannel://"   //组图频道列表 35
#define kLiveChannelProtocol      @"liveChannel://"       //直播频道列表（可能是多个直播频道列表） 36
#define kSearhProtocol            @"search://"            //搜索
#define kSocialShareProtocol      @"socialShare://"       //阅读圈  分享最终页 101
#define kCommentProtocol          @"comment://"           //直接评论某个正文页/回复某个评论 （此协议为h5调用客户端本地空间协议）
#define kUserinfoProtocol         @"userInfo://"          //进入用户详情页（此协议为h5调用客户端本地空间协议）



@interface SHUtility_ProtocolUrl : NSObject
//打开二代协议的入口
+ (NSDictionary *)openProtocolURL:(NSString *)link;
@end
