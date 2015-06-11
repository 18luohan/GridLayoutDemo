//
//  BSGridRect.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSGridPosition;

@interface BSGridRect : NSObject

@property (nonatomic, strong) BSGridPosition *gridPosition;
@property (nonatomic, assign) CGRect frameOfBlock;

@end
