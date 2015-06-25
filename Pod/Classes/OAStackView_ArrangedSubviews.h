//
//  OAStackView_ArrangedSubviews.h
//  Pods
//
//  Created by Thomas Visser on 25/06/15.
//
//

#import <OAStackView/OAStackView.h>

@interface OAStackView ()

- (NSUInteger)countOfArrangedSubviews;

- (nonnull UIView*)objectInArrangedSubviewsAtIndex:(NSUInteger)index;

- (NSUInteger)indexInArrangedSubviewsOfObject:(nonnull UIView *)view;

- (void)insertObject:(nullable UIView *)object inArrangedSubviewsAtIndex:(NSUInteger)index;

- (void)removeObjectFromArrangedSubviewsAtIndex:(NSUInteger)index;

- (nullable UIView *)firstArrangedSubview;

- (nullable UIView *)lastArrangedSubview;

@end
