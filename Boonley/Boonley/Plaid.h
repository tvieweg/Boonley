//
//  Plaid.h
//  Balance
//
//  Created by Sapan Bhuta on 8/21/14.
//  Copyright (c) 2014 SapanBhuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plaid : NSObject

+ (void)setClient:(NSString *)inputC setSecret:(NSString *)inputS inProduction:(BOOL)production;

+ (void)addUserWithUsername:(NSString *)username
                   Password:(NSString *)password
                       Type:(NSString *)type
                      Email:(NSString *)email
                    Webhook:(NSString *)webhook
                 Login_only:(BOOL)login_only
      WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)submitMfaCredentialWithAccessToken:(NSString *)accessToken  //<-- HARD TO TEST THIS METHOD; UNIT TEST NOT WORKING
                                       MFA:(NSString *)mfa
                     WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)getTransactionalDataWithAccessToken:(NSString *)accessToken
                      WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)updateCredentialsWithAccessToken:(NSString *)accessToken
                                Username:(NSString *)username
                                Password:(NSString *)password
                                    Type:(NSString *)type
                   WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)deleteUserWithAccessToken:(NSString *)accessToken
                         Username:(NSString *)username
                         Password:(NSString *)password
            WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)allInstitutionsWithCompletionHandler:(void (^)(NSArray *output))handler;

+ (void)institutionWithId:(NSString *)ID
    WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)allCategoriesWithCompletionHandler:(void (^)(NSArray *output))handler;

+ (void)categoriesByMapping:(NSString *)map
                       Type:(NSString *)type
                 full_match:(BOOL)full_match
      WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)categoriesWithId:(NSString *)ID
   WithCompletionHandler:(void (^)(NSDictionary *output))handler;

+ (void)entityWithId:(NSString *)ID
WithCompletionHandler:(void (^)(NSDictionary *output))handler;

@end