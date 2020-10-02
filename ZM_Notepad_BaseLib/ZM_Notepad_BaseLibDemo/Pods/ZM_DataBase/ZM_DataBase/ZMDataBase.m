//
//  ZMDataBase.m
//  ZM_DataBase
//
//  Created by Chin on 2018/7/25.
//

#import "ZMDataBase.h"
#import "FMDB.h"

#define TABLE_PRIMARY_KEY @"zmdbid"

static FMDatabaseQueue * queue = nil;
static ZMDataBase * dataBase   = nil;

@interface ZMDataBase()

@property (nonatomic, strong)NSString * dbPath;
@property (nonatomic, strong)FMDatabaseQueue *dbQueue;
@property (nonatomic, strong)FMDatabase *db;

@end

@implementation ZMDataBase

+ (instancetype)shareDataBase {
    return [ZMDataBase shareDataBase:nil];
}

+ (instancetype)shareDataBase:(NSString *)dbName {
    return [ZMDataBase shareDataBase:dbName storagePath:nil];
}

+ (instancetype)shareDataBase:(NSString *)dbName storagePath:(NSString *)dbStoragePath {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *dataBaseName = dbName;
        NSString *path = dbStoragePath;
        if (!dbName) {
            dataBaseName = DATABASE_DEFAULT_NAME;
        }
        if (!path) {
            path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dataBaseName];
        } else {
            path = [path stringByAppendingPathComponent:dataBaseName];
        }
        FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
        if ([fmdb open]) {
            dataBase = [[self alloc] init];
            dataBase.db = fmdb;
            dataBase.dbPath = path;
        }
    });
    
    if (![dataBase.db open]) {
        NSAssert([dataBase.db open],@"数据库打开失败!");
        NSLog(@"database can not open !");
        return nil;
    }
    return dataBase;
}

- (FMDatabaseQueue *)dbQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FMDatabaseQueue *fmdb = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        queue = fmdb;
        self.db = [fmdb valueForKey:@"_db"];
        
    });
    
    return queue;
}

- (instancetype)initWithDBName:(NSString *)dbName
{
    return [self initWithDBName:dbName path:nil];
}

- (instancetype)initWithDBName:(NSString *)dbName path:(NSString *)dbPath
{
    NSString *dataBaseName = dbName;
    NSString *path = dbPath;
    if (!dbName) {
        dataBaseName = DATABASE_DEFAULT_NAME;
    }
    if (!dbPath) {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dataBaseName];
    } else {
        path = [path stringByAppendingPathComponent:dataBaseName];
    }
    FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
    if ([fmdb open]) {
        self = [super init];
        if (self) {
            self.db = fmdb;
            self.dbPath = path;
            return self;
        }
    }
    return nil;
}
#pragma mark 创建表
- (BOOL)zm_createTable:(NSString *)tableName dictOrModel:(id)parameters {
    
    return [self zm_createTable:tableName dictOrModel:parameters excludeName:nil];
}

- (BOOL)zm_createTable:(NSString *)tableName dictOrModel:(id)parameters excludeName:(NSArray *)fieldsArr {
    
    return [self zm_createTable:tableName dictOrModel:parameters primaryKey:nil excludeName:fieldsArr];
}

- (BOOL)zm_createTable:(NSString *)tableName dictOrModel:(id)parameters  primaryKey:(NSString *)primaryKey  excludeName:(NSArray *)fieldsArr {
    
    NSAssert(tableName,@"表名不能为空!");
    NSAssert(parameters,@"字典或模型变量名影射集合不能为空!");
    NSString *primaryKeyStr = primaryKey;
    if (!primaryKeyStr||[primaryKeyStr isEqualToString:@""]) {
        primaryKeyStr = TABLE_PRIMARY_KEY;
    }
    BOOL isExists = [self zm_tableExists:tableName];
    if (!isExists) {
        NSDictionary *dict = [ZMDataBaseTool transformModelToDictionary:parameters excludeFields:fieldsArr];
        NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@  INTEGER PRIMARY KEY,", tableName,primaryKeyStr];
        int keyCount = 0;
        for (NSString *key in dict) {
            keyCount++;
            
            if ((fieldsArr && [self wetherArray:fieldsArr containString:key]) || [key isEqualToString:primaryKeyStr]) {
                continue;
            }
            
            [fieldStr appendFormat:@" %@ %@,", key, dict[key]];
        }
        [fieldStr replaceCharactersInRange:NSMakeRange([fieldStr length]-1, 1) withString:@")"];
        
        NSLog(@"SQL=CREATE_TABLE=%@",fieldStr);
        BOOL creatFlag;
        creatFlag = [_db executeUpdate:fieldStr];
        if (!creatFlag) {
            NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
        }
        return creatFlag;
    }
    else{
        NSLog(@"%@_已经存在了",tableName);
        return NO;
    }
    return YES;
}


//new  add
- (BOOL)zm_createTableWithSupportArrDictDataTypeModel:(id)parameters {
    
    NSAssert(parameters,@"模型变量名影射集合不能为空!");
    NSString *primaryKeyStr = TABLE_PRIMARY_KEY;
    
    NSString *tableName = NSStringFromClass([parameters class]);
    
    BOOL isExists = [self zm_tableExists:tableName];
    if (!isExists) {
        NSDictionary *dict = [ZMDataBaseTool transformSupportArrDictDataTypeModelToDictionary:parameters excludeFields:nil];
        NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@  INTEGER PRIMARY KEY,", tableName,primaryKeyStr];
        int keyCount = 0;
        for (NSString *key in dict) {
            keyCount++;
            if ([key isEqualToString:primaryKeyStr]) {
                continue;
            }
            [fieldStr appendFormat:@" %@ %@,", key, dict[key]];
        }
        [fieldStr replaceCharactersInRange:NSMakeRange([fieldStr length]-1, 1) withString:@")"];
        
        NSLog(@"SQL=CREATE_TABLE=%@",fieldStr);
        BOOL creatFlag;
        creatFlag = [_db executeUpdate:fieldStr];
        if (!creatFlag) {
            NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
        }
        return creatFlag;
    }
    else{
        NSLog(@"%@_已经存在了",tableName);
        return NO;
    }
    return YES;
    
}
- (BOOL)zm_createTableWithModel:(id)parameters {
    
    NSAssert(parameters,@"模型变量名影射集合不能为空!");
    NSString *primaryKeyStr = TABLE_PRIMARY_KEY;
    
    NSString *tableName = NSStringFromClass([parameters class]);
    
    BOOL isExists = [self zm_tableExists:tableName];
    if (!isExists) {
        NSDictionary *dict = [ZMDataBaseTool transformModelToDictionary:parameters excludeFields:nil];
        NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@  INTEGER PRIMARY KEY,", tableName,primaryKeyStr];
        int keyCount = 0;
        for (NSString *key in dict) {
            keyCount++;
            if ([key isEqualToString:primaryKeyStr]) {
                continue;
            }
            [fieldStr appendFormat:@" %@ %@,", key, dict[key]];
        }
        [fieldStr replaceCharactersInRange:NSMakeRange([fieldStr length]-1, 1) withString:@")"];
        
        NSLog(@"SQL=CREATE_TABLE=%@",fieldStr);
        BOOL creatFlag;
        creatFlag = [_db executeUpdate:fieldStr];
        if (!creatFlag) {
            NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
        }
        return creatFlag;
    }
    else{
        NSLog(@"%@_已经存在了",tableName);
        return NO;
    }
    return YES;
    
}
- (BOOL)zm_tableExists:(NSString *)tableName {
    
    BOOL isExists = [self.db tableExists:tableName];
    return isExists;
}

- (NSArray *)getTableColumnsFromTable:(NSString *)tableName {
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *resultSet = [self.db getTableSchema:tableName];
    
    while ([resultSet next]) {
        [mArr addObject:[resultSet stringForColumn:@"name"]];
    }
    [resultSet close];
    return (NSArray *)mArr;
}


#pragma mark 数据库表数据操作  增、删、改、查


/*
 新增
 */

- (BOOL)zm_insertTableWithSupportArrDictDataTypeModel:(id)model {
    
    NSString *tableName = NSStringFromClass([model class]);
    
    return [self zm_insertTable:tableName WithSupportArrDictDataTypeDict:model];
}
/*
 新增
 */
- (BOOL)zm_insertTable:(NSString *)tableName WithSupportArrDictDataTypeDict:(id)parameters {
    
    BOOL flag;
    NSArray *columnArr = nil;
    NSDictionary *dic = [ZMDataBaseTool getSupportArrDictDataTypeModelPropertyKeyValue:parameters tableName:tableName columnArr:columnArr];
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in dic) {
        
        if ([self wetherArray:columnArr containString:key] || [key isEqualToString:TABLE_PRIMARY_KEY]) {
            continue;
        }
        [finalStr appendFormat:@"%@,", key];
        [tempStr appendString:@"?,"];
        
        [argumentsArr addObject:dic[key]];
    }
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (tempStr.length)
        [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];
    
    [finalStr appendFormat:@") values (%@)", tempStr];
    NSLog(@"insert语句：%@",finalStr);
    flag = [self.db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    if (!flag) {
        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
    }
    return flag;
}

/**
 表中插入数据 自定义Model
 
 @param model 自定义Model
 @return 插入数据成功失败
 */
- (BOOL)zm_insertTableWithModel:(id)model {
    NSAssert(model,@"模型变量名影射集合不能为空!");
    NSString *tableName = NSStringFromClass([model class]);
    //    NSArray *columnArr = [self getTableColumnsFromTable:tableName];
    return [self zm_insertTable:tableName dictOrModel:model columnArr:nil];
}

/**
 表中插入数据
 
 @param tableName 表名
 @param parameters 数据模型或者字典
 @return 插入成功或者失败
 */
- (BOOL)zm_insertTable:(NSString *)tableName dictOrModel:(id)parameters {
    //    NSArray *columnArr = [self getTableColumnsFromTable:tableName];
    return [self zm_insertTable:tableName dictOrModel:parameters columnArr:nil];
}

- (BOOL)zm_insertTable:(NSString *)tableName dictOrModel:(id)parameters columnArr:(NSArray *)columnArr {
    
    BOOL flag;
    NSDictionary *dic = [ZMDataBaseTool getModelPropertyKeyValue:parameters tableName:tableName columnArr:columnArr];
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *tempStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in dic) {
        
        if ([self wetherArray:columnArr containString:key] || [key isEqualToString:TABLE_PRIMARY_KEY]) {
            continue;
        }
        [finalStr appendFormat:@"%@,", key];
        [tempStr appendString:@"?,"];
        
        [argumentsArr addObject:dic[key]];
    }
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (tempStr.length)
        [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];
    
    [finalStr appendFormat:@") values (%@)", tempStr];
    NSLog(@"insert语句：%@",finalStr);
    flag = [self.db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    if (!flag) {
        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
    }
    return flag;
}

// 直接传一个array插入
- (NSArray *)zm_insertTable:(NSString *)tableName dicOrModelArray:(NSArray *)dicOrModelArray
{
    int errorIndex = 0;
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    for (id parameters in dicOrModelArray) {
        
        BOOL flag = [self zm_insertTable:tableName dictOrModel:parameters columnArr:nil];
        if (!flag) {
            [resultMArr addObject:@(errorIndex)];
        }
        errorIndex++;
    }
    
    return resultMArr;
}

/**
 删除表中数据
 
 @param tableName 表名
 @param format 删除条件 未设置条件 传@""  空字符串  请勿传 nil
 @return 成功失败
 */
- (BOOL)zm_deleteTable:(NSString *)tableName whereFormat:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc]initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@ ", tableName];
    if (where.length){
        [finalStr appendFormat:@" %@", where];
    }
    NSLog(@"delete语句=%@",finalStr);
    flag = [self.db executeUpdate:finalStr];
    if (!flag) {
        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
    }
    return flag;
}
- (BOOL)zm_deleteAllDataFromTable:(NSString *)tableName
{
    return [self zm_deleteTable:tableName whereFormat:@""];
}

/**
 删除表中数据  自定义model
 
 @param modelClass model
 @param format 条件
 @return 成功失败
 */
- (BOOL)zm_deleteTableWithModel:(Class)modelClass whereFormat:(NSString *)format, ... {
    
    NSAssert(modelClass, @"传入model不能为空!");
    NSString *tableName = NSStringFromClass(modelClass);
    
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    
    BOOL flag;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@ ", tableName];
    if (where.length){
        [finalStr appendFormat:@" %@", where];
    }
    NSLog(@"delete语句=%@",finalStr);
    flag = [self.db executeUpdate:finalStr];
    if (!flag) {
        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
    }
    return flag;
}
/*
 新增
 */
- (BOOL)zm_updateTableWithSupportArrDictDataTypeModel:(id)parameters whereFormat:(NSString *)format, ... {
    
    NSAssert(parameters,@"模型变量名影射集合不能为空!");
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    NSLog(@"%@",where);
    va_end(args);
    
    NSString *tableName = NSStringFromClass([parameters class]);
    
    return [self zm_updateTable:tableName withSupportArrDictDataTypeDictOrModel:parameters whereQueryString:where];
}
- (BOOL)zm_updateTable:(NSString *)tableName withSupportArrDictDataTypeDictOrModel:(id)parameters whereQueryString:(NSString *)where {
    
    BOOL flag ;
    NSDictionary *dic;
    NSArray *columnArr = nil;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        
        dic = [ZMDataBaseTool getSupportArrDictDataTypeModelPropertyKeyValue:parameters tableName:tableName columnArr:columnArr];
        //        parameters;
    }
    else{
        dic = [ZMDataBaseTool getSupportArrDictDataTypeModelPropertyKeyValue:parameters tableName:tableName columnArr:columnArr];
    }
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in dic) {
        
        if ([self wetherArray:columnArr containString:key] || [key isEqualToString:TABLE_PRIMARY_KEY]) {
            continue;
        }
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (where.length) [finalStr appendFormat:@" %@", where];
    NSLog(@"update 语句 === %@",finalStr);
    
    flag = [self.db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    
    if (!flag) {
        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
    }
    NSLog(@"update table语句 = %d",flag);
    return flag;
}


/**
 更新数据 自定义model
 
 @param parameters model
 @param format 可变参数
 @return 成功失败
 */
- (BOOL)zm_updateTableWithModel:(id)parameters whereFormat:(NSString *)format, ... {
    
    NSAssert(parameters,@"模型变量名影射集合不能为空!");
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    NSLog(@"%@",where);
    va_end(args);
    
    NSString *tableName = NSStringFromClass([parameters class]);
    return [self zm_updateTable:tableName dictOrModel:parameters whereQueryString:where?where:@""];
    
}

- (BOOL)zm_updateTable:(NSString *)tableName dictOrModel:(id)parameters whereFormat:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    
    return [self zm_updateTable:tableName dictOrModel:parameters whereQueryString:where?where:@""];
}

- (BOOL)zm_updateTable:(NSString *)tableName dictOrModel:(id)parameters whereQueryString:(NSString *)where {
    
    BOOL flag ;
    NSDictionary *dic;
    NSArray *columnArr = nil;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    }
    else{
        dic = [ZMDataBaseTool getModelPropertyKeyValue:parameters tableName:tableName columnArr:columnArr];
    }
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"update %@ set ", tableName];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in dic) {
        
        if ([self wetherArray:columnArr containString:key] || [key isEqualToString:TABLE_PRIMARY_KEY]) {
            continue;
        }
        [finalStr appendFormat:@"%@ = %@,", key, @"?"];
        [argumentsArr addObject:dic[key]];
    }
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (where.length) [finalStr appendFormat:@" %@", where];
    NSLog(@"update 语句 === %@",finalStr);
    
    flag = [self.db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    
    if (!flag) {
        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
    }
    NSLog(@"update table语句 = %d",flag);
    return flag;
}


/**
 查询数据  自定义model
 
 @param parameters 自定义model
 @param format 查询条件
 @return 查询的数据  数组
 */
- (NSArray *)zm_lookupTableWithModel:(id)parameters whereFormat:(NSString *)format, ... {
    NSAssert(parameters,@"模型变量名影射集合不能为空!");
    
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    
    NSString *tableName = NSStringFromClass([parameters class]);
    NSLog(@"where = %@",where);
    return [self zm_lookupTable:tableName dictOrModel:parameters whereQueryString:where?where:@""];
    
}
- (NSArray *)zm_lookupTable:(NSString *)tableName dictOrModel:(id)parameters whereFormat:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    
    return  [self zm_lookupTable:tableName dictOrModel:parameters whereQueryString:where?where:@""];
}

- (NSArray *)zm_lookupTable:(NSString *)tableName dictOrModel:(id)parameters whereQueryString:(NSString *)where {
    
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@", tableName, where?where:@""];
    NSArray *columnArr = [self getTableColumnsFromTable:tableName];
    FMResultSet * set = [self.db executeQuery:finalStr];
    if (!parameters) {
        while ([set next]) {
            
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            for (int i=0;i<[[[set columnNameToIndexMap] allKeys] count];i++) {
                dictM[[set columnNameForIndex:i]] = [set objectForColumnIndex:i];
                NSLog(@"%@ === %@",[set columnNameForIndex:i],[set objectForColumnIndex:i]);
            }
            [resultMArr addObject:dictM];
        }
        //查询完后要关闭set，不然会报@"Warning: there is at least one open result set around after performing
        [set close];
        
    }
    else if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
        
        while ([set next]) {
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
            for (NSString *key in dic) {
                
                if ([dic[key] isEqualToString:SQL_Type_Text]) {
                    id value = [set stringForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                } else if ([dic[key] isEqualToString:SQL_Type_Integer]) {
                    [resultDic setObject:@([set longLongIntForColumn:key]) forKey:key];
                } else if ([dic[key] isEqualToString:SQL_Type_Real]) {
                    [resultDic setObject:[NSNumber numberWithDouble:[set doubleForColumn:key]] forKey:key];
                } else if ([dic[key] isEqualToString:SQL_Type_Blob]) {
                    id value = [set dataForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                }
            }
            
            if (resultDic) [resultMArr addObject:resultDic];
        }
        
    }
    else {
        
        Class cls = [ZMDataBaseTool getClassFromModel:parameters];
        if (cls) {
            NSDictionary *propertyType = [ZMDataBaseTool modelToDictionary:cls excludePropertyName:nil];
            while ([set next]) {
                id model = [[cls alloc]init];//cls.new;
                for (NSString *name in columnArr) {
                    if ([propertyType[name] isEqualToString:SQL_Type_Text]) {
                        id value = [set stringForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_Type_Integer]) {
                        [model setValue:@([set longLongIntForColumn:name]) forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_Type_Real]) {
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_Type_Blob]) {
                        id value = [set dataForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    }
                }
                
                [resultMArr addObject:model];
            }
            
            //查询完后要关闭set，不然会报@"Warning: there is at least one open result set around after performing
            [set close];
        }
    }
    
    return resultMArr;
    
}


- (NSArray *)zm_lookupSupportArrDictDataTypeTableWithModel:(id)parameters whereFormat:(NSString *)format, ... {
    NSAssert(parameters,@"模型变量名影射集合不能为空!");
    
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    
    NSString *tableName = NSStringFromClass([parameters class]);
    NSLog(@"where = %@",where);
    return [self zm_lookupSupportArrDictDataTypeTable:tableName dictOrModel:parameters whereQueryString:where?where:@""];
    
}
- (NSArray *)zm_lookupSupportArrDictDataTypeTable:(NSString *)tableName dictOrModel:(id)parameters whereFormat:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    
    return  [self zm_lookupSupportArrDictDataTypeTable:tableName dictOrModel:parameters whereQueryString:where?where:@""];
}

- (NSArray *)zm_lookupSupportArrDictDataTypeTable:(NSString *)tableName dictOrModel:(id)parameters whereQueryString:(NSString *)where {
    
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@", tableName, where?where:@""];
    NSArray *columnArr = [self getTableColumnsFromTable:tableName];
    FMResultSet * set = [self.db executeQuery:finalStr];
    if (!parameters) {
        while ([set next]) {
            
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            for (int i=0;i<[[[set columnNameToIndexMap] allKeys] count];i++) {
                dictM[[set columnNameForIndex:i]] = [set objectForColumnIndex:i];
                NSLog(@"%@ === %@",[set columnNameForIndex:i],[set objectForColumnIndex:i]);
            }
            [resultMArr addObject:dictM];
        }
        //查询完后要关闭set，不然会报@"Warning: there is at least one open result set around after performing
        [set close];
        
    }
    else if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
        
        while ([set next]) {
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
            for (NSString *key in dic) {
                
                if ([dic[key] isEqualToString:SQL_Type_Text]) {
                    id value = [set stringForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                } else if ([dic[key] isEqualToString:SQL_Type_Integer]) {
                    [resultDic setObject:@([set longLongIntForColumn:key]) forKey:key];
                } else if ([dic[key] isEqualToString:SQL_Type_Real]) {
                    [resultDic setObject:[NSNumber numberWithDouble:[set doubleForColumn:key]] forKey:key];
                } else if ([dic[key] isEqualToString:SQL_Type_Blob]) {
                    id value = [set dataForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                }
            }
            
            if (resultDic) [resultMArr addObject:resultDic];
        }
        
    }
    else {
        
        Class cls = [ZMDataBaseTool getClassFromModel:parameters];
        if (cls) {
            NSDictionary *propertyType = [ZMDataBaseTool supportArrDictDataTypeModelToDictionary:cls excludePropertyName:nil];
            
            NSArray *arrOrDictNameArr = [ZMDataBaseTool getArrDictTypeDataNameFrom:cls];
            while ([set next]) {
                id model = [[cls alloc]init];//cls.new;
                
                for (NSString *name in columnArr) {
                    
                    if ([propertyType[name] isEqualToString:SQL_Type_Text]) {
                        id value = [set stringForColumn:name];
                        if (value){
                            BOOL isHave = [self wetherArray:arrOrDictNameArr containString:name];
                            if (isHave) {
                                NSDictionary *transferDict = [ZMDataBaseTool transferJsonStringToDictionaryWithJsonString:value];
                                if (transferDict) {
                                    [model setValue:transferDict forKey:name];
                                }
                            }
                            else{
                                [model setValue:value forKey:name];
                            }
                        }
                    } else if ([propertyType[name] isEqualToString:SQL_Type_Integer]) {
                        [model setValue:@([set longLongIntForColumn:name]) forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_Type_Real]) {
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    } else if ([propertyType[name] isEqualToString:SQL_Type_Blob]) {
                        id value = [set dataForColumn:name];
                        if (value)
                            [model setValue:value forKey:name];
                    }
                }
                
                [resultMArr addObject:model];
            }
            
            //查询完后要关闭set，不然会报@"Warning: there is at least one open result set around after performing
            [set close];
        }
    }
    
    return resultMArr;
}



/**
 删除一个表
 
 @param tableName 表名
 @return 成功失败
 */
- (BOOL)zm_dropTable:(NSString *)tableName {
    NSString *sqlStr = [NSString stringWithFormat:@"drop table %@",tableName];
    BOOL flag = [self.db executeUpdate:sqlStr];
    if (!flag) {
        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
    }
    return flag;
}
- (NSInteger)zm_tableItemCount:(NSString *)tableName
{
    
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next])
    {
        return [set intForColumn:@"count"];
    }
    [set close];
    return 0;
}

- (void)close
{
    [self.db close];
}

- (void)open
{
    [self.db open];
}


- (BOOL)zm_alterTable:(NSString *)tableName newTableName:(NSString *)newTableName
{
    __block BOOL flag ;
    [self zm_inTransaction:^(BOOL *rollback) {
        
        flag = [self.db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", tableName, newTableName]];
        if (!flag) {
            *rollback = YES;
            NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
            return ;
        }
    }];
    return flag;
}

- (BOOL)zm_alterTable:(NSString *)tableName addColumnWithDictOrModel:(id)parameters
{
    return [self zm_alterTable:tableName addColumnWithDictOrModel:parameters excludeName:nil];
}

- (BOOL)zm_alterTable:(NSString *)tableName addColumnWithDictOrModel:(id)parameters excludeName:(NSArray *)nameArr
{
    __block BOOL flag;
    [self zm_inTransaction:^(BOOL *rollback) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in parameters) {
                if ([self wetherArray:nameArr containString:key]) {
                    continue;
                }
                flag = [self.db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, parameters[key]]];
                if (!flag) {
                    *rollback = YES;
                    NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
                    
                    return;
                }
            }
            
        } else {
            Class CLS = [ZMDataBaseTool getClassFromModel:parameters];
            NSDictionary *modelDic = [ZMDataBaseTool modelToDictionary:CLS excludePropertyName:nameArr];
            NSArray *columnArr = [self getTableColumnsFromTable:tableName];
            for (NSString *key in modelDic) {
                if (![self wetherArray:columnArr containString:key] && ![self wetherArray:nameArr containString:key]) {
                    flag = [self.db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, modelDic[key]]];
                    if (!flag) {
                        *rollback = YES;
                        NSLog(@"Error Code:%d :Error Message=%@",[self.db lastErrorCode],[self.db lastErrorMessage]);
                        
                        return;
                    }
                }
            }
        }
    }];
    return flag;
}
#pragma mark 线程安全

- (void)zm_inDatabase:(void(^)(void))block {
    
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        block();
    }];
}

- (void)zm_inTransaction:(void(^)(BOOL *rollback))block {
    
    [self.dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        block(rollback);
    }];
}
#pragma mark 获取 sql alter  create table string  语句

- (NSString *)zm_getCreateTableSQLStringWithModel:(id)model {
    
    NSDictionary *dict = [ZMDataBaseTool transformModelToDictionary:model excludeFields:nil];
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (%@  INTEGER PRIMARY KEY,", NSStringFromClass([model class]),TABLE_PRIMARY_KEY];
    int keyCount = 0;
    for (NSString *key in dict) {
        keyCount++;
        
        [fieldStr appendFormat:@" %@ %@,", key, dict[key]];
    }
    [fieldStr replaceCharactersInRange:NSMakeRange([fieldStr length]-1, 1) withString:@")"];
    NSLog(@"SQL=CREATE_TABLE=%@",fieldStr);
    return fieldStr;
}

- (NSArray *)zm_getAddColumnSQLStringWithModel:(id)model {
    
    NSDictionary *dict = [ZMDataBaseTool transformModelToDictionary:model excludeFields:nil];
    NSArray *columnArr = [self getTableColumnsFromTable:NSStringFromClass([model class])];
    NSArray *arr = [[dict allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)",columnArr]];
    NSLog(@"add column = %@",arr);
    NSString *tableName = NSStringFromClass([model class]);
    NSMutableArray *sqlArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in arr) {
        NSString *sqlStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", tableName, key, dict[key]];
        [sqlArr addObject:sqlStr];
    }
    if ([sqlArr count]>0) {
        return (NSArray *)sqlArr;
    }
    return nil;
    
    
}
- (long long int)lastInsertPrimaryKeyIdFromTableName:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = (SELECT max(%@) FROM %@)", tableName, TABLE_PRIMARY_KEY,TABLE_PRIMARY_KEY,tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next])
    {
        long long int pkid = [set longLongIntForColumn:TABLE_PRIMARY_KEY];
        [set close];
        return pkid;
    }
    
    return 0;
}

- (NSArray *)zm_lookupAllTablesInDatabase {
    
    NSString *sqlstr = @"select name from sqlite_master  where type = 'table' order by name";
    FMResultSet *set = [self.db executeQuery:sqlstr];
    NSMutableArray *tableArr = [NSMutableArray arrayWithCapacity:0];
    while ([set next])
    {
        NSString *tableNameStr = [set stringForColumn:@"name"];
        [tableArr addObject:tableNameStr];
    }
    [set close];
    
    return (NSArray *)tableArr;
}

- (BOOL)zm_executeUpdate:(NSString *)format, ... {
    
    va_list args;
    va_start(args, format);
    
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    
    va_end(args);
    
    BOOL result = [self.db executeUpdate:where];
    
    return result;
}

#pragma mark Tool
- (BOOL)wetherArray:(NSArray *)arr containString:(NSString *)str {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",str];
    NSArray *result = [arr filteredArrayUsingPredicate:predicate];
    return [result count] > 0;
}


@end
