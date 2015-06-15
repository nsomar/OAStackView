//
//  OAStackView+Traversal.m
//  Pods
//
//  Created by Omar Abdelhafith on 15/06/2015.
//
//

#import "OAStackView+Traversal.h"

@implementation OAStackView (Traversal)

- (UIView*)visibleViewBeforeView:(UIView*)view {
  int index = [self.subviews indexOfObject:view];
  if (index == NSNotFound) { return nil; }
  
  return [self visibleViewBeforeIndex:index];
}

- (UIView*)visibleViewAfterView:(UIView*)view {
  int index = [self.subviews indexOfObject:view];
  if (index == NSNotFound) { return nil; }
  
  return [self visibleViewAfterIndex:index];
}

- (UIView*)visibleViewAfterIndex:(NSInteger)index {
  for (int i = index + 1; i < self.subviews.count; i++) {
    UIView *theView = self.subviews[i];
    if (!theView.hidden) {
      return theView;
    }
  }
  
  return nil;
}

- (UIView*)visibleViewBeforeIndex:(NSInteger)index {
  for (int i = index - 1; i >= 0; i--) {
    UIView *theView = self.subviews[i];
    if (!theView.hidden) {
      return theView;
    }
  }
  
  return nil;
}

- (UIView*)lastVisibleItem {
  return [self visibleViewBeforeIndex:self.subviews.count];
}

- (void)iterateVisibleViews:(void (^) (UIView *view))block {
  for (UIView *view in self.subviews) {
    
    if (view.isHidden) { continue; }
    
    block(view);
  }
}

- (NSArray*)currentVisibleViews {
  NSMutableArray *arr = [@[] mutableCopy];
  [self iterateVisibleViews:^(UIView *view) {
    [arr addObject:view];
  }];
  return arr;
}

- (BOOL)isLastVisibleItem:(UIView*)view {
  return view == [self lastVisibleItem];
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

- (BOOL)isViewLastItem:(UIView*)view excludingItem:(UIView*)excludingItem {
  NSArray *visible = [self currentVisibleViews];
  NSInteger index = [visible indexOfObject:view];
  NSInteger exclutedIndex = [visible indexOfObject:excludingItem];
  
  
  return index == visible.count - 1 ||
  (exclutedIndex  == visible.count - 1 && index  == visible.count - 2);
}


@end
