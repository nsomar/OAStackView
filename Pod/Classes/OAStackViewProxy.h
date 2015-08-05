//
//  OAStackViewProxy.h
//  Pods
//
//  Created by Natan Rolnik on 8/5/15.
//
//

#import <UIKit/UIKit.h>

@interface OAStackViewProxy : UIView

@property(nonatomic,readonly,copy) NSArray<__kindof UIView *> *arrangedSubviews;

- (instancetype)initWithArrangedSubviews:(NSArray *)arrangedSubviews;

- (void)addArrangedSubview:(UIView *)view;

- (void)removeArrangedSubview:(UIView *)view;

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;

@property(nonatomic) UILayoutConstraintAxis axis;

@property(nonatomic) UIStackViewDistribution distribution;

@property(nonatomic) UIStackViewAlignment alignment;

@property(nonatomic) CGFloat spacing;

@property(nonatomic,getter=isBaselineRelativeArrangement) BOOL baselineRelativeArrangement;

@property(nonatomic,getter=isLayoutMarginsRelativeArrangement) BOOL layoutMarginsRelativeArrangement;

@end
