//
//  WCGSettingsViewController.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGSettingsViewController.h"
#import "WCGSettings.h"

@interface WCGSettingsViewController ()

@end

@implementation WCGSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        levels = [NSArray arrayWithObjects:@"Easy", @"Medium", @"Hard", nil];
        levelPicker.dataSource = self;
        levelPicker.delegate = self;        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString * type = [[NSUserDefaults standardUserDefaults]
                              valueForKey:[[WCGSettings sharedStore] level]];
    
    [levelPicker selectRow:[levels indexOfObject:type] inComponent:0 animated:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[NSUserDefaults standardUserDefaults]
     setValue:[levels objectAtIndex:row]
     forKey:[[WCGSettings sharedStore] level]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [levels count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [levels objectAtIndex:row];
}

@end
