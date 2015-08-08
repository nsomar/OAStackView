//
//  OAStackViewAlignmentStrategyBaseline.m
//  
//
//  Created by Omar Abdelhafith on 08/08/2015.
//
//

#import "OAStackViewAlignmentStrategyBaseline.h"


@implementation OAStackViewAlignmentStrategyBaseline

- (NSArray*)constraintsalignViewOnOtherAxis:(UIView*)view {
  id constraintString = [NSString stringWithFormat:@"%@:|-(>=0@750)-[view]-(>=0@750)-|", [self otherAxisString]];
  
  return [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)];
}

- (NSArray*)constraintsAlignView:(UIView *)view afterPreviousView:(UIView*)afterView {
  if (!view  || !afterView) { return nil; }
  
  return @[[NSLayoutConstraint constraintWithItem:view
                                        attribute:[self baselineAttribute]
                                        relatedBy:NSLayoutRelationEqual toItem:afterView
                                        attribute:[self baselineAttribute] multiplier:1.0f
                                         constant:0.0f]];
}

- (NSLayoutAttribute)baselineAttribute {
  return NSLayoutAttributeBaseline;
}

@end


@implementation OAStackViewAlignmentStrategyFirstBaseline

- (NSLayoutAttribute)baselineAttribute {
  return NSLayoutAttributeFirstBaseline;
}

@end


@implementation OAStackViewAlignmentStrategyLastBaseline

- (NSLayoutAttribute)baselineAttribute {
  return NSLayoutAttributeLastBaseline;
}

@end
