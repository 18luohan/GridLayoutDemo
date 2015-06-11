//
//  BSGrid.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSGridPosition;

@interface BSGrid : NSObject

@property (nonatomic, strong) BSGridPosition *gridPosition;
@property (nonatomic, assign) BOOL used;

- (instancetype)initWithPosition:(BSGridPosition *)position;
- (void) setToUsed;

@end
