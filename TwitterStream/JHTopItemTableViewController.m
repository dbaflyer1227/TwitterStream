//
//  JHTopItemTableViewController.m
//  TwitterStream
//
//  Created by dsailer on 4/9/17.
//  Copyright © 2017 dsailer. All rights reserved.
//

#import "JHTopItemTableViewController.h"
#import "JHHash.h"

@interface JHTopItemTableViewController ()

@property (nonatomic,strong) NSMutableArray *_Nonnull keys;

@end

@implementation JHTopItemTableViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.keys = [[NSMutableArray alloc] init];
    if ([self.topEmojis count])
        [self.keys addObject:@"e"];
    
    if ([self.topDomains count])
        [self.keys addObject:@"d"];
    
    if ([self.topHashTags count])
        [self.keys addObject:@"h"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [self.keys objectAtIndex:section];
    
    if ([@"d" isEqualToString:key]) {
        return [self.topDomains count];
    }
    else if ([@"e" isEqualToString:key]) {
        return [self.topEmojis count];
    }
    else if ([@"h" isEqualToString:key]) {
        return [self.topHashTags count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"topItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    NSString *key = [self.keys objectAtIndex:indexPath.section];
    
    JHHash *hash = nil;
    if ([@"d" isEqualToString:key]) {
        hash = [self.topDomains objectAtIndex:indexPath.row];
    }
    else if ([@"e" isEqualToString:key]) {
        hash = [self.topEmojis objectAtIndex:indexPath.row];
    }
    else if ([@"h" isEqualToString:key]) {
        hash = [self.topHashTags objectAtIndex:indexPath.row];
    }
    
    if ([@"e" isEqualToString:key]) {
        
        if (hash.text) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",hash.text,hash.count];
        }
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",hash.text,hash.count];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *key = [self.keys objectAtIndex:section];
    
    if ([@"d" isEqualToString:key]) {
        return @"Top Domains";
    }
    else if ([@"e" isEqualToString:key]) {
        return @"Top Emojis";
    }
    else if ([@"h" isEqualToString:key]) {
        return @"Top Hash Tags";
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
