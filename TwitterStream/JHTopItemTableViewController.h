//
//  JHTopItemTableViewController.h
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHash.h"

@interface JHTopItemTableViewController : UITableViewController

@property(nonatomic,strong) NSArray<JHHash *> *_Nonnull topDomains;
@property(nonatomic,strong) NSArray<JHHash *> *_Nonnull topHashTags;
@property(nonatomic,strong) NSArray<JHHash *> *_Nonnull topEmojis;

@end
