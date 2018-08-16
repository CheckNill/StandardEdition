//
//  EditController.h
//  StandardEdition
//
//  Created by Tony on 2018/8/14.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteModel.h"
@interface EditController : UIViewController

@property (strong, nonatomic) FavoriteModel *model;
@property (strong, nonatomic) IBOutlet UITextField *userNameT;
@property (strong, nonatomic) IBOutlet UITextField *nickNameT;
@property (strong, nonatomic) IBOutlet UITextField *passwordT;
@property (strong, nonatomic) IBOutlet UITextField *webSiteT;
@property (strong, nonatomic) IBOutlet UITextField *emailT;
@property (strong, nonatomic) IBOutlet UITextField *categoryT;
@property (strong, nonatomic) IBOutlet UITextField *remarkT;

@property (strong, nonatomic) NSString *category;


@end
