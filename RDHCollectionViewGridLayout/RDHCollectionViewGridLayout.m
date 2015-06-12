//
//  RDHCollectionViewGridLayout.m
//  RDHCollectionViewGridLayout
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHCollectionViewGridLayout.h"
#import "BSGridMatrix.h"
#import "BSGridRect.h"
#import "BSPositionTranslator.h"

@interface RDHCollectionViewGridLayout ()

@property (nonatomic, copy, readonly) NSMutableDictionary *itemAttributes;

/// This property is used to store the lineDimension when it is set to 0 (depends on the average item size) and the base item size.
@property (nonatomic, assign) CGSize calculatedItemSize;

/// This property is re-calculated when invalidating the layout
@property (nonatomic, assign) NSUInteger numberOfLines;

@property (nonatomic, strong) BSGridMatrix *gridMatrix;

@property (nonatomic, copy, readonly) NSMutableDictionary *indexPathToGridRectMapping;

@end

@implementation RDHCollectionViewGridLayout

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    [self setInitialDefaults];
    
    _itemAttributes = [NSMutableDictionary dictionary];
    _numberOfLines = 0;
}

-(void)setInitialDefaults
{
    // Default properties
    _scrollDirection = UICollectionViewScrollDirectionVertical;
    _lineSpacing = 0;
    _itemSpacing = 10;
    _lineItemCount = 6;
    _lineSpacing = _itemSpacing;
}

-(void)invalidateLayout
{
    [super invalidateLayout];
    
    [self.itemAttributes removeAllObjects];
    self.numberOfLines = 0;
    self.calculatedItemSize = CGSizeZero;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    self.numberOfLines = [self calculateNumberOfLines];
    
    self.calculatedItemSize = [self calculateItemSize];
    
    [self setGridMetadataWithLines:_numberOfLines LineItemCount:_lineItemCount ItemSpacing:_itemSpacing];
    
    NSInteger const sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section=0; section<sectionCount; section++) {
        
        NSInteger const itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item=0; item<itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            self.itemAttributes[indexPath] = [self calculateLayoutAttributesForItemAtIndexPath:indexPath];
        }
    }
}

- (void) setGridMetadataWithLines:(NSUInteger)lines LineItemCount:(NSUInteger)lineItemCount ItemSpacing:(CGFloat)itemSpacing {
    _lineItemCount = lineItemCount;
    _itemSpacing = itemSpacing;
    _lineSpacing = itemSpacing;
    [self initGridMatrix:lines :lineItemCount];
}

- (void) initGridMatrix:(NSInteger)rows :(NSInteger)cols  {
    UIView *backgroud = self.collectionView.backgroundView;
    BSPositionTranslator *positionTranslator = [[BSPositionTranslator alloc]
                                                initWithBackground:backgroud padding:_itemSpacing GridCountInUnscrollDirection:self.lineItemCount];
    self.gridMatrix = [[BSGridMatrix alloc] initWithRows:rows Columns:cols PositonTranslator:positionTranslator];
}

-(CGSize)collectionViewContentSize
{
    CGSize size;
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            size.width = self.numberOfLines * self.calculatedItemSize.width;
            // Add spacings
            size.width += (self.numberOfLines - 1) * self.lineSpacing;
            size.height = [self constrainedCollectionViewDimension];
            break;
            
        case UICollectionViewScrollDirectionVertical:
            size.width = [self constrainedCollectionViewDimension];
            size.height = self.numberOfLines * self.calculatedItemSize.height;
            // Add spacings
            size.height += (self.numberOfLines - 1) * self.lineSpacing;
            break;
    }
    
    return size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttrs = self.itemAttributes[indexPath];
    
    if (!layoutAttrs) {
        layoutAttrs = [self calculateLayoutAttributesForItemAtIndexPath:indexPath];
        self.itemAttributes[indexPath] = layoutAttrs;
    }
    
    return layoutAttrs;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:[self.itemAttributes count]];
    
    [self.itemAttributes enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *const indexPath, UICollectionViewLayoutAttributes *attr, BOOL *stop) {
        
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [layoutAttributes addObject:attr];
        }
    }];
    
    return layoutAttributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return !CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size);
}

#pragma mark - Lazily loaded properties

/// Precalculate the frames for the first line as they can be reused for every line

#pragma mark - Calculation methods

-(NSUInteger)calculateNumberOfLines
{
    NSInteger numberOfLines;
    // sectionsStartOnNewLine 表示是否要为每个新行创建一个section
    if (self.sectionsStartOnNewLine) {
        
        numberOfLines = 0;
        
        NSInteger const sectionCount = [self.collectionView numberOfSections];
        for (NSInteger section=0; section<sectionCount; section++) {
            // If there are too many items to fill a line, allow it to over flow.
            numberOfLines += ceil(((CGFloat) [self.collectionView numberOfItemsInSection:section]) / self.lineItemCount);
        }
        
        // Best case: numberOfLines = number of sections with items
        // Worse case: numberOfLines = 2 * number of sections with items
        
    } else {
        
        NSUInteger n = 0;
        NSInteger const sectionCount = [self.collectionView numberOfSections];
        for (NSInteger section=0; section<sectionCount; section++) {
            /*
             疑问：numberOfItemsInSection返回值表示的是一个section中grid的总数，还是可见的视图块（即ViewCell）的数量？
             如果是可见的视图块的数量，那么这样计算行数就有问题。如果指的是一个grid，那么这个方法命名很有误导性，
             因为DataSource中的基本单元就是data item，这里的item指的就是ViewCell。
             */
            n += [self.collectionView numberOfItemsInSection:section];
        }
        CGFloat numberOfItems = n;
        // We just need to work out the number of lines
        numberOfLines = ceil(numberOfItems / self.lineItemCount);
    }
    
    return numberOfLines;
}

// 计算grid的绝对大小。这里的item就是网格布局中的每个单元格，即grid。
-(CGSize)calculateItemSize
{
    CGFloat collectionConstrainedDimension = [self constrainedCollectionViewDimension];
    // Subtract the spacing between items on a line
    collectionConstrainedDimension -= (self.itemSpacing * (self.lineItemCount - 1));
    
    // constrainedItemDimension 就是在不可滚动的维度上 item 的长度
    const CGFloat constrainedItemDimension = floor(collectionConstrainedDimension / self.lineItemCount);
    
    // Uses the same height/width
    return CGSizeMake(constrainedItemDimension, constrainedItemDimension);
}

-(UICollectionViewLayoutAttributes *)calculateLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [[[self class] layoutAttributesClass] layoutAttributesForCellWithIndexPath:indexPath];
    
    // 如果是垂直方向滚动，使用如下定位逻辑
    BSGridPlate *gridPlate = [self.delegate getGridBlockSizeForItemAtIndexPath:indexPath layout:self];
    BSGridRect *gridRect = [self.gridMatrix gridRectForGridPlate:gridPlate];
    self.indexPathToGridRectMapping[indexPath] = gridRect;
    
    #warning 如果是水平方向滚动，使用如下逻辑
    #warning TODO 水平方向滚动的定位逻辑
    
    attrs.frame = gridRect.frameOfBlock;
    
    // Place below the scroll bar
    attrs.zIndex = -1;
    
    return attrs;
}

#pragma mark - Convenince sizing methods

// 计算collection view中 在不可滚动的维度上 实际可用于布局视图组件的长度
-(CGFloat)constrainedCollectionViewDimension
{
    // collectionView.contentInset 就是内嵌在 collection view 边缘里面的 padding
    // collectionViewInsetBoundsSize 就是 collection view 内实际可用来展现内容的区域
    CGSize collectionViewInsetBoundsSize = UIEdgeInsetsInsetRect(self.collectionView.bounds, self.collectionView.contentInset).size;
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            return collectionViewInsetBoundsSize.height;
            
        case UICollectionViewScrollDirectionVertical:
            return collectionViewInsetBoundsSize.width;
    }
}

#pragma mark - Detail setters that invalidate the layout

-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    NSAssert(scrollDirection == UICollectionViewScrollDirectionHorizontal || scrollDirection == UICollectionViewScrollDirectionVertical, @"Invalid scrollDirection: %ld", (long) scrollDirection);
    
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        
        [self invalidateLayout];
    }
}

-(void)setLineItemCount:(NSUInteger)lineItemCount
{
    NSAssert(lineItemCount > 0, @"Zero line item count is meaningless");
    if (_lineItemCount != lineItemCount) {
        _lineItemCount = lineItemCount;
        
        [self invalidateLayout];
    }
}

-(void)setItemSpacing:(CGFloat)itemSpacing
{
    if (_itemSpacing != itemSpacing) {
        _itemSpacing = itemSpacing;
        
        [self invalidateLayout];
    }
}

-(void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        
        [self invalidateLayout];
    }
}

-(void)setSectionsStartOnNewLine:(BOOL)sectionsStartOnNewLine
{
    if (_sectionsStartOnNewLine != sectionsStartOnNewLine) {
        _sectionsStartOnNewLine = sectionsStartOnNewLine;
        
        [self invalidateLayout];
    }
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; scrollDirection = %@; lineItemCount = %llu; itemSpacing = %.3lf; lineSpacing = %.3lf; sectionsStartOnNewLine = %@>",
            NSStringFromClass([self class]), self, (self.scrollDirection == UICollectionViewScrollDirectionVertical ? @"Vertical" : @"Horizontal"), (unsigned long long) self.lineItemCount, self.itemSpacing, self.lineSpacing, (self.sectionsStartOnNewLine ? @"YES" : @"NO")];
}

@end

@interface RDHCollectionViewGridLayout (InspectableScrolling)

@property (nonatomic, assign) IBInspectable BOOL verticalScrolling;

@end

@implementation RDHCollectionViewGridLayout (InspectableScrolling)

-(BOOL)verticalScrolling
{
    return self.scrollDirection == UICollectionViewScrollDirectionVertical;
}

-(void)setVerticalScrolling:(BOOL)verticalScrolling
{
    self.scrollDirection = verticalScrolling ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
}

@end

@implementation RDHCollectionViewGridLayout (RDHCollectionViewGridLayout_Deprecated)

-(CGFloat)lineDimension
{
    return self.lineSize;
}

-(void)setLineDimension:(CGFloat)lineDimension
{
    self.lineSize = lineDimension;
}

@end