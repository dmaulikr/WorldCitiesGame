//
//  WCGRegion.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 17/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGRegion.h"
#import "WCGCountry.h"


@implementation WCGRegion

@dynamic name;
@dynamic code;
@dynamic countries;

-(void)addName:(NSString*)regionName code:(NSString*)code
{
    
    if (self)
    {
        self.name = regionName;
        self.code = code;
    }
    
}

@end
