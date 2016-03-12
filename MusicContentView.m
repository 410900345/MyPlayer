//
//  MusicContentView.m
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MusicContentView.h"
#import "LRCItem.h"
@interface MusicContentView()<UITableViewDataSource,UITableViewDelegate>
@end
@implementation MusicContentView
{
    UIScrollView * _scrollView;
    UITableView * _titleTableView;
    UILabel * _lrcLabel;
    UILabel * _lrcIMGLabel;
    UIImageView * _lrcIMGbg;
    UILabel * _lrcView;
    //歌词视图的显示行数
    int _lines;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        _titleTableView = [[UITableView alloc]initWithFrame:CGRectMake(40,0,  frame.size.width-90, frame.size.height-40) style:UITableViewStylePlain];
        _titleTableView.backgroundColor = [UIColor clearColor];
        _titleTableView.delegate=self;
        _titleTableView.dataSource=self;
        _titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scrollView addSubview:_titleTableView];
        _scrollView.contentSize = CGSizeMake(frame.size.width*2, frame.size.height);
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.pagingEnabled=YES;
        _lrcLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, frame.size.height-50, frame.size.width-40, 50)];
        _lrcLabel.backgroundColor = [UIColor clearColor];
        _lrcLabel.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_lrcLabel];
        _lrcLabel.textAlignment = NSTextAlignmentCenter;
        _lrcLabel.numberOfLines=0;

        _lrcView = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width+20, 50, frame.size.width-40, frame.size.height-100)];
        _lines = (int)_lrcView.frame.size.height/21;
        _lrcView.numberOfLines = _lines;
        _lrcView.textAlignment = NSTextAlignmentCenter;
        _lrcView.textColor = [UIColor whiteColor];
        [_scrollView addSubview:_lrcView];
        _lrcIMGLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height)];
        _lrcIMGLabel.numberOfLines = _lines;
        _lrcIMGLabel.textAlignment = NSTextAlignmentCenter;
        _lrcIMGLabel.textColor = [UIColor whiteColor];
        
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleDataAttay.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.textLabel.text = self.titleDataAttay[indexPath.row];
    return cell;
}
-(void)setTitleDataAttay:(NSArray *)titleDataAttay{
    _titleDataAttay = [NSArray arrayWithArray:titleDataAttay];
    [_titleTableView reloadData];
}
-(void)setCurretLRCArray:(NSArray *)array index:(int)index{
    NSString * lineLRC = [(LRCItem *)array[index] lrc];
    //提高性能
    if ([_lrcLabel.text isEqualToString:lineLRC]) {
        return;
    }
    _lrcLabel.text = lineLRC;
    //进行行数设置
        NSMutableString * lrcStr = [[NSMutableString alloc]init];
        if (index<_lines/2) {
            //前面用\n补齐
            int offset = (int)_lines/2-index;
            for (int j=0; j<offset; j++) {
                [lrcStr appendFormat:@"\n"];
            }
            for (int j=0; j<_lines-offset; j++) {
                [lrcStr appendFormat:@"%@\n",[(LRCItem *)array[j] lrc]];
            }
        } else if (array.count-1-index<_lines/2) {
            //后面用\n补齐
            int offset = (int)_lines/2-(int)(array.count-index-1);
            for (int j=index-(_lines/2); j<array.count; j++) {
                [lrcStr appendFormat:@"%@\n",[(LRCItem *)array[j] lrc]];
            }
            for (int j=0; j<offset; j++) {
                [lrcStr appendFormat:@"\n"];
            }
        }else {
            for (int j=0; j<_lines; j++) {
                [lrcStr appendString:[(LRCItem *)array[index-_lines/2+j] lrc]];
                [lrcStr appendString:@"\n"];
            }
        }
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:lrcStr];
    NSRange range = [lrcStr rangeOfString:[array[index] lrc]];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:range];
    _lrcView.attributedText = attriStr;
    _lrcIMGLabel.attributedText = attriStr;
    //进行截屏
    if (!_lrcIMGbg) {
        _lrcIMGbg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _lrcIMGbg.image = [UIImage imageNamed:@"BG.jpeg"];
        [_lrcIMGbg addSubview:_lrcIMGLabel];

    }
    UIGraphicsBeginImageContext(_lrcIMGbg.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_lrcIMGbg.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _lrcImage = [img copy];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.play playAtIndex:(int)indexPath.row isPlay:self.play.isPlaying];
}
@end
