//
//  WCGCountriesViewController.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 26/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGCountriesViewController.h"
#import "WCGMapViewController.h"
#import "WCGWorldStore.h"

@interface WCGCountriesViewController ()

@end

@implementation WCGCountriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        allItems = [[WCGWorldStore sharedStore] getAllRegions];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[[allItems objectAtIndex:[indexPath row]] name]];
    // [[cell detailTextLabel] setText:[item statusDetailsFull]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int curRow = [indexPath row];
    WCGRegion *region = [allItems objectAtIndex:curRow];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"2", @"count", @"region", @"type", [region code], @"details", nil];
    
    WCGMapViewController *currentViewController = [[WCGMapViewController alloc] initWithParams:params];

    
    [[self navigationController] pushViewController:currentViewController
                                           animated:YES];
    
}


@end
