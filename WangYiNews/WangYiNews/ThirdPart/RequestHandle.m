//
//  RequestHandle.m
//  WorkNetwork1.0
//
//  Created by 范玉贞 on 14-7-7.
//  Copyright (c) 2014年 北京蓝鸥科技有限公司. All rights reserved.
//

#import "RequestHandle.h"


@interface RequestHandle ()
@property (nonatomic, retain) NSMutableData *data; //存储服务器返回数据
@property (nonatomic, retain) NSURLConnection *connection; //连接
@end
@implementation RequestHandle
- (id)initWithURLString:(NSString *)urlString parmString:(NSString *)parmString requestMethod:(RequestMethod)requestMethod delegate:(id<RequestHandleDelegate>)delegate
{
    self = [super init];
    if (self) {
        //接收代理对象
        self.delegate = delegate;
        //根据请求方式匹配请求方法
        switch (requestMethod) {
            case RequestMethodGET:
                //匹配到get请求
                [self requestDataByGETWithURLString:urlString];
                break;
            case RequestMethodPOST:
                //匹配到post请求
                [self requestDataByPOSTWithURLString:urlString parmString:parmString];
                break;
            default:
                break;
        }
    }
    return self;
}
//post请求
- (void)requestDataByPOSTWithURLString:(NSString *)urlString parmString:(NSString *)parmString
{
    //1.创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlString];
    //2.创建NSMutableURLRequest对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求体
    NSData *parmData = [parmString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:parmData];
    [self performSelector:@selector(aa) withObject:nil afterDelay:0.4];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    //3.创建连接
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
//get请求
- (void)requestDataByGETWithURLString:(NSString *)urlString
{
    //1.创建NSURL对象
    //(1)进行URLEncode UTF8
    NSString *encodString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodString];
    //2.创建NSURLRequest对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建连接
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
#pragma mark - NSURLConnectionDataDelegate
//当收到服务器响应时触发
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}
//当收到服务器数据时触发
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
//当所有数据请求完毕之后触发
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //当数据请求成功之后,让代理回调requestSuccess方法,并且将请求的数据data作为参数传给delegate
    if ([self.delegate respondsToSelector:@selector(requestHandle:didRequestSuccessWithData:)]) {
        [self.delegate requestHandle:self didRequestSuccessWithData:self.data];
    }
}
//当请求失败之后触发
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(requestHandle:didRequestFailWithError:)]) {
        [self.delegate requestHandle:self didRequestFailWithError:error];
    }
}
- (void)terminateConnection
{
    [self.connection cancel];
}

@end
