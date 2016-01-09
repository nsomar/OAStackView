//
//  OAStackViewAlignmentSpec.m
//
//
//  Created by Omar Abdelhafith on 08/08/2015.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OAStackView.h"
#import "TestHelpers.h"


SPEC_BEGIN(OAStackViewAlignmentSpec)

describe(@"OAStackViewAlignment", ^{
  
  __block OAStackView *stackView;
  
  context(@"Alignemnt", ^{
    
    __block UIView *view1, *view2, *view3;
    
    beforeEach(^{
      view1 = createViewP(200, 300, 20, 250);
      view2 = createViewP(500, 300, 30, 250);
      view3 = createViewP(600, 330, 40, 250);
      
      NSArray *views = @[view1, view2, view3];
      
      stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
      stackView.axis = UILayoutConstraintAxisVertical;
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
    });
    
    it(@"Arrange the views to fill the whole axis if OAStackViewAlignmentFill is passed", ^{
      stackView.alignment = OAStackViewAlignmentFill;
      layoutView(stackView);
      
      [[theValue(CGRectGetMinX(view3.frame)) should] equal:theValue(0)];
      [[theValue(CGRectGetWidth(view3.frame)) should] equal:theValue(600)];
      
      [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(0)];
      [[theValue(CGRectGetWidth(view2.frame)) should] equal:theValue(600)];
    });
    
    it(@"Arrange the views on the begginning of the axis if OAStackViewAlignmentLeading is passed", ^{
      stackView.alignment = OAStackViewAlignmentLeading;
      layoutView(stackView);
      
      [[theValue(CGRectGetMinX(view1.frame)) should] equal:theValue(0)];
      [[theValue(CGRectGetWidth(view1.frame)) should] equal:theValue(200)];
      
      [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(0)];
      [[theValue(CGRectGetWidth(view2.frame)) should] equal:theValue(500)];
    });
    
    it(@"Arrange the views on the End of the axis if OAStackViewAlignmentTrailing is passed", ^{
      stackView.alignment = OAStackViewAlignmentTrailing;;
      layoutView(stackView);
      
      [[theValue(CGRectGetMinX(view1.frame)) should] equal:theValue(400)];
      [[theValue(CGRectGetWidth(view1.frame)) should] equal:theValue(200)];
      
      [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(100)];
      [[theValue(CGRectGetWidth(view2.frame)) should] equal:theValue(500)];
    });
    
    it(@"Arrange the views on the Center of the axis if OAStackViewAlignmentCenter is passed", ^{
      stackView.alignment = OAStackViewAlignmentCenter;
      layoutView(stackView);
      
      [[theValue(CGRectGetMinX(view1.frame)) should] equal:theValue(200)];
      [[theValue(CGRectGetWidth(view1.frame)) should] equal:theValue(200)];
      
      [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(50)];
      [[theValue(CGRectGetWidth(view2.frame)) should] equal:theValue(500)];
    });
    
  });
  
  
  context(@"Baseline alignment", ^{
    __block UILabel *label;
    __block UIView *view;
    
    beforeEach(^{
      label = createLabel(150, 1000);
      view = createViewP(100, 300, 30, 250);
      
      NSArray *views = @[label, view];
      
      stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
      stackView.axis = UILayoutConstraintAxisHorizontal;
      stackView.distribution = OAStackViewDistributionFill;
    });
    
    it(@"Arrange the view based on the first baseline", ^{
      
      if (OA_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        stackView.alignment = OAStackViewAlignmentFirstBaseline;
        label.text = @"hello world hello world hello world hello world ";
        label.numberOfLines = 0;
        
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(view.frame)) shouldNot] equal:theValue(CGRectGetHeight(label.frame))];
        [[theValue(CGRectGetMinY(view.frame)) should] equal:theValue(0)];
      }
    });
    
    it(@"Arrange the view based on the last baseline", ^{
      stackView.alignment = OAStackViewAlignmentLastBaseline;
      label.text = @"hello world hello world hello world hello world ";
      label.numberOfLines = 0;
      
      layoutView(stackView);
      
      [[theValue(CGRectGetHeight(view.frame)) shouldNot] equal:theValue(CGRectGetHeight(label.frame))];
      [[theValue(CGRectGetMinY(view.frame)) shouldNot] equal:theValue(0)];
      
      BOOL isBigger = CGRectGetMaxY(view.frame) > CGRectGetMaxY(label.frame);
      [[theValue(isBigger) should] beYes];
    });
    
    it(@"can arrange multiple views", ^{
      UIView *view2 = createViewP(100, 300, 30, 250);
      [stackView addArrangedSubview:view2];
      
      stackView.alignment = OAStackViewAlignmentLastBaseline;
      label.text = @"hello world hello world hello world hello world ";
      label.numberOfLines = 0;
      
      layoutView(stackView);
      
      [[theValue(CGRectGetHeight(view.frame)) shouldNot] equal:theValue(CGRectGetHeight(label.frame))];
      [[theValue(CGRectGetMinY(view.frame)) shouldNot] equal:theValue(0)];
      
      BOOL isBigger = CGRectGetMaxY(view.frame) > CGRectGetMaxY(label.frame);
      [[theValue(isBigger) should] beYes];
      
      [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(CGRectGetMinY(view.frame))];
      [[theValue(CGRectGetMaxY(view2.frame)) should] equal:theValue(CGRectGetMaxY(view.frame))];
    });
    
    it(@"can arrange multiple views with different orders", ^{
      UIView *view2 = createViewP(100, 300, 30, 250);
      [stackView insertArrangedSubview:view2 atIndex:0];
      
      stackView.alignment = OAStackViewAlignmentLastBaseline;
      label.text = @"hello world hello world hello world hello world ";
      label.numberOfLines = 0;
      
      layoutView(stackView);
      
      [[theValue(CGRectGetHeight(view.frame)) shouldNot] equal:theValue(CGRectGetHeight(label.frame))];
      [[theValue(CGRectGetMinY(view.frame)) shouldNot] equal:theValue(0)];
      
      BOOL isBigger = CGRectGetMaxY(view.frame) > CGRectGetMaxY(label.frame);
      [[theValue(isBigger) should] beYes];
      
      [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(CGRectGetMinY(view.frame))];
      [[theValue(CGRectGetMaxY(view2.frame)) should] equal:theValue(CGRectGetMaxY(view.frame))];
    });
    
  });
  
});

SPEC_END
