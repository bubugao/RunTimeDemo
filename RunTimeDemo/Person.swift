//
//  Person.swift
//  RunTimeDemo
//
//  Created by xiaodou on 2016/10/31.
//  Copyright © 2016年 xiaodouxiaodou. All rights reserved.
//

import UIKit

class Person: NSObject {
     var name : NSString = "xiaoBao"  /**< 若用private修饰 KVC都无法获取(OC的可以) 但可用runtime的object_getIvar获取 */
     var sex  : NSString = "man"
    
    func getPersonName() -> NSString {
        return name
    }
    
    func getPersonSex() -> NSString {
        return sex
    }
    
    class func getPersonAge() -> NSString {
        return  "18"
    }
    
    class func getPersonSchool() -> NSString {
        return  "BeiDa"
    }
    
}

extension Person {
    // OC 的类中也一样 在set和get方法中设置关联
    var telephone : NSString {
        set {
            objc_setAssociatedObject(self, "telephone", newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            return objc_getAssociatedObject(self, "telephone") as! NSString
        }
    }
}
