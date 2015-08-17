//
//  Plaid.m
//  Balance
//
//  Created by Sapan Bhuta on 8/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//


#import "Plaid.h"
#import "AFHTTPRequestOperationManager.h"

@implementation Plaid

static NSString *API;
static NSString *client;
static NSString *secret;

+ (void)setClient:(NSString *)inputC setSecret:(NSString *)inputS inProduction:(BOOL)production {
    if (production) {
        API = @"https://api.plaid.com/";
        client = inputC;
        secret = inputS;
    } else {
        API = @"https://tartan.plaid.com/";
        client = @"test_id";
        secret = @"test_secret";
    }
}

+ (void)addUserWithUsername:(NSString *)username
                   Password:(NSString *)password
                       Type:(NSString *)type
      WithCompletionHandler:(void (^)(NSDictionary *output))handler {
    NSDictionary *params = @{@"client_id":client, @"secret":secret, @"credentials":@{@"username":username, @"password":password}, @"type":type};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[API stringByAppendingString:@"connect"]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              handler(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              handler(@{@"error":error});
          }];
}

+ (void)addUserWithUsername:(NSString *)username
                   Password:(NSString *)password
                       Type:(NSString *)type
                      Email:(NSString *)email
                    Webhook:(NSString *)webhook
                 Login_only:(BOOL)login_only
      WithCompletionHandler:(void (^)(NSDictionary *output))handler {
    NSDictionary *params = @{@"client_id":client, @"secret":secret, @"credentials":@{@"username":username, @"password":password}, @"type":type, @"email":email, @"options":@{@"webhook":webhook, @"login_only":@(login_only)}};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[API stringByAppendingString:@"connect"]
       parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@{@"error":error});
         }];
}

+ (void)submitMfaCredentialWithAccessToken:(NSString *)accessToken
                                       MFA:(NSString *)mfa
                     WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[API stringByAppendingString:@"connect/step"]
       parameters:@{@"client_id":client, @"secret":secret, @"mfa":mfa, @"access_token":accessToken}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              handler(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error %@", error);
              handler(@{@"error":error});
          }];
}

+ (void)getTransactionalDataWithAccessToken:(NSString *)accessToken
                      WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[API stringByAppendingString:@"connect"]
      parameters:@{@"client_id":client, @"secret":secret, @"access_token":accessToken}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(@{@"error":error});
    }];
}

+ (void)updateCredentialsWithAccessToken:(NSString *)accessToken
                                Username:(NSString *)username
                                Password:(NSString *)password
                                    Type:(NSString *)type
                   WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PATCH:[API stringByAppendingString:@"connect"]
        parameters:@{@"client_id":client, @"secret":secret, @"credentials":@{@"username":username, @"password":password}, @"type":type, @"access_token":accessToken}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@{@"error":error});
         }];
}

+ (void)deleteUserWithAccessToken:(NSString *)accessToken
                         Username:(NSString *)username
                         Password:(NSString *)password
            WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:[API stringByAppendingString:@"connect"]
      parameters:@{@"client_id":client, @"secret":secret, @"access_token":accessToken}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@{@"error":error});
         }];
}

+ (void)allInstitutionsWithCompletionHandler:(void (^)(NSArray *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[API stringByAppendingString:@"institutions"]
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                handler(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                handler(@[error]);
            }];
}

+ (void)institutionWithId:(NSString *)ID
    WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@institutions/%@",API,ID]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@{@"error":error});
         }];
}

+ (void)allCategoriesWithCompletionHandler:(void (^)(NSArray *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[API stringByAppendingString:@"categories"]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@[@"error"]);
         }];
}

+ (void)categoriesByMapping:(NSString *)map
                       Type:(NSString *)type
                 full_match:(BOOL)full_match
      WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[API stringByAppendingString:@"categories"]
      parameters:@{@"mapping":map, @"type":type, @"options":@{@"full_match":@(full_match)}}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@{@"error":error});
         }];
}

+ (void)categoriesWithId:(NSString *)ID
   WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@categories/%@",API,ID]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@{@"error":error});
         }];
}

+ (void)entityWithId:(NSString *)ID
WithCompletionHandler:(void (^)(NSDictionary *output))handler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@entities/%@",API,ID]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(@{@"error":error});
         }];
}

@end