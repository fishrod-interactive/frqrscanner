//
//  FRQRScanner.m
//  skystudio-remote
//
//  Created by Gavin Williams on 03/12/2013.
//  Copyright (c) 2013 Fishrod Interactive. All rights reserved.
//

#import "FRQRScanner.h"

@interface FRQRScanner ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) UIView *scannerPreview;
@property (nonatomic, strong) NSString *readValue;
@end

@implementation FRQRScanner

# pragma mark - Initialisation methods

- (id) initWithView:(UIView *)view withCameraPosition:(AVCaptureDevicePosition) position delegate:(id<FRQRScannerProtocol>)delegate {
    
    self = [super init];
    
    if(self){
        self.scannerPreview = view;
        self.delegate = delegate;
        [self setupCaptureSessionWithCameraPosition:position];
    }
    
    return self;
    
}

- (void) setupCaptureSessionWithCameraPosition:(AVCaptureDevicePosition) position {
    NSError *error;
    
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [previewLayer setFrame:self.scannerPreview.bounds];
    
    
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.scannerPreview.layer addSublayer:previewLayer];
    
    // Add the camera input
    AVCaptureDevice *camera;
    
    for(AVCaptureDevice *input in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]){
        
        if(input.position == position){
            camera = input;
        }
        
    }
    
    if(!camera){
        if([self.delegate respondsToSelector:@selector(reader:didFailToDetectCameraWithError:)]) {
            error = [NSError errorWithDomain:@"FRQRScanner" code:1000 userInfo:@{NSLocalizedDescriptionKey: @"No camera input found"}];
            [self.delegate performSelector:@selector(reader:didFailToDetectCameraWithError:) withObject:self withObject:error];
        }
        return;
    }
    
    // Add the camera input to the session
    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    
    if(error){
        if([self.delegate respondsToSelector:@selector(reader:didFailToDetectCameraWithError:)]) {
            [self.delegate performSelector:@selector(reader:didFailToDetectCameraWithError:) withObject:self withObject:error];
        }
        return;
    }
    
    [self.captureSession addInput:cameraInput];
    
    // Add the data output
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    [self.captureSession addOutput:metadataOutput];
    
    [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    
    // Change the video orientation
    AVCaptureConnection *previewLayerConnection = previewLayer.connection;
    if([previewLayerConnection isVideoOrientationSupported]) {
        [previewLayerConnection setVideoOrientation:(AVCaptureVideoOrientation) [[UIApplication sharedApplication] statusBarOrientation]];
    }
    
    [self startReading];
    
}

# pragma mark - Metadata Output
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if(self.readValue) return;
    
    AVMetadataMachineReadableCodeObject *object = [metadataObjects firstObject];
    
    if(object){
        self.readValue = [object stringValue];
        [self stopReading];
        if([self.delegate respondsToSelector:@selector(reader:didReadString:)]){
            [self.delegate performSelector:@selector(reader:didReadString:) withObject:self withObject:object.stringValue];
        }
    }
}

# pragma mark - Reader methods

- (void) startReading {
    self.readValue = nil;
    if([self.captureSession isRunning] == NO){
        [self.captureSession startRunning];
    }
}

- (void) stopReading {
    self.readValue = nil;
    if([self.captureSession isRunning] == YES){
        [self.captureSession stopRunning];
    }
}

@end