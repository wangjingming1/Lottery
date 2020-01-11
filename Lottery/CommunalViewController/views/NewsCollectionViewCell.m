//
//  NewsCollectionViewCell.m
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "NewsCollectionViewCell.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "LottoryNewsModel.h"
#import "UIImageView+AddImage.h"

#define kNCVCellTitleLabelFontSize      kSystemFontOfSize+3
#define kNCVCellTimeLabelFontSize       kSystemFontOfSize-4
#define kNCVCellThumbnailImageViewSize  CGSizeMake(100, 70)

@interface NewsCollectionViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *informationSourcesLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation NewsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.thumbnailImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.informationSourcesLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding15);
        make.right.mas_equalTo(self.thumbnailImageView.mas_left).offset(-kPadding10);
        make.top.mas_equalTo(self.thumbnailImageView);
        make.height.mas_equalTo(45);
    }];
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kPadding15);
        make.right.mas_equalTo(-kPadding15);
        make.size.mas_equalTo(kNCVCellThumbnailImageViewSize);
        make.bottom.mas_equalTo(-kPadding15);
    }];
    [self.informationSourcesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.thumbnailImageView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.informationSourcesLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.informationSourcesLabel);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding15);
        make.right.mas_equalTo(-kPadding15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(LottoryNewsModel *)model{
    _model = model;
    [self reloadViewByModel:model];
}

- (void)reloadViewByModel:(LottoryNewsModel *)model{
    self.titleLabel.text = model.title;
    self.informationSourcesLabel.text = model.informationSources;
    self.timeLabel.text = model.time;
    self.thumbnailImageView.image = nil;
    [self.thumbnailImageView setImageWithName:model.imageUrl];
}

//用来更新特殊约束
//- (void)updateConstraints {
//    [super updateConstraints];
//}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kTitleTintTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:kNCVCellTitleLabelFontSize];
        _titleLabel.numberOfLines = 0;
//        _titleLabel.preferredMaxLayoutWidth = 250;
//        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLabel;
}

- (UILabel *)informationSourcesLabel{
    if (!_informationSourcesLabel){
        _informationSourcesLabel = [[UILabel alloc] init];
        _informationSourcesLabel.textColor = kSubtitleTintTextColor;
        _informationSourcesLabel.font = [UIFont systemFontOfSize:kNCVCellTimeLabelFontSize];
        
    }
    return _informationSourcesLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kSubtitleTintTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:kNCVCellTimeLabelFontSize];
    }
    return _timeLabel;
}

- (UIImageView *)thumbnailImageView{
    if (!_thumbnailImageView){
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.backgroundColor = [UIColor redColor];
        _thumbnailImageView.layer.cornerRadius = 4;
        _thumbnailImageView.layer.masksToBounds = YES;
    }
    return _thumbnailImageView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = kSubtitleTintTextColor;
    }
    return _bottomLineView;
}
@end
