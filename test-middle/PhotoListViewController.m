//
//  PhotoListViewController.m
//  test-middle
//
//  Created by Андрей on 26.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "PhotoListViewController.h"
#import "VkontakteHelper.h"

#import "AlbumList.h"
//#import "PhotoList.h"

@interface PhotoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) PhotoListType listType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

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
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = (self.listType == PhotoAlbumList) ? @"Фотоальбомы": @"Фотографии";
    
    self.dataSource = [AlbumList findAll];
    [self updateDataSource];
    
    // table
    [self createAndLayoutTableView];
}

- (void)createAndLayoutTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    
    NSDictionary *views = @{@"tableView": self.tableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views]];
}

- (void)updateDataSource {
    [[VkontakteHelper sharedHelper] getAlbumsWithComplitionBlock:^(NSArray *responseObject, NSError *error, VKResponse *response) {
        if (!error && responseObject) {
            self.dataSource = responseObject;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PhotoAlbumCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = @"Тест";
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

@end
