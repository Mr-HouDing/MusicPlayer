//
//  MusicModel.m
//  MusicPlayer
//
//  Created by 侯仁杰 on 15/10/15.
//  Copyright © 2015年 侯仁杰. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        self.ID = value;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", self.name, self.singer];
}

@end
