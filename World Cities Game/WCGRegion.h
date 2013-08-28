//
//  WCGRegion.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WCGCountry;

@interface WCGRegion : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * centreLat;
@property (nonatomic, retain) NSString * centreLng;
@property (nonatomic, retain) NSNumber * zoomX;
@property (nonatomic, retain) NSNumber * zoomY;
@property (nonatomic, retain) NSSet *countries;
-(void)addName:(NSString*)regionName code:(NSString*)code centreLat:(NSString*)lat centreLng:(NSString*)lng zoomX:(NSNumber*)zoomX zoomY:(NSNumber*)zoomY;

@end

@interface WCGRegion (CoreDataGeneratedAccessors)

- (void)addCountriesObject:(WCGCountry *)value;
- (void)removeCountriesObject:(WCGCountry *)value;
- (void)addCountries:(NSSet *)values;
- (void)removeCountries:(NSSet *)values;

@end
