<!---
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
-->

# org.awokenwell.proximity

This is a fork of https://github.com/rbarroetavena/cordova-plugin-proximity, which is a fork of https://github.com/awoken-well/cordova-plugin-proximity.
It has been modified to improve power efficiency and be compatible with newer versions of Android.

This plugin provides access to the device's (IR) proximity sensor. This sensor is typically used in applications to prevent touch events on the screen when the device is held close to one's face.

## Installation
    cordova plugin add https://github.com/opentelecom/cordova-plugin-proximity.git

## Supported Platforms

- iOS
- Android

## Methods

- navigator.proximity.getProximityState
- navigator.proximity.enableSensor
- navigator.proximity.disableSensor
- navigator.proximity.enableProximityScreenOff
- navigator.proximity.disableProximityScreenOff

## navigator.proximity.getProximityState

Get the current proximity sensor state: true = near, false = far.

This proximity state is returned to the 'successCallback' callback function.

    navigator.proximity.getProximityState(successCallback);

## navigator.proximity.enableSensor

Enable the proximity sensor. In iOS the proximity sensor is disabled by default and must
be enabled manually. If the proximity value is not checked within 30 seconds, the sensor
will be turned off to save power.

    navigator.proximity.enableSensor();

## navigator.proximity.disableSensor

Disable the proximity sensor.

    navigator.proximity.disableSensor();

## navigator.proximity.enableProximityScreenOff();

This function enables the functionality that makes the device screen turn off when the proximity sensor detects a near object.
Note that the device does not actually fall asleep while the screen is off.

    navigator.proximity.enableProximityScreenOff();

## navigator.proximity.disableProximityScreenOff();

This function disables the functionality that makes the device screen turn off when the proximity sensor detects a near object.

    navigator.proximity.disableProximityScreenOff();

### Example 1

    function onSuccess(state) {
        alert('Proximity state: ' + (state ? 'near' : 'far'));
    };

    navigator.proximity.enableSensor();
    
    setInterval(function(){
      navigator.proximity.getProximityState(onSuccess);
    }, 1000);


### Example 2

This example shows a watcher. If other things approaches the phone, 'on_approch_callback' would be called. 


    var proximitysensor = {
    };

    var proximitysensorWatchStart = function(_scope, on_approch_callback) {
        if(navigator.proximity == null)
            console.log("cannot find navigator.proximity");

        navigator.proximity.enableSensor();

        // Start watch timer to get proximity sensor value
        var frequency = 100;
        _scope.id = window.setInterval(function() {
            navigator.proximity.getProximityState(function(val) { // on success
                var timestamp = new Date().getTime();
                if(timestamp - _scope.lastemittedtimestamp > 1000) { // test on each 1 secs
                    if( proximitysensor.lastval == 1 && val == 0 ) { // far => near changed
                        _scope.lastemittedtimestamp = timestamp;
                        _scope.lastval = val;
                        on_approch_callback(timestamp);
                    }
                }
                _scope.lastval = val;
            });
        }, frequency);
    }

    var proximitysensorWatchStop = function(_scope) {
        if(navigator.proximity == null)
            console.log("cannot find navigator.proximity");

        window.clearInterval( _scope.id );

        navigator.proximity.disableSensor();
    };

    proximitysensorWatchStart(proximitysensor, function(timestamp) {
       console.log('approched on ' + timestamp);
    });

    // .... after testing
    //proximitysensorWatchStop(proximitysensor);

### Example 3

This example shows how the plugin can easily be used to turn the device screen on and off when
it approaches an object.

```
// Enables polling of proximity to automatically disable screen when object is near
startProximityPolling() {
    navigator.proximity.enableSensor();
    navigator.proximity.enableProximityScreenOff();
}
disable proximity sensing
stopProximityPolling() {
    navigator.proximity.disableProximityScreenOff();
    navigator.proximity.disableSensor();
}
```
