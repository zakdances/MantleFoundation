//
//  NSAttributedString+MTLFoundation.h
//  Pods
//
//  Created by Zak.
//
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "MTLFAttributedString.h"

@interface NSAttributedString (MantleFoundation)

@property (strong) MTLFAttributedString *model;

+ (NSAttributedString *)attributedStringFromJSON:(NSDictionary *)JSONDictionary error:(NSError **)error;

@end
