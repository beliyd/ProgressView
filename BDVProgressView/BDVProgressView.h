//
//  BDVProgressView.h
//  BDVProgressView
//
//  Created by Dima Belov on 5/31/14.
//  Copyright (c) 2014 dnepr. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Simple progress view that supports displaying of progress between 0 and 100%
 */
@interface BDVProgressView : UIView

/**
 *  Set the property to update the view with percent of progress.
 */
@property (assign, nonatomic) CGFloat progress;

/**
 *  Sets the progress property of the view
 *
 *  @param progress value between 0% and 100%.  Values above or below the limits will be pinned to maximum or minimum.
 *  @param animated animates the setting
 */
-(void) setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
