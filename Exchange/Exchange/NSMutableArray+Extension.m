//
//  NSMutableArray+Extension.m
//  Exchange
//
//  Created by 李雅珠 on 2020/9/29.
//  Copyright © 2020 李雅珠. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

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
    Class clsInit = NSClassFromString(@"__NSPlaceholderArray");
    Method method_init_sys = class_getInstanceMethod(clsInit, @selector(initWithObjects:count:));
    Method method_init_new = class_getInstanceMethod(clsInit, @selector(yz_initWithObjects:count:));
    method_exchangeImplementations(method_init_sys, method_init_new);
    
    Class clsArrayM = NSClassFromString(@"__NSArrayM");
    Method method_insert_sys = class_getInstanceMethod(clsArrayM, @selector(insertObject:atIndex:));
    Method method_insert_new = class_getInstanceMethod(clsArrayM, @selector(yz_insertObject:atIndex:));
    method_exchangeImplementations(method_insert_sys, method_insert_new);
    
    Method method_objectIndex_sys = class_getInstanceMethod(clsArrayM, @selector(objectAtIndexedSubscript:));
    Method method_objectIndex_new = class_getInstanceMethod(clsArrayM, @selector(yz_objectAtIndexedSubscript:));
    method_exchangeImplementations(method_objectIndex_sys, method_objectIndex_new);
}


#pragma mark - 交换的方法
- (instancetype)yz_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    // 注意 objects 和keys 都是c语言的，所以要创建c语言的数组
    NSUInteger index = 0; // 数组下标，用于数据存入正确的位置
    id objectArray[cnt];
    for (int i = 0; i < cnt; i++) {
        if (objects[i] != nil) {
            objectArray[index] = objects[i];
            index++;
        }else {
            NSString *str = [NSString stringWithFormat:@"%@不能为空",objects[i]];
            NSLog(@"Error--%s__%@", __func__, str);
        }
    }
    
    return [self yz_initWithObjects:objectArray count:index];
}


- (void)yz_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        return;
    }
    [self yz_insertObject:anObject atIndex:index];
}

- (id)yz_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        NSLog(@"Error--%s, %lu 超出了数组的长度", __func__, (unsigned long)idx);
        return nil;
    }
   return [self yz_objectAtIndexedSubscript:idx];
}



@end
