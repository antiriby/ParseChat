//
//  LoginViewController.m
//  ParseChat
//
//  Created by antiriby on 7/10/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    UIAlertController *alert = [self makeUIAlert];
    
    // set user properties
    newUser.username = self.usernameField.text;
//    newUser.email = self.emailField.text;
    newUser.email = @"email@gmail.com";
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            if([self.usernameField.text isEqual:@""]){
                [self presentViewController:alert animated:YES completion:^{
                }];
            } else if([self.passwordField.text isEqual:@""]){
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
        }
    }];
}
     
- (UIAlertController *)makeUIAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unsucessful Registration" message:@"Empty username or password." preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // handle cancel response here. Doing nothing will dismiss the view.
    }];
    
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    return alert;
         
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    UIAlertController *alert = [self makeUIAlert];
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            if([self.usernameField.text isEqual:@""]){
                [self presentViewController:alert animated:YES completion:^{
                }];
                
            } else if([self.passwordField.text isEqual:@""]){
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
