//
//  MTLFAttributedString.h
//  Pods
//
//  Created by Zak.
//
//

#import <Mantle/Mantle.h>

@interface MTLFAttributedString : MTLModel <MTLJSONSerializing>

//@property (weak) NSString *string;
@property (strong) NSAttributedString *attributedString;
//@property (weak) NSMutableArray *attributedRanges;
//@property (strong) NSMutableArray *attributedRanges;

@end
