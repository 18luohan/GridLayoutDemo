//
//  BSGridMatrix.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BSGridPlate, BSGridRect, BSPositionTranslator;

@interface BSGridMatrix : NSObject

- (instancetype)initWithRows:(NSInteger) rows Columns:(NSInteger) cols PositonTranslator:(BSPositionTranslator *)positionTranslator;
- (BSGridRect *) gridRectForGridPlate:(BSGridPlate *)gridBlockSize;

@end
