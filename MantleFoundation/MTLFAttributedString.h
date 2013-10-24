//
//  MTLFAttributedString.h
//  Pods
//
//  Created by Zak.
//
//

#import <Mantle/Mantle.h>
#import "NSAttributedString+MantleFoundation.h"

@interface MTLFAttributedString : MTLModel <MTLJSONSerializing>

//@property (weak) NSString *string;
@property (weak) NSAttributedString *attributedString;
//@property (weak) NSMutableArray *attributedRanges;
//@property (strong) NSMutableArray *attributedRanges;

@end
