#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

@class TrackingplanSharedCacheStorage, TrackingplanSharedIngestConfigCacheCompanion, TrackingplanSharedTrackingplanIngestConfig, TrackingplanSharedKeyValueStoreCompanion, TrackingplanSharedKeyValueStore, TrackingplanSharedKotlinEnumCompanion, TrackingplanSharedKotlinEnum<E>, TrackingplanSharedLogLevel, TrackingplanSharedKotlinArray<T>, TrackingplanSharedKotlinx_serialization_jsonJsonElement, TrackingplanSharedSamplingOptionsCompanion, TrackingplanSharedSamplingOptions, TrackingplanSharedServiceLocator, TrackingplanSharedStorageCompanion, TrackingplanSharedTrackingplanSession, TrackingplanSharedIngestConfigCache, TrackingplanSharedStorage, TrackingplanSharedTestLoggerLogMessage, TrackingplanSharedTimeProviderCompanion, TrackingplanSharedTrackingplanConfigCompanion, TrackingplanSharedTrackingplanConfig, TrackingplanSharedTrackingplanConfigBuilder, TrackingplanSharedKotlinRandom, TrackingplanSharedTrackingplanIngestConfigCompanion, TrackingplanSharedTrackingplanIngestConfigParser, TrackingplanSharedTrackingplanSessionCompanion, TrackingplanSharedSamplingResult, TrackingplanSharedRequest, TrackingplanSharedAdaptiveSamplingPattern, TrackingplanSharedUrlMatcher, TrackingplanSharedAdaptiveSamplingEvaluator, TrackingplanSharedAdaptiveSamplingMatcher, TrackingplanSharedMatchResult, TrackingplanSharedMatchCondition, TrackingplanSharedAdaptiveSamplingPatternCompanion, TrackingplanSharedAdaptiveSamplingPatternParser, TrackingplanSharedDropReason, TrackingplanSharedMatchConditionCompanion, TrackingplanSharedMatchConditionAndCompanion, TrackingplanSharedMatchConditionAnd, TrackingplanSharedMatchValue, TrackingplanSharedMatchConditionFieldsCompanion, TrackingplanSharedMatchConditionFields, TrackingplanSharedMatchConditionNotCompanion, TrackingplanSharedMatchConditionNot, TrackingplanSharedMatchConditionOrCompanion, TrackingplanSharedMatchConditionOr, TrackingplanSharedMatchValueCompanion, TrackingplanSharedMatchValueMultipleCompanion, TrackingplanSharedMatchValueMultiple, TrackingplanSharedMatchValueSingleCompanion, TrackingplanSharedMatchValueSingle, TrackingplanSharedPayloadFlattener, TrackingplanSharedRequestDataExtractor, TrackingplanSharedKotlinPair<__covariant A, __covariant B>, TrackingplanSharedSamplingMode, TrackingplanSharedSamplingResultDrop, TrackingplanSharedSamplingResultInclude, TrackingplanSharedSpecialKeys, TrackingplanSharedKotlinThrowable, TrackingplanSharedKotlinx_serialization_jsonJsonElementCompanion, TrackingplanSharedKotlinException, TrackingplanSharedKotlinRuntimeException, TrackingplanSharedKotlinRandomDefault, TrackingplanSharedKotlinByteArray, TrackingplanSharedKotlinx_serialization_coreSerializersModule, TrackingplanSharedKotlinx_serialization_coreSerialKind, TrackingplanSharedKotlinNothing, TrackingplanSharedKotlinByteIterator;

@protocol TrackingplanSharedKotlinComparable, TrackingplanSharedLogger, TrackingplanSharedKotlinx_serialization_coreKSerializer, TrackingplanSharedTimeProvider, TrackingplanSharedKotlinIterator, TrackingplanSharedKotlinx_serialization_coreEncoder, TrackingplanSharedKotlinx_serialization_coreSerialDescriptor, TrackingplanSharedKotlinx_serialization_coreSerializationStrategy, TrackingplanSharedKotlinx_serialization_coreDecoder, TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy, TrackingplanSharedKotlinx_serialization_coreCompositeEncoder, TrackingplanSharedKotlinAnnotation, TrackingplanSharedKotlinx_serialization_coreCompositeDecoder, TrackingplanSharedKotlinx_serialization_coreSerializersModuleCollector, TrackingplanSharedKotlinKClass, TrackingplanSharedKotlinKDeclarationContainer, TrackingplanSharedKotlinKAnnotatedElement, TrackingplanSharedKotlinKClassifier;

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-warning-option"
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wnullability"

#pragma push_macro("_Nullable_result")
#if !__has_feature(nullability_nullable_result)
#undef _Nullable_result
#define _Nullable_result _Nullable
#endif

__attribute__((swift_name("KotlinBase")))
@interface TrackingplanSharedBase : NSObject
- (instancetype)init __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
+ (void)initialize __attribute__((objc_requires_super));
@end

@interface TrackingplanSharedBase (TrackingplanSharedBaseCopying) <NSCopying>
@end

__attribute__((swift_name("KotlinMutableSet")))
@interface TrackingplanSharedMutableSet<ObjectType> : NSMutableSet<ObjectType>
@end

__attribute__((swift_name("KotlinMutableDictionary")))
@interface TrackingplanSharedMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>
@end

@interface NSError (NSErrorTrackingplanSharedKotlinException)
@property (readonly) id _Nullable kotlinException;
@end

__attribute__((swift_name("KotlinNumber")))
@interface TrackingplanSharedNumber : NSNumber
- (instancetype)initWithChar:(char)value __attribute__((unavailable));
- (instancetype)initWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
- (instancetype)initWithShort:(short)value __attribute__((unavailable));
- (instancetype)initWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
- (instancetype)initWithInt:(int)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
- (instancetype)initWithLong:(long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
- (instancetype)initWithLongLong:(long long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
- (instancetype)initWithFloat:(float)value __attribute__((unavailable));
- (instancetype)initWithDouble:(double)value __attribute__((unavailable));
- (instancetype)initWithBool:(BOOL)value __attribute__((unavailable));
- (instancetype)initWithInteger:(NSInteger)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
+ (instancetype)numberWithChar:(char)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
+ (instancetype)numberWithShort:(short)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
+ (instancetype)numberWithInt:(int)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
+ (instancetype)numberWithLong:(long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
+ (instancetype)numberWithLongLong:(long long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
+ (instancetype)numberWithFloat:(float)value __attribute__((unavailable));
+ (instancetype)numberWithDouble:(double)value __attribute__((unavailable));
+ (instancetype)numberWithBool:(BOOL)value __attribute__((unavailable));
+ (instancetype)numberWithInteger:(NSInteger)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
@end

__attribute__((swift_name("KotlinByte")))
@interface TrackingplanSharedByte : TrackingplanSharedNumber
- (instancetype)initWithChar:(char)value;
+ (instancetype)numberWithChar:(char)value;
@end

__attribute__((swift_name("KotlinUByte")))
@interface TrackingplanSharedUByte : TrackingplanSharedNumber
- (instancetype)initWithUnsignedChar:(unsigned char)value;
+ (instancetype)numberWithUnsignedChar:(unsigned char)value;
@end

__attribute__((swift_name("KotlinShort")))
@interface TrackingplanSharedShort : TrackingplanSharedNumber
- (instancetype)initWithShort:(short)value;
+ (instancetype)numberWithShort:(short)value;
@end

__attribute__((swift_name("KotlinUShort")))
@interface TrackingplanSharedUShort : TrackingplanSharedNumber
- (instancetype)initWithUnsignedShort:(unsigned short)value;
+ (instancetype)numberWithUnsignedShort:(unsigned short)value;
@end

__attribute__((swift_name("KotlinInt")))
@interface TrackingplanSharedInt : TrackingplanSharedNumber
- (instancetype)initWithInt:(int)value;
+ (instancetype)numberWithInt:(int)value;
@end

__attribute__((swift_name("KotlinUInt")))
@interface TrackingplanSharedUInt : TrackingplanSharedNumber
- (instancetype)initWithUnsignedInt:(unsigned int)value;
+ (instancetype)numberWithUnsignedInt:(unsigned int)value;
@end

__attribute__((swift_name("KotlinLong")))
@interface TrackingplanSharedLong : TrackingplanSharedNumber
- (instancetype)initWithLongLong:(long long)value;
+ (instancetype)numberWithLongLong:(long long)value;
@end

__attribute__((swift_name("KotlinULong")))
@interface TrackingplanSharedULong : TrackingplanSharedNumber
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value;
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value;
@end

__attribute__((swift_name("KotlinFloat")))
@interface TrackingplanSharedFloat : TrackingplanSharedNumber
- (instancetype)initWithFloat:(float)value;
+ (instancetype)numberWithFloat:(float)value;
@end

__attribute__((swift_name("KotlinDouble")))
@interface TrackingplanSharedDouble : TrackingplanSharedNumber
- (instancetype)initWithDouble:(double)value;
+ (instancetype)numberWithDouble:(double)value;
@end

__attribute__((swift_name("KotlinBoolean")))
@interface TrackingplanSharedBoolean : TrackingplanSharedNumber
- (instancetype)initWithBool:(BOOL)value;
+ (instancetype)numberWithBool:(BOOL)value;
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("CacheStorage")))
@interface TrackingplanSharedCacheStorage : TrackingplanSharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (BOOL)clearFilename:(NSString *)filename error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("clear(filename:)")));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (int64_t)getTimestampFilename:(NSString *)filename error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("getTimestamp(filename:)"))) __attribute__((swift_error(nonnull_error)));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (NSString * _Nullable)loadIfValidFilename:(NSString *)filename maxAgeMs:(int64_t)maxAgeMs error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("loadIfValid(filename:maxAgeMs:)"))) __attribute__((swift_error(nonnull_error)));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (BOOL)saveFilename:(NSString *)filename content:(NSString *)content error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("save(filename:content:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IngestConfigCache")))
@interface TrackingplanSharedIngestConfigCache : TrackingplanSharedBase
- (instancetype)initWithCacheStorage:(TrackingplanSharedCacheStorage *)cacheStorage tpId:(NSString *)tpId __attribute__((swift_name("init(cacheStorage:tpId:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedIngestConfigCacheCompanion *companion __attribute__((swift_name("companion")));
- (void)clear __attribute__((swift_name("clear()")));
- (int64_t)getDownloadedAt __attribute__((swift_name("getDownloadedAt()")));
- (BOOL)hasExpired __attribute__((swift_name("hasExpired()")));
- (TrackingplanSharedTrackingplanIngestConfig * _Nullable)loadIfValid __attribute__((swift_name("loadIfValid()")));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (BOOL)saveJsonContent:(NSString *)jsonContent error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("save(jsonContent:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("IngestConfigCache.Companion")))
@interface TrackingplanSharedIngestConfigCacheCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedIngestConfigCacheCompanion *shared __attribute__((swift_name("shared")));
@property (readonly) int64_t CONFIG_MAX_AGE_MS __attribute__((swift_name("CONFIG_MAX_AGE_MS")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KeyValueStore")))
@interface TrackingplanSharedKeyValueStore : TrackingplanSharedBase
@property (class, readonly, getter=companion) TrackingplanSharedKeyValueStoreCompanion *companion __attribute__((swift_name("companion")));
- (void)clear __attribute__((swift_name("clear()")));
- (BOOL)containsKey:(NSString *)key __attribute__((swift_name("contains(key:)")));
- (BOOL)getBooleanKey:(NSString *)key defaultValue:(BOOL)defaultValue __attribute__((swift_name("getBoolean(key:defaultValue:)")));
- (float)getFloatKey:(NSString *)key defaultValue:(float)defaultValue __attribute__((swift_name("getFloat(key:defaultValue:)")));
- (int32_t)getIntKey:(NSString *)key defaultValue:(int32_t)defaultValue __attribute__((swift_name("getInt(key:defaultValue:)")));
- (int64_t)getLongKey:(NSString *)key defaultValue:(int64_t)defaultValue __attribute__((swift_name("getLong(key:defaultValue:)")));
- (NSString * _Nullable)getStringKey:(NSString *)key defaultValue:(NSString * _Nullable)defaultValue __attribute__((swift_name("getString(key:defaultValue:)")));
- (void)removeKey:(NSString *)key __attribute__((swift_name("remove(key:)")));
- (void)setBooleanKey:(NSString *)key value:(BOOL)value __attribute__((swift_name("setBoolean(key:value:)")));
- (void)setFloatKey:(NSString *)key value:(float)value __attribute__((swift_name("setFloat(key:value:)")));
- (void)setIntKey:(NSString *)key value:(int32_t)value __attribute__((swift_name("setInt(key:value:)")));
- (void)setLongKey:(NSString *)key value:(int64_t)value __attribute__((swift_name("setLong(key:value:)")));
- (void)setStringKey:(NSString *)key value:(NSString *)value __attribute__((swift_name("setString(key:value:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KeyValueStore.Companion")))
@interface TrackingplanSharedKeyValueStoreCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedKeyValueStoreCompanion *shared __attribute__((swift_name("shared")));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (TrackingplanSharedKeyValueStore * _Nullable)createName:(NSString *)name error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("create(name:)")));
@end

__attribute__((swift_name("KotlinComparable")))
@protocol TrackingplanSharedKotlinComparable
@required
- (int32_t)compareToOther:(id _Nullable)other __attribute__((swift_name("compareTo(other:)")));
@end

__attribute__((swift_name("KotlinEnum")))
@interface TrackingplanSharedKotlinEnum<E> : TrackingplanSharedBase <TrackingplanSharedKotlinComparable>
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedKotlinEnumCompanion *companion __attribute__((swift_name("companion")));
- (int32_t)compareToOther:(E)other __attribute__((swift_name("compareTo(other:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) int32_t ordinal __attribute__((swift_name("ordinal")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("LogLevel")))
@interface TrackingplanSharedLogLevel : TrackingplanSharedKotlinEnum<TrackingplanSharedLogLevel *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) TrackingplanSharedLogLevel *verbose __attribute__((swift_name("verbose")));
@property (class, readonly) TrackingplanSharedLogLevel *debug __attribute__((swift_name("debug")));
@property (class, readonly) TrackingplanSharedLogLevel *info __attribute__((swift_name("info")));
@property (class, readonly) TrackingplanSharedLogLevel *warn __attribute__((swift_name("warn")));
@property (class, readonly) TrackingplanSharedLogLevel *error __attribute__((swift_name("error")));
+ (TrackingplanSharedKotlinArray<TrackingplanSharedLogLevel *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<TrackingplanSharedLogLevel *> *entries __attribute__((swift_name("entries")));
@end

__attribute__((swift_name("Logger")))
@protocol TrackingplanSharedLogger
@required
- (void)dMsg:(NSString *)msg __attribute__((swift_name("d(msg:)")));
- (void)eMsg:(NSString *)msg __attribute__((swift_name("e(msg:)")));
- (void)iMsg:(NSString *)msg __attribute__((swift_name("i(msg:)")));
- (void)vMsg:(NSString *)msg __attribute__((swift_name("v(msg:)")));
- (void)wMsg:(NSString *)msg __attribute__((swift_name("w(msg:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PlatformLogger")))
@interface TrackingplanSharedPlatformLogger : TrackingplanSharedBase <TrackingplanSharedLogger>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)dMsg:(NSString *)msg __attribute__((swift_name("d(msg:)")));
- (void)eMsg:(NSString *)msg __attribute__((swift_name("e(msg:)")));
- (void)iMsg:(NSString *)msg __attribute__((swift_name("i(msg:)")));
- (void)vMsg:(NSString *)msg __attribute__((swift_name("v(msg:)")));
- (void)wMsg:(NSString *)msg __attribute__((swift_name("w(msg:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SamplingOptions")))
@interface TrackingplanSharedSamplingOptions : TrackingplanSharedBase
- (instancetype)initWithUseAdaptiveSampling:(BOOL)useAdaptiveSampling adaptiveSamplingPatterns:(NSArray<TrackingplanSharedKotlinx_serialization_jsonJsonElement *> *)adaptiveSamplingPatterns __attribute__((swift_name("init(useAdaptiveSampling:adaptiveSamplingPatterns:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedSamplingOptionsCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedSamplingOptions *)doCopyUseAdaptiveSampling:(BOOL)useAdaptiveSampling adaptiveSamplingPatterns:(NSArray<TrackingplanSharedKotlinx_serialization_jsonJsonElement *> *)adaptiveSamplingPatterns __attribute__((swift_name("doCopy(useAdaptiveSampling:adaptiveSamplingPatterns:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<TrackingplanSharedKotlinx_serialization_jsonJsonElement *> *adaptiveSamplingPatterns __attribute__((swift_name("adaptiveSamplingPatterns")));
@property (readonly) BOOL useAdaptiveSampling __attribute__((swift_name("useAdaptiveSampling")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SamplingOptions.Companion")))
@interface TrackingplanSharedSamplingOptionsCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedSamplingOptionsCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@property (readonly) TrackingplanSharedSamplingOptions *EMPTY __attribute__((swift_name("EMPTY")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ServiceLocator")))
@interface TrackingplanSharedServiceLocator : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)serviceLocator __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedServiceLocator *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedLogger>)getLogger __attribute__((swift_name("getLogger()")));
- (id<TrackingplanSharedTimeProvider>)getTimeProvider __attribute__((swift_name("getTimeProvider()")));
- (void)reset __attribute__((swift_name("reset()")));
- (void)setLoggerLogger:(id<TrackingplanSharedLogger>)logger __attribute__((swift_name("setLogger(logger:)")));
- (void)setTimeProviderProvider:(id<TrackingplanSharedTimeProvider>)provider __attribute__((swift_name("setTimeProvider(provider:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Storage")))
@interface TrackingplanSharedStorage : TrackingplanSharedBase
@property (class, readonly, getter=companion) TrackingplanSharedStorageCompanion *companion __attribute__((swift_name("companion")));
- (void)clear __attribute__((swift_name("clear()")));
- (BOOL)isFirstTimeExecution __attribute__((swift_name("isFirstTimeExecution()")));
- (TrackingplanSharedTrackingplanSession *)loadSession __attribute__((swift_name("loadSession()")));
- (BOOL)loadTrackingEnabled __attribute__((swift_name("loadTrackingEnabled()")));
- (void)saveFirstTimeExecutionTimestamp:(int64_t)timestamp __attribute__((swift_name("saveFirstTimeExecution(timestamp:)")));
- (void)saveFirstTimeExecutionNow __attribute__((swift_name("saveFirstTimeExecutionNow()")));
- (void)saveLastDauEventSentTimeNow __attribute__((swift_name("saveLastDauEventSentTimeNow()")));
- (void)saveLastDauEventSentTimestampTimestamp:(int64_t)timestamp __attribute__((swift_name("saveLastDauEventSentTimestamp(timestamp:)")));
- (void)saveSessionSession:(TrackingplanSharedTrackingplanSession *)session __attribute__((swift_name("saveSession(session:)")));
- (void)saveTrackingEnabledEnabled:(BOOL)enabled __attribute__((swift_name("saveTrackingEnabled(enabled:)")));
- (BOOL)wasLastDauSent24hAgo __attribute__((swift_name("wasLastDauSent24hAgo()")));
@property (readonly) TrackingplanSharedIngestConfigCache *ingestConfigCache __attribute__((swift_name("ingestConfigCache")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Storage.Companion")))
@interface TrackingplanSharedStorageCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedStorageCompanion *shared __attribute__((swift_name("shared")));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (TrackingplanSharedStorage * _Nullable)createTpId:(NSString *)tpId environment:(NSString *)environment error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("create(tpId:environment:)")));
@end

__attribute__((swift_name("TimeProvider")))
@protocol TrackingplanSharedTimeProvider
@required
- (int64_t)currentTimeMillis __attribute__((swift_name("currentTimeMillis()")));
- (int64_t)elapsedRealTime __attribute__((swift_name("elapsedRealTime()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SystemTimeProvider")))
@interface TrackingplanSharedSystemTimeProvider : TrackingplanSharedBase <TrackingplanSharedTimeProvider>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (int64_t)currentTimeMillis __attribute__((swift_name("currentTimeMillis()")));
- (int64_t)elapsedRealTime __attribute__((swift_name("elapsedRealTime()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TestLogger")))
@interface TrackingplanSharedTestLogger : TrackingplanSharedBase <TrackingplanSharedLogger>
- (instancetype)initWithMaxSize:(int32_t)maxSize __attribute__((swift_name("init(maxSize:)"))) __attribute__((objc_designated_initializer));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (BOOL)assertExpectationsMatchAndReturnError:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("assertExpectationsMatch()")));
- (BOOL)containsExactMessageMsg:(NSString *)msg __attribute__((swift_name("containsExactMessage(msg:)")));
- (void)dMsg:(NSString *)msg __attribute__((swift_name("d(msg:)")));
- (void)eMsg:(NSString *)msg __attribute__((swift_name("e(msg:)")));
- (void)expectExactMessageMessage:(NSString *)message __attribute__((swift_name("expectExactMessage(message:)")));
- (void)expectMessageStartingWithAndContainingPrefix:(NSString *)prefix contains:(NSArray<NSString *> *)contains __attribute__((swift_name("expectMessageStartingWithAndContaining(prefix:contains:)")));
- (void)expectMessageStartsWithPrefix:(NSString *)prefix __attribute__((swift_name("expectMessageStartsWith(prefix:)")));
- (void)iMsg:(NSString *)msg __attribute__((swift_name("i(msg:)")));
- (void)reset __attribute__((swift_name("reset()")));
- (void)vMsg:(NSString *)msg __attribute__((swift_name("v(msg:)")));
- (void)wMsg:(NSString *)msg __attribute__((swift_name("w(msg:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TestLogger.LogMessage")))
@interface TrackingplanSharedTestLoggerLogMessage : TrackingplanSharedBase
- (instancetype)initWithLevel:(TrackingplanSharedLogLevel *)level message:(NSString *)message __attribute__((swift_name("init(level:message:)"))) __attribute__((objc_designated_initializer));
- (TrackingplanSharedTestLoggerLogMessage *)doCopyLevel:(TrackingplanSharedLogLevel *)level message:(NSString *)message __attribute__((swift_name("doCopy(level:message:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) TrackingplanSharedLogLevel *level __attribute__((swift_name("level")));
@property (readonly) NSString *message __attribute__((swift_name("message")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TestTimeProvider")))
@interface TrackingplanSharedTestTimeProvider : TrackingplanSharedBase <TrackingplanSharedTimeProvider>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)advanceTimeMs:(int64_t)ms __attribute__((swift_name("advanceTime(ms:)")));
- (int64_t)currentTimeMillis __attribute__((swift_name("currentTimeMillis()")));
- (int64_t)elapsedRealTime __attribute__((swift_name("elapsedRealTime()")));
- (void)setCurrentTimeMillisTime:(int64_t)time __attribute__((swift_name("setCurrentTimeMillis(time:)")));
- (void)setElapsedRealTimeTime:(int64_t)time __attribute__((swift_name("setElapsedRealTime(time:)")));
- (void)simulateReboot __attribute__((swift_name("simulateReboot()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TimeProviderCompanion")))
@interface TrackingplanSharedTimeProviderCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedTimeProviderCompanion *shared __attribute__((swift_name("shared")));
@property (readonly) int64_t HOUR __attribute__((swift_name("HOUR")));
@property (readonly) int64_t MILLISECOND __attribute__((swift_name("MILLISECOND")));
@property (readonly) int64_t MINUTE __attribute__((swift_name("MINUTE")));
@property (readonly) int64_t SECOND __attribute__((swift_name("SECOND")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanConfig")))
@interface TrackingplanSharedTrackingplanConfig : TrackingplanSharedBase
@property (class, readonly, getter=companion) TrackingplanSharedTrackingplanConfigCompanion *companion __attribute__((swift_name("companion")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)sampleRateUrl __attribute__((swift_name("sampleRateUrl()")));
- (NSString *)description __attribute__((swift_name("description()")));
- (TrackingplanSharedTrackingplanConfig *)withTagsNewTags:(NSDictionary<NSString *, NSString *> *)newTags replace:(BOOL)replace __attribute__((swift_name("withTags(newTags:replace:)")));
@property (readonly) NSString *configEndpoint __attribute__((swift_name("configEndpoint")));
@property (readonly) BOOL debug __attribute__((swift_name("debug")));
@property (readonly) BOOL dryRun __attribute__((swift_name("dryRun")));
@property (readonly) NSString *environment __attribute__((swift_name("environment")));
@property (readonly) NSDictionary<NSString *, NSString *> *providerDomains __attribute__((swift_name("providerDomains")));
@property (readonly) NSString *sourceAlias __attribute__((swift_name("sourceAlias")));
@property (readonly) NSDictionary<NSString *, NSString *> *tags __attribute__((swift_name("tags")));
@property (readonly) BOOL testing __attribute__((swift_name("testing")));
@property (readonly) NSString *tpId __attribute__((swift_name("tpId")));
@property (readonly) NSString *tracksEndpoint __attribute__((swift_name("tracksEndpoint")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanConfig.Companion")))
@interface TrackingplanSharedTrackingplanConfigCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedTrackingplanConfigCompanion *shared __attribute__((swift_name("shared")));
- (TrackingplanSharedTrackingplanConfig *)empty __attribute__((swift_name("empty()")));
@property (readonly) NSString *DEFAULT_CONFIG_ENDPOINT __attribute__((swift_name("DEFAULT_CONFIG_ENDPOINT")));
@property (readonly) NSString *DEFAULT_TRACKS_ENDPOINT __attribute__((swift_name("DEFAULT_TRACKS_ENDPOINT")));
@property (readonly) int32_t MAX_REQUEST_BODY_SIZE_IN_BYTES __attribute__((swift_name("MAX_REQUEST_BODY_SIZE_IN_BYTES")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanConfigBuilder")))
@interface TrackingplanSharedTrackingplanConfigBuilder : TrackingplanSharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));

/**
 * @note This method converts instances of IllegalArgumentException to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (TrackingplanSharedTrackingplanConfig * _Nullable)buildAndReturnError:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("build()")));
- (TrackingplanSharedTrackingplanConfigBuilder *)configEndpointEndpoint:(NSString *)endpoint __attribute__((swift_name("configEndpoint(endpoint:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)debugEnabled:(BOOL)enabled __attribute__((swift_name("debug(enabled:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)dryRunEnabled:(BOOL)enabled __attribute__((swift_name("dryRun(enabled:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)environmentEnvironment:(NSString *)environment __attribute__((swift_name("environment(environment:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)providerDomainsDomains:(NSDictionary<NSString *, NSString *> *)domains __attribute__((swift_name("providerDomains(domains:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)sourceAliasAlias:(NSString *)alias __attribute__((swift_name("sourceAlias(alias:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)tagsTags:(NSDictionary<NSString *, NSString *> *)tags __attribute__((swift_name("tags(tags:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)testingEnabled:(BOOL)enabled __attribute__((swift_name("testing(enabled:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)tpIdTpId:(NSString *)tpId __attribute__((swift_name("tpId(tpId:)")));
- (TrackingplanSharedTrackingplanConfigBuilder *)tracksEndpointEndpoint:(NSString *)endpoint __attribute__((swift_name("tracksEndpoint(endpoint:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanIngestConfig")))
@interface TrackingplanSharedTrackingplanIngestConfig : TrackingplanSharedBase
- (instancetype)initWithSampleRate:(int32_t)sampleRate environmentRates:(NSDictionary<NSString *, TrackingplanSharedInt *> *)environmentRates options:(TrackingplanSharedSamplingOptions *)options random:(TrackingplanSharedKotlinRandom *)random __attribute__((swift_name("init(sampleRate:environmentRates:options:random:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedTrackingplanIngestConfigCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedTrackingplanIngestConfig *)doCopySampleRate:(int32_t)sampleRate environmentRates:(NSDictionary<NSString *, TrackingplanSharedInt *> *)environmentRates options:(TrackingplanSharedSamplingOptions *)options random:(TrackingplanSharedKotlinRandom *)random __attribute__((swift_name("doCopy(sampleRate:environmentRates:options:random:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (int32_t)getSamplingRateEnvironment:(NSString *)environment __attribute__((swift_name("getSamplingRate(environment:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (BOOL)isAdaptiveSamplingEnabled __attribute__((swift_name("isAdaptiveSamplingEnabled()")));
- (BOOL)shouldEnableTrackingSamplingRate:(int32_t)samplingRate __attribute__((swift_name("shouldEnableTracking(samplingRate:)")));
- (BOOL)shouldEnableTrackingEnvironment:(NSString *)environment __attribute__((swift_name("shouldEnableTracking(environment:)")));
- (NSString *)description __attribute__((swift_name("description()")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="environment_rates")
*/
@property (readonly) NSDictionary<NSString *, TrackingplanSharedInt *> *environmentRates __attribute__((swift_name("environmentRates")));
@property (readonly) TrackingplanSharedSamplingOptions *options __attribute__((swift_name("options")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="sample_rate")
*/
@property (readonly) int32_t sampleRate __attribute__((swift_name("sampleRate")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanIngestConfig.Companion")))
@interface TrackingplanSharedTrackingplanIngestConfigCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedTrackingplanIngestConfigCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanIngestConfigParser")))
@interface TrackingplanSharedTrackingplanIngestConfigParser : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)trackingplanIngestConfigParser __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedTrackingplanIngestConfigParser *shared __attribute__((swift_name("shared")));

/**
 * @note This method converts instances of Exception to errors.
 * Other uncaught Kotlin exceptions are fatal.
*/
- (TrackingplanSharedTrackingplanIngestConfig * _Nullable)parseJsonString:(NSString *)jsonString error:(NSError * _Nullable * _Nullable)error __attribute__((swift_name("parse(jsonString:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanSession")))
@interface TrackingplanSharedTrackingplanSession : TrackingplanSharedBase
@property (class, readonly, getter=companion) TrackingplanSharedTrackingplanSessionCompanion *companion __attribute__((swift_name("companion")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (TrackingplanSharedSamplingResult *)evaluateSamplingDecisionRequest:(TrackingplanSharedRequest *)request __attribute__((swift_name("evaluateSamplingDecision(request:)")));
- (TrackingplanSharedSamplingResult *)evaluateSamplingDecisionRequest:(TrackingplanSharedRequest *)request random:(TrackingplanSharedKotlinRandom *)random __attribute__((swift_name("evaluateSamplingDecision(request:random:)")));
- (BOOL)hasExpired __attribute__((swift_name("hasExpired()")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
- (BOOL)updateLastActivity __attribute__((swift_name("updateLastActivity()")));
@property (readonly) int64_t createdAt __attribute__((swift_name("createdAt")));
@property (readonly) BOOL isNew __attribute__((swift_name("isNew")));
@property int64_t lastActivityTime __attribute__((swift_name("lastActivityTime")));
@property (readonly) NSArray<TrackingplanSharedAdaptiveSamplingPattern *> *parsedPatterns __attribute__((swift_name("parsedPatterns")));
@property (readonly) TrackingplanSharedSamplingOptions *samplingOptions __attribute__((swift_name("samplingOptions")));
@property (readonly) int32_t samplingRate __attribute__((swift_name("samplingRate")));
@property (readonly) NSString *sessionId __attribute__((swift_name("sessionId")));
@property (readonly) BOOL trackingEnabled __attribute__((swift_name("trackingEnabled")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanSession.Companion")))
@interface TrackingplanSharedTrackingplanSessionCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedTrackingplanSessionCompanion *shared __attribute__((swift_name("shared")));
- (TrackingplanSharedTrackingplanSession *)fromStorageSessionId:(NSString *)sessionId samplingRate:(int32_t)samplingRate trackingEnabled:(BOOL)trackingEnabled createdAt:(int64_t)createdAt lastActivityTime:(int64_t)lastActivityTime samplingOptions:(TrackingplanSharedSamplingOptions *)samplingOptions __attribute__((swift_name("fromStorage(sessionId:samplingRate:trackingEnabled:createdAt:lastActivityTime:samplingOptions:)")));
- (TrackingplanSharedTrackingplanSession *)doNewSessionSamplingRate:(int32_t)samplingRate trackingEnabled:(BOOL)trackingEnabled samplingOptions:(TrackingplanSharedSamplingOptions *)samplingOptions __attribute__((swift_name("doNewSession(samplingRate:trackingEnabled:samplingOptions:)")));
@property (readonly) TrackingplanSharedTrackingplanSession *EMPTY __attribute__((swift_name("EMPTY")));
@property (readonly) int64_t MAX_IDLE_DURATION __attribute__((swift_name("MAX_IDLE_DURATION")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UrlMatcher")))
@interface TrackingplanSharedUrlMatcher : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)urlMatcher __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedUrlMatcher *shared __attribute__((swift_name("shared")));
- (void)clearRegexCache __attribute__((swift_name("clearRegexCache()")));
- (NSString * _Nullable)matchProviderProviders:(NSDictionary<NSString *, NSString *> *)providers requestUrl:(NSString *)requestUrl __attribute__((swift_name("matchProvider(providers:requestUrl:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AdaptiveSamplingEvaluator")))
@interface TrackingplanSharedAdaptiveSamplingEvaluator : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)adaptiveSamplingEvaluator __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedAdaptiveSamplingEvaluator *shared __attribute__((swift_name("shared")));
- (TrackingplanSharedSamplingResult *)evaluateRequest:(TrackingplanSharedRequest *)request sessionSampleRate:(int32_t)sessionSampleRate sessionTrackingEnabled:(BOOL)sessionTrackingEnabled adaptiveSamplingEnabled:(BOOL)adaptiveSamplingEnabled patterns:(NSArray<TrackingplanSharedAdaptiveSamplingPattern *> *)patterns random:(TrackingplanSharedKotlinRandom *)random __attribute__((swift_name("evaluate(request:sessionSampleRate:sessionTrackingEnabled:adaptiveSamplingEnabled:patterns:random:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AdaptiveSamplingMatcher")))
@interface TrackingplanSharedAdaptiveSamplingMatcher : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)adaptiveSamplingMatcher __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedAdaptiveSamplingMatcher *shared __attribute__((swift_name("shared")));
- (TrackingplanSharedMatchResult *)matchRequestRequest:(TrackingplanSharedRequest *)request patterns:(NSArray<TrackingplanSharedAdaptiveSamplingPattern *> *)patterns __attribute__((swift_name("matchRequest(request:patterns:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AdaptiveSamplingPattern")))
@interface TrackingplanSharedAdaptiveSamplingPattern : TrackingplanSharedBase
- (instancetype)initWithProvider:(NSString *)provider match:(TrackingplanSharedMatchCondition * _Nullable)match sampleRate:(int32_t)sampleRate __attribute__((swift_name("init(provider:match:sampleRate:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedAdaptiveSamplingPatternCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedAdaptiveSamplingPattern *)doCopyProvider:(NSString *)provider match:(TrackingplanSharedMatchCondition * _Nullable)match sampleRate:(int32_t)sampleRate __attribute__((swift_name("doCopy(provider:match:sampleRate:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) TrackingplanSharedMatchCondition * _Nullable match __attribute__((swift_name("match")));
@property (readonly) NSString *provider __attribute__((swift_name("provider")));

/**
 * @note annotations
 *   kotlinx.serialization.SerialName(value="sample_rate")
*/
@property (readonly) int32_t sampleRate __attribute__((swift_name("sampleRate")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AdaptiveSamplingPattern.Companion")))
@interface TrackingplanSharedAdaptiveSamplingPatternCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedAdaptiveSamplingPatternCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AdaptiveSamplingPatternParser")))
@interface TrackingplanSharedAdaptiveSamplingPatternParser : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)adaptiveSamplingPatternParser __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedAdaptiveSamplingPatternParser *shared __attribute__((swift_name("shared")));
- (TrackingplanSharedAdaptiveSamplingPattern * _Nullable)parsePatternElement:(TrackingplanSharedKotlinx_serialization_jsonJsonElement *)element __attribute__((swift_name("parsePattern(element:)")));
- (NSArray<TrackingplanSharedAdaptiveSamplingPattern *> *)parsePatternsElements:(NSArray<TrackingplanSharedKotlinx_serialization_jsonJsonElement *> *)elements __attribute__((swift_name("parsePatterns(elements:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("DropReason")))
@interface TrackingplanSharedDropReason : TrackingplanSharedKotlinEnum<TrackingplanSharedDropReason *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) TrackingplanSharedDropReason *trackingDisabled __attribute__((swift_name("trackingDisabled")));
@property (class, readonly) TrackingplanSharedDropReason *adaptiveSamplingDisabled __attribute__((swift_name("adaptiveSamplingDisabled")));
@property (class, readonly) TrackingplanSharedDropReason *noMatchingPattern __attribute__((swift_name("noMatchingPattern")));
@property (class, readonly) TrackingplanSharedDropReason *rescueProbabilityFailed __attribute__((swift_name("rescueProbabilityFailed")));
+ (TrackingplanSharedKotlinArray<TrackingplanSharedDropReason *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<TrackingplanSharedDropReason *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((swift_name("MatchCondition")))
@interface TrackingplanSharedMatchCondition : TrackingplanSharedBase
@property (class, readonly, getter=companion) TrackingplanSharedMatchConditionCompanion *companion __attribute__((swift_name("companion")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="and")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.And")))
@interface TrackingplanSharedMatchConditionAnd : TrackingplanSharedMatchCondition
- (instancetype)initWithConditions:(NSArray<TrackingplanSharedMatchCondition *> *)conditions __attribute__((swift_name("init(conditions:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedMatchConditionAndCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedMatchConditionAnd *)doCopyConditions:(NSArray<TrackingplanSharedMatchCondition *> *)conditions __attribute__((swift_name("doCopy(conditions:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<TrackingplanSharedMatchCondition *> *conditions __attribute__((swift_name("conditions")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.AndCompanion")))
@interface TrackingplanSharedMatchConditionAndCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchConditionAndCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.Companion")))
@interface TrackingplanSharedMatchConditionCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchConditionCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(TrackingplanSharedKotlinArray<id<TrackingplanSharedKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="fields")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.Fields")))
@interface TrackingplanSharedMatchConditionFields : TrackingplanSharedMatchCondition
- (instancetype)initWithFields:(NSDictionary<NSString *, TrackingplanSharedMatchValue *> *)fields __attribute__((swift_name("init(fields:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedMatchConditionFieldsCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedMatchConditionFields *)doCopyFields:(NSDictionary<NSString *, TrackingplanSharedMatchValue *> *)fields __attribute__((swift_name("doCopy(fields:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSDictionary<NSString *, TrackingplanSharedMatchValue *> *fields __attribute__((swift_name("fields")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.FieldsCompanion")))
@interface TrackingplanSharedMatchConditionFieldsCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchConditionFieldsCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="not")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.Not")))
@interface TrackingplanSharedMatchConditionNot : TrackingplanSharedMatchCondition
- (instancetype)initWithCondition:(TrackingplanSharedMatchCondition *)condition __attribute__((swift_name("init(condition:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedMatchConditionNotCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedMatchConditionNot *)doCopyCondition:(TrackingplanSharedMatchCondition *)condition __attribute__((swift_name("doCopy(condition:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) TrackingplanSharedMatchCondition *condition __attribute__((swift_name("condition")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.NotCompanion")))
@interface TrackingplanSharedMatchConditionNotCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchConditionNotCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="or")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.Or")))
@interface TrackingplanSharedMatchConditionOr : TrackingplanSharedMatchCondition
- (instancetype)initWithConditions:(NSArray<TrackingplanSharedMatchCondition *> *)conditions __attribute__((swift_name("init(conditions:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedMatchConditionOrCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedMatchConditionOr *)doCopyConditions:(NSArray<TrackingplanSharedMatchCondition *> *)conditions __attribute__((swift_name("doCopy(conditions:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<TrackingplanSharedMatchCondition *> *conditions __attribute__((swift_name("conditions")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchCondition.OrCompanion")))
@interface TrackingplanSharedMatchConditionOrCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchConditionOrCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchResult")))
@interface TrackingplanSharedMatchResult : TrackingplanSharedBase
- (instancetype)initWithMatched:(BOOL)matched sampleRate:(TrackingplanSharedInt * _Nullable)sampleRate matchedPattern:(TrackingplanSharedAdaptiveSamplingPattern * _Nullable)matchedPattern __attribute__((swift_name("init(matched:sampleRate:matchedPattern:)"))) __attribute__((objc_designated_initializer));
- (TrackingplanSharedMatchResult *)doCopyMatched:(BOOL)matched sampleRate:(TrackingplanSharedInt * _Nullable)sampleRate matchedPattern:(TrackingplanSharedAdaptiveSamplingPattern * _Nullable)matchedPattern __attribute__((swift_name("doCopy(matched:sampleRate:matchedPattern:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) BOOL matched __attribute__((swift_name("matched")));
@property (readonly) TrackingplanSharedAdaptiveSamplingPattern * _Nullable matchedPattern __attribute__((swift_name("matchedPattern")));
@property (readonly) TrackingplanSharedInt * _Nullable sampleRate __attribute__((swift_name("sampleRate")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
*/
__attribute__((swift_name("MatchValue")))
@interface TrackingplanSharedMatchValue : TrackingplanSharedBase
@property (class, readonly, getter=companion) TrackingplanSharedMatchValueCompanion *companion __attribute__((swift_name("companion")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchValue.Companion")))
@interface TrackingplanSharedMatchValueCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchValueCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializerTypeParamsSerializers:(TrackingplanSharedKotlinArray<id<TrackingplanSharedKotlinx_serialization_coreKSerializer>> *)typeParamsSerializers __attribute__((swift_name("serializer(typeParamsSerializers:)")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="multiple")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchValue.Multiple")))
@interface TrackingplanSharedMatchValueMultiple : TrackingplanSharedMatchValue
- (instancetype)initWithValues:(NSArray<NSString *> *)values __attribute__((swift_name("init(values:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedMatchValueMultipleCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedMatchValueMultiple *)doCopyValues:(NSArray<NSString *> *)values __attribute__((swift_name("doCopy(values:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSArray<NSString *> *values __attribute__((swift_name("values")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchValue.MultipleCompanion")))
@interface TrackingplanSharedMatchValueMultipleCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchValueMultipleCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable
 *   kotlinx.serialization.SerialName(value="single")
*/
__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchValue.Single")))
@interface TrackingplanSharedMatchValueSingle : TrackingplanSharedMatchValue
- (instancetype)initWithValue:(NSString *)value __attribute__((swift_name("init(value:)"))) __attribute__((objc_designated_initializer));
@property (class, readonly, getter=companion) TrackingplanSharedMatchValueSingleCompanion *companion __attribute__((swift_name("companion")));
- (TrackingplanSharedMatchValueSingle *)doCopyValue:(NSString *)value __attribute__((swift_name("doCopy(value:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MatchValue.SingleCompanion")))
@interface TrackingplanSharedMatchValueSingleCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedMatchValueSingleCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("PayloadFlattener")))
@interface TrackingplanSharedPayloadFlattener : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)payloadFlattener __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedPayloadFlattener *shared __attribute__((swift_name("shared")));
- (NSDictionary<NSString *, NSArray<NSString *> *> *)flattenToKeyValuesData:(id _Nullable)data __attribute__((swift_name("flattenToKeyValues(data:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Request")))
@interface TrackingplanSharedRequest : TrackingplanSharedBase
- (instancetype)initWithProvider:(NSString *)provider endpoint:(NSString *)endpoint payload:(NSString * _Nullable)payload __attribute__((swift_name("init(provider:endpoint:payload:)"))) __attribute__((objc_designated_initializer));
- (TrackingplanSharedRequest *)doCopyProvider:(NSString *)provider endpoint:(NSString *)endpoint payload:(NSString * _Nullable)payload __attribute__((swift_name("doCopy(provider:endpoint:payload:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString *endpoint __attribute__((swift_name("endpoint")));
@property (readonly) NSString * _Nullable payload __attribute__((swift_name("payload")));
@property (readonly) NSString *provider __attribute__((swift_name("provider")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("RequestDataExtractor")))
@interface TrackingplanSharedRequestDataExtractor : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)requestDataExtractor __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedRequestDataExtractor *shared __attribute__((swift_name("shared")));
- (NSDictionary<NSString *, id> * _Nullable)parseJsonPayloadPayload:(NSString *)payload __attribute__((swift_name("parseJsonPayload(payload:)")));
- (NSDictionary<NSString *, NSString *> *)parseQueryStringQueryString:(NSString *)queryString __attribute__((swift_name("parseQueryString(queryString:)")));
- (TrackingplanSharedKotlinPair<NSString *, NSDictionary<NSString *, NSString *> *> *)parseUrlUrl:(NSString *)url __attribute__((swift_name("parseUrl(url:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SamplingMode")))
@interface TrackingplanSharedSamplingMode : TrackingplanSharedKotlinEnum<TrackingplanSharedSamplingMode *>
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)initWithName:(NSString *)name ordinal:(int32_t)ordinal __attribute__((swift_name("init(name:ordinal:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
@property (class, readonly) TrackingplanSharedSamplingMode *default_ __attribute__((swift_name("default_")));
@property (class, readonly) TrackingplanSharedSamplingMode *sessionSampledPatternMatched __attribute__((swift_name("sessionSampledPatternMatched")));
@property (class, readonly) TrackingplanSharedSamplingMode *sessionSampledNoPattern __attribute__((swift_name("sessionSampledNoPattern")));
@property (class, readonly) TrackingplanSharedSamplingMode *eventRescuedByAdaptive __attribute__((swift_name("eventRescuedByAdaptive")));
+ (TrackingplanSharedKotlinArray<TrackingplanSharedSamplingMode *> *)values __attribute__((swift_name("values()")));
@property (class, readonly) NSArray<TrackingplanSharedSamplingMode *> *entries __attribute__((swift_name("entries")));
@property (readonly) NSString *value __attribute__((swift_name("value")));
@end

__attribute__((swift_name("SamplingResult")))
@interface TrackingplanSharedSamplingResult : TrackingplanSharedBase
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SamplingResult.Drop")))
@interface TrackingplanSharedSamplingResultDrop : TrackingplanSharedSamplingResult
- (instancetype)initWithReason:(TrackingplanSharedDropReason *)reason __attribute__((swift_name("init(reason:)"))) __attribute__((objc_designated_initializer));
- (TrackingplanSharedSamplingResultDrop *)doCopyReason:(TrackingplanSharedDropReason *)reason __attribute__((swift_name("doCopy(reason:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) TrackingplanSharedDropReason *reason __attribute__((swift_name("reason")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SamplingResult.Include")))
@interface TrackingplanSharedSamplingResultInclude : TrackingplanSharedSamplingResult
- (instancetype)initWithEffectiveSampleRate:(int32_t)effectiveSampleRate matchedPattern:(TrackingplanSharedAdaptiveSamplingPattern * _Nullable)matchedPattern samplingMode:(TrackingplanSharedSamplingMode *)samplingMode __attribute__((swift_name("init(effectiveSampleRate:matchedPattern:samplingMode:)"))) __attribute__((objc_designated_initializer));
- (TrackingplanSharedSamplingResultInclude *)doCopyEffectiveSampleRate:(int32_t)effectiveSampleRate matchedPattern:(TrackingplanSharedAdaptiveSamplingPattern * _Nullable)matchedPattern samplingMode:(TrackingplanSharedSamplingMode *)samplingMode __attribute__((swift_name("doCopy(effectiveSampleRate:matchedPattern:samplingMode:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) int32_t effectiveSampleRate __attribute__((swift_name("effectiveSampleRate")));
@property (readonly) TrackingplanSharedAdaptiveSamplingPattern * _Nullable matchedPattern __attribute__((swift_name("matchedPattern")));
@property (readonly) TrackingplanSharedSamplingMode *samplingMode __attribute__((swift_name("samplingMode")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SpecialKeys")))
@interface TrackingplanSharedSpecialKeys : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)specialKeys __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedSpecialKeys *shared __attribute__((swift_name("shared")));
@property (readonly) NSString *ANY_KEY __attribute__((swift_name("ANY_KEY")));
@property (readonly) NSString *CONTAINS_SUFFIX __attribute__((swift_name("CONTAINS_SUFFIX")));
@property (readonly) NSString *ENDPOINT_OR_PAYLOAD_CONTAINS __attribute__((swift_name("ENDPOINT_OR_PAYLOAD_CONTAINS")));
@property (readonly) NSString *ENDPOINT_PATH_CONTAINS __attribute__((swift_name("ENDPOINT_PATH_CONTAINS")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Platform_iosKt")))
@interface TrackingplanSharedPlatform_iosKt : TrackingplanSharedBase
+ (NSString *)platform __attribute__((swift_name("platform()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("TrackingplanConfig_iosKt")))
@interface TrackingplanSharedTrackingplanConfig_iosKt : TrackingplanSharedBase
+ (NSString *)defaultSourceAlias __attribute__((swift_name("defaultSourceAlias()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UrlEncoding_iosKt")))
@interface TrackingplanSharedUrlEncoding_iosKt : TrackingplanSharedBase
+ (NSString *)urlDecodeEncoded:(NSString *)encoded __attribute__((swift_name("urlDecode(encoded:)")));
@end

__attribute__((swift_name("KotlinThrowable")))
@interface TrackingplanSharedKotlinThrowable : TrackingplanSharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));

/**
 * @note annotations
 *   kotlin.experimental.ExperimentalNativeApi
*/
- (TrackingplanSharedKotlinArray<NSString *> *)getStackTrace __attribute__((swift_name("getStackTrace()")));
- (void)printStackTrace __attribute__((swift_name("printStackTrace()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) TrackingplanSharedKotlinThrowable * _Nullable cause __attribute__((swift_name("cause")));
@property (readonly) NSString * _Nullable message __attribute__((swift_name("message")));
- (NSError *)asError __attribute__((swift_name("asError()")));
@end

__attribute__((swift_name("KotlinException")))
@interface TrackingplanSharedKotlinException : TrackingplanSharedKotlinThrowable
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinEnumCompanion")))
@interface TrackingplanSharedKotlinEnumCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedKotlinEnumCompanion *shared __attribute__((swift_name("shared")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinArray")))
@interface TrackingplanSharedKotlinArray<T> : TrackingplanSharedBase
+ (instancetype)arrayWithSize:(int32_t)size init:(T _Nullable (^)(TrackingplanSharedInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (T _Nullable)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (id<TrackingplanSharedKotlinIterator>)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(T _Nullable)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.Serializable(with=NormalClass(value=kotlinx/serialization/json/JsonElementSerializer))
*/
__attribute__((swift_name("Kotlinx_serialization_jsonJsonElement")))
@interface TrackingplanSharedKotlinx_serialization_jsonJsonElement : TrackingplanSharedBase
@property (class, readonly, getter=companion) TrackingplanSharedKotlinx_serialization_jsonJsonElementCompanion *companion __attribute__((swift_name("companion")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerializationStrategy")))
@protocol TrackingplanSharedKotlinx_serialization_coreSerializationStrategy
@required
- (void)serializeEncoder:(id<TrackingplanSharedKotlinx_serialization_coreEncoder>)encoder value:(id _Nullable)value __attribute__((swift_name("serialize(encoder:value:)")));
@property (readonly) id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreDeserializationStrategy")))
@protocol TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy
@required
- (id _Nullable)deserializeDecoder:(id<TrackingplanSharedKotlinx_serialization_coreDecoder>)decoder __attribute__((swift_name("deserialize(decoder:)")));
@property (readonly) id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor> descriptor __attribute__((swift_name("descriptor")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreKSerializer")))
@protocol TrackingplanSharedKotlinx_serialization_coreKSerializer <TrackingplanSharedKotlinx_serialization_coreSerializationStrategy, TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy>
@required
@end

__attribute__((swift_name("KotlinRuntimeException")))
@interface TrackingplanSharedKotlinRuntimeException : TrackingplanSharedKotlinException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end

__attribute__((swift_name("KotlinIllegalArgumentException")))
@interface TrackingplanSharedKotlinIllegalArgumentException : TrackingplanSharedKotlinRuntimeException
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (instancetype)initWithMessage:(NSString * _Nullable)message __attribute__((swift_name("init(message:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithCause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(cause:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithMessage:(NSString * _Nullable)message cause:(TrackingplanSharedKotlinThrowable * _Nullable)cause __attribute__((swift_name("init(message:cause:)"))) __attribute__((objc_designated_initializer));
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.3")
*/
__attribute__((swift_name("KotlinRandom")))
@interface TrackingplanSharedKotlinRandom : TrackingplanSharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property (class, readonly, getter=companion) TrackingplanSharedKotlinRandomDefault *companion __attribute__((swift_name("companion")));
- (int32_t)nextBitsBitCount:(int32_t)bitCount __attribute__((swift_name("nextBits(bitCount:)")));
- (BOOL)nextBoolean __attribute__((swift_name("nextBoolean()")));
- (TrackingplanSharedKotlinByteArray *)nextBytesArray:(TrackingplanSharedKotlinByteArray *)array __attribute__((swift_name("nextBytes(array:)")));
- (TrackingplanSharedKotlinByteArray *)nextBytesSize:(int32_t)size __attribute__((swift_name("nextBytes(size:)")));
- (TrackingplanSharedKotlinByteArray *)nextBytesArray:(TrackingplanSharedKotlinByteArray *)array fromIndex:(int32_t)fromIndex toIndex:(int32_t)toIndex __attribute__((swift_name("nextBytes(array:fromIndex:toIndex:)")));
- (double)nextDouble __attribute__((swift_name("nextDouble()")));
- (double)nextDoubleUntil:(double)until __attribute__((swift_name("nextDouble(until:)")));
- (double)nextDoubleFrom:(double)from until:(double)until __attribute__((swift_name("nextDouble(from:until:)")));
- (float)nextFloat __attribute__((swift_name("nextFloat()")));
- (int32_t)nextInt __attribute__((swift_name("nextInt()")));
- (int32_t)nextIntUntil:(int32_t)until __attribute__((swift_name("nextInt(until:)")));
- (int32_t)nextIntFrom:(int32_t)from until:(int32_t)until __attribute__((swift_name("nextInt(from:until:)")));
- (int64_t)nextLong __attribute__((swift_name("nextLong()")));
- (int64_t)nextLongUntil:(int64_t)until __attribute__((swift_name("nextLong(until:)")));
- (int64_t)nextLongFrom:(int64_t)from until:(int64_t)until __attribute__((swift_name("nextLong(from:until:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinPair")))
@interface TrackingplanSharedKotlinPair<__covariant A, __covariant B> : TrackingplanSharedBase
- (instancetype)initWithFirst:(A _Nullable)first second:(B _Nullable)second __attribute__((swift_name("init(first:second:)"))) __attribute__((objc_designated_initializer));
- (TrackingplanSharedKotlinPair<A, B> *)doCopyFirst:(A _Nullable)first second:(B _Nullable)second __attribute__((swift_name("doCopy(first:second:)")));
- (BOOL)equalsOther:(id _Nullable)other __attribute__((swift_name("equals(other:)")));
- (int32_t)hashCode __attribute__((swift_name("hashCode()")));
- (NSString *)toString __attribute__((swift_name("toString()")));
@property (readonly) A _Nullable first __attribute__((swift_name("first")));
@property (readonly) B _Nullable second __attribute__((swift_name("second")));
@end

__attribute__((swift_name("KotlinIterator")))
@protocol TrackingplanSharedKotlinIterator
@required
- (BOOL)hasNext __attribute__((swift_name("hasNext()")));
- (id _Nullable)next __attribute__((swift_name("next()")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Kotlinx_serialization_jsonJsonElement.Companion")))
@interface TrackingplanSharedKotlinx_serialization_jsonJsonElementCompanion : TrackingplanSharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedKotlinx_serialization_jsonJsonElementCompanion *shared __attribute__((swift_name("shared")));
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("serializer()")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreEncoder")))
@protocol TrackingplanSharedKotlinx_serialization_coreEncoder
@required
- (id<TrackingplanSharedKotlinx_serialization_coreCompositeEncoder>)beginCollectionDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor collectionSize:(int32_t)collectionSize __attribute__((swift_name("beginCollection(descriptor:collectionSize:)")));
- (id<TrackingplanSharedKotlinx_serialization_coreCompositeEncoder>)beginStructureDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("beginStructure(descriptor:)")));
- (void)encodeBooleanValue:(BOOL)value __attribute__((swift_name("encodeBoolean(value:)")));
- (void)encodeByteValue:(int8_t)value __attribute__((swift_name("encodeByte(value:)")));
- (void)encodeCharValue:(unichar)value __attribute__((swift_name("encodeChar(value:)")));
- (void)encodeDoubleValue:(double)value __attribute__((swift_name("encodeDouble(value:)")));
- (void)encodeEnumEnumDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)enumDescriptor index:(int32_t)index __attribute__((swift_name("encodeEnum(enumDescriptor:index:)")));
- (void)encodeFloatValue:(float)value __attribute__((swift_name("encodeFloat(value:)")));
- (id<TrackingplanSharedKotlinx_serialization_coreEncoder>)encodeInlineDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("encodeInline(descriptor:)")));
- (void)encodeIntValue:(int32_t)value __attribute__((swift_name("encodeInt(value:)")));
- (void)encodeLongValue:(int64_t)value __attribute__((swift_name("encodeLong(value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNotNullMark __attribute__((swift_name("encodeNotNullMark()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNull __attribute__((swift_name("encodeNull()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNullableSerializableValueSerializer:(id<TrackingplanSharedKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeNullableSerializableValue(serializer:value:)")));
- (void)encodeSerializableValueSerializer:(id<TrackingplanSharedKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeSerializableValue(serializer:value:)")));
- (void)encodeShortValue:(int16_t)value __attribute__((swift_name("encodeShort(value:)")));
- (void)encodeStringValue:(NSString *)value __attribute__((swift_name("encodeString(value:)")));
@property (readonly) TrackingplanSharedKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerialDescriptor")))
@protocol TrackingplanSharedKotlinx_serialization_coreSerialDescriptor
@required

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (NSArray<id<TrackingplanSharedKotlinAnnotation>> *)getElementAnnotationsIndex:(int32_t)index __attribute__((swift_name("getElementAnnotations(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)getElementDescriptorIndex:(int32_t)index __attribute__((swift_name("getElementDescriptor(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (int32_t)getElementIndexName:(NSString *)name __attribute__((swift_name("getElementIndex(name:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (NSString *)getElementNameIndex:(int32_t)index __attribute__((swift_name("getElementName(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)isElementOptionalIndex:(int32_t)index __attribute__((swift_name("isElementOptional(index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) NSArray<id<TrackingplanSharedKotlinAnnotation>> *annotations __attribute__((swift_name("annotations")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) int32_t elementsCount __attribute__((swift_name("elementsCount")));
@property (readonly) BOOL isInline __attribute__((swift_name("isInline")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) BOOL isNullable __attribute__((swift_name("isNullable")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) TrackingplanSharedKotlinx_serialization_coreSerialKind *kind __attribute__((swift_name("kind")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
@property (readonly) NSString *serialName __attribute__((swift_name("serialName")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreDecoder")))
@protocol TrackingplanSharedKotlinx_serialization_coreDecoder
@required
- (id<TrackingplanSharedKotlinx_serialization_coreCompositeDecoder>)beginStructureDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("beginStructure(descriptor:)")));
- (BOOL)decodeBoolean __attribute__((swift_name("decodeBoolean()")));
- (int8_t)decodeByte __attribute__((swift_name("decodeByte()")));
- (unichar)decodeChar __attribute__((swift_name("decodeChar()")));
- (double)decodeDouble __attribute__((swift_name("decodeDouble()")));
- (int32_t)decodeEnumEnumDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)enumDescriptor __attribute__((swift_name("decodeEnum(enumDescriptor:)")));
- (float)decodeFloat __attribute__((swift_name("decodeFloat()")));
- (id<TrackingplanSharedKotlinx_serialization_coreDecoder>)decodeInlineDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeInline(descriptor:)")));
- (int32_t)decodeInt __attribute__((swift_name("decodeInt()")));
- (int64_t)decodeLong __attribute__((swift_name("decodeLong()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)decodeNotNullMark __attribute__((swift_name("decodeNotNullMark()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (TrackingplanSharedKotlinNothing * _Nullable)decodeNull __attribute__((swift_name("decodeNull()")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id _Nullable)decodeNullableSerializableValueDeserializer:(id<TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy>)deserializer __attribute__((swift_name("decodeNullableSerializableValue(deserializer:)")));
- (id _Nullable)decodeSerializableValueDeserializer:(id<TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy>)deserializer __attribute__((swift_name("decodeSerializableValue(deserializer:)")));
- (int16_t)decodeShort __attribute__((swift_name("decodeShort()")));
- (NSString *)decodeString __attribute__((swift_name("decodeString()")));
@property (readonly) TrackingplanSharedKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinRandom.Default")))
@interface TrackingplanSharedKotlinRandomDefault : TrackingplanSharedKotlinRandom
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
+ (instancetype)default_ __attribute__((swift_name("init()")));
@property (class, readonly, getter=shared) TrackingplanSharedKotlinRandomDefault *shared __attribute__((swift_name("shared")));
- (int32_t)nextBitsBitCount:(int32_t)bitCount __attribute__((swift_name("nextBits(bitCount:)")));
- (BOOL)nextBoolean __attribute__((swift_name("nextBoolean()")));
- (TrackingplanSharedKotlinByteArray *)nextBytesArray:(TrackingplanSharedKotlinByteArray *)array __attribute__((swift_name("nextBytes(array:)")));
- (TrackingplanSharedKotlinByteArray *)nextBytesSize:(int32_t)size __attribute__((swift_name("nextBytes(size:)")));
- (TrackingplanSharedKotlinByteArray *)nextBytesArray:(TrackingplanSharedKotlinByteArray *)array fromIndex:(int32_t)fromIndex toIndex:(int32_t)toIndex __attribute__((swift_name("nextBytes(array:fromIndex:toIndex:)")));
- (double)nextDouble __attribute__((swift_name("nextDouble()")));
- (double)nextDoubleUntil:(double)until __attribute__((swift_name("nextDouble(until:)")));
- (double)nextDoubleFrom:(double)from until:(double)until __attribute__((swift_name("nextDouble(from:until:)")));
- (float)nextFloat __attribute__((swift_name("nextFloat()")));
- (int32_t)nextInt __attribute__((swift_name("nextInt()")));
- (int32_t)nextIntUntil:(int32_t)until __attribute__((swift_name("nextInt(until:)")));
- (int32_t)nextIntFrom:(int32_t)from until:(int32_t)until __attribute__((swift_name("nextInt(from:until:)")));
- (int64_t)nextLong __attribute__((swift_name("nextLong()")));
- (int64_t)nextLongUntil:(int64_t)until __attribute__((swift_name("nextLong(until:)")));
- (int64_t)nextLongFrom:(int64_t)from until:(int64_t)until __attribute__((swift_name("nextLong(from:until:)")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinByteArray")))
@interface TrackingplanSharedKotlinByteArray : TrackingplanSharedBase
+ (instancetype)arrayWithSize:(int32_t)size __attribute__((swift_name("init(size:)")));
+ (instancetype)arrayWithSize:(int32_t)size init:(TrackingplanSharedByte *(^)(TrackingplanSharedInt *))init __attribute__((swift_name("init(size:init:)")));
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
- (int8_t)getIndex:(int32_t)index __attribute__((swift_name("get(index:)")));
- (TrackingplanSharedKotlinByteIterator *)iterator __attribute__((swift_name("iterator()")));
- (void)setIndex:(int32_t)index value:(int8_t)value __attribute__((swift_name("set(index:value:)")));
@property (readonly) int32_t size __attribute__((swift_name("size")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreCompositeEncoder")))
@protocol TrackingplanSharedKotlinx_serialization_coreCompositeEncoder
@required
- (void)encodeBooleanElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(BOOL)value __attribute__((swift_name("encodeBooleanElement(descriptor:index:value:)")));
- (void)encodeByteElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int8_t)value __attribute__((swift_name("encodeByteElement(descriptor:index:value:)")));
- (void)encodeCharElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(unichar)value __attribute__((swift_name("encodeCharElement(descriptor:index:value:)")));
- (void)encodeDoubleElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(double)value __attribute__((swift_name("encodeDoubleElement(descriptor:index:value:)")));
- (void)encodeFloatElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(float)value __attribute__((swift_name("encodeFloatElement(descriptor:index:value:)")));
- (id<TrackingplanSharedKotlinx_serialization_coreEncoder>)encodeInlineElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("encodeInlineElement(descriptor:index:)")));
- (void)encodeIntElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int32_t)value __attribute__((swift_name("encodeIntElement(descriptor:index:value:)")));
- (void)encodeLongElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int64_t)value __attribute__((swift_name("encodeLongElement(descriptor:index:value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)encodeNullableSerializableElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index serializer:(id<TrackingplanSharedKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeNullableSerializableElement(descriptor:index:serializer:value:)")));
- (void)encodeSerializableElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index serializer:(id<TrackingplanSharedKotlinx_serialization_coreSerializationStrategy>)serializer value:(id _Nullable)value __attribute__((swift_name("encodeSerializableElement(descriptor:index:serializer:value:)")));
- (void)encodeShortElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(int16_t)value __attribute__((swift_name("encodeShortElement(descriptor:index:value:)")));
- (void)encodeStringElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index value:(NSString *)value __attribute__((swift_name("encodeStringElement(descriptor:index:value:)")));
- (void)endStructureDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("endStructure(descriptor:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)shouldEncodeElementDefaultDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("shouldEncodeElementDefault(descriptor:index:)")));
@property (readonly) TrackingplanSharedKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreSerializersModule")))
@interface TrackingplanSharedKotlinx_serialization_coreSerializersModule : TrackingplanSharedBase

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (void)dumpToCollector:(id<TrackingplanSharedKotlinx_serialization_coreSerializersModuleCollector>)collector __attribute__((swift_name("dumpTo(collector:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<TrackingplanSharedKotlinx_serialization_coreKSerializer> _Nullable)getContextualKClass:(id<TrackingplanSharedKotlinKClass>)kClass typeArgumentsSerializers:(NSArray<id<TrackingplanSharedKotlinx_serialization_coreKSerializer>> *)typeArgumentsSerializers __attribute__((swift_name("getContextual(kClass:typeArgumentsSerializers:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<TrackingplanSharedKotlinx_serialization_coreSerializationStrategy> _Nullable)getPolymorphicBaseClass:(id<TrackingplanSharedKotlinKClass>)baseClass value:(id)value __attribute__((swift_name("getPolymorphic(baseClass:value:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id<TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy> _Nullable)getPolymorphicBaseClass:(id<TrackingplanSharedKotlinKClass>)baseClass serializedClassName:(NSString * _Nullable)serializedClassName __attribute__((swift_name("getPolymorphic(baseClass:serializedClassName:)")));
@end

__attribute__((swift_name("KotlinAnnotation")))
@protocol TrackingplanSharedKotlinAnnotation
@required
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((swift_name("Kotlinx_serialization_coreSerialKind")))
@interface TrackingplanSharedKotlinx_serialization_coreSerialKind : TrackingplanSharedBase
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@end

__attribute__((swift_name("Kotlinx_serialization_coreCompositeDecoder")))
@protocol TrackingplanSharedKotlinx_serialization_coreCompositeDecoder
@required
- (BOOL)decodeBooleanElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeBooleanElement(descriptor:index:)")));
- (int8_t)decodeByteElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeByteElement(descriptor:index:)")));
- (unichar)decodeCharElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeCharElement(descriptor:index:)")));
- (int32_t)decodeCollectionSizeDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeCollectionSize(descriptor:)")));
- (double)decodeDoubleElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeDoubleElement(descriptor:index:)")));
- (int32_t)decodeElementIndexDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("decodeElementIndex(descriptor:)")));
- (float)decodeFloatElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeFloatElement(descriptor:index:)")));
- (id<TrackingplanSharedKotlinx_serialization_coreDecoder>)decodeInlineElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeInlineElement(descriptor:index:)")));
- (int32_t)decodeIntElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeIntElement(descriptor:index:)")));
- (int64_t)decodeLongElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeLongElement(descriptor:index:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (id _Nullable)decodeNullableSerializableElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index deserializer:(id<TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy>)deserializer previousValue:(id _Nullable)previousValue __attribute__((swift_name("decodeNullableSerializableElement(descriptor:index:deserializer:previousValue:)")));

/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
- (BOOL)decodeSequentially __attribute__((swift_name("decodeSequentially()")));
- (id _Nullable)decodeSerializableElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index deserializer:(id<TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy>)deserializer previousValue:(id _Nullable)previousValue __attribute__((swift_name("decodeSerializableElement(descriptor:index:deserializer:previousValue:)")));
- (int16_t)decodeShortElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeShortElement(descriptor:index:)")));
- (NSString *)decodeStringElementDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor index:(int32_t)index __attribute__((swift_name("decodeStringElement(descriptor:index:)")));
- (void)endStructureDescriptor:(id<TrackingplanSharedKotlinx_serialization_coreSerialDescriptor>)descriptor __attribute__((swift_name("endStructure(descriptor:)")));
@property (readonly) TrackingplanSharedKotlinx_serialization_coreSerializersModule *serializersModule __attribute__((swift_name("serializersModule")));
@end

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KotlinNothing")))
@interface TrackingplanSharedKotlinNothing : TrackingplanSharedBase
@end

__attribute__((swift_name("KotlinByteIterator")))
@interface TrackingplanSharedKotlinByteIterator : TrackingplanSharedBase <TrackingplanSharedKotlinIterator>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (TrackingplanSharedByte *)next __attribute__((swift_name("next()")));
- (int8_t)nextByte __attribute__((swift_name("nextByte()")));
@end


/**
 * @note annotations
 *   kotlinx.serialization.ExperimentalSerializationApi
*/
__attribute__((swift_name("Kotlinx_serialization_coreSerializersModuleCollector")))
@protocol TrackingplanSharedKotlinx_serialization_coreSerializersModuleCollector
@required
- (void)contextualKClass:(id<TrackingplanSharedKotlinKClass>)kClass provider:(id<TrackingplanSharedKotlinx_serialization_coreKSerializer> (^)(NSArray<id<TrackingplanSharedKotlinx_serialization_coreKSerializer>> *))provider __attribute__((swift_name("contextual(kClass:provider:)")));
- (void)contextualKClass:(id<TrackingplanSharedKotlinKClass>)kClass serializer:(id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)serializer __attribute__((swift_name("contextual(kClass:serializer:)")));
- (void)polymorphicBaseClass:(id<TrackingplanSharedKotlinKClass>)baseClass actualClass:(id<TrackingplanSharedKotlinKClass>)actualClass actualSerializer:(id<TrackingplanSharedKotlinx_serialization_coreKSerializer>)actualSerializer __attribute__((swift_name("polymorphic(baseClass:actualClass:actualSerializer:)")));
- (void)polymorphicDefaultBaseClass:(id<TrackingplanSharedKotlinKClass>)baseClass defaultDeserializerProvider:(id<TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy> _Nullable (^)(NSString * _Nullable))defaultDeserializerProvider __attribute__((swift_name("polymorphicDefault(baseClass:defaultDeserializerProvider:)"))) __attribute__((deprecated("Deprecated in favor of function with more precise name: polymorphicDefaultDeserializer")));
- (void)polymorphicDefaultDeserializerBaseClass:(id<TrackingplanSharedKotlinKClass>)baseClass defaultDeserializerProvider:(id<TrackingplanSharedKotlinx_serialization_coreDeserializationStrategy> _Nullable (^)(NSString * _Nullable))defaultDeserializerProvider __attribute__((swift_name("polymorphicDefaultDeserializer(baseClass:defaultDeserializerProvider:)")));
- (void)polymorphicDefaultSerializerBaseClass:(id<TrackingplanSharedKotlinKClass>)baseClass defaultSerializerProvider:(id<TrackingplanSharedKotlinx_serialization_coreSerializationStrategy> _Nullable (^)(id))defaultSerializerProvider __attribute__((swift_name("polymorphicDefaultSerializer(baseClass:defaultSerializerProvider:)")));
@end

__attribute__((swift_name("KotlinKDeclarationContainer")))
@protocol TrackingplanSharedKotlinKDeclarationContainer
@required
@end

__attribute__((swift_name("KotlinKAnnotatedElement")))
@protocol TrackingplanSharedKotlinKAnnotatedElement
@required
@end


/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
__attribute__((swift_name("KotlinKClassifier")))
@protocol TrackingplanSharedKotlinKClassifier
@required
@end

__attribute__((swift_name("KotlinKClass")))
@protocol TrackingplanSharedKotlinKClass <TrackingplanSharedKotlinKDeclarationContainer, TrackingplanSharedKotlinKAnnotatedElement, TrackingplanSharedKotlinKClassifier>
@required

/**
 * @note annotations
 *   kotlin.SinceKotlin(version="1.1")
*/
- (BOOL)isInstanceValue:(id _Nullable)value __attribute__((swift_name("isInstance(value:)")));
@property (readonly) NSString * _Nullable qualifiedName __attribute__((swift_name("qualifiedName")));
@property (readonly) NSString * _Nullable simpleName __attribute__((swift_name("simpleName")));
@end

#pragma pop_macro("_Nullable_result")
#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
