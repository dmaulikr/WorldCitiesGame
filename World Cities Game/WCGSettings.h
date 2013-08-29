//
//  WCGSettings.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCGSettings : NSObject
{
    
}
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * score;

+ (WCGSettings *) sharedStore;

@end
