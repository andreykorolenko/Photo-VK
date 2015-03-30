//
//  PhotoListViewController.m
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "PhotoListViewController.h"
#import "ListViewCell.h"
#import "ListViewCellDelegate.h"
#import "VKManager.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "UIFont+Styles.h"

#import "AlbumManager.h"
#import "Album.h"
#import "Photo.h"

#import "MWPhotoBrowser.h"
#import "PhotoShow.h"

#import "GoogleMapViewController.h"

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

typedef NS_ENUM(NSInteger, ListType) {
    AlbumsList,
    PhotosList
};

@interface PhotoListViewController () <UITableViewDataSource, UITableViewDelegate, ListViewCellDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, assign) ListType listType;
@property (nonatomic, strong) Album *selectedAlbum;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, assign) BOOL needBlackStatusBar;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) UIView *emptyAlbumsView;

@end

@implementation PhotoListViewController

#pragma mark - Lifecycle

+ (instancetype)photoListWithAllAlbums {
    return [[self alloc] initWithAllAlbums];
}

- (instancetype)initWithAllAlbums
{
    self = [super init];
    if (self) {
        self.listType = AlbumsList;
    }
    return self;
}

+ (instancetype)photoListWithPhotosFromAlbum:(Album *)album {
    return [[self alloc] initWithAlbum:album];
}

- (instancetype)initWithAlbum:(Album *)album
{
    self = [super init];
    if (self) {
        self.listType = PhotosList;
        self.selectedAlbum = album;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLightStatusBar:YES];
    self.needBlackStatusBar = YES;
    [self.view layoutIfNeeded];
    
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = (self.listType == AlbumsList) ? [MCLocalization stringForKey:@"photo_albums"] : [MCLocalization stringForKey:@"photos"];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // настраиваем navigation bar
    [self customizeNavigationBar];
    
    // загружаем данные из Core Data
    [self loadDataSourceWithType:self.listType];
    
    // создаем таблицу
    [self createAndLayoutTableView];
    
    // загружаем данные из сети
    [self updateDataSourceFromServerWithType:self.listType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.needBlackStatusBar) {
        [self showLightStatusBar:NO];
    }
}

#pragma mark - UI

- (void)createAndLayoutTableView {
    self.tableView = [[TableViewRefreshNoJump alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = kHeightRow;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:self.tableView];
    
    NSDictionary *views = @{@"tableView": self.tableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-64)-[tableView]|" options:0 metrics:nil views:views]];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)customizeNavigationBar {
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    // общее
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"main_color"] forBarMetrics:UIBarMetricsDefault];
    navigationBar.translucent = YES;
    navigationBar.tintColor = [UIColor whiteColor];
    
    // тайтл
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont thinFontWithSize:22.f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // кнопка назад
    navigationBar.backIndicatorImage = [UIImage imageNamed:@"icon_back"];
    navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"icon_back"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil
                                                                      action:nil];
    // иконка смены экранов
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_switch"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(closePhotoLibrary)];
}

- (void)showLightStatusBar:(BOOL)isLight {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarStyle:isLight ? UIStatusBarStyleLightContent: UIStatusBarStyleDefault];
    });
}

// сообщение - нет альбомов/фото
- (void)showMessageEmptyWithType:(ListType)type {
    
    [self.emptyAlbumsView removeFromSuperview];
    
    // если альбомов или фото нет
    if (self.dataSource.count == 0) {
        self.emptyAlbumsView = [[UIView alloc] initWithFrame:CGRectZero];
        self.emptyAlbumsView.translatesAutoresizingMaskIntoConstraints = NO;
        self.emptyAlbumsView.backgroundColor = [UIColor whiteColor];
        self.emptyAlbumsView.alpha = 0.0;
        [self.view addSubview:self.emptyAlbumsView];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        messageLabel.font = [UIFont thinFontWithSize:22.0];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.text = (type == AlbumsList) ? [MCLocalization stringForKey:@"album_list_is_empty"] : [MCLocalization stringForKey:@"photo_list_is_empty"];
        [self.emptyAlbumsView addSubview:messageLabel];
        
        NSDictionary *views = @{@"emptyAlbums": self.emptyAlbumsView, @"message": messageLabel};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[emptyAlbums]|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[emptyAlbums]|" options:0 metrics:nil views:views]];
        
        [self.emptyAlbumsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[message]|" options:0 metrics:nil views:views]];
        [self.emptyAlbumsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[message]|" options:0 metrics:nil views:views]];
        [UIView animateWithDuration:0.3 animations:^{
            self.emptyAlbumsView.alpha = 1.0;
        }];
    }
}

#pragma mark - Load Content

// загрузка из core data
- (void)loadDataSourceWithType:(ListType)type {
    if (type == AlbumsList) {
        self.dataSource = [AlbumManager allAlbums];
    } else {
        self.dataSource = [self.selectedAlbum allPhotos];
        [self updatePhotosForBrowser];
    }
}

// загрузка из сети
- (void)updateDataSourceFromServerWithType:(ListType)type {
    if (type == AlbumsList) {
        [[VKManager sharedHelper] getAlbumsWithComplitionBlock:^(NSArray *responseObject, NSError *error, VKResponse *response) {
            if (!error && responseObject) {
                self.dataSource = responseObject;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                [self showMessageEmptyWithType:type];
            } else {
                // невозможно обновить ленту
            }
        }];
    } else {
        [[VKManager sharedHelper] getPhotosFromAlbum:self.selectedAlbum withComplitionBlock:^(id responseObject, NSError *error, VKResponse *response) {
            if (!error && responseObject) {
                self.dataSource = responseObject;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                [self updatePhotosForBrowser];
                [self showMessageEmptyWithType:type];
            } else {
                // невозможно обновить ленту
            }
        }];
    }
}

- (void)refresh:(UIRefreshControl *)sender {
    [self updateDataSourceFromServerWithType:self.listType];
}

#pragma mark - All Methods

- (void)closePhotoLibrary {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// создает объекты фото для просмотра в photobrowser
- (void)updatePhotosForBrowser {
    
    NSMutableArray *photos = [NSMutableArray array];
    for (Photo *photo in self.dataSource) {
        PhotoShow *photoShow = [PhotoShow photoWithPhoto:photo];
        [photos addObject:photoShow];
    }
    self.photos = photos;
}

// возвращает номер фотографии по счету
- (NSInteger)numberPhotoInListByUID:(NSNumber *)uid {
    NSInteger result = 0;
    for (Photo *photo in self.dataSource) {
        if (photo.uidValue == uid.integerValue) {
            return result;
        }
        result++;
    }
    return -1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (ListViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PhotoAlbumCell";
    
    NSManagedObject *object = self.dataSource[indexPath.row];
    
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if (self.listType == AlbumsList) {
            cell = [ListViewCell cellWithAlbum:(Album *)object];
        } else {
            cell = [ListViewCell cellWithPhoto:(Photo *)object delegate:self];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == AlbumsList) {
        self.needBlackStatusBar = NO;
        Album *selectedAlbum = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:[PhotoListViewController photoListWithPhotosFromAlbum:selectedAlbum] animated:YES];
    }
}

#pragma mark - ListViewCellDelegate

// пользователь нажал на фото
- (void)userDidSelectPhoto:(NSNumber *)uid {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    [browser setCurrentPhotoIndex:[self numberPhotoInListByUID:uid]];
    
    self.needBlackStatusBar = NO;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browser];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

@end
