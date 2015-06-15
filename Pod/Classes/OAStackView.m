//
//  OAStackView.m
//  TestingUsingXC7
//
//  Created by Omar Abdelhafith on 14/06/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

#import "OAStackView.h"
#import "OAStackView+Constraint.h"
#import "OAStackView+Hiding.h"
#import "OAStackView+Traversal.h"


@interface OAStackView ()
@property(nonatomic, copy) NSArray *arrangedSubviews;
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
  
  [self removeDecendentConstraints];
  [self layoutArrangedViews];
}

#pragma mark - Internals

- (void)addViewsAsSubviews:(NSArray*)views {
  for (UIView *view in views) {
    [self addSubview:view];
  }
}

- (void)removeDecendentConstraints {
  for (NSInteger i = self.constraints.count - 1; i >= 0 ; i--) {
    NSLayoutConstraint *constraint = self.constraints[i];
    if ([self.subviews containsObject:constraint.firstItem] ||
        [self.subviews containsObject:constraint.secondItem]) {
      [self removeConstraint:constraint];
    }
  }
}

- (void)layoutArrangedViews {
  __block UIView *previousView = nil;
  
  [self iterateVisibleViews:^(UIView *view) {
    [self alignView:view previousView:previousView];
    previousView = view;
    [self alignViewOnOtherAxis:view];
  }];
  
  [self alignView:nil previousView:[self lastVisibleItem]];
}

- (void)alignView:(UIView*)view previousView:(UIView*)previousView {
  
  if (previousView && view) {
    NSString *str = [NSString stringWithFormat:@"%@:[previousView]-%f-[view]",
                     [self currentAxisString], self.spacing];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:str
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(view, previousView)]];
  } else if(!view) {
    NSString *constraintString = [NSString stringWithFormat:@"%@:[view]-0-|", [self currentAxisString]];
    UIView *view = previousView;
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(view)]];
  } else {
    NSString *str = [NSString stringWithFormat:@"%@:|-0-[view]", [self currentAxisString]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:str
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(view)]];
  }
  
}

- (NSString*)currentAxisString {
  return self.axis == UILayoutConstraintAxisHorizontal ? @"H" : @"V";
}

- (NSString*)otherAxisString {
  return self.axis == UILayoutConstraintAxisHorizontal ? @"V" : @"H";
}

- (NSLayoutAttribute)centerAttribute {
  return self.axis == UILayoutConstraintAxisHorizontal ? NSLayoutAttributeCenterY : NSLayoutAttributeCenterX;
}

- (void)alignViewOnOtherAxis:(UIView*)view {
  if (self.alignment == OAStackViewAlignmentCenter) {
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:view
                                  attribute:[self centerAttribute]
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:[self centerAttribute]
                                 multiplier:1 constant:0]];
    return;
  }
  
  NSString *constraintString;
  
  switch (self.alignment) {
    case OAStackViewAlignmentFill:
      constraintString = [NSString stringWithFormat:@"%@:|-0-[view]-0-|", [self otherAxisString]];
      break;
      
    case OAStackViewAlignmentLeading:
      constraintString = [NSString stringWithFormat:@"%@:|-0-[view]", [self otherAxisString]];
      break;
      
    case OAStackViewAlignmentTrailing:
      constraintString = [NSString stringWithFormat:@"%@:[view]-0-|", [self otherAxisString]];
      break;
      
    default:
      break;
  }
  
  [self addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:constraintString
                                           options:0
                                           metrics:nil
                                             views:NSDictionaryOfVariableBindings(view)]];
}

#pragma mark - Properties

- (void)setSpacing:(CGFloat)spacing {
  if (_spacing == spacing) { return; }
  
  _spacing = spacing;
  
  for (NSLayoutConstraint *constraint in self.constraints) {
    if ([self.subviews containsObject:constraint.firstItem] &&
        [self.subviews containsObject:constraint.secondItem]) {
      constraint.constant = spacing;
    }
  }
}

- (void)setAxis:(UILayoutConstraintAxis)axis {
  if (_axis == axis) { return; }
  
  _axis = axis;
  
  [self removeDecendentConstraints];
  [self layoutArrangedViews];
}

- (void)setAxisValue:(NSInteger)axisValue {
  _axisValue = axisValue;
  self.axis = self.axisValue;
}

- (void)setAlignment:(OAStackViewAlignment)alignment {
  if (_alignment == alignment) { return; }
  
  _alignment = alignment;
  [self reAlignSecondaryAxis];
}

- (void)setAlignmentValue:(NSInteger)alignmentValue {
  _alignmentValue = alignmentValue;
  self.alignment = alignmentValue;
}

- (void)reAlignSecondaryAxis {
  [self iterateVisibleViews:^(UIView *view) {
    UILayoutConstraintAxis otherAxis = self.axis == UILayoutConstraintAxisHorizontal? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
    
    NSArray *constraints = [self constraintsBetweenView:view andView:self inAxis:otherAxis];
    [self removeConstraints:constraints];
    [self alignViewOnOtherAxis:view];
  }];
}

#pragma mark subviews

- (void)didAddSubview:(UIView *)subview {
  [super didAddSubview:subview];
  [self addObserverForView:subview];
}

- (void)willRemoveSubview:(UIView *)subview {
  [super willRemoveSubview:subview];
  [self removeObserverForView:subview];
}

#pragma mark Layouting

- (void)layoutSubviews {
  [super layoutSubviews];
  [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
  CGSize size = [super intrinsicContentSize];
  
  __block float maxSize = 0;
  
  [self iterateVisibleViews:^(UIView *view) {
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

- (void)hideView:(UIView*)view {
  [self removeViewFromArrangedViews:view permanently:NO];
}

- (void)unHideView:(UIView*)view {
  int index = [self.subviews indexOfObject:view];
  [self insertArrangedSubview:view atIndex:index newItem:NO];
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
    
    if (isLastVisibleItem) {
      constraints = @[[self lastViewConstraint]];
    } else {
      constraints = [self constraintsBetweenView:previousView ?: self andView:nextView ?: self inAxis:self.axis];
    }
    
    [self removeConstraints:constraints];
    
    if (newItem) {
      [self insertSubview:view atIndex:stackIndex];
    }
  }
  
  [self alignView:view previousView:previousView];
  [self alignViewOnOtherAxis:view];
  [self alignView:nextView previousView:view];
}

- (void)removeViewFromArrangedViews:(UIView*)view permanently:(BOOL)permanently {
  int index = [self.subviews indexOfObject:view];
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
    [self alignView:nextView previousView:previousView];
  } else if(previousView) {
    [self alignView:nil previousView:[self lastVisibleItem]];
  }
}

@end
