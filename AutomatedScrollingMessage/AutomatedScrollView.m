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

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *visibleLabels;
@property (nonatomic, strong) NSString *labelText;

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

- (void)awakeFromNib
{
    _labelText = @"This is a default message to scroll";
    _labelTextColor = [UIColor whiteColor];
    _visibleLabels = [[NSMutableArray alloc] init];
    [_scrollView setDelegate:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Trigger layout after a scrolling increment
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Scrolling Control and Timing

// Initiate the scrolling with a timer that will control its movement
- (void)doHorizontalScrolling
{
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                      target:self
                                                    selector:@selector(doSingleScroll:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

// Triggered by the timer to do one scroll increment
- (void)doSingleScroll:(NSTimer *)timerParam
{
    CGPoint currentOffset = [_scrollView contentOffset];
    int x = currentOffset.x;
    _scrollView.contentOffset = CGPointMake(x + 5, currentOffset.y);
}

// Stop and remove timer
- (void)stopTimer
{
    if (self.timer == nil)
        return;
    if ([self.timer isValid])
    {
        [self.timer invalidate];
    }
    self.timer = nil;
}

// Remove all labels from the array of labels
- (void)removeAllLabels
{
    // Remove labels from view
    for (UILabel *nextlabel in _visibleLabels)
    {
        [nextlabel removeFromSuperview];
    }
    // Clear the visibleLabels
    [_visibleLabels removeAllObjects];
}

#pragma mark - Label Tiling

- (void)tileLabelsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    
    // The upcoming tiling logic depends on there already being at least one label in the
    // visibleLabels array, so to kick off the tiling we need to make sure there's at least one
    // label
    if ([_visibleLabels count] == 0)
    {
        [self placeNewLabelOnRight:minimumVisibleX];
    }
    
    // Add labels that are missing on right side
    UILabel *lastLabel = [_visibleLabels lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastLabel frame]);
    while (rightEdge < maximumVisibleX)
    {
        rightEdge = [self placeNewLabelOnRight:rightEdge];
    }
    
    // Add labels that are missing on left side
    UILabel *firstLabel = _visibleLabels[0];
    CGFloat leftEdge = CGRectGetMinX([firstLabel frame]);
    while (leftEdge > minimumVisibleX)
    {
        leftEdge = [self placeNewLabelOnLeft:leftEdge];
    }
    
    // Remove labels that have fallen off right edge
    lastLabel = [_visibleLabels lastObject];
    while ([lastLabel frame].origin.x > maximumVisibleX)
    {
        [lastLabel removeFromSuperview];
        [_visibleLabels removeLastObject];
        lastLabel = [_visibleLabels lastObject];
    }
    
    // Remove labels that have fallen off left edge
    firstLabel = _visibleLabels[0];
    while (CGRectGetMaxX([firstLabel frame]) < minimumVisibleX)
    {
        [firstLabel removeFromSuperview];
        [_visibleLabels removeObjectAtIndex:0];
        firstLabel = _visibleLabels[0];
    }
}

- (UILabel *)insertLabel
{
    UILabel *label = [[UILabel alloc] init];
    [label setNumberOfLines:1];
    [label setText:_labelText];
    
    [label setTextColor:self.labelTextColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [label setFont:[UIFont systemFontOfSize:40]];
    }
    
    [label sizeToFit];
    // Make the label a bit wider than the text for nice message separation when scrolling
    [label setBounds:CGRectMake(0, 0, label.bounds.size.width + 75,
                                _labelContainerView.bounds.size.height)];
    [_labelContainerView addSubview:label];
    
    return label;
}

- (CGFloat)placeNewLabelOnRight:(CGFloat)rightEdge
{
    UILabel *label = [self insertLabel];
    [_visibleLabels addObject:label]; // add rightmost label at the end of the array
    
    CGRect frame = [label frame];
    frame.origin.x = rightEdge;
    frame.origin.y = [_labelContainerView bounds].size.height / 2 - frame.size.height / 2;
    [label setFrame:frame];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewLabelOnLeft:(CGFloat)leftEdge
{
    UILabel *label = [self insertLabel];
    [_visibleLabels insertObject:label
                         atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [label frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = [_labelContainerView bounds].size.height / 2 - frame.size.height / 2;
    [label setFrame:frame];
    
    return CGRectGetMinX(frame);
}

#pragma mark - Layout and Recentering

- (void)layoutSubviews
{
    BOOL shouldRestartScrolling = NO;
    
    [super layoutSubviews];
    
    if ([self recenterIfNecessary])
    {
        shouldRestartScrolling = YES;
    }
    
    // Tile content in visible bounds
    CGRect visibleBounds =
    [_scrollView convertRect:[_scrollView bounds] toView:_labelContainerView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileLabelsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
    if (shouldRestartScrolling)
    {
        [self doHorizontalScrolling];
    }
}

// Recenter content periodically to achieve impression of infinite scrolling
- (BOOL)recenterIfNecessary
{
    BOOL didRecenter = NO;
    
    CGPoint currentOffset = [_scrollView contentOffset];
    CGFloat contentWidth = [_scrollView contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [_scrollView bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0))
    {
        [self stopTimer];
        didRecenter = YES;
        _scrollView.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // Recenter by moving the visible bounds to its center location and move the content by the
        // same amount so it appears to stay still and we are viewing what we were before
        // recentering visible bounds
        for (UILabel *label in _visibleLabels)
        {
            CGPoint center = [_labelContainerView convertPoint:label.center toView:_scrollView];
            center.x += (centerOffsetX - currentOffset.x);
            label.center = [_scrollView convertPoint:center toView:_labelContainerView];
        }
    }
    return didRecenter;
}




@end
