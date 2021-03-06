//
//  SinglePageAdvertViewCell.m
//  HCFunwear
//
//  Created by 刘海川 on 16/6/29.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import "SinglePageAdvertViewCell.h"
#import "GlobalColors.h"
#import "Masonry.h"

@implementation SinglePageAdvertViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _advertView = [UIImageView new];
        _advertView.backgroundColor = [UIColor whiteColor];
        _advertView.contentMode = UIViewContentModeCenter;
        _advertView.image = [UIImage imageNamed:@"fan_default_02"];
        [self.contentView addSubview:_advertView];
        
        [_advertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

@end
