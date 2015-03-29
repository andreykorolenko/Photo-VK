//
//  PhotoListViewController.m
//  test-middle
//
//  Created by Андрей on 26.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import "PhotoListViewController.h"
#import "VkontakteHelper.h"
#import "ListViewCell.h"
#import "ListViewCellDelegate.h"
#import "UIFont+Styles.h"

#import "AlbumManager.h"
#import "Album.h"
#import "Photo.h"

#import "MWPhotoBrowser.h"

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

@property (nonatomic, strong) NSMutableArray *photos;

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
    [self.view layoutIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = (self.listType == AlbumsList) ? @"Фотоальбомы": @"Фотографии";
    
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
    [self showLightStatusBar:NO];
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

- (void)closePhotoLibrary {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Load Content

- (void)loadDataSourceWithType:(ListType)type {
    if (type == AlbumsList) {
        self.dataSource = [AlbumManager allAlbums];
    } else {
        self.dataSource = [self.selectedAlbum allPhotos];
        [self updatePhotosForBrowser];
    }
}

- (void)refresh:(UIRefreshControl *)sender {
    [self updateDataSourceFromServerWithType:self.listType];
}

- (void)updateDataSourceFromServerWithType:(ListType)type {
    if (type == AlbumsList) {
        [[VkontakteHelper sharedHelper] getAlbumsWithComplitionBlock:^(NSArray *responseObject, NSError *error, VKResponse *response) {
            if (!error && responseObject) {
                self.dataSource = responseObject;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            } else {
                // невозможно обновить ленту
            }
        }];
    } else {
        [[VkontakteHelper sharedHelper] getPhotosFromAlbum:self.selectedAlbum withComplitionBlock:^(id responseObject, NSError *error, VKResponse *response) {
            if (!error && responseObject) {
                self.dataSource = responseObject;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
                [self updatePhotosForBrowser];
            } else {
                // невозможно обновить ленту
            }
        }];
    }
}

// создает объекты фото для просмотра в photobrowser
- (void)updatePhotosForBrowser {
    
    NSMutableArray *photos = [NSMutableArray array];
    for (Photo *photo in self.dataSource) {
        MWPhoto *bigPhoto = [MWPhoto photoWithURL:[NSURL URLWithString:photo.originalSizeURL]];
        bigPhoto.caption = @"Fireworks";
        [photos addObject:bigPhoto];
    }
    self.photos = photos;
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
        Album *selectedAlbum = self.dataSource[indexPath.row];
        [self.navigationController pushViewController:[PhotoListViewController photoListWithPhotosFromAlbum:selectedAlbum] animated:YES];
    }
}

#pragma mark - ListViewCellDelegate

- (void)userDidSelectPhoto:(NSNumber *)uid {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    [browser setCurrentPhotoIndex:[self numberPhotoInListByUID:uid]];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

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

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (void)createPhotoBrowser {
    
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    // Photos
    
    
    // Options
    enableGrid = NO;
    
    self.photos = photos;
//    /self.thumbs = thumbs;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    //nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];

}

@end
