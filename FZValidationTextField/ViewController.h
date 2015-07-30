//
//  ViewController.h
//  FZValidationTextField
//
//  Created by Faheem Ziker on 28/07/2015.
//  Copyright (c) 2015 V7iTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FZValidationTextField;

@interface ViewController : UIViewController
{
    IBOutlet FZValidationTextField *nameField,*minMaxField,*emailField,*mobileNumberField,*customRegexField;
}

-(IBAction) validateAllFields;
@end

