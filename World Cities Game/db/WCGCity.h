//
//  WCGCity.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 29/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@class WCGCountry;

@interface WCGCity : NSManagedObject

@property (nonatomic, retain) NSNumber * capital;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lng;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * population;
@property (nonatomic, retain) WCGCountry *country;
@property (nonatomic, retain) WCGCountry *countryCapital;
-(void)addName:(NSString*)cityName countyCode:(WCGCountry*)country population:(NSNumber*)population lat:(NSString*)lat lng:(NSString*)lng isCapital:(BOOL)isCapital;

-(CLLocationDegrees)getLat;

-(CLLocationDegrees)getLng;


@end
