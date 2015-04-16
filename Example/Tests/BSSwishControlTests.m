//
//  BSSwishControlTests.m
//  SwishControl
//
//  Created by Joakim Gyllström on 2015-04-16.
//  Copyright (c) 2015 Joakim Gyllstrom. All rights reserved.
//

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
