/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVProximity.h"

@interface CDVProximity () {}
@end

@implementation CDVProximity

@synthesize callbackId;

- (CDVProximity*)init
{
    self = [super init];
    if (self) {
        self.callbackId = nil;
        status = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stop:nil];
}

- (void)getProximityState:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    bool proxState = true;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    /* if the screen brightness is not 0, check sensor, otherwise report that the user is close to the screen */
    if ([[UIScreen mainScreen] brightness] != 0.0) {
        proxState = [[UIDevice currentDevice] proximityState];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool: proxState];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)start:(CDVInvokedUrlCommand*)command
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

- (void)onReset
{
    [self stop:nil];
}

- (void)stop:(CDVInvokedUrlCommand*)command
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    if (command != nil) {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    status = [[UIDevice currentDevice] proximityState];
}

@end
