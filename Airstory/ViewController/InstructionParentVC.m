//
//  InstructionParentVC.m
//  Airstory
//
//  Created by ProDev on 4/28/15.
//  Copyright (c) 2015 joanna. All rights reserved.
//

#import "InstructionParentVC.h"
#import "InstructionContentVC.h"

@interface InstructionParentVC (){
    UIPageViewController *pageVC;
}

@end

@implementation InstructionParentVC
@synthesize pageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageVC.view.frame = self.view.frame;

    [self addChildViewController:pageVC];
    [self.view addSubview:pageVC.view];
    
    pageVC.delegate = self;
    pageVC.dataSource = self;
    
    [pageVC setViewControllers:[NSArray arrayWithObject:[self getChildViewControllers:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    pageControl.numberOfPages = 3;

//    
//     UIPageControl *pageControl = [UIPageControl appearance];
//     pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//     pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//     pageControl.backgroundColor = [UIColor whiteColor];
//    
//    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((InstructionContentVC*)viewController).index;
    
    if (index == 0) {
        return nil;
    }
    
    return [self getChildViewControllers:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((InstructionContentVC*)viewController).index;
    
    if (index == 2) {
        return nil;
    }
    
    return [self getChildViewControllers:index + 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 3;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (finished) {
        InstructionContentVC *vc = (InstructionContentVC*)pageViewController.viewControllers[0];
        pageControl.currentPage = vc.index;
    }
}

//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    return 0;
//}

- (InstructionContentVC *)getChildViewControllers:(NSUInteger)index {
    NSString *storyboardID = [NSString stringWithFormat:@"Instruction%d", (int)index];
    
    InstructionContentVC *vc = (InstructionContentVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
    vc.index = index;
    CGRect rect = self.view.frame;
    vc.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    return vc;
}

@end
