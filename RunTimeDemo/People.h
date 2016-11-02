//
//  People.h
//  RunTimeDemo
//
//  Created by xiaodou on 2016/10/31.
//  Copyright © 2016年 xiaodouxiaodou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSArray *books;

/** 字典转模型 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

- (NSString *)getPersonName;
- (NSString *)getPersonSex;
+ (NSString *)getPersonAge;
+ (NSString *)getPersonSchool;

@end
