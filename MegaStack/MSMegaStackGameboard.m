//
//  MSMegaStackGameboard.m
//  MegaStack
//
//  Created by FlyinGeek on 2/12/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import "MSMegaStackGameboard.h"

@interface MSMegaStackGameboard()

@property (nonatomic) CGRect gameboardFrame;
@property (nonatomic) CGColorRef gameboardLineColor;
@property (nonatomic, readwrite) NSInteger numberOfRows;
@property (nonatomic, readwrite) NSInteger numberOfColumns;

@end

@implementation MSMegaStackGameboard

- (instancetype)initWithFrame:(CGRect)frame rows:(NSInteger)numberOfRows columns:(NSInteger)numberOfColumns gameboardColor:(UIColor *)color
{
    if (numberOfRows < MIN_ROWS || numberOfColumns < MIN_COLUMNS) {
        NSLog(@"Number of rows and columns should greater or equal than minimun requirements");
        return nil;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfRows = numberOfRows;
        _numberOfColumns = numberOfColumns;
        _gameboardLineColor = color.CGColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self initGameboard];
}

- (void)initGameboard
{
    // set actual frame
    self.gameboardFrame = CGRectMake(GAME_BOARD_LINE_WIDTH / 2.0, GAME_BOARD_LINE_WIDTH / 2.0, self.frame.size.width - GAME_BOARD_LINE_WIDTH, self.frame.size.height - GAME_BOARD_LINE_WIDTH);
    
    // draw columns
    for (int i = 0; i <= self.numberOfColumns; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.gameboardLineColor);
    
        CGContextSetLineWidth(context, GAME_BOARD_LINE_WIDTH);
        CGContextMoveToPoint(context, (self.gameboardFrame.size.width/(float)self.numberOfColumns) * i + GAME_BOARD_LINE_WIDTH / 2.0, 0.0);
        CGContextAddLineToPoint(context, (self.gameboardFrame.size.width/(float)self.numberOfColumns) * i + GAME_BOARD_LINE_WIDTH / 2.0, self.gameboardFrame.size.height);
        CGContextStrokePath(context);
    }
    
    // draw rows
    for (int i = 0; i <= self.numberOfRows; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.gameboardLineColor);
        
        CGContextSetLineWidth(context, GAME_BOARD_LINE_WIDTH);
        CGContextMoveToPoint(context, 0.0, (self.gameboardFrame.size.height/(float)self.numberOfRows) * i + GAME_BOARD_LINE_WIDTH / 2.0);
        CGContextAddLineToPoint(context, self.gameboardFrame.size.width + GAME_BOARD_LINE_WIDTH, (self.gameboardFrame.size.height/(float)self.numberOfRows) * i + GAME_BOARD_LINE_WIDTH / 2.0);
        CGContextStrokePath(context);
    }
    
    NSLog(@"Gameboard initialized!");
}


- (void)drawBlockUnitAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex withColor:(UIColor*)color
{
    // check for bounds
    if (rowIndex >= self.numberOfRows || columnIndex >= self.numberOfColumns || rowIndex < 0 || columnIndex < 0) {
        NSLog(@"Cannot draw block at (%ld, %ld): row index or column index out of bounds", rowIndex, columnIndex);
        return;
    }
    
    // check for existence
    NSInteger tag = [NSString stringWithFormat:@"%ld%ld", (rowIndex + 1)*(columnIndex + 1), (columnIndex + 1)].integerValue;
    if([self viewWithTag:tag]) {
        NSLog(@"Cannot draw block at (%ld, %ld): block already exists", rowIndex, columnIndex);
        return;
    }
    
    UIView *newBlock = [[UIView alloc]initWithFrame:CGRectMake((self.gameboardFrame.size.width / self.numberOfColumns) * columnIndex + GAME_BOARD_LINE_WIDTH, (self.gameboardFrame.size.height / self.numberOfRows) * (self.numberOfRows - rowIndex - 1) + GAME_BOARD_LINE_WIDTH, self.gameboardFrame.size.width / self.numberOfColumns - GAME_BOARD_LINE_WIDTH, self.gameboardFrame.size.height / self.numberOfRows - GAME_BOARD_LINE_WIDTH)];
    newBlock.backgroundColor = color;
    newBlock.tag = tag;
    
    [self addSubview:newBlock];
}

- (void)removeBlockUnitAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    // check for bounds
    if (rowIndex >= self.numberOfRows || columnIndex >= self.numberOfColumns || rowIndex < 0 || columnIndex < 0) {
        NSLog(@"Cannot remove block at (%ld, %ld): row index or column index out of bounds", rowIndex, columnIndex);
        return;
    }
    
    NSInteger tag = [NSString stringWithFormat:@"%ld%ld", (rowIndex + 1)*(columnIndex + 1), (columnIndex + 1)].integerValue;
    UIView *targetBlock = [self viewWithTag:tag];
    if(targetBlock) {
        [targetBlock removeFromSuperview];
    } else {
        NSLog(@"Cannot remove block at (%ld, %ld): block doesn't exists", rowIndex, columnIndex);
    }
}

- (void)reset
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

@end
