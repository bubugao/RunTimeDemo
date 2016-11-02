//
//  NSDictionary+PropertyLog.m
//  RunTimeDemo
//
//  Created by xiaodou on 2016/11/2.
//  Copyright © 2016年 xiaodouxiaodou. All rights reserved.
//

#import "NSDictionary+PropertyLog.h"

@implementation NSDictionary (PropertyLog)

- (void)propertyLog {
    
    NSMutableString *properties = [[NSMutableString alloc] init];
    // 遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *property;
        if ([obj isKindOfClass:[NSString class]]) {
            property = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;", key];
            
        } else if ([obj isKindOfClass:[NSArray class]]) {
            property = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;", key];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            property = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;", key];
            
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            property = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;", key];
        }
        
        [properties appendFormat:@"\n%@\n", property];
    }];
    
    NSLog(@"%@", properties);
}

@end
