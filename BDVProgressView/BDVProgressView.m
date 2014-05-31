//
//  BDVProgressView.m
//  BDVProgressView
//
//  Created by Dima Belov on 5/31/14.
//  Copyright (c) 2014 dnepr. All rights reserved.
//

#import "BDVProgressView.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)
#define kProgressRadius 100

@interface BDVProgressView ()

@property (strong, nonatomic) UILabel * progressLabel;
@property (strong, nonatomic) CAShapeLayer * progressShape;

@end

@implementation BDVProgressView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    [self initializeViews];
}

/**
 *  Initializes the views and the shape layer.
 */
-(void) initializeViews {
    
    self.progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.progressLabel.font = [UIFont systemFontOfSize:50];
    self.progressLabel.attributedText = [self formattedProgressPercent:0.0];
    self.progressLabel.numberOfLines = 1;
    self.progressLabel.textColor = [UIColor greenColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:self.progressLabel];
    
    self.progressShape = [CAShapeLayer layer];
    self.progressShape.strokeColor = [UIColor greenColor].CGColor;
    self.progressShape.fillColor = [UIColor clearColor].CGColor;
    self.progressShape.lineWidth = 20;
    self.progressShape.strokeEnd = 0;
    
    [self.layer addSublayer:self.progressShape];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    //Set the path to 100 (full circle) and reset the center
    self.progressShape.path = [self createProgressPath:100.0].CGPath;
}

#pragma mark - Progress handlers

-(void) setProgress:(CGFloat) progress {
    [self setProgress:progress animated:NO];
}

-(void) setProgress:(CGFloat) progress animated:(BOOL)animated {
    CGFloat oldProgress = _progress;
  
    //Make sure progress is within limits
    _progress = progress < 0 ? 0 : (progress > 100) ? 100 : progress;
    CGFloat percent = progress/100;
    self.progressLabel.attributedText = [self formattedProgressPercent:progress];
    if(animated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = ABS((oldProgress-progress)/100);
        pathAnimation.fromValue = @(self.progressShape.strokeEnd);
        pathAnimation.toValue = @(percent);
        [self.progressShape addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
    [self updateShapeLayerWithPercent:percent];
}

/**
 *  Disables the implicit animation on the CAShapeLayer and sets the strokeEnd
 *
 *  @param percent a value from 0.0 to 1.0
 */
-(void) updateShapeLayerWithPercent:(CGFloat) percent {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.progressShape.strokeEnd = percent;
    [CATransaction commit];
}

#pragma mark - string helper

-(NSAttributedString *) formattedProgressPercent:(CGFloat)percent {
    NSString * progressString = [NSString stringWithFormat:@"%.02f%%",percent];
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:progressString];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange([progressString length]-1, 1)];
    return attrString;
}

#pragma mark - path helper

- (UIBezierPath *)createProgressPath:(CGFloat)percent;
{
    //Offset the angle to start at the bottom of the label
    CGFloat degree = (360 * percent/100) + 90;
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:self.progressLabel.center
                                                         radius:kProgressRadius
                                                     startAngle:DEGREES_TO_RADIANS(90)
                                                       endAngle:DEGREES_TO_RADIANS(degree)
                                                      clockwise:YES];
    
    return aPath;
}


@end
