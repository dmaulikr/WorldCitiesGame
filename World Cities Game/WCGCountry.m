//
//  WCGCountry.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 25/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGCountry.h"
#import "WCGCity.h"
#import "WCGRegion.h"


@implementation WCGCountry

@dynamic code;
@dynamic name;
@dynamic cities;
@dynamic region;

-(void)addName:(NSString*)countryName countryCode:(NSString*)countryCode region:(WCGRegion*)region
{
    
    if (self)
    {
        self.name = countryName;
        self.code = countryCode;
        self.region = region;
    }
    
    
}


-(void)addWorldRegion:(WCGRegion*)region
{
    self.region = region;
}


@end
