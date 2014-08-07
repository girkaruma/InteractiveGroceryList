//
//  FBUGroceryListItem.h
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FBUGroceryListItem : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) PFUser *owner;

@end
