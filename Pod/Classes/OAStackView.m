//
//  OAStackView.m
//  OAStackView
//
//  Created by Omar Abdelhafith on 14/06/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

#import "OAStackView.h"
#import "OAStackView+Constraint.h"
#import "OAStackView+Hiding.h"
#import "OAStackView+Traversal.h"
#import "OAStackViewAlignmentStrategy.h"
#import "OAStackViewDistributionStrategy.h"

@interface OAStackView ()
@property(nonatomic, copy) NSArray *arrangedSubviews;

@property(nonatomic) OAStackViewAlignmentStrategy *alignmentStrategy;
@property(nonatomic) OAStackViewDistributionStrategy *distributionStrategy;
@end

@implementation OAStackView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  
  if (self) {
    [self commonInit];
  }
  
  return self;
}

- (instancetype)initWithArrangedSubviews:(NSArray*)views {
  self = [super init];
  
  if (self) {
    [self addViewsAsSubviews:views];
    [self commonInit];
  }
  
  return self;
}

- (UIColor * __nullable)backgroundColor {
  return [UIColor clearColor];
}

- (void)commonInit {
  _axis = UILayoutConstraintAxisVertical;
  _alignment = OAStackViewAlignmentFill;
  _distribution = OAStackViewDistributionFill;
  
  _alignmentStrategy = [OAStackViewAlignmentStrategy strategyWithStackView:self];
  _distributionStrategy = [OAStackViewDistributionStrategy strategyWithStackView:self];
  
  [self layoutArrangedViews];
}

#pragma mark - Properties

- (void)setSpacing:(CGFloat)spacing {
  if (_spacing == spacing) { return; }
  
  _spacing = spacing;
  
  for (NSLayoutConstraint *constraint in self.constraints) {
    BOOL isWidthOrHeight =
    (constraint.firstAttribute == NSLayoutAttributeWidth) ||
    (constraint.firstAttribute == NSLayoutAttributeHeight);
    
    if ([self.subviews containsObject:constraint.firstItem] &&
        [self.subviews containsObject:constraint.secondItem] &&
        !isWidthOrHeight) {
      constraint.constant = spacing;
    }
  }
}

- (void)setAxis:(UILayoutConstraintAxis)axis {
  if (_axis == axis) { return; }
  
  _axis = axis;
  _alignmentStrategy = [OAStackViewAlignmentStrategy strategyWithStackView:self];
  
  [self layoutArrangedViews];
}

- (void)setAxisValue:(NSInteger)axisValue {
  _axisValue = axisValue;
  self.axis = self.axisValue;
}

- (void)setAlignment:(OAStackViewAlignment)alignment {
  if (_alignment == alignment) { return; }
  
  _alignment = alignment;
  
  [self.alignmentStrategy removeAddedConstraints];
  self.alignmentStrategy = [OAStackViewAlignmentStrategy strategyWithStackView:self];
  
  [self iterateVisibleViews:^(UIView *view, UIView *previousView) {
    [self.alignmentStrategy addConstraintsOnOtherAxis:view];
  }];
}

- (void)setAlignmentValue:(NSInteger)alignmentValue {
  _alignmentValue = alignmentValue;
  self.alignment = alignmentValue;
}

- (void)setDistribution:(OAStackViewDistribution)distribution {
  if (_distribution == distribution) { return; }
  
  _distribution = distribution;
  
  [self.alignmentStrategy removeAddedConstraints];
  [self.distributionStrategy removeAddedConstraints];
  
  self.alignmentStrategy = [OAStackViewAlignmentStrategy strategyWithStackView:self];
  self.distributionStrategy = [OAStackViewDistributionStrategy strategyWithStackView:self];
  
  [self iterateVisibleViews:^(UIView *view, UIView *previousView) {
    [self.alignmentStrategy addConstraintsOnOtherAxis:view];
    [self.distributionStrategy alignView:view afterView:previousView];
  }];
}

- (void)setDistributionValue:(NSInteger)distributionValue {
  _distributionValue = distributionValue;
  self.distribution = distributionValue;
}

#pragma mark Layouting

- (void)layoutSubviews {
  [super layoutSubviews];
  [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
  CGSize size = [super intrinsicContentSize];
  
  __block float maxSize = 0;
  
  [self iterateVisibleViews:^(UIView *view, UIView *previousView) {
    if (self.axis == UILayoutConstraintAxisVertical) {
      maxSize = fmaxf(maxSize, CGRectGetWidth(view.frame));
    } else {
      maxSize = fmaxf(maxSize, CGRectGetHeight(view.frame));
    }
  }];
  
  if (self.axis == UILayoutConstraintAxisVertical) {
    size.width = maxSize;
  } else {
    size.height = maxSize;
  }
  
  return size;
}

#pragma mark - Adding and removing

- (void)addArrangedSubview:(UIView *)view {
  [self insertArrangedSubview:view atIndex:self.subviews.count];
}

- (void)removeArrangedSubview:(UIView *)view {
  
  if (self.subviews.count == 1) {
    [view removeFromSuperview];
    return;
  }
  
  [self removeViewFromArrangedViews:view permanently:YES];
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
  [self insertArrangedSubview:view atIndex:stackIndex newItem:YES];
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex newItem:(BOOL)newItem {
  
  id previousView, nextView;
  view.translatesAutoresizingMaskIntoConstraints = NO;
  BOOL isAppending = stackIndex == self.subviews.count;
  
  if (isAppending) {
    //Appending a new item
    
    previousView = [self lastVisibleItem];
    nextView = nil;
    
    NSArray *constraints = [self constraintsBetweenView:self andView:previousView inAxis:self.axis];
    [self removeConstraints:constraints];
    
    if (newItem) {
      [self addSubview:view];
    }
    
  } else {
    //Item insertion
    
    previousView = [self visibleViewBeforeIndex:stackIndex];
    nextView = [self visibleViewAfterIndex:newItem ? stackIndex - 1: stackIndex];
    
    NSArray *constraints;
    BOOL isLastVisibleItem = [self isViewLastItem:previousView excludingItem:view];
    BOOL isFirstVisibleView = previousView == nil;
    BOOL isOnlyItem = previousView == nil && nextView == nil;
    
    if (isLastVisibleItem) {
      constraints = @[[self lastViewConstraint]];
    } else if(isOnlyItem) {
      constraints = [self constraintsBetweenView:previousView ?: self andView:nextView ?: self inAxis:self.axis];
    } else if(isFirstVisibleView) {
      constraints = @[[self firstViewConstraint]];
    } else {
      constraints = [self constraintsBetweenView:previousView ?: self andView:nextView ?: self inAxis:self.axis];
    }
    
    [self removeConstraints:constraints];
    
    if (newItem) {
      [self insertSubview:view atIndex:stackIndex];
    }
  }
  
  [self.distributionStrategy alignView:view afterView:previousView];
  [self.alignmentStrategy addConstraintsOnOtherAxis:view];
  [self.distributionStrategy alignView:nextView afterView:view];
}

- (void)removeViewFromArrangedViews:(UIView*)view permanently:(BOOL)permanently {
  NSInteger index = [self.subviews indexOfObject:view];
  if (index == NSNotFound) { return; }
  
  id previousView = [self visibleViewBeforeView:view];
  id nextView = [self visibleViewAfterView:view];
  
  if (permanently) {
    [view removeFromSuperview];
  } else {
    NSArray *constraint = [self constraintsAffectingView:view];
    [self removeConstraints:constraint];
  }
  
  if (nextView) {
    [self.distributionStrategy alignView:nextView afterView:previousView];
  } else if(previousView) {
    [self.distributionStrategy alignView:nil afterView:[self lastVisibleItem]];
  }
}

#pragma mark - Hide and Unhide

- (void)hideView:(UIView*)view {
  [self removeViewFromArrangedViews:view permanently:NO];
}

- (void)unHideView:(UIView*)view {
  NSInteger index = [self.subviews indexOfObject:view];
  [self insertArrangedSubview:view atIndex:index newItem:NO];
}

#pragma mark - Align View

- (void)layoutArrangedViews {
  [self removeDecendentConstraints];
  
  [self iterateVisibleViews:^(UIView *view, UIView *previousView) {
    [self.distributionStrategy alignView:view afterView:previousView];
    [self.alignmentStrategy addConstraintsOnOtherAxis:view];
  }];
  
  [self.distributionStrategy alignView:nil afterView:[self lastVisibleItem]];
}

- (void)addViewsAsSubviews:(NSArray*)views {
  for (UIView *view in views) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
  }
}

@end
