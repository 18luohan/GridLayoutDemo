//
//  BSGridMatrix.h
//  RDHCollectionViewGridLayoutDemo
//
//  Created by chenlong on 6/10/15.
//  Copyright (c) 2015 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BSGridBlockSize, BSGridRect;

@interface BSGridMatrix : NSObject

- (instancetype)initWithRows:(NSInteger) rows columns:(NSInteger) cols;
- (BSGridRect *) gridRectByGridBlockSize:(BSGridBlockSize *)gridBlockSize;

@end
