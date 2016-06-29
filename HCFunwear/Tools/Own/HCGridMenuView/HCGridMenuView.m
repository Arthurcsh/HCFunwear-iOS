//
//  HCGridMenuView.m
//  HCFunwear
//
//  Created by 刘海川 on 16/6/28.
//  Copyright © 2016年 Haichuan Liu. All rights reserved.
//

#import "HCGridMenuView.h"
#import "Masonry.h"

static NSString *const kCellIdentifier = @"HCGridMenuCellIndentifier";
static NSInteger const kNumberOfOnepage = 8;
@implementation HCGridMenuView {
    NSInteger _section;
    NSInteger _row;
    NSInteger _numberOfLastPage;
    NSArray *_gridInfoModels;
    UICollectionView *_collectionView;
}

- (instancetype)initWithTypes:(NSArray *)list {
    _gridInfoModels = list;
    [self handleCollectionViewData];
    
    return [self init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _collectionView = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        view.dataSource = self;
        view.delegate = self;
        view.pagingEnabled = YES;
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        view;
    });
    
    [_collectionView registerClass:[HCGridMenuCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

- (void)handleCollectionViewData {
    NSInteger count = _gridInfoModels.count;
    NSInteger page = count / kNumberOfOnepage;
    NSInteger remainder = count % kNumberOfOnepage;
    _numberOfLastPage = remainder;
    if (remainder == 0) {
        _section = page;
    }
    else {
        _section = page + 1;
    }
}

- (void)reloadDataWithTypes:(NSArray *)list {
    _gridInfoModels = list;
    [self handleCollectionViewData];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _section;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == section -1) {
        return _numberOfLastPage;
    }
    return kNumberOfOnepage;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HCGridMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.section * kNumberOfOnepage + indexPath.row;
    HCGridInfo *model = _gridInfoModels[index];
    cell.iconView.image = model.icon;
    cell.titleView.text = model.title;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(collectionView.frame);
    return CGSizeMake((width-10*3-8*2)/4, 95);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(12, 8, 12, 8);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.section*kNumberOfOnepage + indexPath.row;
    if (_menuClickBlock) {
        _menuClickBlock(index);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(HCGridMenuView:selectedAtGridInfo:)]) {
        [_delegate HCGridMenuView:self selectedAtGridInfo:_gridInfoModels[index]];
    }
}

@end

@implementation HCGridMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //126
    _iconView = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@63);
        }];
        view;
    });
    //    _iconView.backgroundColor = kImageViewBGColor;
    //默认图片
    _iconView.image = [UIImage imageNamed:@"mfw_logo_white120"];
    
    _titleView = ({
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(_iconView.mas_bottom);
        }];
        label;
    });
    //默认蚊子
    _titleView.text = @"生活馆";
}

@end

@implementation HCGridInfo

- (instancetype)initWithIcon:(UIImage *)icon
                       title:(NSString *)title {
    self = [super init];
    if (!self) return nil;
    
    _icon = icon;
    _title = title;
    
    return self;
}

@end
