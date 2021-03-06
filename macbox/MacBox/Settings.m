//
//  Settings.m
//  MacBox
//
//  Created by Mark on 15/08/2017.
//  Copyright © 2017 Mark McGuill. All rights reserved.
//

#import "Settings.h"

#define kRevealDetailsImmediately @"revealDetailsImmediately"
#define kFullVersion @"fullVersion"
#define kEndFreeTrialDate @"endFreeTrialDate"
#define kAutoLockTimeout @"autoLockTimeout"
#define kPasswordGenerationParameters @"passwordGenerationParameters"
#define kWarnedAboutTouchId @"warnedAboutTouchId"
#define kAlwaysShowPassword @"alwaysShowPassword"
#define kUiDoNotSortKeePassNodesInBrowseView @"uiDoNotSortKeePassNodesInBrowseView"

static NSString* const kAutoFillNewRecordSettings = @"autoFillNewRecordSettings";
static NSString* const kAutoSave = @"autoSave";
static NSString* const kClearClipboardEnabled = @"clearClipboardEnabled";
static NSString* const kClearClipboardAfterSeconds = @"clearClipboardAfterSeconds";
static NSString* const kDoNotShowTotp = @"doNotShowTotp";
static NSString* const kShowRecycleBinInSearchResults = @"showRecycleBinInSearchResults";
static NSString* const kDoNotShowRecycleBinInBrowse = @"doNotShowRecycleBinInBrowse";
static NSString* const kDoNotFloatDetailsWindowOnTop = @"doNotFloatDetailsWindowOnTop";
static NSString* const kNoAlternatingRows = @"noAlternatingRows";
static NSString* const kShowHorizontalGrid = @"showHorizontalGrid";
static NSString* const kShowVerticalGrid = @"showVerticalGrid";
static NSString* const kDoNotShowAutoCompleteSuggestions = @"doNotShowAutoCompleteSuggestions";
static NSString* const kDoNotShowChangeNotifications = @"doNotShowChangeNotifications";
static NSString* const kOutlineViewTitleIsReadonly = @"outlineViewTitleIsReadonly";
static NSString* const kOutlineViewEditableFieldsAreReadonly = @"outlineViewEditableFieldsAreReadonly";
static NSString* const kDereferenceInQuickView = @"dereferenceInQuickView";
static NSString* const kDereferenceInOutlineView = @"dereferenceInOutlineView";
static NSString* const kDereferenceDuringSearch = @"dereferenceDuringSearch";
static NSString* const kAutoReloadAfterForeignChanges = @"autoReloadAfterForeignChanges";
static NSString* const kDetectForeignChanges = @"detectForeignChanges";
static NSString* const kConcealEmptyProtectedFields = @"concealEmptyProtectedFields";
static NSString* const kShowCustomFieldsOnQuickView = @"showCustomFieldsOnQuickView";

static NSString* const kVisibleColumns = @"visibleColumns";
NSString* const kTitleColumn = @"TitleColumn";
NSString* const kUsernameColumn = @"UsernameColumn";
NSString* const kPasswordColumn = @"PasswordColumn";
NSString* const kTOTPColumn = @"TOTPColumn";
NSString* const kURLColumn = @"URLColumn";
NSString* const kEmailColumn = @"EmailColumn";
NSString* const kNotesColumn = @"NotesColumn";
NSString* const kAttachmentsColumn = @"AttachmentsColumn";
NSString* const kCustomFieldsColumn = @"CustomFieldsColumn";

static const NSInteger kDefaultClearClipboardTimeout = 60;

@implementation Settings

+ (instancetype)sharedInstance {
    static Settings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Settings alloc] init];
    });
    return sharedInstance;
}

+ (NSArray<NSString*> *)kDefaultVisibleColumns
{
    static NSArray *_arr;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _arr = @[kTitleColumn, kUsernameColumn, kPasswordColumn, kURLColumn];
    });
    
    return _arr;
}

+ (NSArray<NSString*> *)kAllColumns
{
    static NSArray *_arr;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _arr = @[kTitleColumn, kUsernameColumn, kPasswordColumn, kTOTPColumn, kURLColumn, kEmailColumn, kNotesColumn, kAttachmentsColumn, kCustomFieldsColumn];
    });
    
    return _arr;
}

- (BOOL)getBool:(NSString*)key {
    return [self getBool:key fallback:NO];
}

- (BOOL)getBool:(NSString*)key fallback:(BOOL)fallback {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber* obj = [userDefaults objectForKey:key];
    
    return obj != nil ? obj.boolValue : fallback;
}

- (void)setBool:(NSString*)key value:(BOOL)value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:value forKey:key];
    
    [userDefaults synchronize];
}

- (BOOL)revealDetailsImmediately {
    return [self getBool:kRevealDetailsImmediately];
}

- (void)setRevealDetailsImmediately:(BOOL)value {
    [self setBool:kRevealDetailsImmediately value:value];
}

- (BOOL)warnedAboutTouchId {
    return [self getBool:kWarnedAboutTouchId];
}

- (void)setWarnedAboutTouchId:(BOOL)warnedAboutTouchId {
    [self setBool:kWarnedAboutTouchId value:warnedAboutTouchId];
}

- (BOOL)fullVersion {
    return [self getBool:kFullVersion];
}

- (void)setFullVersion:(BOOL)value {
    [self setBool:kFullVersion value:value];
}

- (BOOL)alwaysShowPassword {
    return [self getBool:kAlwaysShowPassword];
}

-(void)setAlwaysShowPassword:(BOOL)alwaysShowPassword {
    [self setBool:kAlwaysShowPassword value:alwaysShowPassword];
}

- (BOOL)freeTrial {
    NSDate* date = self.endFreeTrialDate;
    
    if(date == nil) {
        return YES;
    }
    
    return !([date timeIntervalSinceNow] < 0);
}

- (NSInteger)freeTrialDaysRemaining {
    NSDate* date = self.endFreeTrialDate;
    
    if(date == nil) {
        return -1;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay
                                                fromDate:[NSDate date]
                                                  toDate:date
                                                 options:0];
    
    NSInteger days = [components day];
    
    return days;
}

- (NSDate*)endFreeTrialDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults objectForKey:kEndFreeTrialDate];
}

- (void)setEndFreeTrialDate:(NSDate *)endFreeTrialDate {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:endFreeTrialDate forKey:kEndFreeTrialDate];
    
    [userDefaults synchronize];
}

- (NSInteger)autoLockTimeoutSeconds {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:kAutoLockTimeout];
}

- (void)setAutoLockTimeoutSeconds:(NSInteger)autoLockTimeoutSeconds {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:autoLockTimeoutSeconds forKey:kAutoLockTimeout];
    
    [userDefaults synchronize];
}

- (PasswordGenerationParameters *)passwordGenerationParameters {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:kPasswordGenerationParameters];
    
    if(encodedObject == nil) {
        return [[PasswordGenerationParameters alloc] initWithDefaults];
    }
    
    PasswordGenerationParameters *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

-(void)setPasswordGenerationParameters:(PasswordGenerationParameters *)passwordGenerationParameters {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:passwordGenerationParameters];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:kPasswordGenerationParameters];
    [defaults synchronize];
}

- (AutoFillNewRecordSettings*)autoFillNewRecordSettings {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAutoFillNewRecordSettings];
    
    if(data) {
        return (AutoFillNewRecordSettings *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return AutoFillNewRecordSettings.defaults;
}

- (void)setAutoFillNewRecordSettings:(AutoFillNewRecordSettings *)autoFillNewRecordSettings {
    NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:autoFillNewRecordSettings];
    
    [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:kAutoFillNewRecordSettings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)autoSave {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSObject* autoSave = [userDefaults objectForKey:kAutoSave];

    BOOL ret = TRUE;
    if(!autoSave) {
        NSLog(@"No Autosave settings... defaulting to Yes");
    }
    else {
        NSNumber* num = (NSNumber*)autoSave;
        ret = num.boolValue;
    }

    return ret;
}

-(void)setAutoSave:(BOOL)autoSave {
    [self setBool:kAutoSave value:autoSave];
}

- (BOOL)uiDoNotSortKeePassNodesInBrowseView {
    return [self getBool:kUiDoNotSortKeePassNodesInBrowseView];
}

- (void)setUiDoNotSortKeePassNodesInBrowseView:(BOOL)uiDoNotSortKeePassNodesInBrowseView {
    [self setBool:kUiDoNotSortKeePassNodesInBrowseView value:uiDoNotSortKeePassNodesInBrowseView];
}

- (BOOL)clearClipboardEnabled {
    return [self getBool:kClearClipboardEnabled];
}

- (void)setClearClipboardEnabled:(BOOL)clearClipboardEnabled {
    [self setBool:kClearClipboardEnabled value:clearClipboardEnabled];
}

- (NSInteger)clearClipboardAfterSeconds {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger ret = [userDefaults integerForKey:kClearClipboardAfterSeconds];

    return ret == 0 ? kDefaultClearClipboardTimeout : ret;
}


- (void)setClearClipboardAfterSeconds:(NSInteger)clearClipboardAfterSeconds {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:clearClipboardAfterSeconds forKey:kClearClipboardAfterSeconds];
    
    [userDefaults synchronize];
}

- (BOOL)doNotShowTotp {
    return [self getBool:kDoNotShowTotp];
}

- (void)setDoNotShowTotp:(BOOL)doNotShowTotp {
    [self setBool:kDoNotShowTotp value:doNotShowTotp];
}

- (BOOL)showRecycleBinInSearchResults {
    return [self getBool:kShowRecycleBinInSearchResults];
}

- (void)setShowRecycleBinInSearchResults:(BOOL)showRecycleBinInSearchResults {
    [self setBool:kShowRecycleBinInSearchResults value:showRecycleBinInSearchResults];
}

- (BOOL)doNotShowRecycleBinInBrowse {
    return [self getBool:kDoNotShowRecycleBinInBrowse];
}

- (void)setDoNotShowRecycleBinInBrowse:(BOOL)doNotShowRecycleBinInBrowse {
    [self setBool:kDoNotShowRecycleBinInBrowse value:doNotShowRecycleBinInBrowse];
}

- (BOOL)doNotFloatDetailsWindowOnTop {
    return [self getBool:kDoNotFloatDetailsWindowOnTop];
}

- (void)setDoNotFloatDetailsWindowOnTop:(BOOL)doNotFloatDetailsWindowOnTop {
    [self setBool:kDoNotFloatDetailsWindowOnTop value:doNotFloatDetailsWindowOnTop];
}

- (BOOL)noAlternatingRows {
    return [self getBool:kNoAlternatingRows];
}

- (void)setNoAlternatingRows:(BOOL)noAlternatingRows {
    [self setBool:kNoAlternatingRows value:noAlternatingRows];
}

- (BOOL)showHorizontalGrid {
    return [self getBool:kShowHorizontalGrid];
}

- (void)setShowHorizontalGrid:(BOOL)showHorizontalGrid {
    [self setBool:kShowHorizontalGrid value:showHorizontalGrid];
}

- (BOOL)showVerticalGrid {
    return [self getBool:kShowVerticalGrid];
}

- (void)setShowVerticalGrid:(BOOL)showVerticalGrid {
    [self setBool:kShowVerticalGrid value:showVerticalGrid];
}

- (BOOL)doNotShowAutoCompleteSuggestions {
    return [self getBool:kDoNotShowAutoCompleteSuggestions];
}

- (void)setDoNotShowAutoCompleteSuggestions:(BOOL)doNotShowAutoCompleteSuggestions {
    [self setBool:kDoNotShowAutoCompleteSuggestions value:doNotShowAutoCompleteSuggestions];
}

- (BOOL)doNotShowChangeNotifications {
    return [self getBool:kDoNotShowChangeNotifications];
}

- (void)setDoNotShowChangeNotifications:(BOOL)doNotShowChangeNotifications {
    [self setBool:kDoNotShowChangeNotifications value:doNotShowChangeNotifications];
}

- (NSString *)easyReadFontName {
    return @"Menlo";
}

- (NSArray<NSString *> *)visibleColumns {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray<NSString*>* ret = [userDefaults objectForKey:kVisibleColumns];
    
    return ret ? ret : [Settings kDefaultVisibleColumns];
}

- (void)setVisibleColumns:(NSArray<NSString *> *)visibleColumns {
    if(!visibleColumns || !visibleColumns.count) {
        visibleColumns = [Settings kDefaultVisibleColumns];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:visibleColumns forKey:kVisibleColumns];
    [userDefaults synchronize];
}

- (BOOL)outlineViewTitleIsReadonly {
    return [self getBool:kOutlineViewTitleIsReadonly];
}

- (void)setOutlineViewTitleIsReadonly:(BOOL)outlineViewTitleIsReadonly {
    [self setBool:kOutlineViewTitleIsReadonly value:outlineViewTitleIsReadonly];
}

- (BOOL)outlineViewEditableFieldsAreReadonly {
    return [self getBool:kOutlineViewEditableFieldsAreReadonly];
}

- (void)setOutlineViewEditableFieldsAreReadonly:(BOOL)outlineViewEditableFieldsAreReadonly {
    [self setBool:kOutlineViewEditableFieldsAreReadonly value:outlineViewEditableFieldsAreReadonly];
}

- (BOOL)dereferenceInQuickView {
    return [self getBool:kDereferenceInQuickView fallback:YES];
}

- (void)setDereferenceInQuickView:(BOOL)dereferenceInQuickView {
    [self setBool:kDereferenceInQuickView value:dereferenceInQuickView];
}

- (BOOL)dereferenceInOutlineView {
    return [self getBool:kDereferenceInOutlineView fallback:YES];
}

- (void)setDereferenceInOutlineView:(BOOL)dereferenceInOutlineView {
    [self setBool:kDereferenceInOutlineView value:dereferenceInOutlineView];
}

- (BOOL)dereferenceDuringSearch {
    return [self getBool:kDereferenceDuringSearch fallback:NO];
}

- (void)setDereferenceDuringSearch:(BOOL)dereferenceDuringSearch {
    [self setBool:kDereferenceDuringSearch value:dereferenceDuringSearch];
}

- (BOOL)autoReloadAfterForeignChanges {
    return [self getBool:kAutoReloadAfterForeignChanges fallback:NO];
}

- (void)setAutoReloadAfterForeignChanges:(BOOL)autoReloadAfterForeignChanges {
    [self setBool:kAutoReloadAfterForeignChanges value:autoReloadAfterForeignChanges];
}

- (BOOL)detectForeignChanges {
    return [self getBool:kDetectForeignChanges fallback:YES];
}

-(void)setDetectForeignChanges:(BOOL)detectForeignChanges {
    [self setBool:kDetectForeignChanges value:detectForeignChanges];
}

- (BOOL)concealEmptyProtectedFields {
    return [self getBool:kConcealEmptyProtectedFields fallback:YES];
}

- (void)setConcealEmptyProtectedFields:(BOOL)concealEmptyProtectedFields {
    NSLog(@"Setting: %d", concealEmptyProtectedFields);
    [self setBool:kConcealEmptyProtectedFields value:concealEmptyProtectedFields];
}

- (BOOL)showCustomFieldsOnQuickViewPanel {
    return [self getBool:kShowCustomFieldsOnQuickView fallback:YES];
}

- (void)setShowCustomFieldsOnQuickViewPanel:(BOOL)showCustomFieldsOnQuickViewPanel {
    return [self setBool:kShowCustomFieldsOnQuickView value:showCustomFieldsOnQuickViewPanel];
}

@end
