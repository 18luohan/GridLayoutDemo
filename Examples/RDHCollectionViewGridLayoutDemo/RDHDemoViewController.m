//
//  RDHDemoViewController.m
//  RDHCollectionViewGridLayoutDemo
//
//  Created by Richard Hodgkins on 06/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHDemoViewController.h"
#import "RDHCollectionViewGridLayout.h"
#import "RDHDemoCell.h"
#import "BSGridPlate.h"

#define RDH_RANDOM_DATA 1

#define FIXED_LAYOUT 0

@interface RDHDemoViewController () <RDHCollectionViewGridLayoutDelegate>

@property (nonatomic, readonly) RDHCollectionViewGridLayout *currentCollectionViewLayout;

//@property (nonatomic, copy, readonly) NSDictionary *testData;

@property (nonatomic, strong) BSGridPlate *gridBlockSize;

@end

@implementation RDHDemoViewController

@dynamic collectionViewLayout;

+ (RDHCollectionViewGridLayout *)newGridLayout
{
    RDHCollectionViewGridLayout *layout = [[RDHCollectionViewGridLayout alloc] init];
//    NSUInteger lineItemCount = RDH_RANDOM_DATA ? ((arc4random() % 5) + 1) : 4;
//    CGFloat lineSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 5;
//    CGFloat itemSpacing = RDH_RANDOM_DATA ? (arc4random() % 16) : 10;
    
    return layout;
}

- (instancetype)init
{
    self = [self initWithCollectionViewLayout:[[self class] newGridLayout]];
    if (self) {
        // Custom initialization
                
//        NSUInteger sectionCount = RDH_RANDOM_DATA ? (arc4random() % 20) + 10 : 10;
//        NSMutableDictionary *testData = [NSMutableDictionary dictionaryWithCapacity:sectionCount];
//        for (NSUInteger i=0; i<sectionCount; i++) {
//            testData[@(i)] = @(RDH_RANDOM_DATA ? (arc4random() % 16) : 10);
//        }
//        _testData = [testData copy];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapResetItem)];
        
        UIBarButtonItem *changeScrollDirection = [[UIBarButtonItem alloc] initWithTitle:@"Scrolling" style:UIBarButtonItemStylePlain target:self action:@selector(didTapChangeScrollDirectionItem)];
        UIBarButtonItem *sectionsOnNewLine = [[UIBarButtonItem alloc] initWithTitle:@"New Line" style:UIBarButtonItemStylePlain target:self action:@selector(didTapChangeStartSectionOnNewLineItem)];
        
        self.navigationItem.rightBarButtonItems = @[changeScrollDirection, sectionsOnNewLine];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[RDHDemoCell class] forCellWithReuseIdentifier:[RDHDemoCell reuseIdentifier]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)reset
{
    [self setLayout:[[self class] newGridLayout] animated:YES];
}

-(RDHCollectionViewGridLayout *)currentCollectionViewLayout
{
    return (RDHCollectionViewGridLayout *) self.collectionView.collectionViewLayout;
}

-(void)setLayout:(RDHCollectionViewGridLayout *)layout animated:(BOOL)animated
{
    [self.collectionView setCollectionViewLayout:layout animated:animated];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//#if FIXED_LAYOUT
//    return 3;
//#else
//    return [self.testData count];
//#endif
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//#if FIXED_LAYOUT
//    return 3;
//#else
//    return [self.testData[@(section)] unsignedIntegerValue];
//#endif
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RDHDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[RDHDemoCell reuseIdentifier] forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(RDHDemoCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *frame = [NSString stringWithFormat:@"(%.1lf, %.1lf)\n(%.1lf, %.1lf)", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height];
    [cell setText:[NSString stringWithFormat:@"%ld, %ld\n%@", (long) indexPath.section, (long) indexPath.item, frame]];
}

#pragma mark - Nav item actions

-(void)didTapResetItem
{
#if FIXED_LAYOUT
    [self.collectionView reloadData];
#else
    [self reset];
#endif
}

-(void)didTapChangeScrollDirectionItem
{
    UICollectionViewScrollDirection direction = self.currentCollectionViewLayout.scrollDirection;
    switch (direction) {
        case UICollectionViewScrollDirectionHorizontal:
            direction = UICollectionViewScrollDirectionVertical;
            break;
            
        case UICollectionViewScrollDirectionVertical:
            direction = UICollectionViewScrollDirectionHorizontal;
            break;
    }
    self.currentCollectionViewLayout.scrollDirection = direction;
}

-(void)didTapChangeStartSectionOnNewLineItem
{
    self.currentCollectionViewLayout.sectionsStartOnNewLine = !self.currentCollectionViewLayout.sectionsStartOnNewLine;
}

- (BSGridPlate *)getGridBlockSizeForItemAtIndexPath:(NSIndexPath *)indexPath layout:(UICollectionViewLayout *)collectionViewLayout {
    return self.gridBlockSize;
}

@end
