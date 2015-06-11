//
//  BSGrid.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import "BSGrid.h"
#import "BSGridPosition.h"

@implementation BSGrid

- (instancetype)initWithPosition:(BSGridPosition *)position {
    
    self = [super init];
    if (self) {
        self.gridPosition = position;
        self.used = NO;
    }
    return self;
}

- (void) setToUsed {
        self.used = YES;
}

@end
