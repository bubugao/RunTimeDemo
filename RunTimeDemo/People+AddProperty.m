//
//  People+AddProperty.m
//  RunTimeDemo
//
//  Created by xiaodou on 2016/11/1.
//  Copyright © 2016年 xiaodouxiaodou. All rights reserved.
//

#import "People+AddProperty.h"
#import <objc/runtime.h>

@implementation People (AddProperty)

// 重写set和get方法 设置关联
- (NSString *)telephone {
    return objc_getAssociatedObject(self, "telephone");
}

- (void)setTelephone:(NSString *)telephone {
    // OBJC_ASSOCIATION_RETAIN_NONATOMIC 为关联策略
    objc_setAssociatedObject(self, "telephone", telephone, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
