//
//  BaseTextField.m
//
//  Created by Faheem Ziker on 23/05/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "BaseTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
@implementation BaseTextField
@synthesize iconImageName,placeHolderString,validationType,fieldTextColor;
@synthesize showArrow;
@synthesize maxLength;
@synthesize backgroundImageName;

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
    [invalidIconImageView setHidden:YES];
}


-(void) awakeFromNib {
    [super awakeFromNib];
    
    invalidIconImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_ERROR_ICON]];
    [invalidIconImageView setCenter:CGPointMake(self.bounds.size.width-20, self.bounds.size.height/2.0)];
    [invalidIconImageView setHidden:YES];
    [self addSubview:invalidIconImageView];
    
    [self addTarget:self action:@selector(textFieldDidEndEditing:)
   forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(textFieldDidChangeEditing:)
   forControlEvents:UIControlEventEditingChanged];


}

-(void) setText:(NSString *)aText {
    [super setText:aText];
    [invalidIconImageView setHidden:YES];
}


#pragma mark - Validation Methods

-(void) validationPass {
    UIImage *redIcon=[UIImage imageNamed:IMAGE_PASS_ICON];
    [invalidIconImageView setImage:redIcon];
    [invalidIconImageView setHidden:NO];
}

-(void) validationFailed {
    UIImage *redIcon=[UIImage imageNamed:IMAGE_ERROR_ICON];
    [invalidIconImageView setImage:redIcon];
    [invalidIconImageView setHidden:NO];
}

-(NSString *) validateFieldError {
    
    if(validationType) {
        NSString *error=[BaseTextField validateFieldError:self];
        
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

+(NSString *) validatePasswordFieldError:(BaseTextField *)field {
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
    
    
    BOOL isValidEmail=[BaseTextField string:field.text containsPattern:@"\\b[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}\\b"];
    if(!isValidEmail)
    {
        NSString *fieldTitle=field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ not valid",fieldTitle];
        return errorMessage;
    }
    
    return nil;
}



+(NSString *) validatePhoneNumberFieldError:(BaseTextField *)field {
    
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

+(NSString *) validateFieldError:(BaseTextField *)field{
    
    int maxTextLength=60;
    
    if(field.maxLength>0)
        maxTextLength=field.maxLength;
    
    NSString *validationType=[field valueForKeyPath:@"validationType"];
    
    if(!validationType)
    {
        return nil;
    }
    
    if([validationType rangeOfString:@"Country"].location != NSNotFound){
        if(!field.text||[field.text isEqualToString:@""])
        {
            NSString *fieldTitle=validationType;//field?field.placeholder:@"";
            NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be empty",fieldTitle];
            if(errorMessage.length > 0){
                [BaseTextField setErrorColorForField:field];
            }else{
                [BaseTextField removeErrorColorForFeild:field];
            }
            return errorMessage;
        }
    }
    
    if(!field.text||[field.text isEqualToString:@""])
    {
        NSString *fieldTitle=validationType;//field?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be empty",fieldTitle];
        if(errorMessage.length > 0){
            [BaseTextField setErrorColorForField:field];
        }else{
            [BaseTextField removeErrorColorForFeild:field];
        }
        return errorMessage;
    }
    if(field.text.length>maxTextLength)
    {
        NSString *fieldTitle=validationType;//field.placeholder?field.placeholder:@"";
        [BaseTextField setErrorColorForField:field];
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be more than %d characters",fieldTitle,maxTextLength];
        if(errorMessage.length > 0){
            [BaseTextField setErrorColorForField:field];
        }else{
            [BaseTextField removeErrorColorForFeild:field];
        }
        return errorMessage;
    }
    if(field.text.length<field.minLength)
    {
        NSString *fieldTitle=validationType;//field.placeholder?field.placeholder:@"";
        [BaseTextField setErrorColorForField:field];
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be less than %d characters",fieldTitle,field.minLength];
        if(errorMessage.length > 0){
            [BaseTextField setErrorColorForField:field];
        }else{
            [BaseTextField removeErrorColorForFeild:field];
        }
        return errorMessage;
    }
   
    
    if([validationType rangeOfString:@"Email"].location!=NSNotFound)
    {
        NSString *errorMessage=[BaseTextField validateEmailFieldError:field];
        if(errorMessage.length > 0){
            [BaseTextField setErrorColorForField:field];
        }else{
            [BaseTextField removeErrorColorForFeild:field];
        }
        return errorMessage;
    }
    else if([validationType rangeOfString:@"Password"].location!=NSNotFound)
    {
        NSString *errorMessage=[BaseTextField validatePasswordFieldError:field];
        if(errorMessage.length > 0){
            [BaseTextField setErrorColorForField:field];
        }else{
            [BaseTextField removeErrorColorForFeild:field];
        }
        return errorMessage;
    }
    else if([validationType rangeOfString:@"Mobile Number"].location!=NSNotFound)
    {

        NSString *errorMessage=[BaseTextField validatePhoneNumberFieldError:field];
        if(errorMessage.length > 0){
            [BaseTextField setErrorColorForField:field];
        }else{
            [BaseTextField removeErrorColorForFeild:field];
        }
        return errorMessage;
    }
    return nil;
}



+ (void)setErrorColorForField:(BaseTextField*)field{
    
    NSDictionary *errorFontColor = @{NSForegroundColorAttributeName:DEFAULT_ERROR_FIELD_PLACEHOLDER_COLOR};
    NSString *fieldValidationType=[field valueForKeyPath:@"validationType"];
   
    if([fieldValidationType isEqualToString:@"Email"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Email Address" attributes:errorFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:errorFontColor];
        if(field.text.length > 0){
            field.attributedText = originalString;
        }else{
            field.attributedPlaceholder = placeHolderAttribString;
        }
    }

    if([fieldValidationType isEqualToString:@"Mobile Number"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Mobile Number" attributes:errorFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:errorFontColor];
        if(field.text.length > 0){
            field.attributedText = originalString;
        }else{
            field.attributedPlaceholder = placeHolderAttribString;
        }
    }
    
    if([fieldValidationType isEqualToString:@"Country"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Country" attributes:errorFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:errorFontColor];
        if(field.text.length > 0){
            field.attributedText = originalString;
        }else{
            field.attributedPlaceholder = placeHolderAttribString;
        }
    }
    
    if([fieldValidationType isEqualToString:@"Full Name"]){
    
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Full Name" attributes:errorFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:errorFontColor];
        if(field.text.length > 0){
            field.attributedText = originalString;
        }else{
            field.attributedPlaceholder = placeHolderAttribString;
        }
    }
    
    if([fieldValidationType isEqualToString:@"Address"]){
        
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Address" attributes:errorFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:errorFontColor];
        if(field.text.length > 0){
            field.attributedText = originalString;
        }else{
            field.attributedPlaceholder = placeHolderAttribString;
        }
    }
    
}

+ (void)removeErrorColorForFeild:(BaseTextField*)field{
    
    NSString *fieldValidationType=[field valueForKeyPath:@"validationType"];
    NSString *defaultTextColor = [field valueForKey:@"fieldTextColor"];
    if(!defaultTextColor){
        defaultTextColor = @"Default Color";
    }
    NSDictionary *defaultFontColor;
    NSDictionary *defaultPlaceholderFontColor;
    if([defaultTextColor isEqualToString:@"White"]){
        defaultFontColor= @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        defaultPlaceholderFontColor = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }else{
        defaultFontColor= @{NSForegroundColorAttributeName:DEFAULT_FIELD_COLOR};
           defaultPlaceholderFontColor = @{NSForegroundColorAttributeName:DEFAULT_FIELD_PLACEHOLDER_COLOR};
    }
    
    if([fieldValidationType isEqualToString:@"Full Name"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Full Name" attributes:defaultPlaceholderFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:defaultFontColor];
        field.attributedText = originalString;
        field.attributedPlaceholder = placeHolderAttribString;
    }
    
    if([fieldValidationType isEqualToString:@"Email"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Email Address" attributes:defaultPlaceholderFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:defaultFontColor];
        field.attributedText = originalString;
        field.attributedPlaceholder = placeHolderAttribString;
    }
    
    if([fieldValidationType isEqualToString:@"Mobile Number"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Mobile Number" attributes:defaultPlaceholderFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:defaultFontColor];
        field.attributedText = originalString;
        field.attributedPlaceholder = placeHolderAttribString;

    }
    
    if([fieldValidationType isEqualToString:@"Country"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Country" attributes:defaultPlaceholderFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:defaultFontColor];
        field.attributedText = originalString;
        field.attributedPlaceholder = placeHolderAttribString;
    
    }
    
    if([fieldValidationType isEqualToString:@"Address"]){
        NSAttributedString *placeHolderAttribString=[[NSAttributedString alloc] initWithString:@"Address" attributes:defaultPlaceholderFontColor];
        NSAttributedString *originalString = [[NSAttributedString alloc] initWithString:field.text attributes:defaultFontColor];
        field.attributedText = originalString;
        field.attributedPlaceholder = placeHolderAttribString;
        
    }

}


@end