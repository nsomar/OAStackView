//
//  OAStackViewDistributionStrategy.m
//  Pods
//
//  Created by Omar Abdelhafith on 15/06/2015.
//
//

#import "OAStackViewDistributionStrategy.h"

@interface OAStackViewDistributionStrategyFill : OAStackViewDistributionStrategy
@end

@interface OAStackViewDistributionStrategyFillEqually : OAStackViewDistributionStrategy
@end

@interface OAStackViewDistributionStrategy ()
@property(nonatomic) OAStackView *stackView;
@property(nonatomic) NSMutableArray *constraints;
@end

@implementation OAStackViewDistributionStrategy

+ (OAStackViewDistributionStrategy*)strategyWithStackView:(OAStackView *)stackView {
  Class cls;
  
  switch (stackView.distribution) {
    case OAStackViewDistributionFill:
      cls = [OAStackViewDistributionStrategyFill class];
      break;
      
    case OAStackViewDistributionFillEqually:
      cls = [OAStackViewDistributionStrategyFillEqually class];
      break;
      
    default:
      break;
  }
  
  return [[cls alloc] initStackView:stackView];
}

- (instancetype)initStackView:(OAStackView*)stackView {
  self = [super init];
  if (self) {
    _stackView = stackView;
  }
  return self;
}

- (void)alignView:(UIView*)view afterView:(UIView*)previousView {
  if (!previousView && !view) { return; }
  
  if (!previousView) {
    return [self alignFirstView:view];
  }
  
  if(!view) {
    return [self alignLastView:previousView];
  }
  
  if (previousView && view) {
    [self alignMiddleView:view afterView:previousView];
  }
}

- (void)alignLastView:(UIView*)view {
  NSString *constraintString = [NSString stringWithFormat:@"%@:[view]-0-|", [self currentAxisString]];
  [self.stackView addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                           options:0
                                           metrics:nil
                                             views:NSDictionaryOfVariableBindings(view)]];
}

- (void)alignFirstView:(UIView*)view {
  NSString *str = [NSString stringWithFormat:@"%@:|-0-[view]", [self currentAxisString]];
  [self.stackView addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:str
                                           options:0
                                           metrics:nil
                                             views:NSDictionaryOfVariableBindings(view)]];
}


- (void)alignMiddleView:(UIView*)view afterView:(UIView*)previousView {
  NSString *str = [NSString stringWithFormat:@"%@:[previousView]-%f-[view]",
                   [self currentAxisString], self.stackView.spacing];
  
  id arr = [NSLayoutConstraint constraintsWithVisualFormat:str
                                                   options:0
                                                   metrics:nil
                                                     views:NSDictionaryOfVariableBindings(view, previousView)];
  
  [self.constraints addObjectsFromArray:arr];
  [self.stackView addConstraints:arr];
}


- (NSString*)currentAxisString {
  return self.stackView.axis == UILayoutConstraintAxisHorizontal ? @"H" : @"V";
}

- (NSMutableArray *)constraints {
  if (!_constraints) {
    _constraints = [@[] mutableCopy];
  }
  
  return _constraints;
}

- (void)removeAddedConstraints {
  [self.stackView removeConstraints:self.constraints];
  [self.constraints removeAllObjects];
}

@end

@implementation OAStackViewDistributionStrategyFill
@end

@implementation OAStackViewDistributionStrategyFillEqually

- (void)alignMiddleView:(UIView*)view afterView:(UIView*)previousView {
  [super alignMiddleView:view afterView:previousView];
  [self addEqualityConstraintsBetween:view otherView:previousView];
}

- (void)addEqualityConstraintsBetween:(UIView*)view otherView:(UIView*)otherView {
  if (otherView == nil || view == nil) {
    return;
  }
  
  id constraint = [NSLayoutConstraint constraintWithItem:view
                                               attribute:[self equalityAxis]
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:otherView
                                               attribute:[self equalityAxis]
                                              multiplier:1
                                                constant:0];
  
  [self.constraints addObject:constraint];
  [self.stackView addConstraint:constraint];
}

- (NSLayoutAttribute)equalityAxis {
  return self.stackView.axis == UILayoutConstraintAxisVertical ? NSLayoutAttributeHeight : NSLayoutAttributeWidth;
}

@end