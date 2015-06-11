//
//  BSLayout.m
//  MultiImageLab
//
//  Created by LF on 15/6/1.
//  Copyright (c) 2015年 Beauty Sight Network Technology Co.,Ltd. All rights reserved.
//

#import "BSPositionTranslator.h"
#import "BSGridPosition.h"

@interface BSPositionTranslator ()

@property (nonatomic,assign) NSInteger gridCountInUnscrollDirection;
@property (nonatomic,strong) UIView *background;
@property (nonatomic,assign) CGFloat padding;
@property (nonatomic,assign) CGFloat gridAbsSideLength;

@end

@implementation BSPositionTranslator

- (instancetype)initWithBackground:(UIView *)background padding:(CGFloat)padding GridCountInUnscrollDirection:(NSInteger)gridCountInUnscrollDirection{
    self = [super init];
    if (self) {
        self.background = background;
        self.padding = padding;
        self.gridCountInUnscrollDirection = gridCountInUnscrollDirection;
        self.gridAbsSideLength = [self calculateGridAbsSideLength];
    }
    return self;

}

- (CGFloat)calculateGridAbsSideLength {
    return (self.background.frame.size.width - (self.gridCountInUnscrollDirection - 1) * self.padding) / self.gridCountInUnscrollDirection;
}

- (NSInteger)cellSizingInMapWithBackground:(UIView *)background andSizingType:(BSLayoutSizingType)type andMovingObject:(CGFloat)obj{
    
    NSInteger largestCellSign = 1111, largestCellCount = 6;
    
    if (type == BSLayoutSizingTypeWidth) {
        largestCellCount = 6;
        largestCellSign = 1111;
    }
    if (type == BSLayoutSizingTypeHeight) {
        largestCellCount = 12;
        largestCellSign = 12;
    }
    
    
    for (int i = 2; i <= largestCellCount - 1; i ++) {
        
        if (obj > (i * self.gridAbsSideLength + (i - 1) * self.padding) &&
            obj <= ((i + 1) * self.gridAbsSideLength + i * self.padding)){
            return i + 1;
        }
    }
    
    if (obj <= 2 * self.gridAbsSideLength + self.padding) {
        return 2;
    }
    else{
        return largestCellSign;
    }
    
}

- (CGFloat)resizeViewInMapWithLength:(NSInteger)sideLength andBackground:(UIView *)background {
    
    if (sideLength == 1111) {
        return background.frame.size.width;
    }
    else {
        return sideLength * self.gridAbsSideLength + (sideLength - 1) * self.padding;
    }
}

- (NSInteger)cellMovingInMapWithBackground:(UIView *)background andMovingType:(BSLayoutMovingType)type andMovingObject:(CGFloat)obj{
    
    NSInteger farthestCellSign = 1000, farthestCellCount = 6;
    
    if (type == BSLayoutMovingTypeX) {
        farthestCellCount = 6;
        farthestCellSign = 0;
    }
    if (type == BSLayoutMovingTypeY) {
        farthestCellCount = 1000;
        farthestCellSign = 1000;
    }
    
    
    for (int i = 2; i <= farthestCellCount; i ++) {
        
        if (obj >= (i * self.gridAbsSideLength + (i - 1) * self.padding) &&
            obj < ((i + 1) * self.gridAbsSideLength + i * self.padding)){
            return i;
        }
    }
    
    if (obj < 2 * self.gridAbsSideLength + self.padding) {
        return 0;
    }
    else{
        return farthestCellSign;
    }
    
    
}

- (CGFloat)translateToAbsLengthByAxis:(NSInteger)axis {
    return axis * self.gridAbsSideLength + (axis + 2) * self.padding;
}

- (CGPoint)translateToAbsPosition:(BSGridPosition *)gridPosition {
    
    CGFloat xOfAbsPosition= [self translateToAbsLengthByAxis:gridPosition.row];
    CGFloat yOfAbsPosition= [self translateToAbsLengthByAxis:gridPosition.col];
    
    return CGPointMake(xOfAbsPosition, yOfAbsPosition);
}

@end
