//
//  PhotoEditViewController.m
//  PhotoEdit
//
//  Created by 卢梓源 on 2019/6/28.
//  Copyright © 2019 Garry. All rights reserved.
//基于JPImageresizerView自定义界面实现图片裁剪、旋转、重置

#import "PhotoEditViewController.h"

@interface PhotoEditViewController ()
//重置
@property (nonatomic, strong) UIButton *recoveryBtn;
//旋转
@property (nonatomic, strong) UIButton *rotateBtn;
//裁剪
@property (nonatomic, strong) UIButton *resizeBtn;
//裁剪
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, weak) JPImageresizerView *imageresizerView;

@end

@implementation PhotoEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self.imageresizerView setResizeWHScale:1 animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.recoveryBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-25, self.view.bounds.size.height-50, 50, 25)];
    [self.recoveryBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.recoveryBtn setBackgroundColor:[UIColor clearColor]];
    [self.recoveryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.recoveryBtn addTarget:self action:@selector(recovery:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recoveryBtn];
    
    self.rotateBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height-110, 50, 25)];
    [self.rotateBtn setTitle:@"旋转" forState:UIControlStateNormal];
    [self.rotateBtn setBackgroundColor:[UIColor clearColor]];
    [self.rotateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rotateBtn addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rotateBtn];
    
    self.resizeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-70, self.view.bounds.size.height-50, 50, 25)];
    [self.resizeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.resizeBtn setBackgroundColor:[UIColor clearColor]];
    [self.resizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.resizeBtn addTarget:self action:@selector(resize:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resizeBtn];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height-50, 50, 25)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:[UIColor clearColor]];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(50, 0, (40 + 30 + 30 + 10), 0);
    UIImage *image = self.image;
    
    self.recoveryBtn.enabled = NO;

    JPImageresizerConfigure *configure = [JPImageresizerConfigure defaultConfigureWithResizeImage:image make:^(JPImageresizerConfigure *configure) {
        configure
        .jp_resizeImage(image)
        .jp_maskAlpha(0.5)
        .jp_strokeColor([UIColor whiteColor])
        .jp_frameType(JPClassicFrameType)
        .jp_contentInsets(contentInsets)
        .jp_bgColor([UIColor blackColor])
        .jp_isClockwiseRotation(YES)
        .jp_animationCurve(JPAnimationCurveEaseOut);
    }];
    
    __weak typeof(self) wSelf = self;
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当不需要重置设置按钮不可点
        sSelf.recoveryBtn.enabled = isCanRecovery;
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当预备缩放设置按钮不可点，结束后可点击
        BOOL enabled = !isPrepareToScale;
        sSelf.rotateBtn.enabled = enabled;
        sSelf.resizeBtn.enabled = enabled;

    }];
    [self.view insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
    

    //注意：iOS11以下的系统，所在的controller最好设置automaticallyAdjustsScrollViewInsets为NO，不然就会随导航栏或状态栏的变化产生偏移
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//旋转
- (void)rotate:(id)sender {
    [self.imageresizerView rotation];
}

//重置
- (void)recovery:(id)sender {
    [self.imageresizerView recovery];
}

//裁剪
- (void)resize:(id)sender {
    self.recoveryBtn.enabled = NO;
    
    __weak typeof(self) wSelf = self;
    
    // 1.默认以imageView的宽度为参照宽度进行裁剪
    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        
        if (!resizeImage) {
            NSLog(@"没有裁剪图片");
            return;
        }
        
        sSelf.recoveryBtn.enabled = YES;
        
        if (self.callBack) {
            self.callBack(resizeImage);
        }
    }];
    
    // 2.自定义参照宽度进行裁剪（例如按屏幕宽度）
    //    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
    //        // 裁剪完成，resizeImage为裁剪后的图片
    //        // 注意循环引用
    //    } referenceWidth:[UIScreen mainScreen].bounds.size.width];
    
    // 3.以原图尺寸进行裁剪
    //    [self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
    //        // 裁剪完成，resizeImage为裁剪后的图片
    //        // 注意循环引用
    //    }];
}

- (void)pop:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
