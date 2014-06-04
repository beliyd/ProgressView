//
//  BDVViewController.m
//  BDVProgressView
//
//  Created by Dima Belov on 5/31/14.
//  Copyright (c) 2014 dnepr. All rights reserved.
//

#import "BDVViewController.h"
#import "BDVProgressView.h"
#import <BDVProgressView-Swift.h>

@interface BDVViewController ()

@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation BDVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self.slider addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChanged:(UISlider *)sender {
    self.progressView.progress = sender.value;
}
/**
 *  Translates the touch point into slider value and sets the percentage on progress view
 */
-(void) sliderTapped:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.slider];
    CGFloat width = CGRectGetWidth(self.slider.bounds);
    self.slider.value = self.slider.maximumValue * (point.x / width);
    
    [self.progressView setProgress:100*(self.slider.value/self.slider.maximumValue) animated:YES];
    
}

@end
