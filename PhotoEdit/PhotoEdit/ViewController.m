//
//  ViewController.m
//  PhotoEdit
//
//  Created by 卢梓源 on 2019/6/28.
//  Copyright © 2019 Garry. All rights reserved.
//

#import "ViewController.h"
#import "PhotoEditViewController.h"
#import "UIImage+FixOrientation.h"

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, 100, 100, 20)];
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.cornerRadius = 6;
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width-40, self.view.bounds.size.width-40)];
    self.imageView.backgroundColor = [UIColor orangeColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //self.imagePickerController.allowsEditing = YES;
}

#pragma mark - 点击事件
- (void)clickBtn:(UIButton *)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoFromCamera];
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhotoFromAlbum];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:cameraAction];
    [alertVc addAction:photoAction];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - 拍照
- (void)selectPhotoFromCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"请在设置-->隐私-->相机中，开启本应用的相机访问权限！"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了",nil];
        [alert show];
        return;
    }
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
#pragma mark - 相册中选择
- (void)selectPhotoFromAlbum {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"请在设置-->隐私-->照片中，开启本应用的相册访问权限！"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"我知道了",nil];
        [alert show];
        return;
    }
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //返回一个编辑后的图片 UIImagePickerControllerOriginalImage
    NSLog(@"%@", info);
    //UIImage *selectedImage = [UIImage fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    UIImage *selectedImage = info[@"UIImagePickerControllerOriginalImage"];

    PhotoEditViewController *VC = [[PhotoEditViewController alloc] init];
    VC.image = selectedImage;
    __weak typeof(self) weakSelf = self;
    VC.callBack = ^(UIImage * _Nonnull image) {
        weakSelf.imageView.image = image;
        [weakSelf.imagePickerController dismissViewControllerAnimated:NO completion:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //上传图片
        [self uploadImage:image];
    };
    [picker presentViewController:VC animated:YES completion:nil];
}

#pragma mark - 图片转base64
- (void)uploadImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    if (data.length/1000 > 2*1024) {
        NSLog(@"图片上传不能大于2M");
        return;
    }
    
    NSString *imageBase64 = [data base64EncodedStringWithOptions:0];
    NSLog(@"图片：%@", imageBase64);
    
    //以下写网络请求即可
    //...
}

@end
