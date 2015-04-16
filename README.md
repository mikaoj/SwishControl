# SwishControl

[![CI Status](http://img.shields.io/travis/Joakim Gyllstrom/SwishControl.svg?style=flat)](https://travis-ci.org/Joakim Gyllstrom/SwishControl)
[![Version](https://img.shields.io/cocoapods/v/SwishControl.svg?style=flat)](http://cocoapods.org/pods/SwishControl)
[![License](https://img.shields.io/cocoapods/l/SwishControl.svg?style=flat)](http://cocoapods.org/pods/SwishControl)
[![Platform](https://img.shields.io/cocoapods/p/SwishControl.svg?style=flat)](http://cocoapods.org/pods/SwishControl)<br /><br />
SwishControl is a category on UIControl for adding sound effects to UIControlEvents.

## Usage

Import the SwishControl header
```objc
#import <SwishControl/SwishControl.h>
```
SwishControl uses AudioToolbox which supports aif, caf and wav.<br />
This is how you add a sound effect for all UIButtons
```objc
NSString *clickPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"aif"];
[[UIButton appearance] bs_setAudioWithPath:clickPath forEvent:UIControlEventTouchUpInside];
```
Of course it can be applied to a single UIControl as well, if you don't want to set a sound for all of them.

## Requirements
iOS, bananas and a bunch of sound effects

## Installation

SwishControl is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwishControl"
```

## Author

Joakim Gyllström

## License

SwishControl is available under the MIT license. See the LICENSE file for more info.
