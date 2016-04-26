//
//  ViewController.m
//  NSUrlSessionDemo
//
//  Created by Andrew on 16/3/29.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>

@property (nonatomic,strong)NSURLSession *urlSession;

@property (nonatomic,strong)NSURLRequest *request;

@property (nonatomic,strong)NSMutableDictionary *HttpHeaders;

@property (nonatomic,strong)NSMutableData *imageData;

@property (nonatomic,strong)UIImageView *imgview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    //封装请求头 Accept指定客户端能够接收的内容类型
    _HttpHeaders = [@{@"Accept": @"image/*;q=0.8"} mutableCopy];
    _imageData=[[NSMutableData alloc]init];
    
   
}

-(void)initView{
    _imgview=[[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 200, 200)];
    _imgview.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_imgview];
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(_imgview.frame)+10, 100, 40)];
    [btn setTitle:@"download" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=[UIColor blueColor];
    [self.view addSubview:btn];
    
    
    UIButton *clearBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, btn.frame.origin.y, btn.frame.size.width, 40)];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
}

-(void)download{
    NSURL *url=[NSURL URLWithString:@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-3.png"];
    
    //创建request请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
    //request.HTTPShouldHandleCookies=(options&TLImageSpringDownloadHandleCookies);
    
    request.HTTPShouldUsePipelining=YES;
    request.allHTTPHeaderFields=_HttpHeaders;
    
    //创建NSUrlSession
    NSURLSessionConfiguration *defaultConfigure=[NSURLSessionConfiguration defaultSessionConfiguration];
    _urlSession=[NSURLSession sessionWithConfiguration:defaultConfigure delegate:self delegateQueue:nil];
    NSURLSessionTask *dataTask=[_urlSession dataTaskWithRequest:request];
    
    //启动
    [dataTask resume];
}

#pragma mark ===NSUrlSession delegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    [_imageData appendData:data];
  
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if(error){
        NSLog(@"error:%@",[error description]);
    }else{
        UIImage *img=[UIImage imageWithData:_imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgview.image=img;
        });
        
    }
}

-(void)clearAction:(UIButton *)btn{
    _imgview.image=nil;
}


@end
