//
//  WCGRegion.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGRegion.h"
#import "WCGCountry.h"


@implementation WCGRegion

@dynamic code;
@dynamic name;
@dynamic centreLat;
@dynamic centreLng;
@dynamic zoomX;
@dynamic zoomY;
@dynamic countries;

-(void)addName:(NSString*)regionName code:(NSString*)code centreLat:(NSString*)lat centreLng:(NSString*)lng zoomX:(NSNumber*)zoomX zoomY:(NSNumber*)zoomY
{
    
    if (self)
    {
        self.name = regionName;
        self.code = code;
        self.centreLat = lat;
        self.centreLng = lng;
        self.zoomX = zoomX;
        self.zoomY = zoomY;
    }    
}



@end
