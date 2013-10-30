//
//  MTLFAttributedString.m
//  Pods
//
//  Created by Zak.
//
//

#import "MTLFAttributedString.h"
//#import "NSAttributedString+MantleFoundation.h"

@implementation MTLFAttributedString

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
			 @"attributedString": @"attributedString"
			 };
}



//+ (NSValueTransformer *)stringJSONTransformer {
//
//
//	
//	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *string) {
//        return string;
//    } reverseBlock:^(NSString *string) {
//        return string;
//    }];
//	
//
//}

+ (NSValueTransformer *)attributedStringJSONTransformer
{

	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *data) {

		NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:data[@"string"]];
		
		for (NSDictionary *attRange in data[@"attributedRanges"]) {
			
			NSDictionary *attributes = attRange[@"attributes"];
			
			if (attributes.count > 0) {
				
				attributes = [self stringAttributesFromDictionary:attributes];
				NSRange range = NSMakeRange([attRange[@"location"] unsignedIntegerValue], [attRange[@"length"] unsignedIntegerValue]);
				[attString addAttributes:attributes range:range];
			}
		}
		
//		NSAttributedString *attributedString = attString.copy;
        return attString.copy;
		
    } reverseBlock:^(NSAttributedString *attributedString) {
		NSLog(@"reverse block called");
		NSMutableArray *attributedRanges = [NSMutableArray array];
		
		[attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length)
												  options:0
										   usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
			   
			   NSDictionary *attrRange = @{ @"location"	: @(range.location),
												   @"length"		: @(range.length),
												   @"attributes"	: [self stringAttributesToDictionary:attrs] };
			   
			   
			   [attributedRanges addObject:attrRange];
		}];
		
        return @{ @"string": attributedString.string,
				  @"attributedRanges": attributedRanges };
    }];
}




+ (NSDictionary *)stringAttributesToDictionary:(NSDictionary *)dictionary
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	for (id key in dictionary) {
		id val = dictionary[key];
		
		if ([val isKindOfClass:NSColor.class]) {
			
			val = [self colorToDictionary:val];
		}
		else if ([val isKindOfClass:NSShadow.class]) {
			
			val = [self shadowToDictionary:val];
			
		}
		else if ([val isKindOfClass:NSFont.class]) {
			
			val = [self fontToDictionary:val];
			
		}
		else if ([val isKindOfClass:NSParagraphStyle.class]) {
			
			val = [self paragraphStyleToDictionary:val];
		}
		
		attributes[key] = val;
	}
	
	return attributes.copy;
	
}

+ (NSDictionary *)stringAttributesFromDictionary:(NSDictionary *)dictionary
{
	NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
	
	for (id _key in dictionary) {
		id key = _key;
		id val = dictionary[key];
		//			NSString *type = val[@"type"];
		
		if ( [key isEqualToString:NSForegroundColorAttributeName] ||
			 [key isEqualToString:@"color"] ) {
			key = NSForegroundColorAttributeName;
			val = [self colorFromDictionary:val];
		}
		
		else if ( [key isEqualToString:NSShadowAttributeName] ) {
			val = [self shadowFromDictionary:val];
		}
		
		else if ( [key isEqualToString:NSFontAttributeName] ) {
			val = [self fontFromDictionary:val];
		}
		
		else if ( [key isEqualToString:NSParagraphStyleAttributeName] ) {
			val = [self paragraphStyleFromDictionary:val];
		}
		
		attributes[key] = val;
	}
	
	return attributes.copy;
	
}

+ (CGSize)sizeFromDictionary:(NSDictionary *)dictionary
{
	return NSMakeSize([dictionary[@"width"] floatValue], [dictionary[@"height"] floatValue]);
}

+ (NSDictionary *)sizeToDictionary:(CGSize)size
{
	return @{ @"width": @(size.width),
			  @"height": @(size.height)};
}

+ (NSFont *)fontFromDictionary:(NSDictionary *)dictionary
{
	NSFontDescriptor *descriptor = [self fontDescriptorFromDictionary:dictionary[@"fontDescriptor"]];
	NSFont *font = [NSFont fontWithDescriptor:descriptor size:0];
	return font;
}

+ (NSDictionary *)fontToDictionary:(NSFont *)font
{
	NSDictionary *dictionary = @{ @"name": font.fontName,
								  @"fontDescriptor": [self fontDescriptorToDictionary:font.fontDescriptor] };
	return dictionary;
}

+ (NSFontDescriptor *)fontDescriptorFromDictionary:(NSDictionary *)dictionary
{
	NSFontDescriptor *descriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:dictionary];
	return descriptor;
}

+ (NSDictionary *)fontDescriptorToDictionary:(NSFontDescriptor *)fontDescriptor
{
	NSDictionary *dictionary = fontDescriptor.fontAttributes;
	return dictionary;
}

+ (NSColor *)colorFromDictionary:(NSDictionary *)dictionary
{
	NSDictionary *d = dictionary;
	CGFloat a = d[@"a"] ? [d[@"a"] floatValue] : 1;

	NSColor *color = [NSColor colorWithCalibratedRed:[d[@"r"] floatValue]/255.0f
											   green:[d[@"g"] floatValue]/255.0f
												blue:[d[@"b"] floatValue]/255.0f
											   alpha:a];
	return color;
}

+ (NSDictionary *)colorToDictionary:(NSColor *)color
{
	return @{ @"r": @(color.redComponent),
			  @"g": @(color.greenComponent),
			  @"b": @(color.blueComponent),
			  @"a": @(color.alphaComponent)};
}

+ (NSParagraphStyle *)paragraphStyleFromDictionary:(NSDictionary *)dictionary
{
	NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
	paragraphStyle.lineSpacing				= [dictionary[@"lineSpacing"] floatValue];
	paragraphStyle.paragraphSpacing			= [dictionary[@"paragraphSpacing"] floatValue];
	paragraphStyle.alignment				= [dictionary[@"alignment"] unsignedIntegerValue];
	paragraphStyle.lineBreakMode			= [dictionary[@"lineBreakMode"] unsignedIntegerValue];
	return paragraphStyle.copy;
}

+ (NSDictionary *)paragraphStyleToDictionary:(NSParagraphStyle *)paragraphStyle
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	dictionary[@"lineSpacing"]		= @(paragraphStyle.lineSpacing);
	dictionary[@"paragraphSpacing"]	= @(paragraphStyle.paragraphSpacing);
	dictionary[@"alignment"]		= @(paragraphStyle.alignment);
	dictionary[@"lineBreakMode"]	= @(paragraphStyle.lineBreakMode);
	
	return dictionary.copy;
}


+ (NSShadow *)shadowFromDictionary:(NSDictionary *)dictionary
{
	NSShadow *shadow = [NSShadow new];
	shadow.shadowBlurRadius = [dictionary[@"shadowBlurRadius"] floatValue];
	shadow.shadowOffset		= [self sizeFromDictionary:dictionary[@"shadowOffset"]];
	shadow.shadowColor		= [self colorFromDictionary:dictionary[@"shadowColor"]];
	
	return shadow;
}

+ (NSDictionary *)shadowToDictionary:(NSShadow *)shadow
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	dictionary[@"shadowBlurRadius"] = @(shadow.shadowBlurRadius);
	dictionary[@"shadowOffset"]		= [self sizeToDictionary:shadow.shadowOffset];
	dictionary[@"shadowColor"]		= [self colorToDictionary:shadow.shadowColor];
	
	return dictionary.copy;
}
@end
