//
//  DetailViewController.m
//  GetOnThatBus
//
//  Created by Andrew  Nguyen on 7/28/15.
//  Copyright (c) 2015 Andrew Nguyen. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *routesLabel;
@property (weak, nonatomic) IBOutlet UILabel *transfersLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.busStop.name;
    if (self.busStop.transfers.length > 0) {
        self.transfersLabel.text = [NSString stringWithFormat:@"Transfers: %@", self.busStop.transfers];
    }
    else {
        self.transfersLabel.text = @"No Transfers";
    }
    self.routesLabel.text = [NSString stringWithFormat:@"Routes: %@", self.busStop.routes];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.busStop.addressURL]]];
}




@end
