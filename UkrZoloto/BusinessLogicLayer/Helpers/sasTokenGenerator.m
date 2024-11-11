//
//  sasTokenGenerator.m
//  UkrZoloto
//
//  Created by user on 24.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "sasTokenGenerator.h"

@implementation SasTokenGenerator

-(NSString*) generateSasToken:(NSString*)resourceUri :(NSString*)key :(NSString*)keyName
{
    NSString *targetUri;
    NSString* utf8LowercasedUri = NULL;
    NSString *signature = NULL;
    NSString *token = NULL;
    
    @try
    {
        // Add expiration
        resourceUri = [resourceUri lowercaseString];
        utf8LowercasedUri = [self CF_URLEncodedString:resourceUri];
        targetUri = [utf8LowercasedUri lowercaseString];
        NSTimeInterval expiresOnDate = [[NSDate date] timeIntervalSince1970];
        int expiresInMins = 60*24; // 1 day
        expiresOnDate += expiresInMins * 60;
        UInt64 expires = trunc(expiresOnDate);
        NSString* toSign = [NSString stringWithFormat:@"%@\n%qu", targetUri, expires];
        
        // Get an hmac_sha1 Mac instance and initialize with the signing key
        const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
        const char *cData = [toSign cStringUsingEncoding:NSUTF8StringEncoding];
        unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        NSData *rawHmac = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
        signature = [self CF_URLEncodedString:[rawHmac base64EncodedStringWithOptions:0]];
        
        // Construct authorization token string
        token = [NSString stringWithFormat:@"SharedAccessSignature sig=%@&se=%qu&skn=%@&sr=%@",
                 signature, expires, keyName, targetUri];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error generating SaSToken: %@", [exception reason]);
    }
    @finally
    {
        if (utf8LowercasedUri != NULL)
            CFRelease((CFStringRef)utf8LowercasedUri);
        if (signature != NULL)
            CFRelease((CFStringRef)signature);
    }
    
    return token;
}

-(NSString *)CF_URLEncodedString:(NSString *)inputString
{
  
  return [inputString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];

}

@end
