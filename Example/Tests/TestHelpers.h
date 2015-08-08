//
//  TestHelpers.h
//  
//
//  Created by Omar Abdelhafith on 08/08/2015.
//
//

#import <UIKit/UIKit.h>

UIView *createView(float width, float height);
UIView *createViewP(float width, float widthPriority, float height, float heightPriority);

void addHightToView(UIView *view, float height, float heightPriority);
void addWidthToView(UIView *view, float width, float widthPriority);

void layoutView(UIView* view);

UILabel *createLabel(float width, float widthPriority);