//
//  BSGridMatrix.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import "BSGridMatrix.h"
#import "BSGrid.h"
#import "BSGridPosition.h"

@interface BSGridMatrix ()

@property (nonatomic, strong) NSMutableArray *gridMatrix;

@end

@implementation BSGridMatrix

- (instancetype)initWithRows:(NSInteger) rows columns:(NSInteger) cols {
    
    self = [super init];
    if (self) {
        self.gridMatrix = [[NSMutableArray alloc]initWithCapacity:rows];
        for (int numOfRow = 0; numOfRow < rows; numOfRow++) {
            [self.gridMatrix addObject: [self createGridArrayForRow:numOfRow columns:cols]];
        }
    }
    return self;
}

- (NSMutableArray *) createGridArrayForRow:(NSInteger) row columns:(NSInteger) cols {
    NSMutableArray *gridArray = [[NSMutableArray alloc]initWithCapacity:cols];
    for (int numOfCol = 0; numOfCol < cols; numOfCol++) {
        BSGridPosition *position = [[BSGridPosition alloc] initWithRow:row column:numOfCol];
        [gridArray addObject: [[BSGrid alloc] initWithPosition:position]];
    }
    return gridArray;
}

- (BSGridRect *) gridRectByGridBlockSize:(BSGridBlockSize *)gridBlockSize {
    // TODO 待实现计算Panel绝对位置和大小
    return nil;
}

@end
