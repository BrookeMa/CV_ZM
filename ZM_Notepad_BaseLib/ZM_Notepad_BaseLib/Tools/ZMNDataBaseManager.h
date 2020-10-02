//
//  ZMNDataBaseManager.h
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import "ZMDataBase.h"

typedef NS_ENUM(NSInteger,GStatus){
    GStatus_Insert                  =   1,                                      //添加
    GStatus_Delete                  =   2                                       //删除
};

@interface ZMNDataBaseManager : ZMDataBase

+ (instancetype)shareInstance;

/**
 创建笔记本

 @return 创建成功 OR 失败
 */
+ (BOOL)createNotePadInfoDBTable;

/**
 创建分组表

 @return 成功 OR 失败
 */
+ (BOOL)createGroupInfoDBTable;

/**
 判断是否存在分组表

 @return 存在 OR 不存在
 */
+ (BOOL)wetherExistGroupTable;

/**
 判断是否存在笔记本表

 @return 存在 OR 不存在
 */
+ (BOOL)wetherExistNotepadTable;

/**
 通过本地NID删除笔记

 @param localNid 本地NID
 @return 成功 OR 失败
 */
+ (BOOL)deleteNotepadInDBWithLocalNid:(NSString *)localNid;

/**
 通过本地NID和UID删除笔记

 @param localNid 本地NID
 @param uid UID
 @return 成功 OR 失败
 */
+ (BOOL)deleteNotepadInDBWithLocalNid:(NSString *)localNid withUid:(NSString *)uid;


+ (BOOL)deleteGroupListInDBWithUid:(NSString *)uid;

+ (BOOL)deleteGroupListInDBWithUid:(NSString *)uid withGid:(NSString *)gId;


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
                              sha1:(NSString *)sha1;

+ (BOOL)insertGroupInDBWithGname:(NSString *)gname
                         withGid:(NSString *)gid
                     withGstatus:(NSString *)gstatus
                         withUid:(NSString *)uid
                        withIcon:(NSString *)icon
                         withURL:(NSString *)url
                  withCreateTime:(NSString *)createTime
                  withUpdateTime:(NSString *)updateTime;


/**
 通过UID获取分组列表

 @param uid UID.
 @return 分组列表数据.
 */
+ (NSArray *)getGroupListInDBWithUid:(NSString *)uid;

@end
