//
//  OAStackViewSpec.m
//  OAStackView
//
//  Created by Omar Abdelhafith on 14/06/2015.
//  Copyright 2015 Omar Abdelhafith. All rights reserved.
//

#import "Kiwi.h"
#import "OAStackView.h"
#import "TestHelpers.h"


SPEC_BEGIN(OAStackViewSpec)

describe(@"OAStackView", ^{
  __block OAStackView *stackView;
  
  context(@"Vertical", ^{
    
    it(@"Can arrange views vertically", ^{
      NSArray *views = @[createView(100, 20),createView(100, 40)];
      
      stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
      stackView.axis = UILayoutConstraintAxisVertical;
      CGSize size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(100, 60))];
    });
    
    it(@"Can change the spacing between views", ^{
      NSArray *views = @[createView(100, 20),createView(100, 40)];
      
      stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
      stackView.axis = UILayoutConstraintAxisVertical;
      CGSize size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(100, 60))];
      
      stackView.spacing = 20;
      size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(100, 80))];
      
      stackView.spacing = 50;
      size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(100, 110))];
    });
    
    context(@"Removing views", ^{
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createView(100, 20);
        view2 = createView(100, 30);
        view3 = createView(100, 40);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });
      
      it(@"Can remove the first view", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 90))];
        
        [stackView removeArrangedSubview:view1];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 70))];
        
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX([view2 frame])) should] equal:theValue(0)];
      });
      
      it(@"Can remove a middle view", ^{
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 90))];
        
        [stackView removeArrangedSubview:view2];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 60))];
        
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY([view3 frame])) should] equal:theValue(20)];
      });
      
      it(@"Can remove the last view", ^{
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 90))];
        
        [stackView removeArrangedSubview:view3];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 50))];
      });
      
    });
    
    context(@"Adding views", ^{
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createView(100, 20);
        view2 = createView(100, 30);
        view3 = createView(100, 40);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });
      
      it(@"Can append a view", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 90))];
        
        
        [stackView addArrangedSubview:createView(100, 40)];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 130))];
      });
      
      it(@"Can insert a view as first element", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 90))];
        
        
        [stackView insertArrangedSubview:createView(100, 40) atIndex:0];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 130))];
        
        layoutView(stackView);
        [[theValue(CGRectGetMinY(view1.frame)) should] equal:theValue(40)];
        
      });
      
      it(@"Can insert a view in the middle", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 90))];
        
        
        [stackView insertArrangedSubview:createView(100, 40) atIndex:1];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 130))];
        
        layoutView(stackView);
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(60)];
        
      });
      
      it(@"Can insert a view at last index", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 90))];
        
        
        [stackView insertArrangedSubview:createView(100, 40) atIndex:3];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(100, 130))];
      });
    });
    
    context(@"Hiding views", ^{
      
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createViewP(200, 300, 20, 1000);
        view2 = createViewP(500, 300, 30, 1000);
        view3 = createViewP(600, 330, 40, 1000);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.axis = UILayoutConstraintAxisVertical;
      });
      
      it(@"Decreases the height when view is hidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(90)];
        
        view1.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(70)];
      });
      
      it(@"Adjustes frames when views are hidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(0)];
      });
      
      it(@"Adjustes frames when multiple views are hidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view3.frame)) should] equal:theValue(50)];
        
        view1.hidden = YES;
        view2.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view3.frame)) should] equal:theValue(0)];
      });
      
      it(@"Adjustes frames when the first view are hidden and unhidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(0)];
        
        view1.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(20)];
        
      });
      
      it(@"Adjustes frames when all the views are hidden and brought back", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        view2.hidden = YES;
        view3.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(0)];
        
        view1.hidden = NO;
        view2.hidden = NO;
        view3.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(90)];
        
      });
      
      it(@"Adjustes frames when all the views are hidden and brought back in different orders", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        view2.hidden = YES;
        view3.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(0)];
        
        view1.hidden = NO;
        view3.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(60)];
        
        view2.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(90)];
        
      });
      
      it(@"Can Unhide a non hidden view normally", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        view2.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(40)];
        
        view2.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(70)];
        
        view1.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(90)];
        
      });
      
      
    });
    
    
    context(@"Distribution", ^{
      
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createViewP(200, 300, 50, 250);
        view2 = createViewP(500, 300, 60, 250);
        view3 = createViewP(600, 330, 100, 250);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });
      
      context(@"OAStackViewDistributionFill", ^{
        
        it(@"Distributes the view based on their fill using OAStackViewDistributionFill", ^{
          stackView.distribution = OAStackViewDistributionFill;
          addHightToView(stackView, 400, 1000);
          layoutView(stackView);
          
          [[theValue(CGRectGetMinY(view1.frame)) should] equal:theValue(0)];
          
          [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(240)];
          
          [[theValue(CGRectGetMinY(view3.frame)) should] equal:theValue(300)];
        });
        
      });
      
      context(@"OAStackViewDistributionFillEqually", ^{
        
        it(@"Distributes the views equally using OAStackViewDistributionFillEqually", ^{
          stackView.distribution = OAStackViewDistributionFillEqually;
          addHightToView(stackView, 400, 1000);
          layoutView(stackView);
          
          [[theValue(CGRectGetMinY(view1.frame)) should] equal:theValue(0)];
          
          [[theValue(CGRectGetMinY(view2.frame)) should] equal:133 withDelta:1];
          
          [[theValue(CGRectGetMinY(view3.frame)) should] equal:266 withDelta:1];
        });
        
        it(@"Adds the correct spacing between views", ^{
          stackView.distribution = OAStackViewDistributionFillEqually;
          stackView.spacing = 50;
          addHightToView(stackView, 400, 1000);
          layoutView(stackView);
          
          [[theValue(CGRectGetMinY(view1.frame)) should] equal:theValue(0)];
          
          [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(150)];
          
          [[theValue(CGRectGetMinY(view3.frame)) should] equal:theValue(300)];
        });
        
      });
        
      context(@"OAStackViewDistributionFillProportionally", ^{
        it(@"Distributes the views proportionally based on their intrinsicContentSize", ^{
          // Views 1, 2 and 3 are UIButtons. Changing the title affects their intrinsicContentSize.
          // Since we're testing the vertical layout here, we add newlines to affect their intrinsicContentSize height
          
          [(UIButton *)view1 setTitle:@"the title" forState:UIControlStateNormal];
          [(UIButton *)view2 setTitle:@"the title" forState:UIControlStateNormal];
          [(UIButton *)view3 setTitle:@"the\ntitle" forState:UIControlStateNormal];
          
          stackView.distribution = OAStackViewDistributionFillProportionally;
          
          layoutView(stackView);
          CGFloat proportion = view2.intrinsicContentSize.height / view1.intrinsicContentSize.height;
          [[theValue(CGRectGetHeight(view2.frame)) should] beWithin:theValue(1) of:theValue(CGRectGetHeight(view1.frame) * proportion)];
          
          proportion = view3.intrinsicContentSize.height / view2.intrinsicContentSize.height;
          [[theValue(CGRectGetHeight(view3.frame)) should] beWithin:theValue(1) of:theValue(CGRectGetHeight(view2.frame) * proportion)];
        });
      });

      context(@"OAStackViewDistributionEqualSpacing", ^{
        it(@"Distributes the views with equal spacing between each view", ^{
          // Views 1, 2 and 3 are UIButtons. Changing the title affects their intrinsicContentSize.

          [(UIButton *)view1 setTitle:@"A short title" forState:UIControlStateNormal];
          [(UIButton *)view2 setTitle:@"A bit longer title" forState:UIControlStateNormal];
          [(UIButton *)view3 setTitle:@"A really really really really long title"
                             forState:UIControlStateNormal];

          stackView.distribution = OAStackViewDistributionEqualSpacing;
          stackView.spacing = 40;

          layoutView(stackView);

          CGFloat firstGap = CGRectGetMinY(view2.frame) - CGRectGetMaxY(view1.frame);
          CGFloat secondGap = CGRectGetMinY(view3.frame) - CGRectGetMaxY(view2.frame);
          [[theValue(firstGap) should] equal:theValue(secondGap)];
          [[theValue(firstGap) should] beBetween:theValue(stackView.spacing) and:theValue(CGRectGetHeight(stackView.bounds))];
        });
      });
    });

    context(@"Margins", ^{

      __block UIView *view1, *view2, *view3;

      beforeEach(^{
        view1 = createView(100, 100);
        view2 = createView(100, 100);
        view3 = createView(100, 100);

        NSArray *views = @[view1, view2, view3];

        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        stackView.layoutMarginsRelativeArrangement = YES;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.layoutMargins = UIEdgeInsetsMake(10, 20, 30, 40);
      });

      it(@"Arranges the views relative to margins if set", ^{
        layoutView(stackView);

        [[theValue(view1.frame) should] equal:theValue(CGRectMake(20, 10, 100, 100))];
        [[theValue(view2.frame) should] equal:theValue(CGRectMake(20, 110, 100, 100))];
        [[theValue(view3.frame) should] equal:theValue(CGRectMake(20, 210, 100, 100))];
        
        //Frame origin does not return 0,0 for iOS7, This is not a major issue as the stackview has not been added to a view stack.
        //Matching on the size would be enough to verify this fix
        [[theValue(stackView.frame.size) should] equal:theValue(CGSizeMake(160, 340))];
      });
    });

  });
  

  context(@"Horizontal", ^{

    it(@"Can arrange views vertically", ^{
      NSArray *views = @[createView(100, 40),createView(100, 40)];
      
      stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
      stackView.axis = UILayoutConstraintAxisHorizontal;
      
      CGSize size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(200, 40))];
    });
    
    it(@"Can change the spacing between views", ^{
      NSArray *views = @[createView(100, 40),createView(100, 40)];
      
      stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
      stackView.axis = UILayoutConstraintAxisHorizontal;
      
      CGSize size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(200, 40))];
      
      stackView.spacing = 20;
      size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(220, 40))];
      
      stackView.spacing = 50;
      size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
      [[theValue(size) should] equal:theValue(CGSizeMake(250, 40))];
    });
    
    context(@"Removing views", ^{
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createView(20, 100);
        view2 = createView(30, 100);
        view3 = createView(40, 100);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });
      
      it(@"Can remove the first view", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(90, 100))];
        
        [stackView removeArrangedSubview:view1];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(70, 100))];
        
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX([view2 frame])) should] equal:theValue(0)];
      });
      
      it(@"Can remove a middle view", ^{
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(90, 100))];
        
        [stackView removeArrangedSubview:view2];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(60, 100))];
        
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX([view3 frame])) should] equal:theValue(20)];
      });
      
      it(@"Can remove the last view", ^{
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(90, 100))];
        
        [stackView removeArrangedSubview:view3];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(50, 100))];
      });
      
    });
    
    
    context(@"Adding views", ^{
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createView(20, 100 );
        view2 = createView(30, 100);
        view3 = createView(40, 100);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });
      
      it(@"Can append a view", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(90, 100))];
        
        
        [stackView addArrangedSubview:createView(40, 100)];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(130, 100))];
      });
      
      it(@"Can insert a view as first element", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(90, 100))];
        
        
        [stackView insertArrangedSubview:createView(40, 100) atIndex:0];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(130, 100))];
        
        layoutView(stackView);
        [[theValue(CGRectGetMinX(view1.frame)) should] equal:theValue(40)];
        
      });
      
      it(@"Can insert a view in the middle", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(90, 100))];
        
        
        [stackView insertArrangedSubview:createView(40, 100) atIndex:1];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(130, 100))];
        
        layoutView(stackView);
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(60)];
        
      });
      
      it(@"Can insert a view at last index", ^{
        
        CGSize size;
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(90, 100))];
        
        [stackView insertArrangedSubview:createView(40, 100) atIndex:3];
        size = [stackView systemLayoutSizeFittingSize:CGSizeZero];
        [[theValue(size) should] equal:theValue(CGSizeMake(130, 100))];
      });
      
    });
    
    
    context(@"Alignemnt", ^{
      
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createViewP(20, 250, 200, 300);
        view2 = createViewP(30, 250, 500, 300);
        view3 = createViewP(40, 250, 600, 330);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });
      
      it(@"Arrange the views to fill the whole axis if OAStackViewAlignmentFill is passed", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view3.frame)) should] equal:theValue(0)];
        [[theValue(CGRectGetHeight(view3.frame)) should] equal:theValue(600)];
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(0)];
        [[theValue(CGRectGetHeight(view2.frame)) should] equal:theValue(600)];
      });
      
      it(@"Arrange the views on the begginning of the axis if OAStackViewAlignmentLeading is passed", ^{
        stackView.alignment = OAStackViewAlignmentLeading;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view1.frame)) should] equal:theValue(0)];
        [[theValue(CGRectGetHeight(view1.frame)) should] equal:theValue(200)];
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(0)];
        [[theValue(CGRectGetHeight(view2.frame)) should] equal:theValue(500)];
      });
      
      it(@"Arrange the views on the End of the axis if OAStackViewAlignmentTrailing is passed", ^{
        stackView.alignment = OAStackViewAlignmentTrailing;;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view1.frame)) should] equal:theValue(400)];
        [[theValue(CGRectGetHeight(view1.frame)) should] equal:theValue(200)];
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(100)];
        [[theValue(CGRectGetHeight(view2.frame)) should] equal:theValue(500)];
      });
      
      it(@"Arrange the views on the Center of the axis if OAStackViewAlignmentCenter is passed", ^{
        stackView.alignment = OAStackViewAlignmentCenter;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinY(view1.frame)) should] equal:theValue(200)];
        [[theValue(CGRectGetHeight(view1.frame)) should] equal:theValue(200)];
        
        [[theValue(CGRectGetMinY(view2.frame)) should] equal:theValue(50)];
        [[theValue(CGRectGetHeight(view2.frame)) should] equal:theValue(500)];
      });
      
    });
    
    
    context(@"Hiding views", ^{
      
      __block UIView *view1, *view2, *view3;
      
      beforeEach(^{
        view1 = createViewP(20, 1000, 200, 300);
        view2 = createViewP(30, 1000, 500, 300);
        view3 = createViewP(40, 1000, 600, 330);
        
        NSArray *views = @[view1, view2, view3];
        
        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });
      
      it(@"Decreases the height when view is hidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(90)];
        
        view1.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(70)];
      });
      
      it(@"Adjustes frames when views are hidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(0)];
      });
      
      it(@"Adjustes frames when multiple views are hidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view3.frame)) should] equal:theValue(50)];
        
        view1.hidden = YES;
        view2.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view3.frame)) should] equal:theValue(0)];
      });
      
      it(@"Adjustes frames when the first view are hidden and unhidden", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(0)];
        
        view1.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(20)];
        
      });
      
      it(@"Adjustes frames when all the views are hidden and brought back", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        view2.hidden = YES;
        view3.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(0)];
        
        view1.hidden = NO;
        view2.hidden = NO;
        view3.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(90)];
        
      });
      
      it(@"Adjustes frames when all the views are hidden and brought back in different orders", ^{
        stackView.alignment = OAStackViewAlignmentFill;
        layoutView(stackView);
        
        [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(20)];
        
        view1.hidden = YES;
        view2.hidden = YES;
        view3.hidden = YES;
        layoutView(stackView);
        
        [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(0)];
        
        view1.hidden = NO;
        view3.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(60)];
        
        view2.hidden = NO;
        layoutView(stackView);
        
        [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(90)];
        
      });

    });
      
      
    context(@"Distribution", ^{

      __block UIView *view1, *view2, *view3;

      beforeEach(^{
        view1 = createViewP(50, 300, 200, 300);
        view2 = createViewP(60, 300, 500, 300);
        view3 = createViewP(100, 300, 600, 330);

        NSArray *views = @[view1, view2, view3];

        stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
      });

      context(@"OAStackViewDistributionFill", ^{

        it(@"Distributes the view based on their fill using OAStackViewDistributionFill", ^{
          stackView.distribution = OAStackViewDistributionFill;
          addWidthToView(stackView, 400, 1000);
          layoutView(stackView);

          [[theValue(CGRectGetMinX(view1.frame)) should] equal:theValue(0)];

          [[theValue(CGRectGetMinX(view2.frame)) should] equal:240 withDelta:10];

          [[theValue(CGRectGetMinX(view3.frame)) should] equal:theValue(300)];
        });

      });

      context(@"OAStackViewDistributionFillEqually", ^{

        it(@"Distributes the views equally using OAStackViewDistributionFillEqually", ^{
          stackView.distribution = OAStackViewDistributionFillEqually;
          addWidthToView(stackView, 400, 1000);
          layoutView(stackView);

          [[theValue(CGRectGetMinX(view1.frame)) should] equal:theValue(0)];

          [[theValue(CGRectGetMinX(view2.frame)) should] equal:133 withDelta:1];

          [[theValue(CGRectGetMinX(view3.frame)) should] equal:266 withDelta:1];
        });

        it(@"Adds the correct spacing between views", ^{
          stackView.distribution = OAStackViewDistributionFillEqually;
          stackView.spacing = 50;
          addWidthToView(stackView, 400, 1000);
          layoutView(stackView);

          [[theValue(CGRectGetMinX(view1.frame)) should] equal:theValue(0)];

          [[theValue(CGRectGetMinX(view2.frame)) should] equal:theValue(150)];

          [[theValue(CGRectGetMinX(view3.frame)) should] equal:theValue(300)];
        });

      });

      context(@"OAStackViewDistributionFillProportionally", ^{
        it(@"Distributes the views proportionally based on their intrinsicContentSize", ^{
          // Views 1, 2 and 3 are UIButtons. Changing the title affects their intrinsicContentSize.

          [(UIButton *)view1 setTitle:@"the title" forState:UIControlStateNormal];
          [(UIButton *)view2 setTitle:@"the title" forState:UIControlStateNormal];
          [(UIButton *)view3 setTitle:@"the title the title" forState:UIControlStateNormal];

          stackView.distribution = OAStackViewDistributionFillProportionally;

          layoutView(stackView);
          CGFloat proportion = view2.intrinsicContentSize.width / view1.intrinsicContentSize.width;
          [[theValue(CGRectGetWidth(view2.frame)) should] beWithin:theValue(1) of:theValue(CGRectGetWidth(view1.frame) * proportion)];

          proportion = view3.intrinsicContentSize.width / view2.intrinsicContentSize.width;
          [[theValue(CGRectGetWidth(view3.frame)) should] beWithin:theValue(1) of:theValue(CGRectGetWidth(view2.frame) * proportion)];
        });
      });

      context(@"OAStackViewDistributionEqualSpacing", ^{
        it(@"Distributes the views with equal spacing between each view", ^{
          // Views 1, 2 and 3 are UIButtons. Changing the title affects their intrinsicContentSize.

          [(UIButton *)view1 setTitle:@"A short title" forState:UIControlStateNormal];
          [(UIButton *)view2 setTitle:@"A bit longer title" forState:UIControlStateNormal];
          [(UIButton *)view3 setTitle:@"A really really really really long title"
                             forState:UIControlStateNormal];

          stackView.distribution = OAStackViewDistributionEqualSpacing;
          stackView.spacing = 40;

          layoutView(stackView);

          CGFloat firstGap = CGRectGetMinX(view2.frame) - CGRectGetMaxX(view1.frame);
          CGFloat secondGap = CGRectGetMinX(view3.frame) - CGRectGetMaxX(view2.frame);
          [[theValue(firstGap) should] equal:theValue(secondGap)];
          [[theValue(firstGap) should] beBetween:theValue(stackView.spacing)
                                             and:theValue(CGRectGetWidth(stackView.bounds))];
        });
      });

    });

  });

  
  context(@"Margins", ^{

    __block UIView *view1, *view2, *view3;

    beforeEach(^{
      view1 = createView(100, 100);
      view2 = createView(100, 100);
      view3 = createView(100, 100);

      NSArray *views = @[view1, view2, view3];

      stackView = [[OAStackView alloc] initWithArrangedSubviews:views];
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
      stackView.axis = UILayoutConstraintAxisHorizontal;
      stackView.layoutMarginsRelativeArrangement = YES;
      stackView.layoutMargins = UIEdgeInsetsMake(10, 20, 30, 40);
    });

    it(@"Arranges the views relative to margins if set", ^{
      layoutView(stackView);

      [[theValue(view1.frame) should] equal:theValue(CGRectMake(20, 10, 100, 100))];
      [[theValue(view2.frame) should] equal:theValue(CGRectMake(120, 10, 100, 100))];
      [[theValue(view3.frame) should] equal:theValue(CGRectMake(220, 10, 100, 100))];
      
      //Frame origin does not return 0,0 for iOS7, This is not a major issue as the stackview has not been added to a view stack.
      //Matching on the size would be enough to verify this fix
      [[theValue(stackView.frame.size) should] equal:theValue(CGSizeMake(360, 140))];
    });
  });


  context(@"Arranged Subviews", ^{

    __block UIView *view1, *view2, *view3;

    beforeEach(^{
      view1 = createView(100, 100);
      view2 = createView(100, 100);
      view3 = createView(100, 100);

      stackView = [[OAStackView alloc] init];
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
    });

    it(@"Initializes arrangedSubviews to an empty array", ^{
      [[stackView.arrangedSubviews should] beEmpty];
    });

    it(@"Initalizes arrangedSubviews to the given views when initialized with arranged subviess", ^{
      stackView = [[OAStackView alloc] initWithArrangedSubviews:@[view1, view2, view3]];
      [[stackView.arrangedSubviews should] containObjectsInArray:@[view1, view2, view3]];
    });

    it(@"Maintains the correct array when adding views", ^{
      [stackView addArrangedSubview:view1];
      [[stackView.arrangedSubviews should] containObjectsInArray:@[view1]];

      [stackView addArrangedSubview:view2];
      [[stackView.arrangedSubviews should] containObjectsInArray:@[view2]];

      [stackView addArrangedSubview:view3];
      [[stackView.arrangedSubviews should] containObjectsInArray:@[view3]];
    });

    it(@"Maintains the correct array when removing views", ^{
      [stackView addArrangedSubview:view1];
      [stackView addArrangedSubview:view2];
      [stackView addArrangedSubview:view3];

      [[stackView.arrangedSubviews should] containObjectsInArray:@[view1, view2, view3]];

      [stackView removeArrangedSubview:view2];
      [[stackView.arrangedSubviews should] containObjectsInArray:@[view1, view3]];

      [stackView removeArrangedSubview:view1];
      [[stackView.arrangedSubviews should] containObjectsInArray:@[view3]];

      [stackView removeArrangedSubview:view3];
      [[stackView.arrangedSubviews should] containObjectsInArray:@[]];
    });
  });


  context(@"bug fixes", ^{
  
    __block UIView *view1, *view2, *view3;
    
    beforeEach(^{
      view1 = createView(20, 100);
      view2 = createView(30, 100);
      view3 = createView(40, 100);
      
      stackView = [[OAStackView alloc] initWithArrangedSubviews:@[]];
      stackView.axis = UILayoutConstraintAxisHorizontal;
      stackView.translatesAutoresizingMaskIntoConstraints = NO;
    });
    
    it(@"should add the trailing and leading superview constraint in case insert the first view", ^{
      [stackView insertArrangedSubview:view1 atIndex:0];
      [stackView insertArrangedSubview:view2 atIndex:1];
      layoutView(stackView);
      [[theValue(CGRectGetHeight(stackView.frame)) should] equal:theValue(100)];
      [[theValue(CGRectGetWidth(stackView.frame)) should] equal:theValue(50)];
    });
    
  });
});

SPEC_END