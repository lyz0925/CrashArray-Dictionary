//
//  NSMutableDictionary+Extension.m
//  Exchange
//
//  Created by 李雅珠 on 2020/9/29.
//  Copyright © 2020 李雅珠. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Extension)

+ (void)load {
    #ifndef __OPTIMIZE__
        NSLog(@"Debug=========");
    #else
        NSLog(@"release=========");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self exchangeMethod];
        });
    #endif
}

+ (void)exchangeMethod {
    //MSMutableDictionary setObject:forKey:时，如果key和object为nil时就会报错
    Class cls = NSClassFromString(@"__NSDictionaryM");
    Method method_sys = class_getInstanceMethod(cls, @selector(setObject:forKey:));
    Method method_new = class_getInstanceMethod(cls, @selector(yz_setObject:forKey:));
    method_exchangeImplementations(method_sys, method_new);
    
    //NSDictionary 初始化时，如果key和object为nil时就会报错
    Class clsPlace = NSClassFromString(@"__NSPlaceholderDictionary");
    Method methodInit_sys = class_getInstanceMethod(clsPlace, @selector(initWithObjects:forKeys:count:));
    Method methodInit_new = class_getInstanceMethod(clsPlace, @selector(yz_initWithObjects:forKeys:count:));
    method_exchangeImplementations(methodInit_sys, methodInit_new);
}

#pragma mark - 交换方法

- (void)yz_setObject:(id)obj forKey:(NSString *)key {
    if (obj == nil || key == nil) {
        return;
    }
    [self yz_setObject:obj forKey:key];
}

- (instancetype)yz_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    
    // 注意 objects 和keys 都是c语言的，所以要创建c语言的数组
    NSUInteger index = 0;// 数组下标，用于数据存入正确的位置
    id objectsArray[cnt]; // values
    id<NSCopying> keysArray[cnt];//keys
    
    for (int i = 0; i < cnt; i++) {
        // 如果值和key 都不为nil
        if (objects[i] != nil && keys[i] != nil) {
            objectsArray[index] = objects[i];
            keysArray[index] = keys[i];
            index++;
        }else{
            NSString *str = [NSString stringWithFormat:@"%@不能为空",keys[i]];
            NSLog(@"%s__%@", __func__, str);
        }
    }
    
    return [self yz_initWithObjects:objectsArray forKeys:keysArray count:index];
}

@end
