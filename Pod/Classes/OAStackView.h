//
//  OAStackView.h
//  TestingUsingXC7
//
//  Created by Omar Abdelhafith on 14/06/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OAStackViewAlignment) {
  OAStackViewAlignmentFill,
  
  /* Align the leading edges of vertically stacked items
   or the top edges of horizontally stacked items tightly to the relevant edge
   of the container
   */
  OAStackViewAlignmentLeading,
  OAStackViewAlignmentTop = OAStackViewAlignmentLeading,
  OAStackViewAlignmentFirstBaseline, // Valid for horizontal axis only
  
  /* Center the items in a vertical stack horizontally
   or the items in a horizontal stack vertically
   */
  OAStackViewAlignmentCenter,
  
  /* Align the trailing edges of vertically stacked items
   or the bottom edges of horizontally stacked items tightly to the relevant
   edge of the container
   */
  OAStackViewAlignmentTrailing,
  OAStackViewAlignmentBottom = OAStackViewAlignmentTrailing,
  OAStackViewAlignmentLastBaseline, // Valid for horizontal axis only
};

NS_ASSUME_NONNULL_BEGIN
@interface OAStackView : UIView

@property(nonatomic,readonly,copy) NSArray *arrangedSubviews;

//Default is Vertical
@property(nonatomic) UILayoutConstraintAxis axis;
@property(nonatomic) IBInspectable NSInteger axisValue;

@property(nonatomic) IBInspectable CGFloat spacing;

//Default is Fill
@property(nonatomic) OAStackViewAlignment alignment;
@property(nonatomic) IBInspectable NSInteger alignmentValue;

- (instancetype)initWithArrangedSubviews:(NSArray*)views;

- (void)addArrangedSubview:(UIView *)view;
- (void)removeArrangedSubview:(UIView *)view;
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;


//TEMP
- (void)hideView:(UIView*)view;
- (void)unHideView:(UIView*)view;

@end
NS_ASSUME_NONNULL_END