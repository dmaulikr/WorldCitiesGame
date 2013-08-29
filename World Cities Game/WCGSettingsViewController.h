//
//  WCGSettingsViewController.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 28/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCGSettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    __weak IBOutlet UIPickerView *levelPicker;
    NSArray * levels;
}

@end
