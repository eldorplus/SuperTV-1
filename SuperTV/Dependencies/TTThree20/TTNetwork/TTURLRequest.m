//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTURLRequest.h"

// Network
#import "TTGlobalNetwork.h"
#import "TTURLResponse.h"
#import "TTURLRequestQueue.h"

// Core
#import "SHThree20Extral.h"
#import "SHUtility.h"

static NSString* kStringBoundary = @"yi2ndDfv2rTHiSieAbouNdArYfOGhtTPEefj342f";


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTURLRequest

@synthesize urlPath     = _urlPath;
@synthesize httpMethod  = _httpMethod;
@synthesize httpBody    = _httpBody;
@synthesize parameters  = _parameters;
@synthesize headers     = _headers;
@synthesize breakSeqment = _isBreakSeqment;
@synthesize seqmentData  = _seqmentData;

@synthesize contentType           = _contentType;
@synthesize charsetForMultipart   = _charsetForMultipart;

@synthesize response              = _response;

@synthesize cachePolicy           = _cachePolicy;
@synthesize cacheExpirationAge    = _cacheExpirationAge;
@synthesize cacheKey              = _cacheKey;

@synthesize timestamp             = _timestamp;

@synthesize totalBytesLoaded      = _totalBytesLoaded;
@synthesize totalBytesExpected    = _totalBytesExpected;

@synthesize userInfo              = _userInfo;
@synthesize isLoading             = _isLoading;

@synthesize shouldHandleCookies   = _shouldHandleCookies;
@synthesize respondedFromCache    = _respondedFromCache;
@synthesize filterPasswordLogging = _filterPasswordLogging;

@synthesize delegates             = _delegates;

@synthesize requestType;
@synthesize requestCache          = _requestCache;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTURLRequest*)request {
  return [[[TTURLRequest alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (TTURLRequest*)requestWithURL:(NSString*)URL delegate:(id /*<TTURLRequestDelegate>*/)delegate {
  return [[[TTURLRequest alloc] initWithURL:URL delegate:delegate] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithURL:(NSString*)URL delegate:(id /*<TTURLRequestDelegate>*/)delegate {
  if (self = [self init]) {
    _urlPath = [URL retain];
      
    if (nil != delegate) {
      [_delegates addObject:delegate];
    }
  }
  return self;
}

- (void)setRequestCache:(TTURLCache *)requestCache
{
    _requestCache = requestCache;
    
    if (_requestCache.mainKey == nil)
        return;
    
    self.seqmentData = [_requestCache seqmentForUrl:_urlPath];
    if (self.seqmentData != nil)
    {
        _isBreakSeqment = YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
  if (self = [super init]) {
    _delegates = TTCreateNonRetainingArray();
    _cachePolicy = TTURLRequestCachePolicyDefault;
    _cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
    _shouldHandleCookies = YES;
    _charsetForMultipart = NSUTF8StringEncoding;
    _requestCache = [TTURLCache sharedDocsCache];
      
      // 默认不支持断点续传
      _isBreakSeqment = NO;
      _seqmentData = nil;
  }
  return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    
    self.seqmentData = nil;
    
  TT_RELEASE_SAFELY(_urlPath);
  TT_RELEASE_SAFELY(_httpMethod);
  TT_RELEASE_SAFELY(_response);
  TT_RELEASE_SAFELY(_httpBody);
  TT_RELEASE_SAFELY(_contentType);
  TT_RELEASE_SAFELY(_parameters);
  TT_RELEASE_SAFELY(_headers);
  TT_RELEASE_SAFELY(_cacheKey);
  TT_RELEASE_SAFELY(_userInfo);
  TT_RELEASE_SAFELY(_timestamp);
  TT_RELEASE_SAFELY(_files);
  TT_RELEASE_SAFELY(_delegates);
    
  [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)description {
  return [NSString stringWithFormat:@"<TTURLRequest %@>", _urlPath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)generateCacheKey {
  if ([_httpMethod isEqualToString:@"POST"]
      || [_httpMethod isEqualToString:@"PUT"]) {
    NSMutableString* joined = [[[NSMutableString alloc] initWithString:self.urlPath] autorelease];
    NSEnumerator* e = [_parameters keyEnumerator];
    for (id key; key = [e nextObject]; ) {
      [joined appendString:key];
      [joined appendString:@"="];
      NSObject* value = [_parameters valueForKey:key];
      if ([value isKindOfClass:[NSString class]]) {
        [joined appendString:(NSString*)value];
      }
    }

	  return [SHUtility md5Hash:joined];
  } else {
	  return [SHUtility md5Hash:self.urlPath];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)generatePostBody {
  NSMutableData* body = [NSMutableData data];
  NSString* beginLine = [NSString stringWithFormat:@"\r\n--%@\r\n", kStringBoundary];

//  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kStringBoundary]
//    dataUsingEncoding:NSUTF8StringEncoding]];

  for (id key in [_parameters keyEnumerator]) {
    NSString* value = [NSString stringWithFormat:@"%@",[_parameters valueForKey:key]];
    if (![value isKindOfClass:[UIImage class]]) {
      [body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString
        stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
          dataUsingEncoding:_charsetForMultipart]];
      [body appendData:[value dataUsingEncoding:_charsetForMultipart]];
    }
  }

  NSString* imageKey = nil;
  for (id key in [_parameters keyEnumerator]) {
    if ([[_parameters objectForKey:key] isKindOfClass:[UIImage class]]) {
      UIImage* image = [_parameters objectForKey:key];
      CGFloat quality = [TTURLRequestQueue mainQueue].imageCompressionQuality;
      NSData* data = UIImageJPEGRepresentation(image, quality);

      [body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:
                       @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n",
                       key]
          dataUsingEncoding:_charsetForMultipart]];
      [body appendData:[[NSString
        stringWithFormat:@"Content-Length: %d\r\n", data.length]
          dataUsingEncoding:_charsetForMultipart]];
      [body appendData:[@"Content-Type: image/jpeg\r\n\r\n"
          dataUsingEncoding:_charsetForMultipart]];
      [body appendData:data];
      imageKey = key;
    }
  }

  for (NSInteger i = 0; i < _files.count; i += 3) {
    NSData* data = [_files objectAtIndex:i];
    NSString* mimeType = [_files objectAtIndex:i+1];
    NSString* fileName = [_files objectAtIndex:i+2];

    [body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:
                       @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                       fileName, fileName]
          dataUsingEncoding:_charsetForMultipart]];
    [body appendData:[[NSString stringWithFormat:@"Content-Length: %d\r\n", data.length]
          dataUsingEncoding:_charsetForMultipart]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType]
          dataUsingEncoding:_charsetForMultipart]];
    [body appendData:data];
  }

  [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kStringBoundary]
                   dataUsingEncoding:NSUTF8StringEncoding]];

  // If an image was found, remove it from the dictionary to save memory while we
  // perform the upload
  if (imageKey) {
    [_parameters removeObjectForKey:imageKey];
  }

  //TTDPRINT(@"Sending length=%d,%s", [body length] ,[body bytes]);
  return body;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableDictionary*)parameters {
  if (!_parameters) {
    _parameters = [[NSMutableDictionary alloc] init];
  }
  return _parameters;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSData*)httpBody {
  if (_httpBody) {
    return _httpBody;
  } else if ([[_httpMethod uppercaseString] isEqualToString:@"POST"]
             || [[_httpMethod uppercaseString] isEqualToString:@"PUT"]) {
    return [self generatePostBody];
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)contentType {
  if (_contentType) {
    return _contentType;
  } else if ([_httpMethod isEqualToString:@"POST"]
             || [_httpMethod isEqualToString:@"PUT"]) {
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kStringBoundary];
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)cacheKey {
  if (!_cacheKey) {
    _cacheKey = [[self generateCacheKey] retain];
  }
  return _cacheKey;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setValue:(NSString*)value forHTTPHeaderField:(NSString*)field {
  if (!_headers) {
    _headers = [[NSMutableDictionary alloc] init];
  }
  [_headers setObject:value forKey:field];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addFile:(NSData*)data mimeType:(NSString*)mimeType fileName:(NSString*)fileName {
  if (!_files) {
    _files = [[NSMutableArray alloc] init];
  }

  [_files addObject:data];
  [_files addObject:mimeType];
  [_files addObject:fileName];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)send {
  if (_parameters) {
    // Don't log passwords. Save now, restore after logging
    NSString* password = [_parameters objectForKey:@"password"];
    if (_filterPasswordLogging && password) {
      [_parameters setObject:@"[FILTERED]" forKey:@"password"];
    }

    //TTDPRINT(@"SEND %@ %@", self.urlPath, self.parameters);

    if (password) {
      [_parameters setObject:password forKey:@"password"];
    }
  }
    
   if (_isBreakSeqment && self.seqmentData != nil)
   {
       NSString* strValue = [self.seqmentData objectForKey:kSeqmentCurrentLength];
       
       long long lValue = [strValue longLongValue];
       if (lValue > 0)
       {
          [self setValue:[NSString stringWithFormat:@"bytes=%@-",strValue] forHTTPHeaderField:@"Range"]; 
       }
   }
  return [[TTURLRequestQueue mainQueue] sendRequest:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)sendSynchronously {
  return [[TTURLRequestQueue mainQueue] sendSynchronousRequest:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
  [[TTURLRequestQueue mainQueue] cancelRequest:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURLRequest*)createNSURLRequest {
  return [[TTURLRequestQueue mainQueue] createNSURLRequest:self URL:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Properties


///////////////////////////////////////////////////////////////////////////////////////////////////
// Deprecated
- (void)setURL:(NSString*)urlPath {
  NSString* aUrlPath = [urlPath copy];
  [_urlPath release];
  _urlPath = aUrlPath;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// Deprecated
- (NSString*)URL {
  return _urlPath;
}

@end
