//
//  WebViewController.m
//  Lottery
//
//  Created by wangjingming on 2020/1/11.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "WJMAlertController.h"

@interface WebViewController () <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI{
    [self.view addSubview:self.webView];
    [self reloadWebView];
}

- (void)setParams:(NSDictionary *)params{
    [super setParams:params];
    if ([params objectForKey:@"y"]){
        CGFloat offsetY = [params[@"y"] floatValue];
        CGRect frame = self.view.bounds;
        frame.origin.y += offsetY;
        frame.size.height += -offsetY;
        self.webView.frame = frame;
    }
    self.urlStr = [self.params objectForKey:@"url"];
    [self reloadWebView];
}

- (void)reloadWebView{
    if ([self.urlStr isEqualToString:@""]) return;
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void)showLoadingView{
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}

- (void)hideLoadingView{
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
}

- (void)showAlertView:(NSString *)title message:(NSString *)message confirmText:(NSString*)confirmText cancelText:(NSString*)cancelText confirm:(void(^)(void))confirm cancel:(void(^)(void))cancel {
    WJMAlertController *ac = [WJMAlertController showAlertController:title message:message confirmText:confirmText cancelText:cancelText confirm:confirm cancel:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (UIActivityIndicatorView *)loadingView {
    if (_loadingView == nil) {
        if (@available(iOS 13.0, *)){
            _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
            [_loadingView setColor:[UIColor systemBackgroundColor]];
        } else {
            _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [_loadingView setColor:UIColor.blackColor];
        }
        [_loadingView setFrame:CGRectMake(0, 0, 200, 200)];
        [_loadingView setCenter:self.view.center];
        [self.view addSubview:_loadingView];
    }
    return _loadingView;
}

- (WKWebView *)webView{
    if (!_webView){
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
    
        CGRect frame = self.view.bounds;
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

#pragma mark - WKNavigationDelegate
/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self showLoadingView];
}
/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self hideLoadingView];
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self hideLoadingView];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
        NSLog(@"newprogress:%.1f", newprogress);
    }
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    if (@available(iOS 11.0, *)){
        CGRect frame = self.progressView.frame;
        frame.origin.y = self.view.safeAreaInsets.top;
        self.progressView.frame = frame;
    }
}

// 记得取消监听
- (void)dealloc {
   [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
