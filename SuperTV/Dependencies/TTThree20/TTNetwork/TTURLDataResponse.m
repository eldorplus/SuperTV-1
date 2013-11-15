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

#import "TTURLDataResponse.h"

// Core
#import "SHThree20Extral.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTURLDataResponse

@synthesize data = _data,tag,locUrl;
@synthesize statusCode, allHeaderFields;

- (id)init {
	if (self = [super init]) {
		
		self.tag = 0;
        self.locUrl = nil;
	}
	return self;
}

- (id)initWithID:(NSInteger)nTag
{
    if (self = [super init]) {
		
		self.tag = nTag;
        self.locUrl = nil;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  TT_RELEASE_SAFELY(_data);
    
    self.allHeaderFields = nil;
    self.locUrl = nil;
  [super dealloc];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTURLResponse


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response
            data:(id)data {
  // This response is designed for NSData objects, so if we get anything else it's probably a
  // mistake.
  TTDASSERT([data isKindOfClass:[NSData class]]);
  TTDASSERT(nil == _data);

  if ([data isKindOfClass:[NSData class]]) {
    _data = [data retain];
  }
    
    self.statusCode = response.statusCode;
    self.allHeaderFields = response.allHeaderFields;
    self.locUrl = response.URL.absoluteString;
  return nil;
}


@end
