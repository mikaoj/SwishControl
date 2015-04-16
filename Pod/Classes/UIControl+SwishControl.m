// The MIT License (MIT)
//
// Copyright (c) 2015 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UIControl+SwishControl.h"
#import <objc/runtime.h>
#import "BSSoundContainer.h"

static NSString * const kSwishControlSelectorPrefix = @"bs_playAudio";

@interface UIControl (SwishControlPrivate)

// Key is a selector (as a string) and value is a BSSoundContainer
@property (nonatomic, strong) NSDictionary *bs_audioEvents;

/**
 Appends event to selector prefix and returns that as an selector
 @param event The event to create selector for
 */
- (SEL)bs_selectorForEvent:(UIControlEvents)event;

/**
 Method that plays the actual sound
 */
- (void)bs_playAudio;

/**
 Adds a selector with implementation from an existing selector
 @param newSelector The selector to create/add
 @param baseSelector The selector whose implementation we should use
 */
+ (BOOL)bs_addSelector:(SEL)newSelector withImplementationFromSelector:(SEL)baseSelector;

@end

@implementation UIControl (SwishControl)

- (void)bs_setAudioWithPath:(NSString *)aPath forEvent:(UIControlEvents)event {
    // Get key (selector) and value (Sound)
    SEL selector = [self bs_selectorForEvent:event];
    NSString *key = NSStringFromSelector(selector);
    BSSoundContainer *value = [[BSSoundContainer alloc] initWithAudioPath:aPath];
    
    if(key && value) {
        // Add selector and sound to dictionary
        NSMutableDictionary *mutableDictionary = [self.bs_audioEvents mutableCopy];
        [mutableDictionary setObject:value forKey:key];
        self.bs_audioEvents = [mutableDictionary copy];
        
        // Add selector and target for event
        [self addTarget:self action:selector forControlEvents:event];
        
        // Add selector to runtime
        [[self class] bs_addSelector:selector withImplementationFromSelector:@selector(bs_playAudio)];
    }
}
- (void)bs_removeAudioForEvent:(UIControlEvents)event {
    SEL selector = [self bs_selectorForEvent:event];
    NSString *key = NSStringFromSelector(selector);
    if(key && [self.bs_audioEvents objectForKey:key]) {
        NSMutableDictionary *mutableDictionary = [self.bs_audioEvents mutableCopy];
        [mutableDictionary removeObjectForKey:key];
        self.bs_audioEvents = [mutableDictionary copy];
        
        [self removeTarget:self action:selector forControlEvents:event];
    }
}

@end

#pragma mark - Private implementation

@implementation UIControl (SwishControlPrivate)

@dynamic bs_audioEvents;

static char kAssociatedAudioEventsKey;

- (void)setBs_audioEvents:(NSDictionary *)audioEvents {
    objc_setAssociatedObject(self, &kAssociatedAudioEventsKey, audioEvents, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)bs_audioEvents {
    NSDictionary *dict = objc_getAssociatedObject(self, &kAssociatedAudioEventsKey);
    
    // Make sure that we always return a dictionary
    if(!dict) {
        dict = [NSDictionary new];
    }
    
    return dict;
}

- (SEL)bs_selectorForEvent:(UIControlEvents)event {
    NSString *eventString = [[NSNumber numberWithInt:event] stringValue];
    NSString *selectorString = [kSwishControlSelectorPrefix stringByAppendingString:eventString];
    
    return NSSelectorFromString(selectorString);
}

- (void)bs_playAudio {
    // This is the base implementation.
    // But _cmd will reflect the name of our created selector ex: bs_playAudio64
    // Fetch sound container for selector and play it
    BSSoundContainer *soundContainer = [self.bs_audioEvents objectForKey:NSStringFromSelector(_cmd)];
    [soundContainer play];
}

+ (BOOL)bs_addSelector:(SEL)newSelector withImplementationFromSelector:(SEL)baseSelector {
    Method newMethod = class_getInstanceMethod(self, newSelector);
    Method baseMethod = class_getInstanceMethod(self, baseSelector);
    
    // If the method already exists or base doesn't. Bail out
    if(newMethod || !baseMethod) {
        return NO;
    }
    
    return class_addMethod(self, newSelector, method_getImplementation(baseMethod), method_getTypeEncoding(baseMethod));
}

@end