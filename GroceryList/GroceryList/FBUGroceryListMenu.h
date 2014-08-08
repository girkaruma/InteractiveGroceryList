//
//  FBUGroceryListMenu.h
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBUGroceryListMenu : UIViewController <PFLogInViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end
