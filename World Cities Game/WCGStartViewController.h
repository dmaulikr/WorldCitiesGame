//
//  WCGStartViewController.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 23/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCGStartViewController : UIViewController <UITableViewDelegate>
{
    NSArray * allItems;
    __weak IBOutlet UITableView *menuTable;
}


@end
