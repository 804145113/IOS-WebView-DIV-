//
//  ViewController.m
//  获取webView内容高度
//
//  Created by GXY on 15/6/24.
//  Copyright (c) 2015年 GongXinYing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
- (IBAction)showdivAction:(id)sender;

@end

@implementation ViewController {
    UIWebView *myWebView;
    CGFloat height;
    BOOL isNormal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    myWebView = [[UIWebView alloc] init];
    
    /* 禁止webView滚动，直接禁用触摸事件
    myWebView.userInteractionEnabled = NO;
     */
    
    // 这里可以设置下webview的背景颜色利用观察
//    [myWebView setBackgroundColor:[UIColor blueColor]];
    
    myWebView.delegate = self;
    myWebView.center = self.view.center;
    
    // 预计算的HTML代码，实际上问题是计算一个div的高度其中就包括了图片。
//    NSString *htmlString = @"这是预计算高度的HTML代码，不包含图片loading the view, typically from a nib.additionaloading the view, typically from a nib.additionalloading the view, typically from a nib.additionall setup after loading the view, typically from a nib.additional setup loading the view, typically from a nib.additional setup after loading the view, typically from a nib.";
    
    NSString *htmlString = @"这是预计算高度的HTML代码，包含图片<image src=\"http://img0.bdstatic.com/img/image/shouye/qdwzmx002.jpg\" width=\"100%\"></image>loading the view typically from a nib.additional setup after <image src=\"http://www.gxyclub.com/upload/lists/20140617/201406171420519608.jpg\" width=\"100%\"></image>loading the view, typically";
    
    NSString * htmlcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", htmlString];
    
    [myWebView loadHTMLString:htmlcontent baseURL:nil];
    [self.view addSubview:myWebView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    
    //再次设置WebView高度（点）
    webView.frame = CGRectZero;
}

- (IBAction)showdivAction:(UIButton *)sender {
    if (!isNormal) {
        [UIView animateWithDuration:1.f animations:^{
            myWebView.frame = CGRectMake(0, CGRectGetHeight(sender.frame) + CGRectGetMaxY(sender.frame), self.view.frame.size.width, height);
        } completion:^(BOOL finished) {
            isNormal = YES;
        }];
    }
    else {
        [UIView animateWithDuration:0.f animations:^{
            myWebView.frame = CGRectMake(0, CGRectGetHeight(sender.frame) + CGRectGetMaxY(sender.frame), self.view.frame.size.width, 0);
        } completion:^(BOOL finished) {
            isNormal = NO;
        }];
    }
}

@end
