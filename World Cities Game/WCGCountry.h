//
//  WCGCountry.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 17/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WCGCity, WCGRegion;

@interface WCGCountry : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) WCGCity *cities;
@property (nonatomic, retain) WCGRegion *region;

-(void)addName:(NSString*)countryName countryCode:(NSString*)countryCode region:(WCGRegion*)region;


@end
