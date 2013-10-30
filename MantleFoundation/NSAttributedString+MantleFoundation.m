//
//  NSAttributedString+MTLFoundation.m
//  Pods
//
//  Created by Zak.
//
//

#import "NSAttributedString+MantleFoundation.h"
#import <objc/objc-runtime.h>

@interface NSAttributedString ()

@property (strong) MTLFAttributedString *model;

@end

static const char modelKey;

@implementation NSAttributedString (MantleFoundation)

+ (NSAttributedString *)attributedStringFromJSON:(NSDictionary *)JSONDictionary error:(NSError **)error
{
//	NSLog(@"data: %@", JSONDictionary);
//	JSONDictionary = @{@"attributedString": @{@"string": @"lulu",
//											  @"attributedRanges": @[]}
//					   };
	
//	NSError *error2;
	MTLFAttributedString *model = [MTLJSONAdapter modelOfClass:MTLFAttributedString.class fromJSONDictionary:JSONDictionary error:error];
//	if (error2) {
//		NSLog(@"%@", error2);
//	}
//	NSLog(@"model: %@", model);
	NSAttributedString *string = model.attributedString;
//	string.model = model;

	return string;
}

- (MTLFAttributedString *)model
{
	MTLFAttributedString *model = (MTLFAttributedString *)objc_getAssociatedObject(self, &modelKey);
	if (!model) {
		model = [MTLFAttributedString new];
		model.attributedString = self;
		self.model = model;
	}
	return model;
}

- (void)setModel:(MTLFAttributedString *)model
{
	objc_setAssociatedObject(self,
							 &modelKey,
							 model,
							 OBJC_ASSOCIATION_RETAIN);
}

@end
