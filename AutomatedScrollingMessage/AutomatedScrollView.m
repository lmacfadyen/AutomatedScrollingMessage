//
//  AutomatedScrollView.m
//  AutomatedScrollingMessage
//
//  Created by Lawrence F MacFadyen on 2015-03-02.
//  Copyright (c) 2015 LawrenceM. All rights reserved.
//

#import "AutomatedScrollView.h"

@interface AutomatedScrollView ()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *labelContainerView;

@end

@implementation AutomatedScrollView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

#if !TARGET_INTERFACE_BUILDER
        NSBundle *bundle = [NSBundle mainBundle];
#else
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
#endif
        [bundle loadNibNamed:@"AutomatedScrollView" owner:self options:nil];

        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"AutomatedScrollView" owner:self options:nil];
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.view];
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
}

@end
