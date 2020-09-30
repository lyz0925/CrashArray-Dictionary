//
//  NSArray+Extension.m
//  Exchange
//
//  Created by 李雅珠 on 2020/9/29.
//  Copyright © 2020 李雅珠. All rights reserved.
//

#import "NSArray+Extension.h"
#import <objc/runtime.h>

@implementation NSArray (Extension)

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
    //处理不可变数组（数组的数据大于2时）越界崩溃的问题
    Class clsArrayI = NSClassFromString(@"__NSArrayI");
    Method method_objectIndex_sys = class_getInstanceMethod(clsArrayI, @selector(objectAtIndexedSubscript:));
    Method method_objectIndex_new = class_getInstanceMethod(clsArrayI, @selector(yz_objectAtIndexedSubscript:));
    method_exchangeImplementations(method_objectIndex_sys, method_objectIndex_new);
    
    //处理不可变数组（数组里没有数据时）越界崩溃的问题
    Class clsZero = NSClassFromString(@"__NSArray0");
    Method method_objectAtIndex_sys = class_getInstanceMethod(clsZero, @selector(objectAtIndex:));
    Method method_objectAtIndex_new = class_getInstanceMethod(clsZero, @selector(yz_objectAtIndex:));
    method_exchangeImplementations(method_objectAtIndex_sys, method_objectAtIndex_new);
    
    //处理不可变数组（数组里只有一个数据时）越界崩溃的问题
    Class clsSingleArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
    Method method_index_single_sys = class_getInstanceMethod(clsSingleArrayI, @selector(objectAtIndex:));
    Method method_index_single_new = class_getInstanceMethod(self,  @selector(yz_objectAtIndex_singleArray:));//yz_objectAtIndex:
    method_exchangeImplementations(method_index_single_sys, method_index_single_new);
}


#pragma mark - 交换的方法
- (id)yz_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
         NSLog(@"Error--%s, %lu 超出了数组的长度", __func__, (unsigned long)index);
         return nil;
     }
    return [self yz_objectAtIndex:index];
}

- (id)yz_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        NSLog(@"Error--%s, %lu 超出了数组的长度", __func__, (unsigned long)idx);
        return nil;
    }
   return [self yz_objectAtIndexedSubscript:idx];
}


- (id)yz_objectAtIndex_singleArray:(NSUInteger)index {
    if (index >= self.count) {
         NSLog(@"Error--%s, %lu 超出了数组的长度", __func__, (unsigned long)index);
         return nil;
     }
    return [self yz_objectAtIndex_singleArray:index];
}


@end
