//
//  OAViewController.m
//  OAStackView
//
//  Created by Omar Abdelhafith on 06/14/2015.
//  Copyright (c) 2014 Omar Abdelhafith. All rights reserved.
//

#import "OAViewController.h"
#import "OAStackView.h"

@interface OAViewController ()
@property (weak, nonatomic) IBOutlet OAStackView *stackView;
@property (weak, nonatomic) IBOutlet UIView *viewToRemove;
@end

@implementation OAViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)twoTapped:(UIButton*)sender {
  sender.hidden = YES;
}

- (IBAction)oneTapped:(UIButton*)sender {
  sender.hidden = YES;
}

- (IBAction)threeTapped:(UIButton*)sender {
  sender.hidden = YES;
}


- (IBAction)verticalTapped:(id)sender {
  self.stackView.axis = UILayoutConstraintAxisVertical;
}

- (IBAction)horizontalTapped:(id)sender {
  self.stackView.axis = UILayoutConstraintAxisHorizontal;
}

- (IBAction)spacingTapped:(UIButton*)sender {
  self.stackView.spacing = sender.tag;
}

- (IBAction)hideAll:(UIButton*)sender {
  [self.stackView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [obj setHidden:YES];
  }];
}

- (IBAction)showAll:(UIButton*)sender {
//  [self.stackView.subviews[1] setHidden:NO];
  [self.stackView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [obj setHidden:NO];
  }];
}

- (IBAction)alignmentFill:(UIButton*)sender {
  self.stackView.alignment = OAStackViewAlignmentFill;
}

- (IBAction)alignmentCenter:(UIButton*)sender {
  self.stackView.alignment = OAStackViewAlignmentCenter;
}

- (IBAction)alignmentTrailing:(UIButton*)sender {
  self.stackView.alignment = OAStackViewAlignmentTrailing;
}

- (IBAction)alignmentLeading:(UIButton*)sender {
  self.stackView.alignment = OAStackViewAlignmentLeading;
}

- (IBAction)distributionFill:(UIButton *)sender {
  self.stackView.distribution = OAStackViewDistributionFill;
}

- (IBAction)distributionFillEqually:(UIButton *)sender {
  self.stackView.distribution = OAStackViewDistributionFillEqually;
}

- (IBAction)distributionFillProportionally:(UIButton *)sender {
  self.stackView.distribution = OAStackViewDistributionFillProportionally;
}

- (IBAction)distributionEqualSpacing:(UIButton *)sender {
   self.stackView.distribution = OAStackViewDistributionEqualSpacing;
}

- (IBAction)distributionEqualCentering:(UIButton *)sender {
   self.stackView.distribution = OAStackViewDistributionEqualCentering;
}

@end
