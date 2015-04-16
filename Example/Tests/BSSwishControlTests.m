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

#import <XCTest/XCTest.h>
#import <SwishControl/SwishControl.h>

@interface BSSwishControlTests : XCTestCase

@property (nonatomic, strong) NSString *soundPath;

@end

@implementation BSSwishControlTests

- (void)setUp {
    [super setUp];
    
    self.soundPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
}

- (void)testAddSoundToUIControl {
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:NSSelectorFromString(@"wuhu") forControlEvents:UIControlEventTouchUpInside];
    [control bs_setAudioWithPath:self.soundPath forEvent:UIControlEventTouchUpInside];
    
    XCTAssert(control.allTargets.count == 2);
}

- (void)testRemoveSoundToUIControl {
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:NSSelectorFromString(@"wuhu") forControlEvents:UIControlEventTouchUpInside];
    [control bs_setAudioWithPath:self.soundPath forEvent:UIControlEventTouchUpInside];
    [control bs_removeAudioForEvent:UIControlEventTouchUpInside];
    
    XCTAssert(control.allTargets.count == 1);
}

- (void)testSoundTarget {
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:NSSelectorFromString(@"wuhu") forControlEvents:UIControlEventTouchUpInside];
    [control bs_setAudioWithPath:self.soundPath forEvent:UIControlEventTouchUpInside];
    
    id firstTarget = control.allTargets.allObjects.firstObject;
    id secondTarget = control.allTargets.allObjects.lastObject;
    
    XCTAssert(firstTarget == self || firstTarget == control);
    XCTAssert((secondTarget == control || secondTarget == self) && secondTarget != firstTarget);
}

- (void)testSoundTargetAction {
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:NSSelectorFromString(@"wuhu") forControlEvents:UIControlEventTouchUpInside];
    [control bs_setAudioWithPath:self.soundPath forEvent:UIControlEventTouchUpInside];
    
    id firstTarget = control.allTargets.allObjects.firstObject;
    id secondTarget = control.allTargets.allObjects.lastObject;
    
    id selfTarget = nil;
    id controlTarget = nil;
    
    if(firstTarget == self) {
        selfTarget = firstTarget;
        controlTarget = secondTarget;
    } else {
        selfTarget = secondTarget;
        controlTarget = firstTarget;
    }
    
    NSString *selfTargetAction = [control actionsForTarget:selfTarget forControlEvent:UIControlEventTouchUpInside].firstObject;
    NSString *controlTargetAction = [control actionsForTarget:controlTarget forControlEvent:UIControlEventTouchUpInside].firstObject;
    
    XCTAssert([selfTargetAction isEqualToString:@"wuhu"]);
    XCTAssert([controlTargetAction isEqualToString:@"bs_playAudio64"]);
}

@end
