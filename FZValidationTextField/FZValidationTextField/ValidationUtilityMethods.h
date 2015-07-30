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


@interface ValidationUtilityMethods : NSObject
{
    
}


+(void) showAlertView:(NSString *)title description:(NSString *)description;
+(NSError *) validateFields:(NSArray *)fieldsArray;


@end
