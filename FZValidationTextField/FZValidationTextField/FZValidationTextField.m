//
//  BaseTextField.m
//
//  Created by Faheem Ziker on 23/05/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "FZValidationTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation FZValidationTextField
@synthesize iconImageName,validationType;
@synthesize maxLength;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self validateFieldError];
}

- (void)textFieldDidChangeEditing:(UITextField *)textField {
    [iconImageView setHidden:YES];
}


-(void) awakeFromNib {
    [super awakeFromNib];
    
    iconImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_ERROR_ICON]];
    [iconImageView setCenter:CGPointMake(self.bounds.size.width-20, self.bounds.size.height/2.0)];
    [iconImageView setHidden:YES];
    [self addSubview:iconImageView];
    
    
    [self addTarget:self action:@selector(textFieldDidEndEditing:)
   forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(textFieldDidChangeEditing:)
   forControlEvents:UIControlEventEditingChanged];

}

-(void) setText:(NSString *)aText {
    [super setText:aText];
    [iconImageView setHidden:YES];
}


#pragma mark - Validation Methods

-(void) validationPass {
    UIImage *redIcon=[UIImage imageNamed:IMAGE_PASS_ICON];
    [iconImageView setImage:redIcon];
    [iconImageView setHidden:NO];
}

-(void) validationFailed {
    UIImage *redIcon=[UIImage imageNamed:IMAGE_ERROR_ICON];
    [iconImageView setImage:redIcon];
    [iconImageView setHidden:NO];
}

-(NSString *) validateFieldError {
    
    if(validationType) {
        NSString *error=[FZValidationTextField validateFieldError:self];
        
        if(error) {
            [self validationFailed];
            return error;
        }
        else {
            [self validationPass];
        }
    }
    return nil;
}

+(NSString *) validatePasswordFieldError:(FZValidationTextField *)field {

    int passwordLength=6;
    int maxPasswordLength=15;
    
    if(field.text.length<passwordLength)
    {
        NSString *fieldTitle=field.validationType;//field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be less than %d characters",fieldTitle,passwordLength];
        
        return errorMessage;
    }
    else if(field.text.length>maxPasswordLength)
    {
        NSString *fieldTitle=field.validationType;//field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be more than %d characters",fieldTitle,maxPasswordLength];
        
        return errorMessage;
    }
    
    
    return nil;
}


+(BOOL) string:(NSString *)string containsPattern:(NSString *)regexString{
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                                        options:0
                                                          range:NSMakeRange(0, [string length])];
    
    
    
    return numberOfMatches ? YES : NO;
    
}


+(NSString *) validateEmailFieldError:(UITextField *)field {
    
    
    BOOL isValidEmail=[FZValidationTextField string:field.text containsPattern:@"\\b[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}\\b"];
    if(!isValidEmail)
    {
        NSString *fieldTitle=field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ not valid",fieldTitle];
        return errorMessage;
    }
    
    return nil;
}



+(NSString *) validatePhoneNumberFieldError:(FZValidationTextField *)field {
    
    int minLength=4;
    int maxLength=20;
    
    if(field.text.length<minLength)
    {
        NSString *fieldTitle=field.validationType;//field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be less than %d characters",fieldTitle,minLength];
        
        return errorMessage;
    }
    else if(field.text.length>maxLength)
    {
        NSString *fieldTitle=field.validationType;//field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be more than %d characters",fieldTitle,maxLength];
        
        return errorMessage;
    }

    
    NSString *phoneRegex = @"[0-9]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![emailTest evaluateWithObject:field.text]) {
        NSString *errorMessage=[NSString stringWithFormat:@"Phone Number should contains numbers only"];
        return errorMessage;
    }
    
    return nil;
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSString *) validateFieldError:(FZValidationTextField *)field{
    
    int maxTextLength=60;
    
    if(field.maxLength>0)
        maxTextLength=field.maxLength;
    
    NSString *validationType=[field valueForKeyPath:@"validationType"];
    
    if(!validationType)
    {
        return nil;
    }
    
    if(!field.text||[field.text isEqualToString:@""])
    {
        NSString *fieldTitle=validationType;
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be empty",fieldTitle];
        
        return errorMessage;
    }
    if(field.text.length>maxTextLength)
    {
        NSString *fieldTitle=validationType;
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be more than %d characters",fieldTitle,maxTextLength];
        return errorMessage;
    }
    if(field.text.length<field.minLength)
    {
        NSString *fieldTitle=validationType;
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be less than %d characters",fieldTitle,field.minLength];
        return errorMessage;
    }
    if(field.customRegex) {
        if(![FZValidationTextField string:field.text containsPattern:field.customRegex]) {
            return field.customMessage?field.customMessage:@"Validation Failed";
        }
    }
    if([validationType rangeOfString:@"Email"].location!=NSNotFound)
    {
        NSString *errorMessage=[FZValidationTextField validateEmailFieldError:field];
        return errorMessage;
    }
    else if([validationType rangeOfString:@"Password"].location!=NSNotFound)
    {
        NSString *errorMessage=[FZValidationTextField validatePasswordFieldError:field];
        return errorMessage;
    }
    else if([validationType rangeOfString:@"Mobile Number"].location!=NSNotFound)
    {
        NSString *errorMessage=[FZValidationTextField validatePhoneNumberFieldError:field];
        return errorMessage;
    }
    return nil;
}


@end