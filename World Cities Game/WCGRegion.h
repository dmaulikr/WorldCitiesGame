//
//  WCGRegion.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 17/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WCGCountry;

@interface WCGRegion : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) WCGCountry *countries;

-(void)addName:(NSString*)regionName code:(NSString*)code;

@end
