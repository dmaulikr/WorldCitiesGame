//
//  WCGCountry.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 29/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class WCGCity, WCGRegion;

@interface WCGCountry : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * centreLat;
@property (nonatomic, retain) NSString * centreLng;
@property (nonatomic, retain) NSSet *cities;
@property (nonatomic, retain) WCGRegion *region;
@property (nonatomic, retain) WCGCity *capital;

-(void)addName:(NSString*)countryName countryCode:(NSString*)countryCode region:(WCGRegion*)region;
- (void)setCountryCapital:(WCGCity *)city lat:(NSString*)lat lng:(NSString*)lng;
-(void)addWorldRegion:(WCGRegion*)region;

@end

@interface WCGCountry (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(WCGCity *)value;
- (void)removeCitiesObject:(WCGCity *)value;
- (void)addCities:(NSSet *)values;
- (void)removeCities:(NSSet *)values;

-(void)addName:(NSString*)cityName countyCode:(WCGCountry*)country population:(NSNumber*)population lat:(NSString*)lat lng:(NSString*)lng isCapital:(BOOL)isCapital;

-(CLLocationDegrees)getLat;

-(CLLocationDegrees)getLng;

@end
