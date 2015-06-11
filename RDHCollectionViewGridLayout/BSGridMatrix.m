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
#import "BSGridFreeSpace.h"
#import "BSGridRect.h"
#import "BSGridPlate.h"
#import "BSPositionTranslator.h"

#define MAX_COL_COUNT 6
#define MAX_ROW_COUNT 1000

@interface BSGridMatrix ()

@property (nonatomic, strong) NSMutableArray *gridMatrix;
@property (nonatomic, strong) NSMutableArray *gridFreeSpaces;
@property (nonatomic, assign) NSInteger cols;
@property (nonatomic,strong) BSPositionTranslator *positionTranslator;

@end

@implementation BSGridMatrix

- (instancetype)initWithRows:(NSInteger) rows Columns:(NSInteger) cols PositonTranslator:(BSPositionTranslator *)positionTranslator{
    
    self = [super init];
    if (self) {
        self.cols = cols;
        self.gridMatrix = [[NSMutableArray alloc]initWithCapacity:rows];
        for (int numOfRow = 0; numOfRow < rows; numOfRow++) {
            [self.gridMatrix addObject: [self createGridRow:numOfRow]];
        }
        self.gridFreeSpaces = [NSMutableArray array];
        BSGridFreeSpace *freeSpace = [[BSGridFreeSpace alloc] initWithRow:0 col:0 colSpan:cols];
        [self.gridFreeSpaces addObject:freeSpace];
        self.positionTranslator = positionTranslator;
    }
    return self;
}

- (void) appendGridRows:(NSInteger) rowIncrement {
    
    for (int i = 1; i <= rowIncrement; i++) {
        NSInteger numOfRow = self.gridMatrix.count + i;
        self.gridMatrix[numOfRow - 1] = [self createGridRow:numOfRow];
    }
}

- (NSMutableArray *)createGridRow:(NSInteger)numOfRow {
    NSMutableArray *gridArray = [[NSMutableArray alloc]initWithCapacity:self.cols];
    for (int numOfCol = 0; numOfCol < self.cols; numOfCol++) {
        BSGridPosition *position = [[BSGridPosition alloc] initWithRow:numOfRow column:numOfCol];
        [gridArray addObject: [[BSGrid alloc] initWithPosition:position]];
    }
    return gridArray;
}

- (BSGridRect *) gridRectForGridPlate:(BSGridPlate *)gridPlate {
    
    BSGridRect *gridRect = [self locateGridPlate:gridPlate];
    [self calculateGridFreeSpaces:gridRect];
    
    return gridRect;
}

- (BSGridRect *)locateGridPlate:(BSGridPlate *)gridPlate {
    
    BSGridPosition *rectPosition;
    
    for (BSGridFreeSpace *freeSpace in self.gridFreeSpaces) {
        if (gridPlate.colSpan <= freeSpace.colSpan) {
            rectPosition = [freeSpace.position copy];
            break;
        }
    }
    
    CGPoint absPosition = [self.positionTranslator translateToAbsPosition:rectPosition];
    
    #warning TODO 计算plate的绝对大小，目前默认为0，0
    CGRect frameOfPlate = CGRectMake(absPosition.x, absPosition.y, 0, 0);
    
    return [[BSGridRect alloc] initWithPosition:rectPosition frameOfBlock:frameOfPlate];
}

- (void)calculateGridFreeSpaces:(BSGridRect *)rect {
    
    NSMutableArray *additionFreePlaces = [[NSMutableArray alloc] init];
    NSMutableArray *deletionFreePlaces = [[NSMutableArray alloc] init];
    
    NSMutableArray *freePlaces = self.gridFreeSpaces;
    
    for(int i = 0 ;i<freePlaces.count;i++){
        BSGridFreeSpace *free = freePlaces[i];
        NSInteger freeRow = free.position.row;
        NSInteger cellRowStart = rect.position.row;
        NSInteger cellRowEnd = rect.position.row + rect.plate.rowSpan - 1;
        if(freeRow == cellRowStart){
            NSInteger freeColEnd = free.position.col + free.colSpan - 1;
            free.position.col = rect.position.col + rect.plate.colSpan;
            free.colSpan = freeColEnd - free.position.col + 1;
            if(free.colSpan == 0){
                [deletionFreePlaces addObject:free];
            }
        }
        else if(freeRow > cellRowStart && freeRow <= cellRowEnd){
            NSInteger freeEnd = free.position.col + free.colSpan - 1;
            NSInteger cellLeft = rect.position.col - 1;
            NSInteger cellRight = rect.position.col + rect.plate.colSpan;
            if(cellLeft<0){
                [deletionFreePlaces addObject:free];
            }else {
                free.colSpan = cellLeft - free.position.col + 1;
            }
            
            if(cellRight<freeEnd){
                [additionFreePlaces addObject:[[BSGridFreeSpace alloc] initWithRow:free.position.row col:cellRight colSpan:freeEnd - cellRight + 1]];
            }
            
        }
    }
    
    for (BSGridFreeSpace *freeSpace in deletionFreePlaces) {
        [freePlaces removeObject:freeSpace];
    }
    
    for (BSGridFreeSpace *freeSpace in additionFreePlaces) {
        [freePlaces addObject:freeSpace];
    }
    
    Boolean isNewFreePlaceRepeat = false;
    BSGridFreeSpace *newPlace = [self genNewFreePlace:rect];
    for(int i = 0 ;i<freePlaces.count;i++){
        BSGridFreeSpace *freePlace = freePlaces[i];
        if(newPlace.position.col == freePlace.position.col
           && newPlace.position.row == freePlace.position.row
           && newPlace.colSpan == freePlace.colSpan){
            isNewFreePlaceRepeat = true;
        }
    }
    if(!isNewFreePlaceRepeat){
        [freePlaces addObject:[self genNewFreePlace:rect]];
    }
    
    for(NSInteger i = freePlaces.count-1 ; i >=0 ;i--){
        BSGridFreeSpace *free = freePlaces[i];
        if([self calcCellLoc:free.position] <= [self calcCellLoc:rect.position]){
            [freePlaces removeObject:free];
        }
    }
    
    [self sortLayoutPointsInArray];
}

- (BSGridFreeSpace *)genNewFreePlace:(BSGridRect *)rect {
    
    BSGridPosition *gridLoc = rect.position;
    NSInteger colLeftMost = gridLoc.col;
    NSInteger colrightMost = gridLoc.col+rect.plate.colSpan -1;
    NSInteger rowFree = gridLoc.row + rect.plate.rowSpan;
    [self reCalcMatrix:rowFree];
    while(colLeftMost >= 0 && [self isSpecifiedGridUsed:rowFree col:colLeftMost]){
        colLeftMost--;
    }
    colLeftMost++;
    while(colrightMost < MAX_COL_COUNT && [self isSpecifiedGridUsed:rowFree col:colrightMost]){
        colrightMost++;
    }
    colrightMost--;
    BSGridFreeSpace *freeSpace = [[BSGridFreeSpace alloc] initWithRow:rowFree col:colLeftMost colSpan:colrightMost - colLeftMost + 1 ];
    return freeSpace;
}

- (void)reCalcMatrix:(NSInteger)rowEnd{
    if(rowEnd+1  > self.gridMatrix.count && rowEnd < MAX_ROW_COUNT ){
        [self appendGridRows:(rowEnd+1  - self.gridMatrix.count)];
    }
}

- (BOOL) isSpecifiedGridUsed:(NSInteger)row col:(NSInteger)col {
    return [self.gridMatrix[row][col] used];
}

- (NSInteger)calcCellLoc:(BSGridPosition *)position{
    return position.row*10+ position.col;
}

- (void)sortLayoutPointsInArray {
    
    NSArray *sortArray = [self.gridFreeSpaces sortedArrayUsingComparator:^NSComparisonResult(BSGridFreeSpace *p1, BSGridFreeSpace *p2) {
        NSInteger diff = [self calcCellLoc:p1.position] - [self calcCellLoc:p2.position];
        
        if (diff > 0) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (diff < 0) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [self.gridFreeSpaces removeAllObjects];
    [self.gridFreeSpaces addObjectsFromArray:sortArray];
}




@end
