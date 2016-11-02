//
//  People.m
//  RunTimeDemo
//
//  Created by xiaodou on 2016/10/31.
//  Copyright © 2016年 xiaodouxiaodou. All rights reserved.
//

#import "People.h"
#import <objc/runtime.h>

// 写成全局宏 其他Model就可使用
#define ENCODE_RUNTIME(SomeClass)\
\
unsigned int count = 0;\
Ivar *ivarList = class_copyIvarList([SomeClass class], &count);\
for (int i = 0; i < count; i ++) {\
    Ivar ivar = ivarList[i];\
    const char *name = ivar_getName(ivar);\
    NSString *key = [NSString stringWithUTF8String:name];\
    id value = [self valueForKey:key];\
    [aCoder encodeObject:value forKey:key];\
}\
free(ivarList);\
\

#define DECODE_RUNTIME(SomeClass)\
\
if (self = [super init]) {\
unsigned int count = 0;\
Ivar *ivarList = class_copyIvarList([SomeClass class], &count);\
for (int i = 0; i < count; i++) {\
    Ivar ivar = ivarList[i];\
    const char *name = ivar_getName(ivar);\
    NSString *key = [NSString stringWithUTF8String:name];\
    id value = [aDecoder decodeObjectForKey:key];\
    [self setValue:value forKey:key];\
}\
free(ivarList);\
}\
return self;\
\

#define MODEL_WITH_DICTIONARY(dict,modelClass)\
\
Class ModelClass = NSClassFromString(modelClass);\
id model = [[ModelClass alloc] init];\
[model setValuesForKeysWithDictionary:dict];\
return model;\
\

@interface People ()

@end

@implementation People


- (instancetype)init {
    if (self = [super init]) {
        _name = @"xiaoBao";
        _sex = @"man";
    }
    return self;
}

#pragma mark - NSCoding

// 可以将这两个方法内代码写成全局宏或者方法 然后一行代码调用即可
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([People class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];                     // 从成员列表中取出成员变量
        const char *name = ivar_getName(ivar);       // 获取成员变量名
        // 进行归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivarList);
    
    //ENCODE_RUNTIME(People)  // 若写成宏 调用
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList([People class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];                        // 从成员列表中取出成员变量
            const char *name = ivar_getName(ivar);       // 获取成员变量名
            // 进行解档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            // 将值赋值给成员变量
            [self setValue:value forKey:key];
        }
        free(ivarList);
    }
    return self;
    
    //DECODE_RUNTIME(People)  // 若写成宏 调用
}

/** 字典转模型 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    return [self modelWithDictionary:dict modelClass:NSStringFromClass([self class])];
    
//    MODEL_WITH_DICTIONARY(dict, NSStringFromClass([self class]))  // 若写成宏 调用
}

// 下面方法可写在BaseModel中， 这样Model中直接调用即可 也可以写成全局宏
+ (instancetype)modelWithDictionary:(NSDictionary *)dict modelClass:(NSString *)modelClass {
    Class ModelClass = NSClassFromString(modelClass);
    id model = [[ModelClass alloc] init];
    /* 1.KVC方式（推荐） 将dict的key对应的值赋值给对应的model对应的属性
     必须保证model中的属性和dict中的key一一对应 */
    [model setValuesForKeysWithDictionary:dict];
    
    // 2.runTime方式 较为繁琐（不推荐）如果字典中有字典，字典中有数组，需要多级转换
    return model;
}

#pragma mark - override
// 防止model中没有key对应的属性 造成崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"UndefineKey = %@",key);
    // 在此也可实现 字典中的key比model中的属性还多的情况， 比如
    if ([key isEqualToString:@"peoplename"]) {
        _name = value;
    }
}

#pragma mark - public

- (NSString *)getPersonName {
    return _name;
}

- (NSString *)getPersonSex {
    return _sex;
}

+ (NSString *)getPersonAge {
    return @"18";
}

+ (NSString *)getPersonSchool {
    return @"BeiDa";
}

@end
