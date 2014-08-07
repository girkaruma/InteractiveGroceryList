//
//  FBUGroceryListDetailViewController.h
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBUGroceryListItem;

@interface FBUGroceryListDetailViewController : UIViewController

@property (nonatomic, strong) FBUGroceryListItem *item;

@property (weak, nonatomic) IBOutlet UITextField *groceryQuantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *groceryItemTextField;

@end
