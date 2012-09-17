//
//  AppDelegate.m
//  IntroductionCoreData
//
//  Created by Natasha on 14.09.12.
//  Copyright (c) 2012 Natasha. All rights reserved.
//

#import "AppDelegate.h"
#import "Person.h"

@interface AppDelegate()
- (BOOL)createNewPersonWithFirstName:(NSString*)paramFirstName lastName:(NSString*)paramLastName age:(NSUInteger)paramAge;
@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self createNewPersonWithFirstName:@"Anthony" lastName:@"Robbins"
                                   age:51];
    [self createNewPersonWithFirstName:@"Richard" lastName:@"Branson"
                                   age:61];
    //read
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSSortDescriptor *ageSort = [[NSSortDescriptor alloc] initWithKey:@"age"
                                                            ascending:YES];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:ageSort];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    
    
    [fetchRequest setEntity:entity];
    
    NSError *requestError = nil;
    NSArray *persons = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if([persons count] ){
        NSUInteger counter = 1;
        for (Person *thisPerson in persons){
            NSLog(@"Person %d First Name = %@", (NSUInteger)counter, thisPerson.firstName);
            NSLog(@"Person %lu Last Name = %@", (unsigned long)counter,
                  thisPerson.lastName);
            NSLog(@"Person %lu Age = %ld", (unsigned long)counter,
                  (unsigned long)[thisPerson.age unsignedIntegerValue]);
            counter++;
    }
    } else {
        NSLog(@"Could not find any Person entities in the context.");
    }
    
    //delete
    Person *lastPerson = [persons lastObject];
    [self.managedObjectContext deleteObject:lastPerson];
    if ([lastPerson isDeleted]){
        NSLog(@"Successfully deleted the last person...");
        NSError *savingError = nil;
        if ([self.managedObjectContext save:&savingError]){
            NSLog(@"Successfully saved the context.");
        } else {
                NSLog(@"Failed to save the context.");
        }
    } else {
        NSLog(@"Failed to delete the last person.");
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)createNewPersonWithFirstName:(NSString*)paramFirstName lastName:(NSString*)paramLastName age:(NSUInteger)paramAge{
    BOOL result = NO;
    if ([paramFirstName length] == 0 || [paramLastName length] == 0) {
        NSLog(@"First and Last names are mandatory.");
        return NO;
    }
    Person* newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    if (!newPerson){
        NSLog(@"Failed to create the new person.");
        return NO;
    }
    newPerson.firstName = paramFirstName;
    newPerson.lastName = paramLastName;
    newPerson.age = [NSNumber numberWithUnsignedInteger:paramAge];
    NSError *savingError = nil;
    if ([self.managedObjectContext save:&savingError]){
        return YES;
    } else {
        NSLog(@"Failed to save the new person. Error = %@", savingError); }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IntroductionCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IntroductionCoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end