//
//  FBUGroceryListDetailViewController.m
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroceryListDetailViewController.h"
#import "FBUGroceryListItem.h"

@interface FBUGroceryListDetailViewController() <UINavigationControllerDelegate, UITextViewDelegate>

@end

@implementation FBUGroceryListDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.groceryItemTextField.delegate = self;
    if(self.item){
        self.groceryItemTextField.text = self.item.itemName;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return YES;
    }
    
    return YES;
}

- (IBAction)backgroundPressed:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)userDidSave:(id)sender
{
    
    [self showAlertWithTitle: [NSString stringWithFormat:@"%@", self.groceryItemTextField.text]
                     message: [NSString stringWithFormat:@"%@ was saved!", self.groceryItemTextField.text]];
    FBUGroceryListItem *newBucketItem = [FBUGroceryListItem object];
    newBucketItem.itemName = self.groceryItemTextField.text;
    newBucketItem.owner = [PFUser currentUser];
    [newBucketItem saveInBackground];
    
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
