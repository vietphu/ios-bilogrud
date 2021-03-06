//
//  StatusCell.h
//  FaceBookUserInfo
//
//  Created by Natasha on 03.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusCell : UITableViewCell
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) UIImage *photo;
@property (copy, nonatomic) NSString *message;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;
@property (retain, nonatomic) IBOutlet UITextView *messageTextView;
@end
