//
//  BSViewController.m
//  SwishControl
//
//  Created by Joakim Gyllstrom on 04/14/2015.
//  Copyright (c) 2014 Joakim Gyllstrom. All rights reserved.
//

#import "BSViewController.h"
#import <SwishControl/SwishControl.h>

@interface BSViewController ()

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end

@implementation BSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(myAction)];
    
    NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"click2" ofType:@"wav"];
    [self.secondButton bs_setAudioWithPath:clickPath forEvent:UIControlEventTouchUpInside];
}

- (void)myAction {
    NSLog(@"Hello, is it me you're looking for?");
}

@end
