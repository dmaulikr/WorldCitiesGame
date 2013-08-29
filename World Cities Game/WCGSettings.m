//
//  WCGSettings.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGSettings.h"

@implementation WCGSettings

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (WCGSettings *)sharedStore
{
    static WCGSettings *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.level = @"gameLevel";
    }
    return self;
}
@end
