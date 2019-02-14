//
//  ShareViewController.m
//  Airstory Share
//
//  Created by ProDev on 4/6/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "ShareViewController.h"
#import "GlobalHeader.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "CustomAFNetworking.h"
#import "MBProgressHUD.h"
#import "ProjectSelectorTableVC.h"
#import "ErrorDialogVC.h"

@import MobileCoreServices;

@interface AttachmentObject : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *MIMEType;
@property (nonatomic, strong) NSData *data;

@end

@implementation AttachmentObject

@end



@interface ShareViewController () <ReloadConfigurationDelegate, MainVCDelegate> {
    MBProgressHUD *hudView;
    NSArray *projects;
    NSArray *kUTTypes;
    NSMutableArray *attachments;
    NSExtensionItem *extensionItem;
    NSString *urlString;
    
    NSURLSessionDataTask *task;
}
@property (nonatomic) NSUInteger index;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    kUTTypes = @[(NSString*)kUTTypeImage, (NSString*)kUTTypeAudio, (NSString*)kUTTypeUTF8PlainText, (NSString*)kUTTypeURL];
    
    projects = [NSArray array];
    attachments = [NSMutableArray array];
    self.index = 0;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadData];
}

- (void)replacePostLabel:(UIView*)v{
    if ([v isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton*)v;
        if ([[button titleLabel].text isEqual:@"Post"])
            [button setTitle:@"Save" forState:UIControlStateNormal];
    }

    for (int i = 0 ; i < v.subviews.count; i++) {
        [self replacePostLabel:v.subviews[i]];
    }
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    
    return YES;
}

- (void)didSelectPost {
//    [self addLoadingView:@"Syncing with Airstory cardboxes..."];
    
    ShareViewController *weakSelf = self;
    
    [CustomAFNetworking sendRequestWithSharedCookie:@"GET" endPoint:kUploadEndpoint headers:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([CustomAFNetworking isLoginPage:operation]){
//            [hudView hide:YES];
            
            UIResponder* responder = weakSelf;
            while ((responder = [responder nextResponder]) != nil)
            {
                NSLog(@"responder = %@", responder);
                if([responder respondsToSelector:@selector(openURL:)] == YES)
                {
                    [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"airstory://"]];
                }
            }
            
            [self.extensionContext cancelRequestWithError:nil];

        }
        else{
            [weakSelf uploadCard:responseObject[@"results"]];
            
            [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:^(BOOL expired){
                
                if (expired) {
                    NSLog(@"expired");
                    [task suspend];
                }
                else
                {
                    NSLog(@"Not expired");
//                     [task resume];
                }
               
                
            }];

        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hudView hide:YES];
        
        if ([CustomAFNetworking isLoginPage:operation]){
            UIResponder* responder = weakSelf;
            while ((responder = [responder nextResponder]) != nil)
            {
                NSLog(@"responder = %@", responder);
                if([responder respondsToSelector:@selector(openURL:)] == YES)
                {
                    [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"airstory://"]];
                }
            }
        }
        else
        {
            [self displaysErrorDialog:error];
            //        [self.extensionContext cancelRequestWithError:nil];
        }
    }];
    
    
}

- (NSURLSession *)backgroundSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
//        NSURLSession *session = nil;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.joanna.Airstory.BackgroundSessionConfig"];
//        configuration.discretionary = YES;
        configuration.sharedContainerIdentifier = kShareGroupID;
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    
    return session;
}

- (void) uploadCard:(NSString*)url {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
    
    if ([defaults objectForKey:kCookieSessionName] == nil || [defaults objectForKey:kCookieRememberMeName] == nil){
        [defaults setObject:@"" forKey:kCookieSessionName];
        [defaults setObject:@"" forKey:kCookieRememberMeName];
        [defaults synchronize];
    }
    NSHTTPCookie *cookieSession = [NSHTTPCookie cookieWithProperties:@{
                                                                       NSHTTPCookieDomain: kDomain,
                                                                       NSHTTPCookieName: kCookieSessionName,
                                                                       NSHTTPCookieValue: [defaults objectForKey:kCookieSessionName],
                                                                       NSHTTPCookiePath: @"/"
                                                                       }];
    NSHTTPCookie *cookieRemember = [NSHTTPCookie cookieWithProperties:@{
                                                                        NSHTTPCookieDomain: kDomain,
                                                                        NSHTTPCookieName: kCookieRememberMeName,
                                                                        NSHTTPCookieValue: [defaults objectForKey:kCookieRememberMeName],
                                                                        NSHTTPCookiePath: @"/"
                                                                        }];
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:@[cookieSession, cookieRemember]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    [request setAllHTTPHeaderFields:cookieHeaders];
    
    NSString *boundary = kServerMultipartDataBoundary;
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[projects[self.index] valueForKey:@"id"] stringValue], @"projectId",
                            [[projects[self.index] valueForKey:@"id"] stringValue], @"saveToList",
                            self.contentText, @"text", nil];
    if (![urlString isEqualToString:@""]) {
        [params setValue:urlString forKey:@"url"];
    }
    
    NSMutableData *body = [NSMutableData data];
    NSArray *keys = [params allKeys];
    
    
    for (int i = 0; i < [keys count]; i++)
    {
        NSString *value = [params objectForKey:[keys objectAtIndex:i]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", keys[i]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    }


    if (attachments.count == 0){
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"files\"; filename=\"\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        for (int i = 0; i < attachments.count; i++){
            AttachmentObject *obj = attachments[i];
            
//            obj.fileName=@"iphone-file.jpg";
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"files\"; filename=\"%@\"\r\n", obj.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", obj.MIMEType] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:obj.data]];

//            [body appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    NSURLSession *session = [self backgroundSession];
    task = [session uploadTaskWithStreamedRequest:request];

    [task resume];
}

- (NSArray *)configurationItems {
    SLComposeSheetConfigurationItem *item = [[SLComposeSheetConfigurationItem alloc] init];
    
    if (projects.count == 0) {
        item.title = @"";
        item.value = @"";
        return @[item];
    }
    
    item.title = [projects[self.index] valueForKey:@"name"];
    item.value = @"";
    item.tapHandler = ^(){
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
        NSDate *timestamp = [defaults objectForKey:@"Timestamp"];
        NSDate *now = [NSDate date];
        
        if ([now timeIntervalSinceDate:timestamp] > kRefreshInterval) {
            [self loadData];
        }
        else
        {
            ProjectSelectorTableVC *vc = [[ProjectSelectorTableVC alloc] init];
            vc.projects = projects;
            vc.delegate = self;
            
            [self pushConfigurationViewController:vc];
        }
    };
    
    return @[item];
}

- (void)presentationAnimationDidFinish {
    [self replacePostLabel:self.navigationController.navigationBar];
    urlString = @"";
    
    NSArray *array = self.extensionContext.inputItems;
    extensionItem = array[0];
    for (int i = 0; i < array.count; i++) {
        [self extractAttachmentFromExtensionItem:array[i] callback:^(NSString* fileName, NSString *MIMEType, NSData* data){
            AttachmentObject *obj = [AttachmentObject new];
            
            obj.fileName = fileName;
            obj.MIMEType = MIMEType;
            obj.data  = data;
            
            [attachments addObject:obj];
        }];
    }
}

- (void)loadData {
    [self addLoadingView:@"Syncing with your Airstory cardboxes"];
    
    SLComposeServiceViewController *weakSelf = self;
    
    [CustomAFNetworking sendRequestWithSharedCookie:@"GET" endPoint:@"mobile/iphone/v1/get-save-to-list" headers:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hudView hide:YES];
        
        if ([CustomAFNetworking isLoginPage:operation]){
            UIResponder* responder = weakSelf;
            while ((responder = [responder nextResponder]) != nil)
            {
                NSLog(@"responder = %@", responder);
                if([responder respondsToSelector:@selector(openURL:)] == YES)
                {
                    [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"airstory://"]];
                }
            }
            
            [weakSelf.extensionContext cancelRequestWithError:nil];
        }
        else if ([self displaysResponseDialog:responseObject]) {
            return ;
        }
        else{
            [CustomAFNetworking saveTimestampToUserDefaults];
            if (projects == nil || projects.count == 0) {
                projects = responseObject[@"results"];
                self.index = [CustomAFNetworking availableProjectIndexFromList:projects];
                
                [weakSelf reloadConfigurationItems];
            }
            else
            {
                projects = responseObject[@"results"];
                self.index = [CustomAFNetworking availableProjectIndexFromList:projects];
                
                ProjectSelectorTableVC *vc = [[ProjectSelectorTableVC alloc] init];
                vc.projects = projects;
                vc.delegate = self;
                
                [self pushConfigurationViewController:vc];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hudView hide:YES];
        
        if ([CustomAFNetworking isLoginPage:operation]){
            UIResponder* responder = weakSelf;
            while ((responder = [responder nextResponder]) != nil)
            {
                NSLog(@"responder = %@", responder);
                if([responder respondsToSelector:@selector(openURL:)] == YES)
                {
                    [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"airstory://"]];
                }
            }
        }
        else
        {
            [self displaysErrorDialog:error];
//            [weakSelf.extensionContext cancelRequestWithError:error];
        }
        //        [self displayConnectionErrorDialog];
    }];

}

- (void)extractAttachmentFromExtensionItem:(NSExtensionItem*)item callback:(void (^)(NSString* fileName, NSString *MIMEType, NSData* data))callback{
    for (id attachment in item.attachments) {

        for (int j = 0; j < kUTTypes.count; j++) {
            NSString *kUTType = kUTTypes[j];

            if ([attachment hasItemConformingToTypeIdentifier:kUTType]) {

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [attachment loadItemForTypeIdentifier:kUTType options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                        NSString *filePath = (NSString*)item;
                        if ([kUTType isEqualToString:@"public.url"]) {
                            urlString = [(NSURL*)filePath absoluteString];
                            return ;
                        }
                        CFStringRef fileExtension = (__bridge CFStringRef)[filePath pathExtension];
                        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
                        CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
                        CFRelease(UTI);
                        NSString *MIMETypeString = (__bridge_transfer NSString *)MIMEType;
                        
                        callback ([filePath lastPathComponent], MIMETypeString, [NSData dataWithContentsOfURL:(NSURL*)item]);
                    }];
                });
                
            }

        }
    }
}

- (void)reloadConfiguration:(NSUInteger)index {
    self.index = index;
    [CustomAFNetworking saveSelectedProjectIDToUserDefaults:projects[index][@"id"]];
    
    [self reloadConfigurationItems];
}

- (void)addLoadingView : (NSString*)message{

    dispatch_async(dispatch_get_main_queue(), ^(){
        hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudView.detailsLabelText = message;
        hudView.dimBackground = YES;
        hudView.removeFromSuperViewOnHide = YES;
    });
    
}

- (BOOL) displaysResponseDialog : (id) responseObject {
    
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if (responseObject[@"success"])
        return NO;
    
    NSString *errorStr = [CustomAFNetworking errorMessageFromResponse:responseObject];
    
    ErrorDialogVC *vc = [[UIStoryboard storyboardWithName:@"MainInterface" bundle:nil] instantiateViewControllerWithIdentifier:@"ErrorDialogVC"];
    dispatch_async(dispatch_get_main_queue(), ^(){
        vc.errorLabel.text = errorStr;
    });
    vc.delegate = self;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    return YES;
}

- (void) displaysErrorDialog :(NSError*)error {
    NSString *errorStr = [CustomAFNetworking errorMessageFromError:error];
    
    /*
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Error" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    [self showViewController:alertVC sender:self];
     */
    
    /*
    [self setModalPresentationStyle:UIModalPresentationFormSheet];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"MainInterface" bundle:nil] instantiateViewControllerWithIdentifier:@"ErrorDialogVC"];
    [self presentViewController:vc animated:YES completion:nil];
    */
    
    ErrorDialogVC *vc = [[UIStoryboard storyboardWithName:@"MainInterface" bundle:nil] instantiateViewControllerWithIdentifier:@"ErrorDialogVC"];
    dispatch_async(dispatch_get_main_queue(), ^(){
        vc.errorLabel.text = errorStr;
    });
    vc.delegate = self;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)removeDialog {
    [self.extensionContext cancelRequestWithError:nil];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        
        NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
    }
    else
    {
//        [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:^(BOOL expired){
//            
//        }];
    }

//    [session invalidateAndCancel];
//    [session resetWithCompletionHandler:^(){}];
}


@end
