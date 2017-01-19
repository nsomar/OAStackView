//
//  OAStackViewProxyViewController.m
//  OAStackView
//
//  Created by Omar Abdelhafith on 06/14/2015.
//  Copyright (c) 2014 Omar Abdelhafith. All rights reserved.
//

#import "OAStackViewProxyViewController.h"
#import <OAStackView/OAStackView.h>

@interface OAStackViewProxyViewController ()
@property (weak, nonatomic) OAStackViewProxy *stackView;
@property (weak, nonatomic) IBOutlet UIView *viewToRemove;
@end

@implementation OAStackViewProxyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSLog(@"%@: stackView implemented by %@ (%@)",
        NSStringFromClass([self class]),
        NSStringFromClass([self.stackView class]),
        NSStringFromClass([self.stackView superclass]));
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

- (IBAction)marginsTapped:(UIButton *)sender {
  switch (sender.tag) {
    case 100:
      self.stackView.layoutMarginsRelativeArrangement = YES;
      self.stackView.layoutMargins = UIEdgeInsetsMake(10, 0, 10, 0);
      break;
    case 200:
      self.stackView.layoutMarginsRelativeArrangement = YES;
      self.stackView.layoutMargins = UIEdgeInsetsMake(10, 20, 30, 40);
      break;
    default:
      self.stackView.layoutMarginsRelativeArrangement = NO;
      self.stackView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
      break;
  }
}

@end
