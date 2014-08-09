//
//  FBUYummlyWebViewController.h
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUYummlyWebViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *recipesCollectionView;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *recipes;



@end
