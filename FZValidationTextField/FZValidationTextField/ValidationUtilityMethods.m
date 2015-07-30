//
//  UtilityMethods.m
//  FlashPhrase
//
//  Created by Faheem Ziker on 11/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UtilityMethods.h"
#import "BaseTextField.h"

@implementation UtilityMethods

+(NSDate *) dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+(NSString *) stringFromDate:(NSDate *)date {
    NSString *format=@"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString= [dateFormatter stringFromDate:date];
    return dateString;
}



+(NSDate *) dateFromString:(NSString *)dateString format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+(NSString *) stringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString= [dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString *) shortStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString= [dateFormatter stringFromDate:date];
    return dateString;
}


+(NSString*)getTimeFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    [dateFormatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSString *timeInString =[dateFormatter1 stringFromDate:date];
    return timeInString;
}


+(void) showAlertView:(NSString *)title description:(NSString *)description {
    
    [[[UIAlertView alloc] initWithTitle:title
                               message:description
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil] show];
}

+(NSError *) validateFields:(NSArray *)fieldsArray {
    

    for(BaseTextField *field in fieldsArray)
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
   
    
    BOOL isValidEmail=[UtilityMethods string:field.text containsPattern:@"\\b[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}\\b"];
    if(!isValidEmail)
    {
        NSString *fieldTitle=field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ not valid",fieldTitle];        
        return errorMessage;
    }
    
    return nil;
}


+(NSString *) validatePasswordFieldError:(BaseTextField *)field {
    int passwordLength=6;
    int maxPasswordLength=12;
    
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
    
//    BOOL containsAlpha=[UtilityMethods string:field.text containsPattern:@"\\[A-Z]|[a-z]"];
//    BOOL containsNumber=[UtilityMethods string:field.text containsPattern:@"[1-9]"];
//    
//    if(!containsAlpha||!containsNumber)
//    {
//        NSString *fieldTitle=field.validationType;//field.placeholder?field.placeholder:@"";
//        NSString *errorMessage=[NSString stringWithFormat:@"%@ should contains both alphabets and numbers",fieldTitle];
//        
//        return errorMessage;
//    }
    
    return nil;
}

+(NSString *) validatePhoneNumberFieldError:(UITextField *)field {
    if(!NO) //will be added later
    {
        //NSString *fieldTitle=field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"Cell Number should contains numbers only"];
        
        return errorMessage;
    }
    return nil;
}

+(NSString *) validateFieldError:(BaseTextField *)field{
    int maxTextLength=55;
    
    NSString *validationType=[field valueForKeyPath:@"validationType"];
    
    if(!validationType)
    {
        return nil;
    }

    if(!field.text||[field.text isEqualToString:@""])
    {
        NSString *fieldTitle=validationType;//field?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be empty",fieldTitle];
        return errorMessage;
    }    
    if(field.text.length>maxTextLength)
    {
        NSString *fieldTitle=validationType;//field.placeholder?field.placeholder:@"";
        NSString *errorMessage=[NSString stringWithFormat:@"%@ field should not be more than %d characters",fieldTitle,maxTextLength];
        
        return errorMessage;
    }    
    else if([validationType rangeOfString:@"Password"].location!=NSNotFound)
    {
        NSString *errorMessage=[UtilityMethods validatePasswordFieldError:field];
        return errorMessage;
    }
    else if([validationType rangeOfString:@"Email"].location!=NSNotFound)
    {
        NSString *errorMessage=[UtilityMethods validateEmailFieldError:field];
        return errorMessage;
    }
    else if([validationType rangeOfString:@"Cell Number"].location!=NSNotFound)
    {
        NSString *errorMessage=[UtilityMethods validatePhoneNumberFieldError:field];
        return errorMessage;
    }
    
    return nil;
}


+(NSDate *) dateFromTimeStamp:(double )timeStamp{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    
    return date;
}

+(NSString *) sentenceCaps:(NSString *)string{
    if(string&&![string isEqualToString:@""])
    {
        return [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] uppercaseString]];
    }
    return string;
    
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

+(NSString *)prettyStringFromDate:(NSDate *)date
{
    NSString * prettyTimestamp;
    
    float delta = [date timeIntervalSinceNow] * -1;
    
    if (delta < 60) {
        prettyTimestamp = @"just now";
    } else if (delta < 120) {
        prettyTimestamp = @"One Min ago";
    } else if (delta < 3600) {
        prettyTimestamp = [NSString stringWithFormat:@"%d Min ago", (int) floor(delta/60.0) ];
    } else if (delta < 7200) {
        prettyTimestamp = @"one hour ago";      
    } else if (delta < 86400) {
        prettyTimestamp = [NSString stringWithFormat:@"%d hours ago", (int) floor(delta/3600.0) ];
    } else if (delta < ( 86400 * 2 ) ) {
        prettyTimestamp = @"one day ago";       
    } else if (delta < ( 86400 * 7 ) ) {
        prettyTimestamp = [NSString stringWithFormat:@"%d days ago", (int) floor(delta/86400.0) ];
    } else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        prettyTimestamp = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];

    }
    
    return prettyTimestamp;
}



#pragma mark- Dictionary Utility Methods
+(NSString *)getKeyForObject:(NSString *)objectValue inDictionary:(NSDictionary *)dictionary{
    
    for(NSString *key in dictionary.allKeys)
        if([[dictionary objectForKey:key]isEqualToString:objectValue])
            return key;
    return nil;
    
}

+(NSData *) dataFromCIImage:(CIImage *)image {
    
    UIImage *img=[self imageFromCIImage:image];
    NSData *data=UIImageJPEGRepresentation(img,0.5);
    return data;
}

+(UIImage *) imageFromCIImage:(CIImage *)image {
    
    CGRect contextRect = [image extent];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    [context drawImage:image inRect:contextRect fromRect:contextRect];
    CGImageRef imageRef = [context createCGImage:image fromRect:contextRect];
    UIImage* rImage = [UIImage imageWithCGImage:imageRef];
    

    context=nil;
    CFRelease(imageRef);
    
    return rImage;
}


CGRect CGRectTransformToRect(CGRect fromRect, CGRect toRect) {
    CGPoint actualOrigin = (CGPoint){fromRect.origin.x * CGRectGetWidth(toRect), fromRect.origin.y * CGRectGetHeight(toRect)};
    CGSize  actualSize   = (CGSize){fromRect.size.width * CGRectGetWidth(toRect), fromRect.size.height * CGRectGetHeight(toRect)};
    return (CGRect){actualOrigin, actualSize};
}


+ (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect {
    NSParameterAssert(image != nil);
    if (CGPointEqualToPoint(CGPointZero, rect.origin) && CGSizeEqualToSize(rect.size, image.size)) {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    [image drawAtPoint:(CGPoint){-rect.origin.x, -rect.origin.y}];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}



+ (UIImage *)imageWithImage:(UIImage *)image cropInRelativeRect:(CGRect)rect {
    NSParameterAssert(image != nil);
    if (CGRectEqualToRect(rect, CGRectMake(0, 0, 1, 1))) {
        return image;
    }
    
    CGRect imageRect = (CGRect){CGPointZero, image.size};
    CGRect actualRect = CGRectTransformToRect(rect, imageRect);
    return [self imageWithImage:image cropInRect:CGRectIntegral(actualRect)];
}


+(UIImage *) cropImage:(UIImage *)image rect:(CGRect)rect {

    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(image.size);
    }
    
    UIRectClip(rect);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+(UIImage *)scaleToResolution:(CGSize)resolution AndRotateImage:(UIImage *)image {
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > resolution.width || height > resolution.height) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = resolution.width;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = resolution.height;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


+(void)generateImageFromVideoUrl:(NSURL *)url
                           block:(void (^)(UIImage *thumbImage))block
{
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    __block AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    
    asset=nil;
    
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
            block(nil);
        }
        block([UIImage imageWithCGImage:im]);
        generator=nil;
    };
    
    CGSize maxSize = CGSizeMake(128,128);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}


+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



+(CGRect)getCenterForChildView:(UIView*)childView fromParentView:(UIView*)parentView{
    CGRect centerRect=CGRectMake
    (
     ( parentView.frame.size.width  / ( CGFloat )2 ) - ( childView.frame.size.width  / ( CGFloat )2 ),
     (( parentView.frame.size.height / ( CGFloat )2 ) - ( childView.frame.size.height / ( CGFloat )2 ))-44,
     childView.frame.size.width,
     childView.frame.size.height
     );


    return centerRect;
}


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/**
 *  This method is used to calculate height of text given which fits in specific width having    font provided
 *
 *  @param text       Text to calculate height of
 *  @param widthValue Width of container
 *  @param font       Font size of text
 *
 *  @return Height required to fit given text in container
 */

+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize+4;
    
    if (text) {
        CGSize size;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            //iOS 7
            CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            size = CGSizeMake(frame.size.width, frame.size.height+1);
        }
        else
        {
            //iOS 6.0
            //CGFloat width = widthValue;
            //CGSize textSize = { width, CGFLOAT_MAX };       //Width and height of text area
            //            size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        result = MAX(size.height, result); //At least one row
    }
    return result;
}



+(UIView *)findSuperViewOfView:(UIView *)view havingClassName:(Class)class {
    
    if(view.superview==nil||[view.superview isKindOfClass:class]) {
        return view.superview;
    }
    else {
        return [UtilityMethods findSuperViewOfView:view.superview
                                   havingClassName:class];
    }
}



#pragma mark string utils

+(NSString *) replaceString:(NSString *)string withRegex:(NSString *)regexString replaceText:(NSString *)rText  {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];

    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:rText];

    
    return modifiedString;
}

@end
