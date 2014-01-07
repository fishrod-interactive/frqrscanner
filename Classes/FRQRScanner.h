//
//  FRQRScanner.h
//  FRQRScanner
//
//  Created by Gavin Williams on 07/01/2014.
//  Copyright (c) 2014 Fishrod Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

@class FRQRScanner;

@protocol FRQRScannerProtocol <NSObject>

- (void) reader:(FRQRScanner *) reader didReadString:(NSString *) string;
- (void) reader:(FRQRScanner *) reader didFailToDetectCameraWithError:(NSError *) error;

@end

@interface FRQRScanner : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) id<FRQRScannerProtocol>delegate;

# pragma mark - Initialisation methods

- (id) initWithView:(UIView *)view withCameraPosition:(AVCaptureDevicePosition) position delegate:(id<FRQRScannerProtocol>) delegate;

# pragma mark - Reader methods

- (void) startReading;
- (void) stopReading;
// - (void) setCamera:()

@end
