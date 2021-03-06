//
//  Kdb1Database.h
//  Strongbox
//
//  Created by Mark on 08/11/2018.
//  Copyright © 2018 Mark McGuill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractDatabaseFormatAdaptor.h"
#import "Kdb1DatabaseMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface Kdb1Database : NSObject<AbstractDatabaseFormatAdaptor>

+ (BOOL)isAValidSafe:(nullable NSData *)candidate error:(NSError**)error;
+ (NSString *)fileExtension;

- (StrongboxDatabase *)create:(nullable NSString *)password keyFileDigest:(nullable NSData *)keyFileDigest;
- (nullable StrongboxDatabase*)open:(NSData*)data password:(NSString *)password error:(NSError **)error;
- (nullable StrongboxDatabase*)open:(NSData*)data password:(nullable NSString *)password keyFileDigest:(nullable NSData *)keyFileDigest error:(NSError **)error;
- (nullable NSData*)save:(StrongboxDatabase*)database error:(NSError**)error;

@property (nonatomic, readonly) DatabaseFormat format;
@property (nonatomic, readonly) NSString* fileExtension;

@end

NS_ASSUME_NONNULL_END
