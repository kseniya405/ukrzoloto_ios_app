//
//  sasTokenGenerator.h
//  UkrZoloto
//
//  Created by user on 24.03.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

#ifndef sasTokenGenerator_h
#define sasTokenGenerator_h

@interface SasTokenGenerator: NSObject

-(NSString*) generateSasToken:(NSString*)resourceUri :(NSString*)key :(NSString*)keyName;
-(NSString *)CF_URLEncodedString:(NSString *)inputString;

@end

#endif /* sasTokenGenerator_h */
