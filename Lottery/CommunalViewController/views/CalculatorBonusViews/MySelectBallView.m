//
//  MySelectBallView.m
//  Lottery
//
//  Created by wangjingming on 2020/3/11.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "MySelectBallView.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "LSVCBallImageView.h"
#import "MySelectBallViewCell.h"
#import "LotteryPlayRulesModel.h"
#import "LotteryWinningModel.h"

@interface MySelectBallView() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) MySelectBallViewStyle style;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *radBallCollectionView;
@property (nonatomic, strong) UICollectionView *blueBallCollectionView;

@property (nonatomic, strong) UILabel *radBallLabel;
@property (nonatomic, strong) UILabel *blueBallLabel;

@property (nonatomic, strong) NSMutableArray *radBallCountArray;
@property (nonatomic, strong) NSMutableArray *blueBallCountArray;
@end

@implementation MySelectBallView
{
    NSInteger _radCellSelectIdx;
    NSInteger _blueCellSelectIdx;
    
    UIColor *_radBallColor;
    UIColor *_blueBallColor;
}

- (instancetype)initWithStyle:(MySelectBallViewStyle)style
{
    self = [self init];
    if (self) {
        self.style = style;
        [self initData];
        [self setUI];
    }
    return self;
}

- (void)initData{
    _radCellSelectIdx = 0;
    _blueCellSelectIdx = 0;
    
    _radBallColor = [LSVCBallImageView getColor:LSVCBallStyle_radBall];
    _blueBallColor = [LSVCBallImageView getColor:LSVCBallStyle_blueBall];
    
    self.radBallCountArray = [@[] mutableCopy];
    self.blueBallCountArray = [@[] mutableCopy];
}

- (void)setUI{
    UIView *headerView = [[UIView alloc] init];
    
    UIButton *finishButton = [self createButton:kLocalizedString(@"确定") titleColor:[UIColor redColor] action:@selector(finishButtonClick:)];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [finishButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *cancelButton = [self createButton:kLocalizedString(@"取消") titleColor:kTitleTintTextColor action:@selector(cancelButtonClick:)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:kTitleTintTextColor forState:UIControlStateNormal];
    
    self.titleLabel.text = self.style == SelectBallViewStyle ? kLocalizedString(@"我的投注") : kLocalizedString(@"我的命中");
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kDividingLineColor;
    
    UIView *radBallView = [[UIView alloc] init];
    LSVCBallImageView *radBallImageView = [[LSVCBallImageView alloc] init];
    radBallImageView.ballStyle = LSVCBallStyle_radBall;
    
    UIView *blueBallView = [[UIView alloc] init];
    LSVCBallImageView *blueBallImageView = [[LSVCBallImageView alloc] init];
    blueBallImageView.ballStyle = LSVCBallStyle_blueBall;
    
    [self addSubview:headerView];
    [headerView addSubview:self.titleLabel];
    [headerView addSubview:cancelButton];
    [headerView addSubview:finishButton];
    [self addSubview:lineView];
    
    [self addSubview:radBallView];
    [radBallView addSubview:radBallImageView];
    [radBallView addSubview:self.radBallLabel];
    [radBallView addSubview:self.radBallCollectionView];
    
    [self addSubview:blueBallView];
    [blueBallView addSubview:blueBallImageView];
    [blueBallView addSubview:self.blueBallLabel];
    [blueBallView addSubview:self.blueBallCollectionView];
    
    CGFloat ballImageViewSize = 20;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(kPadding10);
        make.size.mas_equalTo(CGSizeMake(40, 25));
        make.bottom.mas_equalTo(-kPadding10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancelButton.mas_right);
        make.right.mas_equalTo(finishButton.mas_left);
        make.centerY.mas_equalTo(cancelButton);
    }];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding10);
        make.size.mas_equalTo(CGSizeMake(40, 25));
        make.centerY.mas_equalTo(cancelButton);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [radBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.top.mas_equalTo(lineView.mas_bottom);
    }];
    [radBallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(kPadding10);
        make.size.mas_equalTo(CGSizeMake(ballImageViewSize, ballImageViewSize));
    }];
    
    [self.radBallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(radBallImageView.mas_right).offset(kPadding10/2);
        make.centerY.mas_equalTo(radBallImageView);
    }];
    
    [self.radBallCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10 + ballImageViewSize);
        make.right.mas_equalTo(-(kPadding10 + ballImageViewSize));
        make.top.mas_equalTo(self.radBallLabel.mas_bottom).offset(kPadding10);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(-kPadding10);
    }];
    
    [blueBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(radBallView);
        make.top.mas_equalTo(radBallView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [blueBallImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10);
        make.top.mas_equalTo(self.radBallCollectionView.mas_bottom).offset(kPadding20);
        make.size.mas_equalTo(CGSizeMake(ballImageViewSize, ballImageViewSize));
    }];
    [self.blueBallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(blueBallImageView.mas_right).offset(kPadding10/2);
        make.centerY.mas_equalTo(blueBallImageView);
    }];
    [self.blueBallCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kPadding10 + ballImageViewSize);
        make.right.mas_equalTo(-(kPadding10 + ballImageViewSize));
        make.top.mas_equalTo(self.blueBallLabel.mas_bottom).offset(kPadding10);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(-kPadding10);
    }];
}

- (void)setModel:(LotteryWinningModel *)model{
    _model = model;
    NSInteger minRadCount = 0, minBlueCount = 0;
    NSInteger maxRadCount = 0, maxBlueCount = 0;
    if (self.style == SelectBallViewStyle){
        minRadCount = model.playRulesModel.radBullCount;
        minBlueCount = model.playRulesModel.blueBullCount;
        if (model.playRulesModel.multipleBets){
            maxRadCount = model.playRulesModel.radBullMultipleMaxCount;
            maxBlueCount = model.playRulesModel.blueBullMultipleMaxCount;
        } else {
            maxRadCount = model.playRulesModel.radBullRange.length;
            maxBlueCount = model.playRulesModel.blueBullRange.length;
        }
    } else if (self.style == TargetBallViewStyle){
        maxRadCount = model.playRulesModel.radBullCount;
        maxBlueCount = model.playRulesModel.blueBullCount;
    }
    [self.radBallCountArray removeAllObjects];
    [self.blueBallCountArray removeAllObjects];
    for (NSInteger i = minRadCount; i <= maxRadCount; i++){
        [self.radBallCountArray addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    
    for (NSInteger i = minBlueCount; i <= maxBlueCount; i++){
        [self.blueBallCountArray addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    [self.radBallCollectionView reloadData];
    [self.blueBallCollectionView reloadData];
}

- (void)setOldRadCount:(NSString *)oldRadCount oldBlueCount:(NSString *)oldBlueCount {
    [self reloadBallLabel:self.radBallLabel ballStr:kLocalizedString(@"红球") count:oldRadCount countColor:_radBallColor];
    [self reloadBallLabel:self.blueBallLabel ballStr:kLocalizedString(@"蓝球") count:oldBlueCount countColor:_blueBallColor];
    _radCellSelectIdx = [self.radBallCountArray indexOfObject:oldRadCount];
    _blueCellSelectIdx = [self.blueBallCountArray indexOfObject:oldBlueCount];
    
    [self.radBallCollectionView reloadData];
    [self.blueBallCollectionView reloadData];
}

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom{
    [self.blueBallCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottom).offset(-kPadding10);
    }];
}

- (void)reloadBallLabel:(UILabel *)ballLabel ballStr:(NSString *)ballStr count:(NSString *)count countColor:(UIColor *)countColor{
    NSString *ballTitle = [NSString stringWithFormat:@"%@-%@%@%@", ballStr, kLocalizedString(@"投注"), count, kLocalizedString(@"个")];
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:ballTitle];
    NSRange range = [ballTitle rangeOfString:count];
    [attriStr addAttribute:NSForegroundColorAttributeName value:countColor range:range];
    
    ballLabel.attributedText = attriStr;
}

- (void)cancelButtonClick:(UIButton *)button{
    if (self.cancelBlock){
        self.cancelBlock();
    }
}

- (void)finishButtonClick:(UIButton *)button{
    if (self.finishBlock){
        NSString *radCount = self.radBallCountArray[_radCellSelectIdx];
        NSString *blueCount = self.blueBallCountArray[_blueCellSelectIdx];
        self.finishBlock(radCount, blueCount);
    }
}

- (UIButton *)createButton:(NSString *)title titleColor:(UIColor *)titleColor action:(SEL)action{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:titleColor];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (UICollectionView *)createCollectionView:(NSString *)cellIde{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(30, 30);
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[MySelectBallViewCell class] forCellWithReuseIdentifier:cellIde];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    return collectionView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)radBallLabel{
    if (!_radBallLabel){
        _radBallLabel = [[UILabel alloc] init];
        _radBallLabel.font = [UIFont systemFontOfSize:15];
        _radBallLabel.textColor = kTitleTintTextColor;
    }
    return _radBallLabel;
}

- (UILabel *)blueBallLabel{
    if (!_blueBallLabel){
        _blueBallLabel = [[UILabel alloc] init];
        _blueBallLabel.font = [UIFont systemFontOfSize:15];
        _blueBallLabel.textColor = kTitleTintTextColor;
    }
    return _blueBallLabel;
}

- (UICollectionView *)radBallCollectionView{
    if (!_radBallCollectionView){
        _radBallCollectionView = [self createCollectionView:[MySelectBallViewCell radCellIdentifier]];
    }
    return _radBallCollectionView;
}

- (UICollectionView *)blueBallCollectionView{
    if (!_blueBallCollectionView){
        _blueBallCollectionView = [self createCollectionView:[MySelectBallViewCell blueCellIdentifier]];
    }
    return _blueBallCollectionView;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.radBallCollectionView){
        return self.radBallCountArray.count;
    } else if (collectionView == self.blueBallCollectionView){
        return self.blueBallCountArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    NSInteger selectIdx = -1;
    NSString *title = @"";
    if (collectionView == self.radBallCollectionView){
        identifier = [MySelectBallViewCell radCellIdentifier];
        selectIdx = _radCellSelectIdx;
        title = self.radBallCountArray[indexPath.row];
    } else if (collectionView == self.blueBallCollectionView){
        identifier = [MySelectBallViewCell blueCellIdentifier];
        selectIdx = _blueCellSelectIdx;
        title = self.blueBallCountArray[indexPath.row];
    }
    MySelectBallViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.title = title;
    cell.selected = selectIdx == indexPath.row;
    if (selectIdx == indexPath.row){
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.radBallCollectionView && indexPath.row < self.radBallCountArray.count){
        _radCellSelectIdx = indexPath.row;
        [self reloadBallLabel:self.radBallLabel ballStr:kLocalizedString(@"红球") count:self.radBallCountArray[indexPath.row] countColor:_radBallColor];
    } else if (collectionView == self.blueBallCollectionView && indexPath.row < self.blueBallCountArray.count){
        _blueCellSelectIdx = indexPath.row;
        [self reloadBallLabel:self.blueBallLabel ballStr:kLocalizedString(@"蓝球") count:self.blueBallCountArray[indexPath.row] countColor:_blueBallColor];
    }
}

#pragma mark - 监听collectionView conentSize改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]){
        UICollectionView *collectionView = object;
        CGSize contentSize = collectionView.contentSize;
        [object mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentSize.height);
        }];
    }
}

//移除监听
-(void)dealloc
{
    [self.radBallCollectionView removeObserver:self forKeyPath:@"contentSize"];
    [self.blueBallCollectionView removeObserver:self forKeyPath:@"contentSize"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
