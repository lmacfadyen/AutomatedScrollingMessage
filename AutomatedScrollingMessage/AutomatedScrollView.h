//
//  AutomatedScrollView.h
//  AutomatedScrollingMessage
//
//  Created by Lawrence F MacFadyen on 2015-03-02.
//  Copyright (c) 2015 LawrenceM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutomatedScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) UIColor *labelTextColor;

-(void)start:(NSString *)label;
-(void)stop;
-(void)setBannerColor:(UIColor *)color;



@end
