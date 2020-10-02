//
//  ZMMigration.h
//  Pods-ZM_DataBaseDemo
//
//  Created by Chin on 2018/7/25.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface ZMMigration : NSObject

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) uint64_t version;

- (instancetype)initWithName:(NSString *)name andVersion:(uint64_t)version andExecuteUpdateArray:(NSArray *)updateArray;//自定义方法

- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error;

@end
