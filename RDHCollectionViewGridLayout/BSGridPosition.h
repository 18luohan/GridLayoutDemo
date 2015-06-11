//
//  BSGridPosition.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSGridPosition : NSObject

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger col;

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger) col;

@end
