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
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
- (IBAction)switchPressed:(id)sender;

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


- (IBAction)switchPressed:(id)sender {
    if (self.switchView.isOn)
    {
        [self.automatedScrollView start:@"Scrolling text that we set from the Switch!"];
    }
    else
    {
        [self.automatedScrollView stop];
    }
}
@end
