//
//  OAStackView+Traversal.h
//  Pods
//
//  Created by Omar Abdelhafith on 15/06/2015.
//
//

#import <OAStackView/OAStackView.h>

@interface OAStackView (Traversal)

- (UIView*)arrangedSubviewBeforeIndex:(NSInteger)index;
- (UIView*)arrangedSubviewBeforeView:(UIView*)view;

- (UIView*)arrangedSubviewAfterIndex:(NSInteger)index;
- (UIView*)arrangedSubviewAfterView:(UIView*)view;

- (void)iterateArrangedSubviews:(void (^) (UIView *view, UIView *previousView))block;

- (NSLayoutConstraint*)firstViewConstraint;
- (NSLayoutConstraint*)lastViewConstraint;

- (BOOL)isViewLastItem:(UIView*)view excludingItem:(UIView*)excludingItem;

@end
