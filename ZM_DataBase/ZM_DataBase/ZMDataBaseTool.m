//
//  ZMDataBaseTool.m
//  Pods-ZM_DataBaseDemo
//
//  Created by Chin on 2018/7/25.
//

#import "ZMDataBaseTool.h"
#import <objc/runtime.h>

//文本
NSString * const SQL_Type_Text = @"TEXT";
//int long integer ...
NSString * const SQL_Type_Integer = @"INTEGER";
//浮点
NSString * const SQL_Type_Real = @"REAL";
//data
NSString * const SQL_Type_Blob = @"BLOB";
//默认数据库名称
NSString * const DATABASE_DEFAULT_NAME = @"ZM_DATABASE.sqlite";

@implementation ZMDataBaseTool

//new add
+ (NSDictionary *)transformSupportArrDictDataTypeModelToDictionary:(id)model excludeFields:(NSArray *)fieldsArr {
    
    if ([model isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)model;
    }
    else{
        Class cls = [self getClassFromModel:model];
        if (cls) {
            NSDictionary *dict = [self supportArrDictDataTypeModelToDictionary:cls excludePropertyName:fieldsArr];
            return dict;
        }
        return nil;
    }
    return nil;
}

//new add
+ (NSDictionary *)supportArrDictDataTypeModelToDictionary:(Class)cls excludePropertyName:(NSArray *)nameArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([self wetherArray:nameArr containString:name]) {
            continue;
        }
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [self supportArrDictDataTypePropertTypeConvert:type];
        if (value) {
            [mDic setObject:value forKey:name];
        }
        else{
            NSLog(@"%@自动过滤掉不支持的数据类型:%@",NSStringFromClass([self class]),name);
        }
        
    }
    free(properties);
    
    return mDic;
}

//new add
+ (NSArray *)getArrDictTypeDataNameFrom:(Class)cls
{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        
        BOOL isArrOrDict = [self wetherArrDictTypeDataName:type];
        if (isArrOrDict) {
            [mArr addObject:name];
        }
        
    }
    free(properties);
    
    return (NSArray *)mArr;
}


//new  add
+ (BOOL)wetherArrDictTypeDataName:(NSString *)typeStr
{
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        return NO;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        return NO;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        return NO;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        return NO;
    }
    else if ([typeStr hasPrefix:@"T@\"NSDictionary\""]) {
        return YES;
    }
    else if ([typeStr hasPrefix:@"T@\"NSArray\""]) {
        return YES;
    }
    else {
        //        其他类型都存成字符串
        return NO;
    }
    
    return NO;
}


//new  add
+ (NSString *)supportArrDictDataTypePropertTypeConvert:(NSString *)typeStr
{
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_Type_Text;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_Type_Blob;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_Type_Integer;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_Type_Real;
    }
    else {
        //        其他类型都存成字符串
        resultStr = SQL_Type_Text;
    }
    
    return resultStr;
}

+ (NSDictionary *)transformModelToDictionary:(id)model excludeFields:(NSArray *)fieldsArr {
    
    if ([model isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)model;
    }
    else{
        Class cls = [self getClassFromModel:model];
        if (cls) {
            NSDictionary *dict = [self modelToDictionary:cls excludePropertyName:fieldsArr];
            return dict;
        }
        return nil;
    }
    return nil;
}

+ (Class)getClassFromModel:(id)model {
    
    Class cls ;
    if ([model isKindOfClass:[NSString class]]) {
        if (!NSClassFromString(model)) {
            cls = nil;
        }
        else{
            cls = NSClassFromString(model);
        }
    }else if ([model isKindOfClass:[NSObject class]]){
        cls = [model class];
    }
    else{
        cls = model;
    }
    
    return cls;
}

#pragma mark - *************** runtime

+ (NSDictionary *)modelToDictionary:(Class)cls excludePropertyName:(NSArray *)nameArr
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        //        if ([nameArr containsObject:name]) continue;
        if ([self wetherArray:nameArr containString:name]) {
            continue;
        }
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [self propertTypeConvert:type];
        if (value) {
            [mDic setObject:value forKey:name];
        }
        else{
            NSLog(@"%@自动过滤掉不支持的数据类型:%@",NSStringFromClass([self class]),name);
        }
        
    }
    free(properties);
    
    return mDic;
}

+ (NSString *)propertTypeConvert:(NSString *)typeStr
{
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_Type_Text;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_Type_Blob;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_Type_Integer;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_Type_Real;
    }
    
    return resultStr;
}

//新增  获取model的key和value
+ (NSDictionary *)getSupportArrDictDataTypeModelPropertyKeyValue:(id)model tableName:(NSString *)tableName columnArr:(NSArray *)columnArr
{
    if ([model isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
        for (NSString *key in model){
            
            id value = model[key];
            if (value) {
                if ([value isKindOfClass:[NSString class]]) {
                    NSLog(@"[NSString class]");
                    [modelDict setObject:value forKey:key];
                }
                else if ([value isKindOfClass:[NSNumber class]]){
                    NSLog(@"[NSNumber class]");
                    [modelDict setObject:value forKey:key];
                }
                else if ([value isKindOfClass:[NSData class]]){
                    NSLog(@"[NSData class]");
                    [modelDict setObject:value forKey:key];
                }
                else if ([value isKindOfClass:[NSDictionary class]]){
                    
                    NSLog(@"[NSDictionary class]");
                    NSString *valueStr = [self transferDictOrArrToJsonStrFromData:value];
                    [modelDict setObject:valueStr forKey:key];
                }
                else if ([value isKindOfClass:[NSArray class]]){
                    NSLog(@"[NSArray class]");
                    
                    NSString *valueStr = [self transferDictOrArrToJsonStrFromData:value];
                    [modelDict setObject:valueStr forKey:key];
                    
                }
                else if ([value isKindOfClass:[NSObject class]]){
                    NSLog(@"[NSObject class]");
                    [modelDict setObject:value forKey:key];
                }
            }
        }
        
        return (NSDictionary *)modelDict;
    }
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        if (columnArr && [self wetherArray:columnArr containString:name]) {
            continue;
        }
        
        id value = [model valueForKey:name];
        NSLog(@"CLASS 类型:%@",[value class]);
        
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                NSLog(@"[NSString class]");
                [mDic setObject:value forKey:name];
            }
            else if ([value isKindOfClass:[NSNumber class]]){
                NSLog(@"[NSNumber class]");
                [mDic setObject:value forKey:name];
            }
            else if ([value isKindOfClass:[NSData class]]){
                NSLog(@"[NSData class]");
                [mDic setObject:value forKey:name];
            }
            else if ([value isKindOfClass:[NSDictionary class]]){
                NSLog(@"[NSDictionary class]");
                NSString *valueStr = [self transferDictOrArrToJsonStrFromData:value];
                [mDic setObject:valueStr forKey:name];
            }
            else if ([value isKindOfClass:[NSArray class]]){
                NSLog(@"[NSArray class]");
                
                NSString *valueStr = [self transferDictOrArrToJsonStrFromData:value];
                [mDic setObject:valueStr forKey:name];
                
            }
            else if ([value isKindOfClass:[NSObject class]]){
                NSLog(@"[NSObject class]");
                [mDic setObject:value forKey:name];
            }
            
        }
    }
    free(properties);
    
    return mDic;
}

// 获取model的key和value
+ (NSDictionary *)getModelPropertyKeyValue:(id)model tableName:(NSString *)tableName columnArr:(NSArray *)columnArr
{
    if ([model isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)model;
    }
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if (columnArr && [self wetherArray:columnArr containString:name]) {
            continue;
        }
        
        id value = [model valueForKey:name];
        NSLog(@"CLASS 类型:%@  = %@",[value class],value);
        
        if (value) {
            
            [mDic setObject:value forKey:name];
        }
    }
    free(properties);
    
    return mDic;
}
+ (NSString *)getDefaultDataBasePath {
    
    return [self getDatabasePathWithDatabaseName:DATABASE_DEFAULT_NAME];
}
+ (NSString *)getDatabasePathWithDatabaseName:(NSString *)dbName {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbName];
    return path;
}
#pragma mark Tool
+ (BOOL)wetherArray:(NSArray *)arr containString:(NSString *)str {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",str];
    NSArray *result = [arr filteredArrayUsingPredicate:predicate];
    return [result count] > 0;
}

#pragma mark Tool 字典数组转json字符串
+ (NSString *)transferDictOrArrToJsonStrFromData:(id)transferData {
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:transferData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonStr==%@",jsonStr);
    return jsonStr;
    
}
#pragma mark Tool json字符串转字典、数组
+ (NSDictionary *)transferJsonStringToDictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
