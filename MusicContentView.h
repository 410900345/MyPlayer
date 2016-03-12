//
//  MusicContentView.h
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMusicPlayer.h"
@interface MusicContentView : UIView
@property(nonatomic,strong)NSArray * titleDataAttay;
-(void)setCurretLRCArray:(NSArray *)array index:(int)index;
@property(nonatomic,strong)MyMusicPlayer * play;
@property(nonatomic,readonly)UIImage * lrcImage;
@end
