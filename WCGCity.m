//
//  WCGCity.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 25/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGCity.h"
#import "WCGCountry.h"


@implementation WCGCity

@dynamic capital;
@dynamic lat;
@dynamic lng;
@dynamic name;
@dynamic population;
@dynamic country;

-(void)addName:(NSString*)cityName countyCode:(WCGCountry*)country population:(NSNumber*)population lat:(NSString*)lat lng:(NSString*)lng isCapital:(BOOL)isCapital
{
    
    if (self)
    {
        self.name = cityName;
        self.country = country;
        self.population = population;
        self.lat = lat;
        self.lng = lng;
        self.capital = [NSNumber numberWithBool:isCapital];
    }
    
    
}

-(CLLocationDegrees)getLat
{
    return [[self lat] doubleValue];
}

-(CLLocationDegrees)getLng
{
    return [[self lng] doubleValue];
}


@end
