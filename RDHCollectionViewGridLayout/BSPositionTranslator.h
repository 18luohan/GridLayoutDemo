//
//  BSLayout.h
//  MultiImageLab
//
//  Created by LF on 15/6/1.
//  Copyright (c) 2015年 Beauty Sight Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BasicRectLength(view) (view.frame.size.width - 90) / 6
#define Padding 10
#define RectMap 6

typedef enum {
    
    BSLayoutMovingTypeX = 0,
    BSLayoutMovingTypeY
    
}BSLayoutMovingType;

typedef enum {
    
    BSLayoutSizingTypeWidth = 0,
    BSLayoutSizingTypeHeight
    
}BSLayoutSizingType;

@class BSGridPosition;

@interface BSPositionTranslator : NSObject

@property (nonatomic,assign) CGFloat referenceYByPix;

- (instancetype)initWithBackground:(UIView *)background padding:(CGFloat)padding GridCountInUnscrollDirection:(NSInteger)gridCountInUnscrollDirection;

//+ (NSInteger)cellSizingInMapWithBackground:(UIView *)background andSizingType:(BSLayoutSizingType)type andMovingObject:(CGFloat)obj;
//+ (CGFloat)resizeViewInMapWithLength:(NSInteger)sideLength andBackground:(UIView *)background;
//+ (NSInteger)cellMovingInMapWithBackground:(UIView *)background andMovingType:(BSLayoutMovingType)type andMovingObject:(CGFloat)obj;
//+ (CGFloat)relocateViewInMapWithAxis:(NSInteger)axis andBackground:(UIView *)background;

- (CGPoint) translateToAbsPosition:(BSGridPosition *) gridPosition;

@end
