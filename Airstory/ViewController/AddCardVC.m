//
//  AddCardVC.m
//  Airstory
//
//  Created by ProDev on 4/16/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "AddCardVC.h"
#import "MBProgressHUD.h"
#import "REFrostedViewController.h"
#import "GlobalHeader.h"
#import "CustomAFNetworking.h"
#import "Utils.h"
#import "SelectProjectVC.h"
#import "MenuVC.h"
#import "AppDelegate.h"

@interface AddCardVC (){
    UIView *dimView;
    MBProgressHUD *hudView;
    NSInteger index;
    BOOL isPlaceHolder;
    UITapGestureRecognizer *tap;
}

@end

@implementation AddCardVC
@synthesize popoverContainerView, statusLabel, projects, projectsTableView, cardContentTextView, cardTitleTextField;

- (void)awakeFromNib {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
    if (projects == nil) {
        [self loadData];
    }
    else
    {
//        index = [CustomAFNetworking availableProjectIndexFromList:projects];
        [self changeUsername];
    }
    
    isPlaceHolder = YES;
    cardContentTextView.text = @"Start typing here...";
    cardContentTextView.textColor = [UIColor lightGrayColor];
    cardContentTextView.delegate = self;
    
    cardTitleTextField.delegate = self;
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissPopoverContainerView)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    index = [CustomAFNetworking availableProjectIndexFromList:projects];
    self.navigationController.navigationBarHidden = NO;
    
    NSIndexPath *indexPath = projectsTableView.indexPathForSelectedRow;
    if (indexPath) {
        [projectsTableView deselectRowAtIndexPath:indexPath animated:animated];
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentVC = self;
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLoadingView : (NSString*)message{
//    dimView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
//    
//    [self.view addSubview:dimView];

    dispatch_async(dispatch_get_main_queue(), ^(){
        hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudView.detailsLabelText = message;
        hudView.dimBackground = YES;
        hudView.removeFromSuperViewOnHide = YES;
    });

}

- (void)removeLoadingView {
    [hudView hide:YES];
//    [dimView removeFromSuperview];
}

- (void)loadData {
    [self addLoadingView:@"Syncing with your Airstory cardboxes"];

    __weak UIViewController *weakSelf = self;
    
    [CustomAFNetworking sendRequestWithSharedCookie:@"GET" endPoint:@"mobile/iphone/v1/get-save-to-list" headers:nil parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self removeLoadingView];
        
        if ([CustomAFNetworking isLoginPage:operation])
            [weakSelf.navigationController popViewControllerAnimated:YES];
        else if ([Utils displaysResponseDialog:responseObject])
            return ;
        else{
            BOOL isFirst = YES;
            
            if (projects != nil) {
                isFirst = NO;
            }
            projects = responseObject[@"results"];
            [projectsTableView reloadData];
            
            index = [CustomAFNetworking availableProjectIndexFromList:projects];
            [self changeUsername];
            [CustomAFNetworking saveTimestampToUserDefaults];

            if (!isFirst) {
                [self performSegueWithIdentifier:@"ToSelectProjectVC" sender:self];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self removeLoadingView];
        
        [Utils displaysErrorDialog:error];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)initView {
    UIImage *menuImage = [UIImage imageNamed:@"Icon_Main_Menu"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 23, 20)];
    [leftButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(didOpenMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIImage *addImage = [UIImage imageNamed:@"Icon_Add"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 23, 20)];
    [rightButton setBackgroundImage:addImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didSave) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    popoverContainerView.hidden = YES;
    popoverContainerView.layer.cornerRadius = 5;
}

- (void)updateLoadedView : (NSString*)name WithMessage:(NSString*)message {
    [cardContentTextView resignFirstResponder];
    [cardTitleTextField resignFirstResponder];
    
    popoverContainerView.hidden = NO;
    
    dimView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [self.view addSubview:dimView];
    
    [self.view bringSubviewToFront:popoverContainerView];
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.statusImageView.image = [UIImage imageNamed:name];
        statusLabel.text = message;
    });
    
    [self.view addGestureRecognizer:tap];

}
- (void)dismissPopoverContainerView {
    popoverContainerView.hidden = YES;
    [dimView removeFromSuperview];
    
    [self.view removeGestureRecognizer:tap];
    
    cardContentTextView.text = @"";
    cardTitleTextField.text = @"";
    
    isPlaceHolder = YES;
    cardContentTextView.text = @"Start typing here...";
    cardContentTextView.textColor = [UIColor lightGrayColor];
}

- (void)didOpenMenu {
    [self.frostedViewController presentMenuViewController];
}

- (void)didSave {
    __weak UIViewController *weakSelf = self;
    
    
    NSString *text;
    if (isPlaceHolder) {
        text = @"";
    }
    else
    {
        text = cardContentTextView.text;
    }

//    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:"<br/>"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[projects[index] valueForKey:@"id"], @"projectId",
                                                                    cardTitleTextField.text, @"name",
                                                                    text, @"text", nil];
    NSDictionary *headers = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Content-Type",
                                                                    @"XMLHttpRequest", @"x-requested-with", nil];
    
    [self addLoadingView:@"Saving a new card"];
    [CustomAFNetworking sendRequestWithSharedCookie:@"POST" endPoint:kSaveCard headers:headers parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self removeLoadingView];
        
        if ([CustomAFNetworking isLoginPage:operation]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please sign in again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else if ([Utils displaysResponseDialog:responseObject])
            return ;
        else{

            [self updateLoadedView:@"Success" WithMessage:@"Card added successfully"];
            
            [self performSelector:@selector(dismissPopoverContainerView) withObject:nil afterDelay:1.5f];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self removeLoadingView];
        
        [Utils displaysErrorDialog:error];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0f];
    cell.textLabel.text = [projects[index] valueForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kShareGroupID];
    NSDate *timestamp = [defaults objectForKey:@"Timestamp"];
    NSDate *now = [NSDate date];
    
    if ([now timeIntervalSinceDate:timestamp] > kRefreshInterval) {
        [self loadData];
    }
    else
        [self performSegueWithIdentifier:@"ToSelectProjectVC" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToSelectProjectVC"]) {
        SelectProjectVC *destVC = (SelectProjectVC*)[segue destinationViewController];
        destVC.projects = projects;
        destVC.selectedIndex = index;
    }
}



- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (isPlaceHolder) {
        cardContentTextView.text = @"";
        cardContentTextView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if(cardContentTextView.text.length == 0){
        cardContentTextView.textColor = [UIColor lightGrayColor];
        cardContentTextView.text = @"Start typing here...";
        [cardContentTextView setSelectedRange:NSMakeRange(0, 0)];
        
        isPlaceHolder = YES;
    }
    else{
        cardContentTextView.textColor = [UIColor blackColor];
        isPlaceHolder = NO;
    }

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(isPlaceHolder && ![text isEqualToString:@""]){
        cardContentTextView.text = @"";
        cardContentTextView.textColor = [UIColor blackColor];
        isPlaceHolder = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)changeUsername {
    MenuVC *menuVC = (MenuVC*)self.frostedViewController.menuViewController;
    
    menuVC.txtName = [projects.lastObject valueForKey:@"updatedUserName"];
}

- (IBAction) willRewind:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"RewindFromSelectProjectVCSegue"]) {
        SelectProjectVC *sourceVC = (SelectProjectVC*)segue.sourceViewController;
        index = sourceVC.selectedIndex;
        
        [CustomAFNetworking saveSelectedProjectIDToUserDefaults:projects[index][@"id"]];
        [projectsTableView reloadData];
    }
}

- (void)willEnterActive {
    index = [CustomAFNetworking availableProjectIndexFromList:projects];
    [projectsTableView reloadData];
}

@end