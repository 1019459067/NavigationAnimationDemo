//
//  ViewController.m
//  NavigationAnimationDemo
//
//  Created by HN on 2019/9/6.
//  Copyright © 2019 HN. All rights reserved.
//

#import "ViewController.h"
#import "NavigationAnimationCell.h"

#define k_screen_width [UIScreen mainScreen].bounds.size.width
#define k_screen_height [UIScreen mainScreen].bounds.size.height
#define k_navbar_height (k_statusbar_height+44-k_navbar_title_top)
#define k_statusbar_height ([UIApplication sharedApplication].statusBarFrame.size.height+k_navbar_title_top)
#define k_navbar_title_top 5
#define k_title_bottom 5
#define k_image_height 150
#define k_title_left 20
#define k_color_count 16

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *headerBgImageView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *whiteBaseView;
@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UILabel *bigTitleLabel;
@property (assign, nonatomic) CGSize bigTitlesize;
@property (strong, nonatomic) UILabel *smallTitle;
@property (assign, nonatomic) CGSize smallTitlesize;

@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self createNavHeaderView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(NavigationAnimationCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(NavigationAnimationCell.class)];

    [self creatNavigationView];
    
    [self getData];
}

#pragma mark-creatNavigationView

- (void)creatNavigationView
{
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_navbar_height)];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.alpha = 0;
    [self.view addSubview:self.navigationView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, k_navbar_height-0.5, k_screen_width, 0.5)];
    lineView.backgroundColor = [UIColor darkGrayColor];
    [self.navigationView addSubview:lineView];
}
 
- (UIView *)createNavHeaderView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_image_height)];
    self.headerView.clipsToBounds = YES;

    self.headerBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_image_height)];
    self.headerBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerBgImageView.image = [UIImage imageNamed:@"top_header.jpeg"];
    [self.headerView addSubview:self.headerBgImageView];
    
    self.whiteBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_image_height)];
    self.whiteBaseView.backgroundColor = [UIColor whiteColor];
    self.whiteBaseView.alpha = 0;
    [self.headerView addSubview:self.whiteBaseView];
    
    self.bigTitleLabel = [[UILabel alloc] init];
    self.bigTitleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.bigTitleLabel];
    

    self.smallTitle = [[UILabel alloc] init];
    self.smallTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:self.smallTitle];
    
    [self updateSmallTitle:@"(您还有118条未读信息)"];
    [self updateBigTitle:@"聊生意"
               imageName:@"setting"];
    
    self.bigTitleLabel.frame = CGRectMake(k_title_left,
                                     k_image_height-k_title_bottom-self.bigTitlesize.height-self.self.smallTitlesize.height,
                                     self.bigTitlesize.width,
                                     self.bigTitlesize.height);
    [self updateSmallTitleFrame];

    return self.headerView;
}

#pragma mark - 更新文本控件Frame

- (void)updateSmallTitleFrame
{
    self.smallTitle.frame = CGRectMake(CGRectGetMinX(self.bigTitleLabel.frame),
                                  CGRectGetMaxY(self.bigTitleLabel.frame),
                                  self.self.smallTitlesize.width,
                                  self.self.smallTitlesize.height);
}

- (void)updateSmallTitle:(NSString *)strTitle
{
    self.smallTitle.font = [UIFont systemFontOfSize:8];
    self.smallTitle.text = strTitle;
    
    self.self.smallTitlesize =  [strTitle boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.smallTitle.font} context:nil].size;
}

#pragma mark - 富文本处理

- (void)updateBigTitle:(NSString *)strTitle
             imageName:(NSString *)imageName
{
    self.bigTitleLabel.text = strTitle;
    //1、初始化富文本对象
     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strTitle];

    NSRange rangeBig = NSMakeRange(0, 3);
    //2、修改富文本中的不同文字的样式
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeBig];//字体颜色
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:22] range:rangeBig];//字体大小

    if (strTitle.length>3) {
        NSRange rangeSmall = NSMakeRange(3, strTitle.length-3);
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeSmall];//字体颜色
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rangeSmall];//字体大小
    }

    if (imageName.length>0) {
        //3、初始化NSTextAttachment对象
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds = CGRectMake(0, -1, 16, 16);//设置frame
        attchment.image = [UIImage imageNamed:imageName];//设置图片
        
        //4、创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(attchment)];
        [attributedString insertAttributedString:string atIndex:3];//插入到第几个下标
    }
    
    //5、用label的attributedText属性来使用富文本
    self.bigTitleLabel.attributedText = attributedString;
    
    CGSize size = [attributedString boundingRectWithSize:CGSizeZero
                                                 options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 context:nil].size;
    self.bigTitlesize = CGSizeMake(size.width, size.height+6);
}

#pragma mark-UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NavigationAnimationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NavigationAnimationCell.class)];
    if (!cell) {
        cell =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(NavigationAnimationCell.class) owner:self options:nil].firstObject;
    }
    cell.contentLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float fallOffsetY = k_image_height-k_navbar_height;
    CGFloat offSetY = scrollView.contentOffset.y;
    
    float offSetYRatio = offSetY/fallOffsetY;
    if (offSetYRatio>0.43) {
        self.smallTitle.hidden = YES;
        [self updateBigTitle:@"聊生意(118)"
                   imageName:nil];
    }else {
        self.smallTitle.hidden = NO;
        [self updateBigTitle:@"聊生意"
                   imageName:@"setting"];
    }
    
    if (offSetY <=0 ) {
        scrollView.contentOffset = CGPointMake(0, 0);
        self.navigationView.alpha = 0;
        self.whiteBaseView.alpha = 0;
        self.headerBgImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        
        self.bigTitleLabel.frame = CGRectMake(k_title_left,
                                         k_image_height-k_title_bottom-self.bigTitlesize.height-self.self.smallTitlesize.height,
                                         self.bigTitlesize.width,
                                         self.bigTitlesize.height);
        self.bigTitleLabel.textColor = [UIColor whiteColor];
        
        self.smallTitle.textColor = self.bigTitleLabel.textColor;
    } else if (offSetY > fallOffsetY) {
        offSetY = fallOffsetY;
        self.navigationView.alpha = 1;
        self.whiteBaseView.alpha = 1;
        
        self.bigTitleLabel.frame = CGRectMake(k_title_left+offSetY/fallOffsetY*((k_screen_width-k_title_left*2-self.bigTitlesize.width)/2),
                                         k_statusbar_height,
                                         self.bigTitlesize.width,
                                         self.bigTitlesize.height);
        self.bigTitleLabel.textColor = [UIColor blackColor];
        
        self.smallTitle.textColor = self.bigTitleLabel.textColor;
    } else {
        self.navigationView.alpha = 0;
        self.bigTitleLabel.frame = CGRectMake(k_title_left+offSetY/fallOffsetY*((k_screen_width-k_title_left*2-self.bigTitlesize.width)/2),
                                         k_image_height-k_title_bottom-self.bigTitlesize.height-self.self.smallTitlesize.height-(k_image_height-k_title_bottom-k_statusbar_height- self.bigTitlesize.height-self.self.smallTitlesize.height)*offSetYRatio,
                                         self.bigTitlesize.width,
                                         self.bigTitlesize.height);
        float colorIndex = (k_color_count-offSetY/(fallOffsetY/k_color_count))*(255./k_color_count)/225.;
        self.bigTitleLabel.textColor = [UIColor colorWithRed:colorIndex green:colorIndex blue:colorIndex alpha:1];
        self.headerBgImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1+0.4*offSetYRatio, 1+0.2*offSetYRatio);
        self.whiteBaseView.alpha = offSetYRatio;
        
        self.smallTitle.textColor = self.bigTitleLabel.textColor;
        
    }
    
    [self updateSmallTitleFrame];
    [self.view bringSubviewToFront:self.bigTitleLabel];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY > k_navbar_height/2.-5 && offSetY <= k_navbar_height) {
        [scrollView setContentOffset:CGPointMake(0, k_image_height-k_navbar_height+1) animated:YES];
    }

    if (offSetY > 0 && offSetY <= k_navbar_height/2.) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


- (void)getData
{
    self.dataArray = @[@"运营商推出“流量不限量”套餐后，人们在使用手机流量时不再像过去那样“小心翼翼”。地铁里、公交上，“低头族”捧着手机追热门网剧、刷小视频的场景几乎随处可见。",
                       @"当手机流量不再那么金贵时，却又出现了新的质疑。近期，有网民反映4G网速越来越慢。甚至有传言称，4G网络速度下降，可能与5G的建设推广有关。",
                       @"一时间，“4G降速”成为了网络热议的焦点话题。近日，工业和信息化部新闻发言人、信息通信发展司司长闻库在接受媒体集体采访时指出，工业和信息化部之前从未，将来也不会要求相关运营商降低或限制4G网络速率。工业和信息化部将进一步加强对运营商的监管，切实维护广大消费者的合法权益。",
                       @"相关网络传闻称，“经网友实测，理论上4G网络速度应该是100Mbps，折合为12.5M/s，但实际速度只有1.51M/s，整整差了11M/s”。",
                       @"在北京理工大学计算机网络及对抗技术研究所所长闫怀志看来，网友实测的样本数量有限，要了解整体4G网络速率的实际情况，需要大范围监测样本的数据。",
                       @"此前，工业和信息化部指导中国信息通信研究院搭建了覆盖全国31个省(区、市)的监测平台，通过技术手段监测4G网络速率，目前每季度监测样本数已超过7100万。",
                       @"闻库介绍，来自上述平台的监测数据显示，近年来全国4G平均下载速率持续稳步提升，2019年7月达23.78Mbps，整体上未出现速率明显下降的情况。",
                       @"“从客观上看，4G网速并没有变慢，而且网络速度是一直在提升的。”天津大学计算机科学与技术学院教授王晓飞在接受科技日报记者采访时说道。",
                       @"一、同意设立中国（山东）自由贸易试验区、中国（江苏）自由贸易试验区、中国（广西）自由贸易试验区、中国（河北）自由贸易试验区、中国（云南）自由贸易试验区、中国（黑龙江）自由贸易试验区。",
                       @"二、中国（山东）自由贸易试验区涵盖济南片区、青岛片区、烟台片区，总面积119.98平方公里（具体四至范围见附件，下同）；中国（江苏）自由贸易试验区涵盖南京片区、苏州片区、连云港片区，总面积119.97平方公里；中国（广西）自由贸易试验区涵盖南宁片区、钦州港片区、崇左片区，总面积119.99平方公里；中国（河北）自由贸易试验区涵盖雄安片区、正定片区、曹妃甸片区、大兴机场片区，总面积119.97平方公里；中国（云南）自由贸易试验区涵盖昆明片区、红河片区、德宏片区，总面积119.86平方公里；中国（黑龙江）自由贸易试验区涵盖哈尔滨片区、黑河片区、绥芬河片区，总面积119.85平方公里。上述6个新设自由贸易试验区地块的落桩定界工作，经商务部、自然资源部审核验收后报国务院备案，由商务部、自然资源部负责发布。",
                       @"三、上述6个新设自由贸易试验区内的海关特殊监管区域的实施范围和税收政策适用范围维持不变。",
                       @"四、山东省、江苏省、广西壮族自治区、河北省、云南省、黑龙江省人民政府和商务部要会同有关部门做好新设自由贸易试验区总体方案的组织实施工作。",];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
