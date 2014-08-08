//
//  FBUGroceryListMenu.m
//  GroceryList
//
//  Created by Uma Girkar on 8/6/14.
//  Copyright (c) 2014 FacebookU. All rights reserved.
//

#import "FBUGroceryListMenu.h"
#import "FBULogInViewController.h"
#import "FBUSignUpViewController.h"

@implementation FBUGroceryListMenu

-(NSDictionary *)findOutWhoPaysWhom:(NSDictionary *)allPeople totalAmount:(float)totalMoney
{
    NSDictionary *people = allPeople;
    NSArray *keys = [people allKeys];
    NSMutableArray *howMuchIOwe = [[NSMutableArray alloc] init];
    NSMutableArray *howMuchINeed = [[NSMutableArray alloc] init];
    int peopleCount = [people count];
    float total = totalMoney;
    float contribution = total / peopleCount;
    for (NSString *key in [people allKeys]) {
        NSNumber *myCont = [people objectForKey:key];
        float myValue = [myCont floatValue];
        if (myValue > contribution) {
            float moneyNeeded = myValue - contribution;
            [howMuchIOwe addObject:[NSNumber numberWithFloat:-1]];
            [howMuchINeed addObject:[NSNumber numberWithFloat:moneyNeeded]];
        } else {
            float moneyToGive = contribution - myValue;
            [howMuchIOwe addObject:[NSNumber numberWithFloat:moneyToGive]];
            [howMuchINeed addObject:[NSNumber numberWithFloat:-1]];
        }
    }
    //NSLog([howMuchIOwe description]);
    //NSLog([howMuchINeed description]);
    NSMutableDictionary *whoGivesWho = [[NSMutableDictionary alloc] init];
    int i = 0;
    for (NSString *key in [people allKeys]) {
        NSMutableDictionary *peopleAndMoneyOwed = [[NSMutableDictionary alloc] init];
        float amountToBePaid = [howMuchIOwe[i] floatValue];
        if (amountToBePaid > 0) {
            for (int b = 0; b < [howMuchINeed count] && amountToBePaid > 0; b++) {
                if ([howMuchINeed[b] floatValue] > 0) {
                    if ((amountToBePaid - [howMuchINeed[b] floatValue]) >= 0) {
                        amountToBePaid = amountToBePaid - [howMuchINeed[b] floatValue];
                        [peopleAndMoneyOwed setObject:howMuchINeed[b] forKey:keys[b]];
                        howMuchINeed[b] = [NSNumber numberWithFloat:-1];
                    } else {
                        [peopleAndMoneyOwed setObject:[NSNumber numberWithFloat:amountToBePaid] forKey:keys[b]];
                        amountToBePaid = 0;
                        howMuchINeed[b] = [NSNumber numberWithFloat:([howMuchINeed[b] floatValue] - amountToBePaid)];
                    }
                }
            }
            [whoGivesWho setObject:peopleAndMoneyOwed forKey:key];
        }
        i++;
    }
    NSLog([whoGivesWho description]);
    return people;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *keys = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:1], [NSNumber numberWithFloat:2], [NSNumber numberWithFloat:3], nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    NSInteger myInt = 6;
    [self findOutWhoPaysWhom:dictionary totalAmount:myInt];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFields: PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

-(void)makeLoginAppear
{
    // Create the log in view controller
    FBULogInViewController *logInViewController = [[FBULogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    [logInViewController setFacebookPermissions:@[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_friends"]];
    [logInViewController setFields: PFLogInFieldsFacebook | PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton];
    
    // Create the sign up view controller
    FBUSignUpViewController *signUpViewController = [[FBUSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    [signUpViewController setFields:PFSignUpFieldsAdditional | PFSignUpFieldsDismissButton | PFSignUpFieldsSignUpButton | PFSignUpFieldsEmail | PFSignUpFieldsAdditional];
    
    // Formats the additional field
    signUpViewController.signUpView.additionalField.placeholder = @"Phone Number";
    signUpViewController.signUpView.additionalField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"I was here");
}

- (IBAction)logoutButtonPressed:(id)sender
{
    [PFUser logOut];
    
    NSLog(@"Logging out...");
    [self makeLoginAppear];
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    //Create request for user's Facebook data
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"id,name,picture",@"fields",nil];
    
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters:params
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if(error == nil) {
                                  FBGraphObject *response = (FBGraphObject*)result;
                                 // NSLog(@"Friends: %@",[response objectForKey:@"data"]);
                              }
                          }];
    
    FBRequest *request = [FBRequest requestForMe];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            [FBRequestConnection startWithGraphPath:@"/me/friends"
                                         parameters:nil
                                         HTTPMethod:@"GET"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error
                                                      ) {
                                      if(error == nil) {
                                          FBGraphObject *response = (FBGraphObject*)result;
                                          NSDictionary *myFriendsDictionary = [response objectForKey:@"data"];
                                          NSLog(@"Friends: %@",myFriendsDictionary);
                                      }
                                  }];
            
            NSString *facebookID = userData[@"id"];
            NSLog(@"I %@", facebookID);
            NSString *name = userData[@"name"];
            NSLog(@"My name is %@", name);
            //NSString *location = userData[@"location"][@"name"];
            NSString *email = userData[@"email"];
            NSLog(@"My email is %@", email);
            
            NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            NSArray* friends = userData[@"user_friends"];
            //NSLog(@"I have %lu", [friends count]);
            /*for (NSDictionary<FBGraphUser>* friend in friends) {
                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
            }*/
            //Now add the data to the UI elements ...
            
            PFUser *user = [PFUser currentUser];
            user[@"FBid"] = facebookID;
            user[@"name"]= name;
            user[@"email"] = email;
            user[@"fbImage"] = pictureURL;
            [user saveInBackground];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
