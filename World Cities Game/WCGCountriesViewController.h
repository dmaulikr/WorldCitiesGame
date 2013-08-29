//
//  WCGCountriesViewController.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class WCGRegion;

@interface WCGCountriesViewController : UITableViewController
{
    NSMutableArray * allItems;
}
-(id)initWithRegion:(WCGRegion*)region;
@property (nonatomic, strong) WCGRegion * currentRegion;

@end
