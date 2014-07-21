//
//  RequestHandle.h
//  WorkNetwork1.0
//
//  Created by 范玉贞 on 14-7-7.
//  Copyright (c) 2014年 北京蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//定义请求方式枚举
typedef enum requestMethod {
    RequestMethodGET,  //GET请求,
    RequestMethodPOST, //POST请求
}RequestMethod;
@class RequestHandle;
@protocol RequestHandleDelegate <NSObject>
//数据请求成功
- (void)requestHandle:(RequestHandle *)requestHandle didRequestSuccessWithData:(NSData *)data;
//数据请求失败
- (void)requestHandle:(RequestHandle *)requestHandle didRequestFailWithError:(NSError *)error;
@end
@interface RequestHandle : NSObject<NSURLConnectionDataDelegate>
/**
 *  为什么代理属性语义特性为assign ,而不是retain
    当该类的对象存在时,存在的意义就在于为其他类来提供网络请求服务,比如为视图控制器来提供网络请求服务,对于视图控制器来说,拥有了该类对象的所有权,而对于该类的对象就不能再拥有视图控制器的所有权,否则会造成双方互相引用问题,循环引用,双方都在等待对方释放拥有的自己的所有权,最后发现所有权都释放不了,造成内存泄露问题.
    解决方案:如果说A类的对象是依托于B类而存在的,只能B类对象拥有A类对象的所有权,而A类对象无权拥有B类对象所有权.
    所以对于delegate属性来说,语义特性声明为assign而不是retain.
 */
@property (nonatomic, assign) id<RequestHandleDelegate> delegate;
/**
 *  初始化方法,根据参数初始化对象
 *
 *  @param urlString     请求数据的地址
 *  @param parmString    请求数据的参数
 *  @param requestMethod 请求数据的方式
 */
- (id)initWithURLString:(NSString *)urlString parmString:(NSString *)parmString requestMethod:(RequestMethod)requestMethod delegate:(id<RequestHandleDelegate>)delegate;
//中断连接
- (void)terminateConnection;
@end
