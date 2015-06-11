//
//  BSGridRect.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSGridPosition,BSGridPlate;

@interface BSGridRect : NSObject

@property (nonatomic, strong) BSGridPosition *position;
@property (nonatomic,strong) BSGridPlate *plate;
@property (nonatomic, assign) CGRect frameOfBlock;

- (instancetype) initWithPosition:(BSGridPosition *)position frameOfBlock:(CGRect)frame;

@end
