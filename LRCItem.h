//
//  LRCItem.h
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRCItem : NSObject
@property (nonatomic) float time;
@property (nonatomic,copy) NSString *lrc;
//排序方法
- (BOOL)isTimeOlderThanAnother:(LRCItem *)item;
@end
