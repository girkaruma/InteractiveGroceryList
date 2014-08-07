//
//  FBUGroceryListMenu.m
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroceryListMenu.h"

@implementation FBUGroceryListMenu


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFields: PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
