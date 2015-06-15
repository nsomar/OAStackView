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
	// Do any additional setup after loading the view, typically from a nib.
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

- (IBAction)buttonTapped:(id)sender {
//  UIButton *button = [[UIButton alloc] init];
//  [button setTitle:@"The tittle" forState:UIControlStateNormal];
//  [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//  [self.stackView insertArrangedSubview:button atIndex:0];
  
//  self.stackView.alignment = OAStackViewAlignmentLeading;
  self.viewToRemove.hidden = !self.viewToRemove.hidden;
//  [self.stackView removeArrangedSubview:self.viewToRemove];
  
//  [UIView animateWithDuration:.3 animations:^{
//  self.stackView.axis =  self.stackView.axis == UILayoutConstraintAxisHorizontal? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
//    self.stackView.spacing = self.stackView.spacing == 20 ? 10 : 20;
//      self.stackView.alignment = OAStackViewAlignmentLeading;
//    [self.stackView layoutIfNeeded];
//  }];
}

@end
