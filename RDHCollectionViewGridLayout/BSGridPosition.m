//
//  BSGridPosition.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import "BSGridPosition.h"

@implementation BSGridPosition

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger) col {
    
    self = [super init];
    if (self) {
        self.row = row;
        self.col = col;
    }
    return self;
}

@end
