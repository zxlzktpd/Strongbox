//
//  KeePassDatabaseMetadata.m
//  Strongbox
//
//  Created by Mark on 23/10/2018.
//  Copyright © 2018 Mark McGuill. All rights reserved.
//

#import "KeePassDatabaseMetadata.h"
#import "KeePassConstants.h"
#import "BasicOrderedDictionary.h"
#import "KdbxSerializationCommon.h"
#import "KeePassCiphers.h"
#import "NSUUID+Zero.h"
#import "Utils.h"

static NSString* const kDefaultFileVersion = @"3.1";
static const uint32_t kDefaultInnerRandomStreamId = kInnerStreamSalsa20;

@implementation KeePassDatabaseMetadata

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.generator = kStrongboxGenerator;
        self.version = kDefaultFileVersion;
        self.compressionFlags = kGzipCompressionFlag;
        self.transformRounds = kDefaultTransformRounds;
        self.innerRandomStreamId = kDefaultInnerRandomStreamId;
        self.cipherUuid = aesCipherUuid();
        self.historyMaxItems = kDefaultHistoryMaxItems;
        self.historyMaxSize = kDefaultHistoryMaxSize;
        
        self.recycleBinEnabled = YES;
        self.recycleBinGroup = NSUUID.zero;
        self.recycleBinChanged = [NSDate date];
    }
    
    return self;
}

- (BasicOrderedDictionary<NSString*, NSString*>*)kvpForUi {
    BasicOrderedDictionary<NSString*, NSString*>* kvps = [[BasicOrderedDictionary alloc] init];
    
    [kvps addKey:@"Database Format" andValue:@"KeePass 2"];
    [kvps addKey:@"KeePass File Version"  andValue:self.version];
    [kvps addKey:@"Database Generator" andValue:self.generator];
    [kvps addKey:@"Compressed"  andValue:self.compressionFlags == kGzipCompressionFlag ? @"Yes (GZIP)" : @"No"];
    [kvps addKey:@"Transform Rounds" andValue:[NSString stringWithFormat:@"%llu", self.transformRounds]];
    [kvps addKey:@"Outer Encryption" andValue:outerEncryptionAlgorithmString(self.cipherUuid)];
    [kvps addKey:@"Inner Encryption" andValue:innerEncryptionString(self.innerRandomStreamId)];
    [kvps addKey:@"Max History Items" andValue:[NSString stringWithFormat:@"%ld", (long)self.historyMaxItems]];
    
    NSString* size = friendlyFileSizeString(self.historyMaxSize);
    
    [kvps addKey:@"Max History Size" andValue:size];

    [kvps addKey:@"Recycle Bin Enabled" andValue:self.recycleBinEnabled ? @"Yes" : @"No"];
    
//    [kvps addKey:@"Recycle Bin Group" andValue:[self.recycleBinGroup isEqual:NSUUID.zero] ? @"Created on Demand" : [NSString stringWithFormat:@"%@", self.recycleBinGroup]];
//    [kvps addKey:@"Recycle Bin Changed" andValue:[NSString stringWithFormat:@"%@", self.recycleBinChanged]];

    return kvps;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self kvpForUi]];
}

@end
