//
//  WCGCountry.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 29/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGCountry.h"
#import "WCGCity.h"
#import "WCGRegion.h"


@implementation WCGCountry

@dynamic code;
@dynamic name;
@dynamic centreLat;
@dynamic centreLng;
@dynamic cities;
@dynamic region;
@dynamic capital;

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

- (void)setCountryCapital:(WCGCity *)city lat:(NSString*)lat lng:(NSString*)lng
{
    self.capital = city;
    self.centreLat = lat;
    self.centreLng = lng;
    city.capital = [NSNumber numberWithBool:YES];
}

@end
