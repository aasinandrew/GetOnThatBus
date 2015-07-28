//
//  BusStop.h
//  GetOnThatBus
//
//  Created by Andrew  Nguyen on 7/28/15.
//  Copyright (c) 2015 Andrew Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStop : NSObject
@property NSString *name;
@property double latitude;
@property double longitude;
@property NSString *routes;
@property NSString *transfers;
@property NSString *addressURL;

@end
