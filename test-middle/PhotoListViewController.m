//
//  PhotoListViewController.m
//  test-middle
//
//  Created by Андрей on 26.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "PhotoListViewController.h"
#import "VkontakteHelper.h"
#import "TableViewCell.h"
#import "UIFont+Styles.h"

#import "AlbumList.h"
//#import "PhotoList.h"

CGFloat const kHeightRow = 80.f;

@interface TableViewRefreshNoJump : UITableView
// http://stackoverflow.com/questions/19483511/uirefreshcontrol-with-uicollectionview-in-ios7
@end

@implementation TableViewRefreshNoJump

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.scrollsToTop = NO;
    }
    return self;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    if (self.tracking) {
        CGFloat diff = contentInset.top - self.contentInset.top;
        CGPoint translation = [self.panGestureRecognizer translationInView:self];
        translation.y -= diff * 3.0 / 2.0;
        [self.panGestureRecognizer setTranslation:translation inView:self];
    }
    [super setContentInset:contentInset];
}

@end

@interface PhotoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) PhotoListType listType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PhotoListViewController

#pragma mark - Lifecycle

+ (instancetype)photoListWithType:(PhotoListType)listType {
    return [[self alloc] initWithType:listType];
}

- (instancetype)initWithType:(PhotoListType)listType
{
    self = [super init];
    if (self) {
        self.listType = listType;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = (self.listType == PhotoAlbumList) ? @"Фотоальбомы": @"Фотографии";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"main_color"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont thinFontWithSize:22.f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"icon_back"]];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closePhotoLibrary)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    // table
    [self createAndLayoutTableView];
    
    // возьмем сохраненные альбомы
    self.dataSource = [AlbumList findAll];
    // отсортировать по дате
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.dataSource = [self.dataSource sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [self updateDataSourceFromServer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)createAndLayoutTableView {
    self.tableView = [[TableViewRefreshNoJump alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = kHeightRow;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    [self.view addSubview:self.tableView];
    
    NSDictionary *views = @{@"tableView": self.tableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-64)-[tableView]|" options:0 metrics:nil views:views]];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.tableView layoutIfNeeded];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)refresh:(UIRefreshControl *)sender {
    [self updateDataSourceFromServer];
}

- (void)updateDataSourceFromServer {
    [[VkontakteHelper sharedHelper] getAlbumsWithComplitionBlock:^(NSArray *responseObject, NSError *error, VKResponse *response) {
        if (!error && responseObject) {
            self.dataSource = responseObject;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)closePhotoLibrary {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PhotoAlbumCell";
    
    AlbumList *album = self.dataSource[indexPath.row];
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [TableViewCell cellWithAlbum:album];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[PhotoListViewController photoListWithType:PhotoAlbumList] animated:YES];
}

//- (NSString *)stringPhotoCount:(NSNumber *)count {
//    NSInteger lastDigit = count.integerValue % 10;
//    switch (lastDigit) {
//        case 0: case <#expression#>:
//            return @"фотографий";
//    }
//}

@end
