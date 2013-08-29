//
//  WCGCountriesViewController.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGCountriesViewController.h"
#import "WCGWorldStore.h"
@class WCGRegion;
#import "WCGCountry.h"
#import "WCGMapViewController.h"

@interface WCGCountriesViewController ()

@end

@implementation WCGCountriesViewController
@synthesize currentRegion;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

-(id)initWithRegion:(WCGRegion*)region
{
    self = [super init];
    
    if (self)
    {
        currentRegion = region;
        allItems = [[WCGWorldStore sharedStore] getAllCountriesForRegion:region];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allItems count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([indexPath row] == 0)
        [[cell textLabel] setText:@"All countries"];
        else
    [[cell textLabel] setText:[[allItems objectAtIndex:[indexPath row] - 1] name]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    int curRow = [indexPath row];
    NSMutableDictionary *params;
    if (curRow == 0)
    {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"10", @"count", @"region", @"type", [currentRegion code], @"details", nil];
    }
    else
    {
        WCGCountry *country = [allItems objectAtIndex:curRow - 1];
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"10", @"count", @"country", @"type", [country code], @"details", nil];
    }
    
    
    WCGMapViewController *currentViewController = [[WCGMapViewController alloc] initWithParams:params];
    
    
    [[self navigationController] pushViewController:currentViewController
                                           animated:YES];
}

@end
