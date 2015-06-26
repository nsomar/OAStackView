//
//  OAStackView.m
//  OAStackView
//
//  Created by Omar Abdelhafith on 14/06/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

#import "OAStackView.h"
#import "OAStackView_ArrangedSubviews.h"
#import "OAStackView+Constraint.h"
#import "OAStackView+Hiding.h"
#import "OAStackView+Traversal.h"
#import "OAStackViewAlignmentStrategy.h"
#import "OAStackViewDistributionStrategy.h"

@interface OAStackView ()

@property (nonatomic) NSMutableArray *mutableArrangedSubviews;

@property(nonatomic) OAStackViewAlignmentStrategy *alignmentStrategy;
@property(nonatomic) OAStackViewDistributionStrategy *distributionStrategy;
@end

@implementation OAStackView

+ (Class)layerClass {
    return [CATransformLayer class];
}

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  
  if (self) {
    [self commonInit];
    [self addAllSubviewsAsArrangedSubviews];
  }
  
  return self;
}

- (instancetype)init {
  self = [self initWithArrangedSubviews:@[]];
  if (self) {
  
  }
  return self;
}

- (instancetype)initWithArrangedSubviews:(NSArray*)views {
  self = [super initWithFrame:CGRectZero];
  
  if (self) {
    [self commonInit];
    [self addArrangedSubviews:views];
  }
  
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithArrangedSubviews:@[]];
}

- (void)commonInit {
  _mutableArrangedSubviews = [NSMutableArray new];
  _axis = UILayoutConstraintAxisVertical;
  _alignment = OAStackViewAlignmentFill;
  _distribution = OAStackViewDistributionFill;
  
  _alignmentStrategy = [OAStackViewAlignmentStrategy strategyWithStackView:self];
  _distributionStrategy = [OAStackViewDistributionStrategy strategyWithStackView:self];
  
  [self layoutArrangedViews];
}

- (void)addAllSubviewsAsArrangedSubviews {
  for (UIView *view in self.subviews) {
    [self addArrangedSubview:view];
  }
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    // Does not have any effect because `CATransformLayer` is not rendered.
}

-(void)setOpaque:(BOOL)opaque {
    // Does not have any effect because `CATransformLayer` is not rendered.
}

- (void)setSpacing:(CGFloat)spacing {
  if (_spacing == spacing) { return; }
  
  _spacing = spacing;
  
  for (NSLayoutConstraint *constraint in self.constraints) {
    BOOL isWidthOrHeight =
    (constraint.firstAttribute == NSLayoutAttributeWidth) ||
    (constraint.firstAttribute == NSLayoutAttributeHeight);
    
    if ([_mutableArrangedSubviews containsObject:constraint.firstItem] &&
        [_mutableArrangedSubviews containsObject:constraint.secondItem] &&
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
  
  [self iterateArrangedSubviews:^(UIView *view, UIView *previousView) {
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
  
  [self iterateArrangedSubviews:^(UIView *view, UIView *previousView) {
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
}

#pragma mark - Adding and removing

- (void)addArrangedSubviews:(NSArray *)views {
  for (UIView *view in views) {
    [self addArrangedSubview:view];
  }
}

- (void)addArrangedSubview:(UIView *)view {
  [self insertArrangedSubview:view atIndex:[self countOfArrangedSubviews]];
}

- (void)insertArrangedSubview:(UIView * __nonnull)view atIndex:(NSUInteger)stackIndex {
  NSUInteger previousIndex = [self indexInArrangedSubviewsOfObject:view];
  NSUInteger newIndex = stackIndex;
  
  if (previousIndex == newIndex) { return; }
  
  if (previousIndex != NSNotFound) {
    // view was already arranged, remove first
    [self removeArrangedSubview:view];
    if (previousIndex < newIndex) {
      newIndex--;
    }
  }

  [self addSubview:view];
  [self insertObject:view inArrangedSubviewsAtIndex:newIndex];
}

- (void)removeArrangedSubview:(UIView *)view {
  NSUInteger index = [_mutableArrangedSubviews indexOfObject:view];
  if (index != NSNotFound) {
    [self removeObjectFromArrangedSubviewsAtIndex:index];
  }
}

- (void)didAddArrangedSubview:(UIView *)view {
  NSAssert([_mutableArrangedSubviews containsObject:view] && [self.subviews containsObject:view], @"View should already be added as subview and arranged view");
  NSUInteger stackIndex = [_mutableArrangedSubviews indexOfObject:view];
  
  UIView *previousView = [self arrangedSubviewBeforeIndex:stackIndex];
  UIView *nextView = [self arrangedSubviewAfterIndex:stackIndex];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  
  if (stackIndex == [self countOfArrangedSubviews]-1) {
    //Appending a new item
      
    NSArray *constraints = [self lastConstraintAffectingView:self andView:previousView inAxis:self.axis];
    [self removeConstraints:constraints];
  } else if (stackIndex == 0) {
    // Prepending a new item
    NSArray *constraints = [self firstConstraintAffectingView:self andView:nextView inAxis:self.axis];
    [self removeConstraints:constraints];
  } else {
    NSAssert(previousView && nextView, @"Should have both a next and previous view");
    
    //Item insertion, never as last or first view
    NSArray *constraints = [self constraintsBetweenView:previousView andView:nextView inAxis:self.axis];
    [self removeConstraints:constraints];
  }
  
  [self.distributionStrategy alignView:view afterView:previousView];
  [self.alignmentStrategy addConstraintsOnOtherAxis:view];
  [self.distributionStrategy alignView:nextView afterView:view];
}

- (void)willRemoveArrangedSubview:(UIView *)view {
  id previousView = [self arrangedSubviewBeforeView:view];
  id nextView = [self arrangedSubviewAfterView:view];
  
  NSArray *constraints = [self constraintsAffectingView:view];
  [self removeConstraints:constraints];
  
  [self.distributionStrategy alignView:nextView afterView:previousView];
}

#pragma mark - Hide and Unhide

- (void)hideView:(UIView*)view {
  [self removeArrangedSubview:view];
}

- (void)unHideView:(UIView*)view {
  // insert the view just before the next arranged view
  
  NSInteger index = [self.subviews indexOfObject:view];
  NSAssert(index != NSNotFound, @"Cannot handle a view that is becoming visible that is not our subview");
  if (index != NSNotFound) {
    UIView *nextArrangedSubview = nil;
    NSUInteger i = index+1;
    for (; i < [self.subviews count] && !nextArrangedSubview; i++) {
      UIView *view = self.subviews[i];
      if ([_mutableArrangedSubviews containsObject:view]) {
        nextArrangedSubview = view;
      }
    }
    if (nextArrangedSubview) {
      [self insertArrangedSubview:view atIndex:[self indexInArrangedSubviewsOfObject:nextArrangedSubview]];
    } else {
      [self addArrangedSubview:view];
    }
  }
}

#pragma mark - Align View

- (void)layoutArrangedViews {
  [self removeDecendentConstraints];
  
  [self iterateArrangedSubviews:^(UIView *view, UIView *previousView) {
    [self.distributionStrategy alignView:view afterView:previousView];
    [self.alignmentStrategy addConstraintsOnOtherAxis:view];
  }];
  
  [self.distributionStrategy alignView:nil afterView:[self lastArrangedSubview]];
}

- (void)didAddSubview:(UIView *)subview {
  [self addObserverForView:subview];
}

- (void)willRemoveSubview:(UIView *)subview {
  [self removeArrangedSubview:subview];
  [self removeObserverForView:subview];
}

- (UIView *)viewForBaselineLayout {
  UIView *res = nil;
  if (self.axis == UILayoutConstraintAxisHorizontal) {
    for (UIView *arrangedView in _mutableArrangedSubviews) {
      if (!res || CGRectGetHeight(res.frame) < CGRectGetHeight(arrangedView.frame)) {
        res = arrangedView;
      }
    }
    
  } else {
    res = [self lastArrangedSubview];
  }
    
  if ([res isKindOfClass:[self class]]) {
    res = [res viewForBaselineLayout];
  }
  return res;
}

#pragma mark KVO-compatible Mutable Indexed Accessors for arrangedSubviews
- (NSUInteger)countOfArrangedSubviews {
  return [_mutableArrangedSubviews count];
}

- (UIView *)objectInArrangedSubviewsAtIndex:(NSUInteger)index {
  return [_mutableArrangedSubviews objectAtIndex:index];
}

- (NSUInteger)indexInArrangedSubviewsOfObject:(UIView *)view {
  return [_mutableArrangedSubviews indexOfObject:view];
}

- (void)insertObject:(UIView *)object inArrangedSubviewsAtIndex:(NSUInteger)index {
  [_mutableArrangedSubviews insertObject:object atIndex:index];
  [self didAddArrangedSubview:object];
}

- (void)removeObjectFromArrangedSubviewsAtIndex:(NSUInteger)index {
  UIView *view = _mutableArrangedSubviews[index];
  [self willRemoveArrangedSubview:view];
  [_mutableArrangedSubviews removeObjectAtIndex:index];
}

- (NSArray * __nonnull)arrangedSubviews {
  return [_mutableArrangedSubviews copy];
}

- (UIView *)firstArrangedSubview {
  return [_mutableArrangedSubviews firstObject];
}

- (UIView *)lastArrangedSubview {
  return [_mutableArrangedSubviews lastObject];
}

@end
