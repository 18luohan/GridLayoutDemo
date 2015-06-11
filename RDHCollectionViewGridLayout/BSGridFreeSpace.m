//
//  BSGridFreeSpace.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by LF on 15/6/11.
//  Copyright (c) 2015年 Rich H. All rights reserved.
//

#import "BSGridFreeSpace.h"
#import "BSGridPosition.h"

@implementation BSGridFreeSpace

- (instancetype)initWithPosition:(BSGridPosition *)position colSpan:(NSInteger)colSpan {
    
    self = [super init];
    if (self) {
        self.position = position;
        self.colSpan = colSpan;
    }
    return self;
}

- (instancetype)initWithRow:(NSInteger)row col:(NSInteger)col colSpan:(NSInteger)colSpan {
    
    self = [super init];
    if (self) {
        self.position = [[BSGridPosition alloc] initWithRow:row column:col];
        self.colSpan = colSpan;
    }
    return self;
}

@end
