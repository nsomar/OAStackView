//
//  OAStackView+Hiding.h
//  Pods
//
//  Created by Omar Abdelhafith on 15/06/2015.
//
//

#import <OAStackView/OAStackView.h>

@interface OAStackView (Hiding)

- (void)addObserverForView:(UIView*)view;
- (void)addObserverForViews:(NSArray*)views;

- (void)removeObserverForView:(UIView*)view;
- (void)removeObserverForViews:(NSArray *)views;

@end
