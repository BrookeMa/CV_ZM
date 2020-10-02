//
//  ZMNDataBaseManager.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/9/6.
//

#import "ZMNDataBaseManager.h"


#define kZMNDATABASE_NAME @"zmn.sqlite"

#define kZMNDB_NOTEPAD_TABLENAME @"notepadList"
#define kZMNDB_GROUP_TABLENAME @"groupList"

@implementation ZMNDataBaseManager

+ (instancetype)shareInstance
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kZMNDATABASE_NAME];
    NSLog(@"数据库路径：%@",path);
    return [ZMNDataBaseManager shareDataBase:kZMNDATABASE_NAME];
}

+ (BOOL)createNotePadInfoDBTable
{
    NSDictionary * dict = @{
                            @"notepad":@"TEXT",                                 //数据内容(detail)
                            @"create_time":@"INTEGER",                          //创建时间
                            @"update_time":@"INTEGER",                          //更新时间
                            @"uid":@"TEXT",                                     //用户id
                            @"gid":@"TEXT",                                     //分组id
                            @"localnid":@"TEXT",                                //本地记事本id(主键)
                            @"localgid":@"TEXT",                                //本地分组id(主键)
                            @"nid":@"TEXT",                                     //记事本id
                            @"usn":@"TEXT",                                     //步数
                            @"is_top":@"BOOLEAN",                               //是否置顶
                            @"is_favorite":@"BOOLEAN",                          //是否收藏
                            @"status":@"TEXT",                                  //操作类型
                            @"status_code":@"INTEGER",                          //操作类型code
                            @"sha1":@"TEXT"                                     //sha1计算值
                            //@"":@"BOOLEAN"
                            };
    NSString * tableName = @"notepadList";
    
    BOOL success = [[ZMNDataBaseManager shareInstance] zm_createTable:tableName
                                                          dictOrModel:dict
                                                           primaryKey:@"localid"
                                                          excludeName:@[]];
    return success;
}

+ (BOOL)createGroupInfoDBTable
{
    NSDictionary * dict = @{
                            @"gname":@"TEXT",                                   //分组名
                            @"gstatus":@"TEXT",                                 //分组状态
                            @"gcount":@"INTEGER",                               //文章个数
                            @"gid":@"TEXT",                                     //分组id
                            @"localgid":@"TEXT",                                //本地分组id(主键)
                            @"uid":@"TEXT",                                     //用户id
                            @"icon":@"TEXT",                                    //ICON名
                            @"url":@"TEXT",                                     //路由URL
                            @"localgid":@"TEXT",
                            @"gcreate_time":@"INTEGER",                            //分组创建时间
                            @"gupdate_time":@"INTEGER",                            //分组更新时间
                            };
    BOOL success = [[ZMNDataBaseManager shareInstance] zm_createTable:kZMNDB_GROUP_TABLENAME
                                                          dictOrModel:dict
                                                           primaryKey:@"localgid"
                                                          excludeName:@[]];
    return success;
}

+ (BOOL)wetherExistGroupTable
{
    NSString * tableName = kZMNDB_GROUP_TABLENAME;
    BOOL isExist = [[ZMNDataBaseManager shareInstance] zm_tableExists:tableName];
    return isExist;
}

+ (BOOL)wetherExistNotepadTable
{
    BOOL isExist = [[ZMNDataBaseManager shareInstance] zm_tableExists:kZMNDB_NOTEPAD_TABLENAME];
    return isExist;
}

+ (BOOL)deleteNotepadInDBWithLocalNid:(NSString *)localNid
{
    if (localNid == nil || [localNid isEqualToString:@""]) {
        NSLog(@"%s  localNid ERROR",__func__);
        return NO;
    }
    __block BOOL deleteSuccess = NO;
    [[ZMNDataBaseManager shareInstance] zm_inDatabase:^{
        deleteSuccess = [[ZMNDataBaseManager shareInstance] zm_deleteTable:kZMNDB_NOTEPAD_TABLENAME whereFormat:@"where %@ = '%@'",@"localnid",localNid];
    }];
    return deleteSuccess;
}

+ (BOOL)deleteNotepadInDBWithLocalNid:(NSString *)localNid withUid:(NSString *)uid
{
    if (localNid == nil || [localNid isEqualToString:@""]) {
        NSLog(@"%s  localNid ERROR",__func__);
        return NO;
    }
    if (uid == nil || [uid isEqualToString:@""]) {
        NSLog(@"%s UID ERROR",__func__);
        return NO;
    }
    
    __block BOOL deleteSuccess = NO;
    [[ZMNDataBaseManager shareInstance] zm_inDatabase:^{
        deleteSuccess = [[ZMNDataBaseManager shareInstance] zm_deleteTable:kZMNDB_NOTEPAD_TABLENAME whereFormat:@"where %@ = '%@' and %@ = '%@' ",@"localnid",localNid,@"uid",uid];
    }];
    return deleteSuccess;
}

/**
 插入笔记

 @param nodepad 数据内容(detail)
 @param createTime 创建时间
 @param updateTime 更新时间
 @param uid 用户id
 @param gid 分组id
 @param localnid 本地记事本id(主键)
 @param localgid 本地分组id(主键)
 @param nid 记事本id
 @param usn 步数
 @param isTop 是否置顶
 @param isFavorite 是否收藏
 @param status 操作类型
 @param statusCode 操作类型code
 @param sha1 sha1计算值
 @return 是否插入成功
 */
+ (BOOL)insertNotesInDBWithNotepad:(NSString *)nodepad
                        createTime:(NSNumber *)createTime
                        updateTime:(NSNumber *)updateTime
                               uid:(NSString *)uid
                               gid:(NSString *)gid
                          localnid:(NSString *)localnid
                          localgid:(NSString *)localgid
                               nid:(NSString *)nid
                               usn:(NSString *)usn
                             isTop:(BOOL)isTop
                        isFavorite:(BOOL)isFavorite
                            status:(NSString *)status
                        statusCode:(NSNumber *)statusCode
                              sha1:(NSString *)sha1 {
    if (nodepad == nil   || [nodepad isEqualToString:@""]   ||
        gid == nil       ||
        uid == nil  ) {
        return NO;
    }
    
    NSDictionary * dic = @{
                           @"notepad":nodepad,
                           @"create_time":createTime,
                           @"update_time":updateTime,
                           @"uid":uid,
                           @"gid":gid,
                           @"localnid":localnid,
                           @"localgid":localgid,
                           @"nid":nid,
                           @"usn":usn,
                           @"is_top":[NSNumber numberWithBool:isTop],
                           @"is_favorite":[NSNumber numberWithBool:isFavorite],
                           @"status":status,
                           @"status_code":statusCode,
                           @"sha1":sha1
                           };
    
    BOOL success = [[ZMNDataBaseManager shareInstance] zm_insertTable:kZMNDB_NOTEPAD_TABLENAME dictOrModel:dic];

    return success;
}


/*
 @"gname":@"TEXT",                                   //分组名
 @"gstatus":@"INTEGER",                              //分组状态
 @"gcount":@"INTEGER",                               //文章个数
 @"gid":@"INTEGER",                                  //分组id
 @"localgid":@"INTEGER",                             //本地分组id(主键)
 @"uid":@"INTEGER",                                  //用户id
 @"localgid":@"INTEGER",
 @"gcreate_time":@"TEXT",                            //分组创建时间
 @"gupdate_time":@"TEXT",                            //分组更新时间
 */
+ (BOOL)insertGroupInDBWithGname:(NSString *)gname
                         withGid:(NSString *)gid
                     withGstatus:(NSString *)gstatus
                         withUid:(NSString *)uid
                        withIcon:(NSString *)icon
                         withURL:(NSString *)url
                  withCreateTime:(NSString *)createTime
                  withUpdateTime:(NSString *)updateTime
{
    if (gname == nil   || [gname isEqualToString:@""]     ||
        gstatus == nil ||
        uid == nil
//        createTime == nil || [createTime isEqualToString:@""] ||
//        updateTime == nil || [updateTime isEqualToString:@""]
        ) {
        return NO;
    }
    
    if (url == nil) {
        url = @"";
    }
    if (icon == nil) {
        icon = @"";
    }
    
    NSDictionary * dic = @{
                           @"gname":gname,
                           @"gstatus":gstatus,
                           @"gid":gid,
                           @"uid":uid,
                           @"icon":icon,                                    //ICON名
                           @"url":url,                                     //路由URL
                           @"gcreate_time":createTime,
                           @"gupdate_time":updateTime
                           };
    
    BOOL success = [[ZMNDataBaseManager shareInstance] zm_insertTable:kZMNDB_GROUP_TABLENAME dictOrModel:dic];
    
    return success;
}

+ (BOOL)deleteGroupListInDBWithUid:(NSString *)uid
{
    if (uid == nil || [uid isEqualToString:@""]) {
        return NO;
    }
    BOOL success = [[ZMNDataBaseManager shareInstance] zm_deleteTable:kZMNDB_GROUP_TABLENAME whereFormat:@"where %@ = '%@'",@"uid",uid];
    return success;
}

+ (BOOL)deleteGroupListInDBWithUid:(NSString *)uid withGid:(NSString *)gId
{
    if (uid == nil || [uid isEqualToString:@""] ||
        gId == nil || [gId isEqualToString:@""]) {
        return NO;
    }
    BOOL success = [[ZMNDataBaseManager shareInstance] zm_deleteTable:kZMNDB_GROUP_TABLENAME whereFormat:@"where %@ = '%@' and %@ = '%@'",@"uid",uid,@"gid",gId];
    return success;
}

+ (NSArray *)getGroupListInDBWithUid:(NSString *)uid
{
    if (uid == nil || [uid isEqualToString:@""]) {
        NSLog(@"%s Error",__func__);
        return nil;
    }
    
    __block NSArray * groupList = nil;
    [[ZMNDataBaseManager shareInstance] zm_inDatabase:^{
       groupList = [[ZMNDataBaseManager shareInstance] zm_lookupTable:kZMNDB_GROUP_TABLENAME dictOrModel:nil whereFormat:@"where %@ = '%@'",@"uid",uid];
        NSLog(@"BBB %@",groupList);
    }];
    return groupList;
}

@end
