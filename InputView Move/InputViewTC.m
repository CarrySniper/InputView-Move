//
//  InputViewTC.m
//  InputView Move
//
//  Created by 思久科技 on 16/6/23.
//  Copyright © 2016年 Seejoys. All rights reserved.
//

#import "InputViewTC.h"

@implementation InputViewTC

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.label];
        
        self.textField = [[UITextField alloc]init];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.placeholder = @"请输入";
        [self.contentView addSubview:self.textField];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView removeFromSuperview];
    [self.textLabel removeFromSuperview];
    
    self.label.frame = CGRectMake(16, 10, 100, 30);
    self.textField.frame = CGRectMake(132, 10, self.contentView.frame.size.width - 148, 30);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
