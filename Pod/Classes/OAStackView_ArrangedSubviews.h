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

- (UIView* __nonnull)objectInArrangedSubviewsAtIndex:(NSUInteger)index;

- (NSUInteger)indexInArrangedSubviewsOfObject:(UIView * __nonnull)view;

- (void)insertObject:(UIView * __nonnull)object inArrangedSubviewsAtIndex:(NSUInteger)index;

- (void)removeObjectFromArrangedSubviewsAtIndex:(NSUInteger)index;

- (UIView * __nullable)firstArrangedSubview;

- (UIView * __nullable)lastArrangedSubview;

@end
