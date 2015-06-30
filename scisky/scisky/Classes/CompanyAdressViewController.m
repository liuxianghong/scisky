//
//  CompanyAdressViewController.m
//  scisky
//
//  Created by 刘向宏 on 15/6/11.
//  Copyright (c) 2015年 刘向宏. All rights reserved.
//

#import "CompanyAdressViewController.h"
#import <MapKit/MapKit.h>
#import "BasicMapAnnotation.h"

@interface CompanyAdressViewController ()
@property (nonatomic,weak) IBOutlet MKMapView *mapView;
@end

@implementation CompanyAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地址";
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude] ;
    [self.mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        MKAnnotationView *annotationView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"Icon-vendor-address-location"];
        }
        
        return annotationView;
    }
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
