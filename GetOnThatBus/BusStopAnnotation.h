//
//  BusStopAnnotation.h
//  GetOnThatBus
//
//  Created by Andrew  Nguyen on 7/28/15.
//  Copyright (c) 2015 Andrew Nguyen. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BusStop.h"

@interface BusStopAnnotation : MKPointAnnotation
@property BusStop *busStop;

@end
