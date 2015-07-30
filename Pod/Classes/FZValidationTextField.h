//
//  BaseTextField.h
//
//  Created by Faheem Ziker on 23/05/2014.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_ERROR_ICON @"icon_validation_fail"
#define IMAGE_PASS_ICON  @"icon_validation_pass"


@interface FZValidationTextField : UITextField
{
    UIImageView *iconImageView;
    
}
@property(nonatomic,strong) NSString *iconImageName,*validationType;
@property(nonatomic,strong) NSString *customRegex,*customMessage;
@property(nonatomic,assign) int maxLength,minLength;


- (NSString *) validateFieldError;
-(void) validationPass;
-(void) validationFailed;
@end
