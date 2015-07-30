//
//  ViewController.m
//  FZValidationTextField
//
//  Created by Faheem Ziker on 28/07/2015.
//  Copyright (c) 2015 V7iTech. All rights reserved.
//

#import "FZViewController.h"
#import "ValidationUtilityMethods.h"
#import "FZValidationTextField.h"

@interface FZViewController ()

@end

@implementation FZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //using code to set regex
    [customRegexField setCustomRegex:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"];
    
    NSLog(@"res:%@",[[NSBundle mainBundle] resourcePath]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(IBAction) validateAllFields {
    NSError *error=[ValidationUtilityMethods validateFields:@[nameField,minMaxField,emailField,mobileNumberField,customRegexField]];
    
    if(error) {
        [ValidationUtilityMethods showAlertView:@"Validation Failed"
                                    description:error.localizedDescription];
    }
    else {
        [ValidationUtilityMethods showAlertView:@"Validation Pass"
                                    description:@"Success"];
    }
}

@end
