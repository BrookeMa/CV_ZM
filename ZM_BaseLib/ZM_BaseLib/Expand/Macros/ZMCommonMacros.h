//
//  ZMCommonMacros.h
//  Pods
//
//  Created by Chin on 2018/7/24.
//

#ifndef ZMCommonMacros_h
#define ZMCommonMacros_h

//强引用和弱引用
#define WEAKSELF    __weak typeof(self)  weakSelf = self;
#define STRONGSELF  __strong typeof(weakSelf)  strongSelf = weakSelf;

#define kScreenWidth (iOS8?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)
#define kScreenHeight (iOS8?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)
#define kScreenBounds CGRectMake(0, 0, kScreenWidth, kScreenHeight)
#define kScreenCenter CGPointMake(kScreenWidth*0.5, kScreenHeight*0.5)

#define kSystemVersion ([[UIDevice currentDevice].systemVersion floatValue])
#define iOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7 ? 1 : 0)
#define iOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8 ? 1 : 0)
#define iOS9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9 ? 1 : 0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10 ? 1 : 0)
#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)

#endif /* ZMCommonMacros_h */





/**
 给Class通过runtime添加对象属性的方法，用于.m中.
 Category必须引入 #import <objc/runtime.h>
 ***************************************
 Example:
 @interface NSObject (ZMTools)
 @property (nonatomic, strong) NSObject * privateObj;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (ZMTools)
 YYSYNTH_DYNAMIC_PROPERTY_OBJECT(privateObj, setPrivateObj, STRONG, NSObject *)
 @end
 
 */
#if kZMDEFINE_DYNAMIC_PROPERTY_OBJ
#define kZMDEFINE_DYNAMIC_PROPERTY_OBJ(fun_getter, fun_setter, obj_association, obj_type) \
- (void)fun_setter : (obj_type)object { \
[self willChangeValueForKey:@#fun_getter]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## obj_association); \
[self didChangeValueForKey:@#fun_getter]; \
} \
- (obj_type)fun_getter { \
return objc_getAssociatedObject(self, @selector(fun_getter:)); \
}
#endif
