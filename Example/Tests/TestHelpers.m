//
//  TestHelpers.m
//  
//
//  Created by Omar Abdelhafith on 08/08/2015.
//
//

#import "TestHelpers.h"


UIColor *randomColor() {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
  return color;
}

UIView *createView(float width, float height) {
  return createViewP(width, 1000, height, 1000);
}

UIView *createViewP(float width, float widthPriority, float height, float heightPriority) {
  UIColor *color = randomColor();
  UIButton *view = [UIButton new];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  [view setTitle:@"the title" forState:UIControlStateNormal];
  NSString *constraintStr = [NSString stringWithFormat:@"V:[view(%f@%f)]", height, heightPriority];
  [view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:constraintStr
                                           options:0
                                           metrics:0
                                             views:NSDictionaryOfVariableBindings(view)]];
  
  constraintStr = [NSString stringWithFormat:@"H:[view(%f@%f)]", width, widthPriority];
  [view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:constraintStr
                                           options:0
                                           metrics:0
                                             views:NSDictionaryOfVariableBindings(view)]];
  
  view.backgroundColor = color;
  return view;
}

UILabel *createLabel(float width, float widthPriority) {
  UIColor *color = randomColor();
  UILabel *label = [UILabel new];
  label.translatesAutoresizingMaskIntoConstraints = NO;
 
  NSString *constraintStr = [NSString stringWithFormat:@"H:[label(%f@%f)]", width, widthPriority];
  [label addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:constraintStr
                                           options:0
                                           metrics:0
                                             views:NSDictionaryOfVariableBindings(label)]];
  
  label.backgroundColor = color;
  return label;
}

void addWidthToView(UIView *view, float width, float widthPriority) {
  NSString *constraintStr = [NSString stringWithFormat:@"H:[view(%f@%f)]", width, widthPriority];
  [view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:constraintStr
                                           options:0
                                           metrics:0
                                             views:NSDictionaryOfVariableBindings(view)]];
}

void addHightToView(UIView *view, float height, float heightPriority) {
  NSString *constraintStr = [NSString stringWithFormat:@"V:[view(%f@%f)]", height, heightPriority];
  [view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:constraintStr
                                           options:0
                                           metrics:0
                                             views:NSDictionaryOfVariableBindings(view)]];
}

void layoutView(UIView* view) {
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  [window addSubview:view];
  
  [window setNeedsLayout];
  [window layoutIfNeeded];
}