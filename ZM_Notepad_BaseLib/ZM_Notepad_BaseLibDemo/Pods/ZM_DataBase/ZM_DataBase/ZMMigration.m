//
//  ZMMigration.m
//  Pods-ZM_DataBaseDemo
//
//  Created by Chin on 2018/7/25.
//

#import "ZMMigration.h"
#import "FMDBMigrationManager.h"

@interface ZMMigration() <FMDBMigrating>

@property (nonatomic, copy)NSString * myName;
@property (nonatomic, assign)uint64_t myVersion;
@property (nonatomic, strong)NSArray * updateArray;


@end

@implementation ZMMigration

- (instancetype)initWithName:(NSString *)name andVersion:(uint64_t)version andExecuteUpdateArray:(NSArray *)updateArray
{
    if (self=[super init]) {
        _myName=name;
        _myVersion=version;
        _updateArray=updateArray;
    }
    return self;
}

- (NSString *)name
{
    return _myName;
}

- (uint64_t)version
{
    return _myVersion;
}

- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error
{
    for(NSString * updateStr in _updateArray)
    {
        [database executeUpdate:updateStr];
    }
    return YES;
}

@end
