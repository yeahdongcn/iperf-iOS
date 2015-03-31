//
//  DetailViewController.h
//  iperfDemo
//
//  Created by R0CKSTAR on 15/3/31.
//  Copyright (c) 2015年 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

