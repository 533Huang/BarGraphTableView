//
//  ViewController.m
//  BarGraphTableView
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 Yongya. All rights reserved.
//

#import "ViewController.h"

// 屏幕的宽高
#define MainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define MainScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ColorViewBackgroundNew [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]
#define ColorMainSystem2_1_3 [UIColor colorWithRed:255/255.0 green:106/255.0 blue:89/255.0 alpha:1.0]
#define ColorMainGray2_1_3 [UIColor colorWithRed:196/255.0 green:197/255.0 blue:208/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    float maxHeightTag;//最高的数据内容
    NSArray *arrayTags;//标签的数据
    int SelectNumCell;//选中的cell
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _scrollViewDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    _scrollViewDetail.backgroundColor = [UIColor whiteColor];
    // 隐藏水平滚动条
    _scrollViewDetail.showsHorizontalScrollIndicator = NO;
    _scrollViewDetail.showsVerticalScrollIndicator = NO;
    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    _scrollViewDetail.delegate = self;
    // 提示用户,Indicators flash
    [_scrollViewDetail flashScrollIndicators];
    // 是否同时运动,lock
    _scrollViewDetail.directionalLockEnabled = YES;
    _scrollViewDetail.tag = 10;
    [self.view addSubview:_scrollViewDetail];
    _scrollViewDetail.contentSize = CGSizeMake(MainScreenWidth, MainScreenHeight*2);
    
    [self viewUserTagSet];
    [self setData];
}

#pragma mark 设置显示标签分析的view
-(void)viewUserTagSet{
    
    self.tableViewTags = [[UITableView alloc] initWithFrame:CGRectMake((MainScreenWidth-180-30)/2, 10-(MainScreenWidth-375)/2, 180, MainScreenWidth-70) style:UITableViewStylePlain];
    self.tableViewTags.delegate = self;
    self.tableViewTags.dataSource = self;
    self.tableViewTags.tableHeaderView = [[UIView alloc] init];
    self.tableViewTags.tableFooterView = [[UIView alloc] init];
    self.tableViewTags.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewTags.backgroundColor = [UIColor whiteColor];
    self.tableViewTags.tag = 30;
    self.tableViewTags.showsVerticalScrollIndicator = NO;
    [_scrollViewDetail addSubview:self.tableViewTags];
    self.tableViewTags.transform = CGAffineTransformMakeRotation(-180 *M_PI / 180.0/2);
    
}

#pragma mark 设置section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark 设置section中row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayTags.count;
}

#pragma mark 设置每个cell的高
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark tableView cell的详情
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.frame = CGRectMake(0, 0, 180, 45);
    
    NSDictionary *dictUse = arrayTags[indexPath.row];
    
    NSString *strTitle = [NSString stringWithFormat:@"%@",[dictUse objectForKey:@"title"]];
    int NumUse = [[dictUse objectForKey:@"num"] intValue];
    
    for (int i = 0; i<4; i++) {
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(37*i+19, 0, 1, 45)];
        viewLine.backgroundColor = ColorViewBackgroundNew;
        [cell.contentView addSubview:viewLine];
    }
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake((20-45)/2, (45-20)/2, 45, 20)];
    labelTitle.font = [UIFont systemFontOfSize:10.0];
    labelTitle.textColor = ColorMainGray2_1_3;
    labelTitle.text = strTitle;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:labelTitle];
    labelTitle.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0/2);
    
    UIView *viewZhu = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 140*(NumUse/maxHeightTag), 25)];
    viewZhu.backgroundColor = [UIColor colorWithRed:255/255.0 green:228/255.0 blue:225/255.0 alpha:1];
    [cell.contentView addSubview:viewZhu];
    //指定某一个角为圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewZhu.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(4,4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewZhu.bounds;
    maskLayer.path = maskPath.CGPath;
    viewZhu.layer.mask = maskLayer;
    
    UILabel *labelNumShow = [[UILabel alloc] initWithFrame:CGRectMake((20-45)/2+viewZhu.frame.size.width+viewZhu.frame.origin.x, (45-20)/2, 45, 20)];
    labelNumShow.font = [UIFont systemFontOfSize:10.0];
    labelNumShow.textColor = ColorMainGray2_1_3;
    labelNumShow.text = [NSString stringWithFormat:@"%d次",NumUse];
    labelNumShow.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:labelNumShow];
    labelNumShow.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0/2);
    
    if (SelectNumCell == indexPath.row) {
        labelTitle.textColor = ColorMainSystem2_1_3;
        viewZhu.backgroundColor = ColorMainSystem2_1_3;
        labelNumShow.textColor = ColorMainSystem2_1_3;
    }
    return cell;
    
}

#pragma mark cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectNumCell = (int)indexPath.row;
    [self.tableViewTags reloadData];
}

#pragma mark 设置测试数据
-(void)setData{
    
    
    arrayTags = @[@{@"title":@"1美食",@"num":@"1000"},
                  @{@"title":@"2相亲",@"num":@"500"},
                  @{@"title":@"3亲子",@"num":@"10"},
                  @{@"title":@"4生活",@"num":@"200"},
                  @{@"title":@"5汽车",@"num":@"678"},
                  @{@"title":@"6医疗",@"num":@"233"},
                  @{@"title":@"7保险",@"num":@"55"},
                  @{@"title":@"8工具",@"num":@"788"},
                  @{@"title":@"9美食",@"num":@"1000"},
                  @{@"title":@"10相亲",@"num":@"500"},
                  @{@"title":@"11亲子",@"num":@"10"},
                  @{@"title":@"12生活",@"num":@"200"},
                  @{@"title":@"13汽车",@"num":@"678"},
                  @{@"title":@"14医疗",@"num":@"233"},
                  @{@"title":@"15保险",@"num":@"55"},
                  @{@"title":@"15工具",@"num":@"788"}];
    maxHeightTag = 1000;
    
    [self.tableViewTags reloadData];
}

@end
