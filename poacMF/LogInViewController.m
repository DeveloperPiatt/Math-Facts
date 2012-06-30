//
//  LoginViewController.m
//  poacMF
//
//  Created by Chris Vanderschuere on 04/06/2012.
//  Copyright (c) 2012 Chris Vanderschuere. All rights reserved.
//

#import "LoginViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "PoacMFAppDelegate.h"
#import "AppLibrary.h"
#import "AppConstants.h"
#import "POACDetailViewController.h"
#import "Student.h"
#import "Administrator.h"
#import "AdminSplitViewController.h"
#import "SubjectDetailViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize errorLabel = _errorLabel;
@synthesize buildString = _buildString;
@synthesize loginButton = _loginButton;
@synthesize userNameTextField = _userNameTextField, passwordTextField = _passwordTextField, readyToLogin = _readyToLogin;

-(void) setReadyToLogin:(BOOL)readyToLogin{
    _readyToLogin = readyToLogin;
    if (_readyToLogin) {
        //enableLogin
        self.loginButton.enabled = YES;
    }
    else {
        //DisableLogin
        self.loginButton.enabled = NO;
    }
}

#pragma mark - Button Methods

-(IBAction) loginTapped {
	AppLibrary *al = [[AppLibrary alloc] init];
	//check if username entered
	if (nil == self.userNameTextField.text){
        NSLog(@"UserName: %@",self.userNameTextField);
		NSString *msg = @"Username must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if 
	
	//check if password entered
	if (nil == self.passwordTextField.text){
		NSString *msg = @"Password must be entered.";
		[al showAlertFromDelegate:self withWarning:msg];
		return;
	}//end if
	
	//log em in, swap the view
    PoacMFAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary* loginDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.userNameTextField.text.lowercaseString,self.passwordTextField.text, nil] forKeys:[NSArray arrayWithObjects:@"USERNAME",@"PASSWORD", nil]];
    //Check if is student
    NSFetchRequest *studentLogin = [appDelegate.database.managedObjectModel fetchRequestFromTemplateWithName:@"StudentLogin" substitutionVariables:loginDict];
    NSArray *users = [appDelegate.database.managedObjectContext executeFetchRequest:studentLogin error:nil];
    if (users.count == 1) {
        Student* currentStudent = [users lastObject];
        [self performSegueWithIdentifier:@"studentUserSegue" sender:currentStudent];
    }//
    else if(users.count == 0) {
        //Check if is admin
        NSFetchRequest *adminLogin = [appDelegate.database.managedObjectModel fetchRequestFromTemplateWithName:@"AdminLogin" substitutionVariables:loginDict];
        users = [appDelegate.database.managedObjectContext executeFetchRequest:adminLogin error:nil];
        if (users.count == 1) {
            Administrator* admin = [users lastObject];
            [self performSegueWithIdentifier:@"adminUserSegue" sender:admin];
        }//
        else if(users.count == 1){
            NSLog(@"Does not match ANY user");
        }
        else{
            NSLog(@"Error: Matches %d admin",users.count);
        }
	}
    else {
        NSLog(@"Error: Matches more than 1 student");
    }

}//end method

- (IBAction)sendFeedback:(id)sender {
    [TestFlight openFeedbackView];
}

#pragma mark - Storyboard Segues
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"adminUserSegue"]) {
        [segue.destinationViewController setCurrentAdmin:sender];
    }
    else if ([segue.identifier isEqualToString:@"studentUserSegue"]) {
        SubjectDetailViewController *progressVC = (SubjectDetailViewController *) [[segue.destinationViewController viewControllers] lastObject];
        progressVC.currentStudent = sender;
        
        //Clear Password
        self.passwordTextField.text = nil;
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CGRect frame = CGRectMake(10, 6, 280, 30);
	if ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || 
		(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
		frame = CGRectMake(10, 6, 280, 30);
    
    //Load Build Information
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
	NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
	self.buildString.text = [NSString stringWithFormat:@"%@ v%@ (build %@)",name,version,build];
    
}//end method

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
    //self.userNameTextField.text = @"admin";
	//self.passwordTextField.text = @"poacmf";
}//end method

#pragma mark Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *) textField {
	[textField resignFirstResponder];
	//[self.passwordTextField resignFirstResponder];
	return YES;
}//end method

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setErrorLabel:nil];
    [self setBuildString:nil];
    [super viewDidUnload];
}
@end
