//
//  NavigationAnimationCell.h
//  NavigationAnimation
//
//  Created by HN on 2019/9/6.
//  Copyright © 2019 HN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationAnimationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
