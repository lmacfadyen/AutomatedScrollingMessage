//
//  MainViewController.m
//  AutomatedScrollingMessage
//
//  Created by Lawrence F MacFadyen on 2015-02-26.
//  Copyright (c) 2015 LawrenceM. All rights reserved.
//

#import "MainViewController.h"
#import "AutomatedScrollView.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet AutomatedScrollView *automatedScrollView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_automatedScrollView start:@"Scrolling message supplied by main controller!"];
    //[_automatedScrollView setBannerColor:[UIColor redColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
