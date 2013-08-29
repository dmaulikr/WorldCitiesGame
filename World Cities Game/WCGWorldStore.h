//
//  WCGWorldStore.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 27/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCGCountry.h"
#import "WCGCity.h"
#import "WCGRegion.h"
#import <MapKit/MapKit.h>

struct zoom 
{
    CLLocationCoordinate2D centre;
    int x;
    int y;
};

@interface WCGWorldStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    
       
    NSMutableArray * currentCities;
    
    NSMutableDictionary * countriesZooms;
}


@property (nonatomic, strong) NSMutableDictionary *allRegions;
@property (nonatomic, strong) NSMutableDictionary *allCountries; 

//preparations
- (void)showAllItems:(NSString*)tableName;
- (NSMutableArray *)getCitiesWithParams:(NSMutableDictionary*)params;
- (BOOL)saveChanges;

//all countries and regions
-(NSMutableArray *)getAllRegions;
-(NSMutableArray *)getAllCountriesForRegion:(WCGRegion*)region;

+ (WCGWorldStore *) sharedStore;
- (NSString *)itemArchivePath;

// used for parsing cities and countries
- (void)addDefaultRegions;
- (void)parseAllRegions;
 -(void)parseAllCountries;
 -(void)parseAllCities;
 -(void)addCity:(NSString*)cityName;
 -(void)addCity:(NSString*)cityName countyCode:(WCGCountry*)country population:(NSString*)population lat:(NSString*)lat lng:(NSString*)lng isCapital:(BOOL)isCapital;
 -(void)addCountry:(NSString*)countryName countryCode:(NSString*)countryCode region:(WCGRegion*)region;
-(void)addRegion:(NSString*)regionName code:(NSString*)code centreLat:(NSString*)lat centreLng:(NSString*)lng zoomX:(NSNumber*)zoomX zoomY:(NSNumber*)zoomY;
- (void)parseFullCountryInfo;


@end
