//
//  OAStackViewAlignmentStrategy.h
//  Pods
//
//  Created by Omar Abdelhafith on 15/06/2015.
//
//

#import <UIKit/UIKit.h>
#import "OAStackView.h"


@interface OAStackViewAlignmentStrategy : NSObject

+ (OAStackViewAlignmentStrategy*)strategyWithStackView:(OAStackView *)stackView;

- (void)addConstraintsOnOtherAxis:(UIView*)view;
- (void)alignView:(UIView*)view withPreviousView:(UIView*)previousView;

- (void)removeAddedConstraints;

@end
