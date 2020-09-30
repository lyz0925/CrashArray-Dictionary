//
//  ViewController.m
//  Exchange
//
//  Created by 李雅珠 on 2020/9/29.
//  Copyright © 2020 李雅珠. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSObject *obj = nil;
    NSArray *array = @[@"1",@"2", obj];
    NSLog(@"%@", array[3]) ;
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1", obj, nil];
//    [array addObject:obj];
//    [array insertObject:obj atIndex:5];
    
//    NSMutableArray *arrayM = [NSMutableArray array];
//    [arrayM addObject:@"1"];
//    arrayM[3];
    
}

- (void)test {
    NSObject *obj = nil;
    NSDictionary *dic = @{@"key":@"11111", @"key2":obj, obj:@"333"};

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:obj forKey:@"111"];
    [params setObject:@"22222" forKey:@"1111"];
//    [params setObject:@"333" forKey:obj];
    [params valueForKey:obj];
}


@end
