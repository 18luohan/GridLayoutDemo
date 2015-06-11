//
//  BSGridRect.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import "BSGridRect.h"
#import "BSGridPosition.h"

@implementation BSGridRect

- (instancetype) initWithPosition:(BSGridPosition *)position frameOfBlock:(CGRect)frame {
    
    self = [super init];
    if (self) {
        self.position = position;
        self.frameOfBlock = frame;
    }
    return self;
}

@end
