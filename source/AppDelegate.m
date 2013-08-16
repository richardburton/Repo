#import "Tokens.h"
#import "AppDelegate.h"
#import "TableViewController.h"
#import "RootViewController.h"
#import "Mixpanel.h"
#import "NXOAuth2.h"

@implementation AppDelegate

+ (void)initialize;
{
    [[NXOAuth2AccountStore sharedStore] setClientID:GITHUB_CLIENT_ID
                                             secret:GITHUB_CLIENT_SECRET
                                   authorizationURL:[NSURL URLWithString:@"https://github.com/login/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://github.com/login/oauth/access_token"]
                                        redirectURL:[NSURL URLWithString:REDIRECT_URL]
                                     forAccountType:@"Repo"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      // Update your UI
                                                      
                                                      NSLog(@"Sucess");
                                                  }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // handler code here
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      // Update your UI
                                                      
                                                      NSLog(@"Sucess");
                                                      //                                                      webviewer.alpha = 0.0;
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      // Do something with the error
                                                      
                                                      NSLog(@"Error: %@", error);
                                                  }];
    
    
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Repo"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
                                       // Open a web view or similar
                                       
                                       [[UIApplication sharedApplication] openURL:preparedURL];
                                       
                                   }];
    
    
    
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    RootViewController *rootView = [[RootViewController alloc] init];
    rootView.shouldReload = YES;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootView];
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
