//
//  NSStack.m
//
//  Created by johnzhjfly on 11-4-8.
#import "NSDictionary+xml.h"
@implementation NSStack
- (id) init {
    self = [super init];
    if (self) {
        _stackArray = [[NSMutableArray alloc] init];
    }
    return self;
}
/**
 * @desc judge whether the stack is empty
 *
 * @return TRUE if stack is empty, otherwise FALASE is returned
 */
- (BOOL) empty {
    return ((_stackArray == nil)||([_stackArray count] == 0));
}
/**
 * @desc get top object in the stack
 *
 * @return nil if no object in the stack, otherwise an object
 * is returned, user should judge the return by this method
 */
- (id) top {
    id value = nil;
    if (_stackArray&&[_stackArray count]) {
        value = [_stackArray lastObject];
    }
    return value;
}
/**
 * @desc pop stack top object
 */
- (void) pop {
    if (_stackArray&&[_stackArray count]) {
        [_stackArray removeLastObject];
    }
}
/**
 * @desc push an object to the stack
 */
- (void) push:(id)value {
    [_stackArray addObject:value];
}
- (void) dealloc {
    [_stackArray release];
    [super dealloc];
}
@end



//
//  NSDictionaryAdditions.m
//
//  Created by johnzhjfly on 11-4-8.
//
@implementation NSDictionary(Additions)
- (NSArray*) toArray {
    NSMutableArray *entities = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSEnumerator *enumerator = [self objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
        /* code that acts on the dictionary‚Äôs values */
        [entities addObject:value];
    }
    return [entities autorelease];
}
- (NSString*) toXMLString {
    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    NSStack *stack = [[NSStack alloc] init];
    NSArray  *keys = nil;
    NSString *key  = nil;
    NSObject *value    = nil;
    NSObject *subvalue = nil;
    [stack push:self];
    while (![stack empty]) {
        value = [stack top];
        [stack pop];
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                [xmlString appendFormat:@"</%@>", value];
            }
            else if([value isKindOfClass:[NSDictionary class]]) {
                keys = [(NSDictionary*)value allKeys];
                for (key in keys) {
                    subvalue = [(NSDictionary*)value objectForKey:key];
                    if ([subvalue isKindOfClass:[NSDictionary class]]) {
                        [xmlString appendFormat:@"<%@>", key];
                        [stack push:key];
                        [stack push:subvalue];
                    }
                    else if([subvalue isKindOfClass:[NSString class]]) {
                        [xmlString appendFormat:@"<%@>%@</%@>", key, subvalue, key];
                    }
                }
            }
        }
    }
    [stack release];
    return [xmlString autorelease];
}
@end