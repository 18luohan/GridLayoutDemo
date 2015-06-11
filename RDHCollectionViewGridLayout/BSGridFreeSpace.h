//
//  BSGridFreeSpace.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by LF on 15/6/11.
//  Copyright (c) 2015年 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSGridPosition;
@interface BSGridFreeSpace : NSObject

@property (nonatomic,strong) BSGridPosition *position;
@property (nonatomic,assign) NSInteger colSpan;

- (instancetype)initWithRow:(NSInteger)row col:(NSInteger)col colSpan:(NSInteger)colSpan;

@end
