//
//  MainViewController.m
//  FacebookSDKApp
//
//  Created by Natasha on 10.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "MainViewController.h"
#import "StatusViewController.h"
#import "LoginViewController.h"
#import "FeedViewController.h"
#import "NSDictionary+HTTPParametrs.h"

@interface MainViewController ()
-(void)logIn;
@end

@implementation MainViewController
@synthesize tokenLabel;
@synthesize userImageView;
@synthesize nameLabel;
@synthesize showFeedButton;
@synthesize createStatusButton;
@synthesize logOutButton;

-(void)dealloc
{
    self.tokenLabel = nil;
    self.userImageView = nil;
    self.nameLabel = nil;
    self.showFeedButton = nil;
    self.logOutButton = nil;
    self.createStatusButton = nil;
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    SettingManager *setting = [SettingManager sharedInstance];
    if ([setting isAccessToken]) {
        [self loadImage];
        [self loadBaseUserInfo];
        self.tokenLabel.text = setting.accessToken;
    } else {
        [self logIn];
    }
}

- (void)viewDidLoad
{
    [self.createStatusButton setTitle:NSLocalizedString(@"New Status", @"") forState:UIControlStateNormal];
    [self.showFeedButton setTitle:NSLocalizedString(@"Show Feed" , @"") forState:UIControlStateNormal];
    [self.logOutButton setTitle:NSLocalizedString(@"Log Out", @"") forState:UIControlStateNormal ];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tokenLabel = nil;
    self.userImageView = nil;
    self.nameLabel = nil;
    self.showFeedButton = nil;
    self.logOutButton = nil;
    self.createStatusButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Loading User Data Methods

- (void)loadBaseUserInfo
{
    NSMutableDictionary *dictparametrs = [[SettingManager sharedInstance] baseDict];
    NSString *path = [dictparametrs paramFromDict];
    NSString *urlStr = [[[NSString alloc] initWithFormat: @"%@/me/?%@", basePathUrl, path] autorelease];
    
    NSURL *urlInfo = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlInfo];
    
    void(^infoBlock)(Connect*, NSError *) = ^(Connect *con, NSError *err){
        if(!err){
            [self userInfoLoading:con];
        }
    };
    [Connect urlRequest:request withBlock:infoBlock];
}

- (void)loadImage
{
    NSMutableDictionary *dictparametrs = [[SettingManager sharedInstance] baseDict];
   
    NSString *urlStr = [NSString stringWithFormat: @"%@/me/picture?%@", basePathUrl, [dictparametrs paramFromDict]];
    NSURL *url = [NSURL URLWithString:urlStr ];
    
    [self.userImageView loadImage:url ];
}

- (void) userInfoLoading:(Connect*)connect
{
    NSDictionary* parseObj = [connect objectFromResponce];
    
    if ([parseObj valueForKey:kName]) {
        self.nameLabel.text = [parseObj valueForKey:kName];
    }
}

#pragma mark - User Interaction Methods

- (IBAction)createStatus
{
    StatusViewController *detail = [[StatusViewController alloc] initWithNibName:@"StatusViewController" bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (IBAction)showFeed
{
    FeedViewController *feed = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    [self.navigationController pushViewController:feed animated:YES];
    [feed release];
}

- (IBAction)logOut
{
    [[SettingManager sharedInstance] resetToken];
    [self logIn];
}

#pragma mark - private 

- (void)logIn
{
    LoginViewController *login = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    [self presentModalViewController:login animated:YES];
}

@end
