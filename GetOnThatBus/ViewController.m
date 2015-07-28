//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Andrew  Nguyen on 7/28/15.
//  Copyright (c) 2015 Andrew Nguyen. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "BusStop.h"
#import "BusStopAnnotation.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSArray *busStopsDictionaries;
@property NSMutableArray *busStops;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBusStops];
    self.busStops = [NSMutableArray new];
    self.tableView.hidden = YES;

}

-(void) getBusStops {
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mmios8week/bus.json"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.busStopsDictionaries = responseDictionary[@"row"];

        [self loadBusStops];
         //[self.tableView reloadData];

    }] resume];


}

-(void) loadBusStops {
    for (NSDictionary *d in self.busStopsDictionaries) {
        BusStopAnnotation *busStopAnnotation = [BusStopAnnotation new];
        double latitude = [d[@"latitude"] doubleValue];
        double longitude = [d[@"longitude"] doubleValue];
        busStopAnnotation.coordinate = CLLocationCoordinate2DMake(latitude,longitude);
        busStopAnnotation.title = [NSString stringWithFormat:@"%@: %@",d[@"cta_stop_name"], d[@"routes"]];
        BusStop *busStop = [BusStop new];
        busStop.name = d[@"cta_stop_name"];
        busStop.routes = d[@"routes"];
        busStop.longitude = [d[@"longitude"] doubleValue];
        busStop.latitude = [d[@"latitude"] doubleValue];
        busStop.transfers = d[@"inter_modal"];
        busStop.addressURL = d[@"_address"];
        [self.busStops addObject:busStop];

        busStopAnnotation.busStop = busStop;
        [self.mapView addAnnotation:busStopAnnotation];
    }
    double latitude = [self.busStopsDictionaries[0][@"latitude"] doubleValue];
    double longitude = [self.busStopsDictionaries[0][@"longitude"] doubleValue];

    //CLLocationCoordinate2D chicago = CLLocationCoordinate2DMake(41.868513, -87.55);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView setRegion:MKCoordinateRegionMake(center,MKCoordinateSpanMake(0.4, 0.4)) animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BusStopAnnotation class]]) {
        MKAnnotationView *pin = [MKAnnotationView new];
        BusStopAnnotation *bsa = annotation;
        if ([bsa.busStop.transfers isEqualToString:@"Metra"]) {
            pin.image = [UIImage imageNamed:@"metra"];
        }
        else if ([bsa.busStop.transfers isEqualToString:@"Pace"]) {
            pin.image = [UIImage imageNamed:@"pace"];
        }
        else {
            pin.image = [UIImage imageNamed:@"pin"];
        }
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        return pin;
    }
    else  {
        return nil;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self performSegueWithIdentifier:@"ShowDetail" sender:view];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        DetailViewController *dVC = segue.destinationViewController;
        MKAnnotationView *av = sender;
        BusStopAnnotation *bsa = av.annotation;
        dVC.busStop = bsa.busStop;
    }
    else {
        DetailViewController *dVC = segue.destinationViewController;
        dVC.busStop = [self.busStops objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

- (IBAction)onSegmentToggled:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.tableView.hidden = YES;
        self.mapView.hidden = NO;
    }
    else {
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
         [self.tableView reloadData];

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BusStop *busStop = [self.busStops objectAtIndex:indexPath.row];
    cell.textLabel.text = busStop.name;
    cell.detailTextLabel.text = busStop.routes;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.busStops.count;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"FromCell" sender:self];
//}

@end
