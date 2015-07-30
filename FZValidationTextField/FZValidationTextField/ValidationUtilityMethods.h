//
//  UtilityMethods.h
//  FlashPhrase
//
//  Created by Faheem Ziker on 11/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#define REGEX_URL @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"

@interface UtilityMethods : NSObject
{
    
}


+(NSString *) shortStringFromDate:(NSDate *)date;
+(NSString *) stringFromDate:(NSDate *)date format:(NSString *)format;
+(NSDate *) dateFromString:(NSString *)dateString format:(NSString *)format;
+(NSDate *) dateFromString:(NSString *)dateString;
+(NSDate *) dateFromTimeStamp:(double )timeStamp;
+(NSString *)prettyStringFromDate:(NSDate *)date;
+ (BOOL)validateEmailWithString:(NSString*)email;
+(NSString *) sentenceCaps:(NSString *)string;
+(NSString *) stringFromDate:(NSDate *)date;

+(void) showAlertView:(NSString *)title description:(NSString *)description;
+(NSError *) validateFields:(NSArray *)fieldsArray;



#pragma mark- Dictionary Utility Methods
+(NSString *)getKeyForObject:(NSString *)objectValue
                inDictionary:(NSDictionary *)dictionary;


+(UIImage *) cropImage:(UIImage *)image rect:(CGRect)rect;
+ (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect;
+ (UIImage *)imageWithImage:(UIImage *)image cropInRelativeRect:(CGRect)rect;

+(UIImage *)scaleToResolution:(CGSize)resolution AndRotateImage:(UIImage *)image;

+(void)generateImageFromVideoUrl:(NSURL *)url
                           block:(void (^)(UIImage *thumbImage))block;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;

+(CGRect)getCenterForChildView:(UIView*)childView fromParentView:(UIView*)parentView;
+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

+(UIView *)findSuperViewOfView:(UIView *)view havingClassName:(Class)class;


#pragma mark string utils

+(NSString *) replaceString:(NSString *)string withRegex:(NSString *)regexString replaceText:(NSString *)rText;
@end
