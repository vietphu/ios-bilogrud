//
//  InfoViewController.m
//  FaceBookUserInfo
//
//  Created by Natasha on 31.08.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "InfoViewController.h"
#import "SBJson.h"
#import "Connect.h"

#define kToken @"AAACEdEose0cBAM4s0rZAJBUZBFhJ0ppg4RzgTac7VjLr4VdBWIlPAe3ypSsMRfUX9o181QOrQXY8Sf1jJCuHXxsQWnT9eOiqlt3Yc5A8s9MMgIRtcR"

#define kUserInfoTag 1
#define kUserImage 2
#define kUserStatus 3
@interface InfoViewController ()
@property (nonatomic, retain)NSMutableDictionary *conDict;
@end

@implementation InfoViewController
@synthesize personalInfo;
@synthesize userImage;
@synthesize testImageConnection;
@synthesize testData;
@synthesize conDict;
@synthesize userIdValue;
@synthesize loadImageActivity;
@synthesize nameLabel;
@synthesize statusInfo;
-(void)dealloc{
    self.userImage = nil;
    self.personalInfo = nil;
    self.testImageConnection = nil;
    self.testData = nil;
    self.conDict = nil;
    self.userIdValue = nil;
    self.loadImageActivity = nil;
    self.nameLabel = nil;
    self.statusInfo = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    //image loading
//    NSString* urlsstring =@"https://graph.facebook.com/100001866482612/picture";
//    NSURL* url = [NSURL URLWithString:urlsstring];
//    NSURLRequest* req = [NSURLRequest requestWithURL:url];
//    NSOperationQueue* queue = [NSOperationQueue mainQueue];
//   [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse* resp, NSData* data, NSError* error){
//       UIImage* image = [UIImage imageWithData:data];
//       self.userImage.image = image;
//    }];

    self.conDict = [[[NSMutableDictionary alloc]init]autorelease];
    [self.loadImageActivity startAnimating];
    
    [self addConnectImage];
    [self addConnectInfo];
    [self addConnectStatus];
}

-(void) addConnectImage{
    NSString *urlString = [NSString stringWithFormat: @"https://graph.facebook.com/%@/picture", self.userIdValue];
    NSURL *url = [NSURL URLWithString:urlString ];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url];// cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
    Connect *connectImage = [[Connect alloc] initRequest:imageRequest responce:eResponceTypeImage];    connectImage.delegate = self;
    connectImage.tag = kUserImage;
    [self addConnectToDict:connectImage];
    
    [connectImage startConnect];
    [connectImage release];
}

#pragma mark - Add connects

-(void)addConnectInfo{
    NSString *urlInfoString = [[[NSString alloc]initWithFormat: @"https://graph.facebook.com/%@/?access_token=%@", self.userIdValue, kToken] autorelease];
    NSURL *urlInfo = [NSURL URLWithString:urlInfoString];
    NSURLRequest *infoRequest= [NSURLRequest requestWithURL:urlInfo];
    
    Connect *connectInfo = [[Connect alloc] initRequest:infoRequest responce:eResponceTypeJson];
    connectInfo.delegate = self;
    connectInfo.tag = kUserInfoTag;
    [self addConnectToDict:connectInfo];
    [connectInfo startConnect];
    [connectInfo release];
}

-(void)addConnectStatus{
    NSString *urlStatusString = [[[NSString alloc]initWithFormat: @"https://graph.facebook.com/%@/?access_token=%@/statuses", self.userIdValue,kToken]autorelease];
    NSURL *urlStatus = [NSURL URLWithString:urlStatusString];
    NSURLRequest *statusRequest= [NSURLRequest requestWithURL:urlStatus];
    
    Connect *connectStatus = [[Connect alloc] initRequest:statusRequest responce:eResponceTypeJson];
    connectStatus.delegate = self;
    connectStatus.tag = kUserStatus;
    [self addConnectToDict:connectStatus];
    [connectStatus startConnect];
    [connectStatus release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.userImage = nil;
    self.personalInfo = nil;
    self.testImageConnection = nil;
    self.testData = nil;
    self.conDict = nil;
    self.userIdValue = nil;
    self.loadImageActivity = nil;
    self.nameLabel = nil;
    self.statusInfo = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - connection dict

-(void)addConnectToDict: (Connect *)con{
    [self.conDict setValue:con forKey:[con.connection description]];
}

- (void)removeConnect:(Connect*)connect{
    NSString* key =  [connect.connection description];
    [connect retain];
    [self.conDict removeObjectForKey:key];
    [connect autorelease];
}

-(void)deleteConnectFromDict: (NSURLConnection*)con{
     NSString* key =  [con description];
     [self.conDict removeObjectForKey:key];
}

-(Connect*)connectByConnection: (NSURLConnection*) con{
    return [self.conDict valueForKey:con.description];
}

#pragma mark - ConnectDelegate Method

-(void)didLoadingData:(Connect *)connect error:(NSError *)err{
    if (!err) {
        NSLog(@"connect");
        switch (connect.tag) {
            case kUserImage:{
                [self userImageLoading:connect];
            }
                break;
            case kUserInfoTag:{
                [self userInfoLoading:connect];
            }
                break;
            case kUserStatus:
            {
                [self userStatusLoading:connect];
            }
            default:
                break;
        }
    }
    else{
        if(connect.responceType == eResponceTypeImage){
            [self.loadImageActivity stopAnimating];
        }
    }
    [self deleteConnectFromDict:connect.connection];
}
#pragma mark - Data loading by tag
-(void)userImageLoading: (Connect*)connect{
    UIImage *testImage = [UIImage imageWithData: connect.data];
    [self.loadImageActivity stopAnimating];
    self.userImage.image = testImage;
}

-(void)userInfoLoading:(Connect*)connect{
    NSDictionary* parseObj = [connect objectFromResponce];
    if ([parseObj valueForKey:@"name"]) {
        self.nameLabel.text = [parseObj valueForKey:@"name"];
    }
    
    NSMutableString* information = [[[NSMutableString alloc]init]autorelease];
    
    if ([parseObj valueForKey:@"birthday"]) {
        [information appendFormat:@"Birthday: %@\n",[parseObj valueForKey:@"birthday"] ] ;
    }
    //...
    self.personalInfo.text = information;
}

-(void)userStatusLoading:(Connect*)connect{
    NSDictionary* parseObj = [connect objectFromResponce];
    self.statusInfo.text = @"dasgfidgfusd";
}
@end