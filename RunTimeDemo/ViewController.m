//
//  ViewController.m
//  RunTimeDemo
//
//  Created by xiaodou on 2016/10/31.
//  Copyright © 2016年 xiaodouxiaodou. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>

#import "People.h"
#import "People+AddProperty.h"
#import "NSDictionary+PropertyLog.h"

@interface ViewController () {
    People *myPeople;
}

@end

@implementation ViewController

/** github Desktop测试 */
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"github Desttop come");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
    
    [self dynamicModifyVariable];
    [self dynamicAddMethod];
    [self dynamicExchangeMethod];
    [self dynamicReplaceMethod];
    [self dynamicAddProperty];
    [self automaticArchiveAndUnarchive];
    [self modelConvertFromDictionary];
}

- (void)initData {
    myPeople = [[People alloc] init];
}

#pragma mark - private

// C 函数
void getInformation(id aPerson) {
    People *pp = (People *)aPerson;
    NSLog(@"2.添加的方法，获取全部信息:%@,%@",pp.name,pp.sex);
}

/** 测试Person类新添加的方法 */
- (void)testPersonAddMentod {
    SEL getPersonAllInfo = sel_registerName("getPersonAllInfo");
    // 若调用新增方法 则调用函数
    if ([myPeople respondsToSelector:getPersonAllInfo]) {
        getInformation(myPeople);
    }
}

/** 替换方法测试 */
- (void)replaceMethodTest1 {
    NSLog(@"4.替换方法成功");
}

void replaceMethodTest2() {
    NSLog(@"4.替换方法成功");
}

#pragma mark - Runtime Common

/** 1.动态修改变量（私有变量也可修改）【常用】*/
- (void)dynamicModifyVariable {
    // Swift的Person类的变量类型需为继承NSObject的类
    NSLog(@"修改前姓名为:%@", myPeople.name);
    unsigned int count = 0;
    
    // 获取类的成员变量列表(包括私有) 获取属性，方法，协议列表 类似
    Ivar *varList = class_copyIvarList([People class], &count);
    for (int i = 0; i < count; i++) {
        Ivar var = varList[i];
        const char *varName = ivar_getName(var);
        NSString *proname = [NSString stringWithUTF8String:varName];
        // Person 为Swift类的话，若name为属性，则为"name"
        if ([proname isEqualToString:@"_name"]) {
            object_setIvar(myPeople, var, @"xiaoDong");
            break;
        }
    }
    NSLog(@"1.修改后姓名为:%@",myPeople.name);
}

/** 2.动态添加方法 【常用于给开源库添加方法 类别也可实现】*/
- (void)dynamicAddMethod {
    // 注册一个方法
    SEL getInformationSelector = sel_registerName("getPersonAllInfo");
    /* 将函数指针指向方法 IMP：指向实际执行函数体的指针 type函数返回值和参数类型
       "v@:" v代表无返回值void，如果是i则代表int；@代表id； :代表SEL _cmd; */
    class_addMethod([People class], getInformationSelector, (IMP)getInformation, "v@");
    // 测试
    [self testPersonAddMentod];
}

/** 3.动态交换方法 */
- (void)dynamicExchangeMethod {
    // class_getInstanceMethod 获取对象方法, class_getClassMethod 获取类方法
    Method m1 = class_getInstanceMethod([People class], @selector(getPersonName));
    Method m2 = class_getInstanceMethod([People class], @selector(getPersonSex));
    method_exchangeImplementations(m1, m2);
    NSLog(@"3.交换方法后：%@,%@",[myPeople getPersonName], [myPeople getPersonSex]);
}

/** 4.动态拦截或者替换方法【常用于替换开源库的方法】*/
- (void)dynamicReplaceMethod {
    // 用本类中的对象方法与Person类中的类方法交换 从而实现替换
    Method m1 = class_getClassMethod([People class], @selector(getPersonSchool));
    Method m2 = class_getInstanceMethod([ViewController class], @selector(replaceMethodTest1));
    method_exchangeImplementations(m1, m2);
    // 用下面方法也可 直接替换
    //method_setImplementation(m1, (IMP)replaceMethodTest2);
    [People getPersonSchool];
}

/** 5.动态添加属性 */
- (void)dynamicAddProperty {
    // 在Person的扩展类中设置关联
    myPeople.telephone = @"15688886666";
    NSLog(@"5.添加的属性:%@",myPeople.telephone);
}

/** 6.自动归档和解档*/
- (void)automaticArchiveAndUnarchive {
    // 见People类中的encodeWithCoder和initWithCoder实现
    NSLog(@"自动归档和解档成功");
}

/** 7.字典转模型 */
- (void)modelConvertFromDictionary {
    NSDictionary *dic = @{@"peoplename":@"hello", @"sex":@"unknown",@"books":@[@"math",@"english",@"history"],@"dog":@{@"dogname":@"wangcai",@"dogage":@"1"}};
    // 若dic的key较多 可用下面方法自动打印出模型属性代码 然后拷贝使用即可
    [dic propertyLog];
    myPeople = [People modelWithDictionary:dic];
    NSLog(@"字典转模型后：%@,%@,%@",myPeople.name, myPeople.sex, myPeople.books);
}

@end
