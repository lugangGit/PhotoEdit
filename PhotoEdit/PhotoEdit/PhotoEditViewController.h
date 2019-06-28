//
//  PhotoEditViewController.h
//  PhotoEdit
//
//  Created by 卢梓源 on 2019/6/28.
//  Copyright © 2019 Garry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JPImageresizerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoEditViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void (^callBack)(UIImage *image);

@end

NS_ASSUME_NONNULL_END
