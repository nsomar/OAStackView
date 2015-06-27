//
//  OAStackView+Traversal.m
//  Pods
//
//  Created by Omar Abdelhafith on 15/06/2015.
//
//

#import "OAStackView+Traversal.h"
#import "OAStackView_ArrangedSubviews.h"

@implementation OAStackView (Traversal)

- (UIView*)arrangedSubviewBeforeView:(UIView*)view {
  NSInteger index = [self indexInArrangedSubviewsOfObject:view];
  if (index == NSNotFound) { return nil; }
  
  return [self arrangedSubviewBeforeIndex:index];
}

- (UIView*)arrangedSubviewAfterView:(UIView*)view {
  NSInteger index = [self indexInArrangedSubviewsOfObject:view];
  if (index == NSNotFound) { return nil; }
  
  return [self arrangedSubviewAfterIndex:index];
}

- (UIView*)arrangedSubviewAfterIndex:(NSInteger)index {
  if ((index + 1) < [self countOfArrangedSubviews]) {
    return [self objectInArrangedSubviewsAtIndex:index+1];
  }
  
  return nil;
}

- (UIView*)arrangedSubviewBeforeIndex:(NSInteger)index {
  if (index > 0) {
    return [self objectInArrangedSubviewsAtIndex:index-1];
  }
  
  return nil;
}

- (void)iterateArrangedSubviews:(void (^) (UIView *view, UIView *previousView))block {
  UIView *previousView = nil;
  for (NSUInteger i = 0; i < [self countOfArrangedSubviews]; i++) {
    UIView *view = [self objectInArrangedSubviewsAtIndex:i];
    
    block(view, previousView);
    previousView = view;
  }
}

- (NSLayoutConstraint*)lastViewConstraint {
  for (NSLayoutConstraint *constraint in self.constraints) {
    
    if (self.axis == UILayoutConstraintAxisVertical) {
      if ( (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeBottom) ||
          (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeBottom)) {
        return constraint;
      }
    } else {
      if ( (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeTrailing) ||
          (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeTrailing)) {
        return constraint;
      }
    }
    
  }
  return nil;
}


- (NSLayoutConstraint*)firstViewConstraint {
  for (NSLayoutConstraint *constraint in self.constraints) {
    
    if (self.axis == UILayoutConstraintAxisVertical) {
      if ( (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeTop) ||
          (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeTop)) {
        return constraint;
      }
    } else {
      if ( (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeLeading) ||
          (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeLeading)) {
        return constraint;
      }
    }
    
  }
  return nil;
}

- (BOOL)isViewLastItem:(UIView*)view excludingItem:(UIView*)excludingItem {
  NSArray *visible = [self arrangedSubviews];
  NSInteger index = [visible indexOfObject:view];
  NSInteger exclutedIndex = [visible indexOfObject:excludingItem];
  
  
  return index == visible.count - 1 ||
  (exclutedIndex  == visible.count - 1 && index  == visible.count - 2);
}


@end
