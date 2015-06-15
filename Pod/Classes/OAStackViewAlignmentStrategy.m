//
//  OAStackViewAlignmentStrategy.m
//  Pods
//
//  Created by Omar Abdelhafith on 15/06/2015.
//
//

#import "OAStackViewAlignmentStrategy.h"

@interface OAStackViewAlignmentStrategyFill : OAStackViewAlignmentStrategy
@end

@interface OAStackViewAlignmentStrategyTrailing : OAStackViewAlignmentStrategy
@end

@interface OAStackViewAlignmentStrategyLeading : OAStackViewAlignmentStrategy
@end

@interface OAStackViewAlignmentStrategyCenter: OAStackViewAlignmentStrategy
@end

@interface OAStackViewAlignmentStrategy ()
@property(nonatomic) OAStackView *stackView;
@property(nonatomic) NSMutableArray *constraints;
@end

@implementation OAStackViewAlignmentStrategy

+ (OAStackViewAlignmentStrategy*)strategyWithStackView:(OAStackView *)stackView {
  
  Class cls;
  switch (stackView.alignment) {

    case OAStackViewAlignmentFill:
      cls = [OAStackViewAlignmentStrategyFill class];
      break;
      
    case OAStackViewAlignmentLeading:
      cls = [OAStackViewAlignmentStrategyLeading class];
      break;
      
    case OAStackViewAlignmentTrailing:
      cls = [OAStackViewAlignmentStrategyTrailing class];
      break;
      
    case OAStackViewAlignmentCenter:
      cls = [OAStackViewAlignmentStrategyCenter class];
      break;
      
    default:
      break;
  }
  
  return [[cls alloc] initWithWithStackView:stackView];
}

- (instancetype)initWithWithStackView:(OAStackView *)stackView {
  self = [super init];
  if (self) {
    _stackView = stackView;;
  }
  return self;
}

- (NSString*)otherAxisString {
  return self.stackView.axis == UILayoutConstraintAxisHorizontal ? @"V" : @"H";
}

- (NSLayoutAttribute)centerAttribute {
  return self.stackView.axis == UILayoutConstraintAxisHorizontal ? NSLayoutAttributeCenterY : NSLayoutAttributeCenterX;
}

- (void)addConstraintsOnOtherAxis:(UIView*)view {
  id arr = [self constraintsalignViewOnOtherAxis:view];
  [self.constraints addObjectsFromArray:arr];
  
  [self.stackView addConstraints:arr];
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

- (NSArray*)constraintsalignViewOnOtherAxis:(UIView*)view { /* subclassing */ return nil; }

@end

@implementation OAStackViewAlignmentStrategyFill

- (NSArray*)constraintsalignViewOnOtherAxis:(UIView*)view {
  
  id constraintString = [NSString stringWithFormat:@"%@:|-0-[view]-0-|", [self otherAxisString]];
  
  return [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)];
}

@end

@implementation OAStackViewAlignmentStrategyLeading

- (NSArray*)constraintsalignViewOnOtherAxis:(UIView*)view {
  
  id constraintString = [NSString stringWithFormat:@"%@:|-0-[view]", [self otherAxisString]];
  
  return [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)];
}

@end

@implementation OAStackViewAlignmentStrategyTrailing

- (NSArray*)constraintsalignViewOnOtherAxis:(UIView*)view {
  
  id constraintString = [NSString stringWithFormat:@"%@:[view]-0-|", [self otherAxisString]];
  
  return [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)];
}

@end

@implementation OAStackViewAlignmentStrategyCenter

- (NSArray*)constraintsalignViewOnOtherAxis:(UIView*)view {
  
  return @[[NSLayoutConstraint constraintWithItem:view
                               attribute:[self centerAttribute]
                               relatedBy:NSLayoutRelationEqual
                                  toItem:view.superview
                               attribute:[self centerAttribute]
                                       multiplier:1 constant:0]];
}

@end
