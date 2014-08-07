//
//  FBUGroceryListItem.m
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroceryListItem.h"
#import <Parse/PFObject+Subclass.h>

@implementation FBUGroceryListItem

+ (NSString *)parseClassName
{
    return @"FBUBucketListItem";
}

@dynamic itemName;
@dynamic quantity;
@dynamic owner;

@end
