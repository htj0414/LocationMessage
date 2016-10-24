//
//  HHLocationView.m
//  LocationMessage
//
//  Created by hong7 on 16/9/18.
//  Copyright © 2016年 hong7. All rights reserved.
//

#import "HHLocationView.h"


#import "Masonry.h"
#import <CoreLocation/CoreLocation.h>

@interface HHLocationView()


@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subtitleLabel;
@property (nonatomic,strong) UIButton * button;

@end

@implementation HHLocationView


-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.contentView).offset(15.0f);
        }];
        
        [self.contentView addSubview:self.subtitleLabel];
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-15.0f);
        }];
        
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    
}

-(void)configViewByPlacemark:(CLPlacemark *)placemark {
    
    self.titleLabel.text = placemark.name;
    self.subtitleLabel.text = @"中华人民共和国";
}


-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor yellowColor];
    }
    
    return _contentView;
}


-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor greenColor];
        
    }
    
    
    return _titleLabel;
}

-(UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
    }
    
    
    return _subtitleLabel;
}

-(UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
    }
    return _button;
}

@end
