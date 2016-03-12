//
//  LRCItem.m
//  MyPlayer
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LRCItem.h"

@implementation LRCItem
- (BOOL)isTimeOlderThanAnother:(LRCItem *)item{
    return self.time > item.time;
}
@end
