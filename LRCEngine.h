//
//  LRCEngine.h
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRCItem.h"
@interface LRCEngine : NSObject
-(instancetype)initWithFile:(NSString *)fileName;
@property(nonatomic,strong)NSString * author;
@property(nonatomic,strong)NSString * albume;
@property(nonatomic,strong)NSString * title;
-(void)getCurrentLRCInLRCArray:(void(^)(NSArray * lrcArray,int currentIndex))handle atTime:(float)time;
@end
