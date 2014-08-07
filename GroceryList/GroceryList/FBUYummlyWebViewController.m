//
//  FBUYummlyWebViewController.m
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUYummlyWebViewController.h"

@interface FBUYummlyWebViewController ()

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *searchedWords;
@property (strong, nonatomic) NSString *url;

@end


@implementation FBUYummlyWebViewController

- (void)viewDidLoad
{
    self.recipesCollectionView.delegate = self;
    self.recipesCollectionView.dataSource = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)callYummlyAPI
{
    self.responseData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchedWords = [self.recipeSearchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *url = @"http://api.yummly.com/v1/api/recipes?_app_id=f07aaa47&_app_key=6d7ecf41b1791b1d9a05b31dd8b62f39&q=";
    
    NSString *urlWithKeywords = [url stringByAppendingString:searchedWords];
    self.url = [urlWithKeywords stringByAppendingString:@"&requirePictures=true"];
    
    self.url = [url stringByAppendingString:searchedWords];
    [self callYummlyAPI];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    //grab recipe names
    for (id key in res) {
        
        NSString *keyAsString = (NSString *)key;
        if ([keyAsString isEqualToString:@"matches"]) {
            id value = [res objectForKey:key];
            for (id recipe in value) {
                NSLog(@"%@", recipe);
            }
//            for (id property in value) {
//                NSString *propertyAsString = (NSString *)property;
//                if ([propertyAsString isEqualToString:@"recipeName"]) {
//                    NSLog(@"%@", [property objectForKey:propertyAsString]);
//                }
            }

}
    
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
}

#pragma mark - UICollectionViewDelegateJSPintLayout
- (CGFloat)columnWidthForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    return 135.0;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return 2;
}

/*- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    FBUGroup *group = self.displayedGroups[indexPath.row];
    if (!group.groupImage) {
        return 200;
    }
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[group.groupImage getData]]];
    CGSize rctSizeOriginal = imageView.bounds.size;
    double scale = (222  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);
    
    CGFloat height = imageView.bounds.size.height;
    
    return height;
}


# pragma mark - Collection View Data Source

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FBUGroup *group = self.displayedGroups[indexPath.row];
    
    UICollectionViewCell *cell = [self.groupsCollection dequeueReusableCellWithReuseIdentifier:@"groupCell" forIndexPath:indexPath];
    
    CGRect rectReference = cell.bounds;
    FBUCollectionCellBackgroundView* backgroundView = [[FBUCollectionCellBackgroundView alloc] initWithFrame:rectReference];
    cell.backgroundView = backgroundView;
    
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:rectReference];
    selectedBackgroundView.backgroundColor = [UIColor clearColor];   // no indication of selection
    cell.selectedBackgroundView = selectedBackgroundView;
    
    // remove subviews from previous usage of this cell
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[group.groupImage getData]]];
    
    CGSize rctSizeOriginal = imageView.bounds.size;
    double scale = (cell.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + 20,rctSizeFinal.width,rctSizeFinal.height);
    
    [cell.contentView addSubview:imageView];
    
    CGRect descriptionLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop + rctSizeFinal.height + 15,rctSizeFinal.width,40);
    CGRect nameLabel = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop, rctSizeFinal.width,15);
    
    UILabel* name = [[UILabel alloc] initWithFrame:nameLabel];
    name.numberOfLines = 0;
    name.font = [UIFont systemFontOfSize:12];
    
    UILabel* description = [[UILabel alloc] initWithFrame:descriptionLabel];
    description.numberOfLines = 2;
    description.font = [UIFont systemFontOfSize:12];
    
    name.text = [group groupName];
    description.text = [group groupDescription];
    
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:description];
    
    return cell;
}*/

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.recipes count];
}

@end
