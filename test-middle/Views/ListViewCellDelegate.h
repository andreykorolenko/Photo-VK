//
//  ListViewCellDelegate.h
//  test-middle
//
//  Created by Андрей on 29.03.15.
//  Copyright (c) 2015 sebbia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ListViewCellDelegate <NSObject>

- (void)userDidSelectPhoto:(NSNumber *)uid;

@end
