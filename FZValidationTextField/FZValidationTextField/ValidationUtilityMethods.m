//
//  UtilityMethods.m
//  FlashPhrase
//
//  Created by Faheem Ziker on 11/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ValidationUtilityMethods.h"
#import "FZValidationTextField.h"

@implementation ValidationUtilityMethods

+(void) showAlertView:(NSString *)title description:(NSString *)description {
    
    [[[UIAlertView alloc] initWithTitle:title
                               message:description
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil] show];
}

+(NSError *) validateFields:(NSArray *)fieldsArray {
    

    for(FZValidationTextField *field in fieldsArray)
    {
        [field setText:[field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSString *validationError=[field validateFieldError];
        if(validationError)
        {
            NSError *error=[NSError errorWithDomain:@"Field Error"
                                               code:0
                                           userInfo:@{NSLocalizedDescriptionKey:validationError
                                                      }];
            return error;
        }
    }
    return nil;
}


@end
