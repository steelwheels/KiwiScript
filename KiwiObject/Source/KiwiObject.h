/**
 * @file	KiwiObject.h.
 * @brief	Bridge for KiwiObject
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <Cocoa/Cocoa.h>
#endif

//! Project version number for KiwiObject.
FOUNDATION_EXPORT double KiwiObjectVersionNumber;

//! Project version string for KiwiObject.
FOUNDATION_EXPORT const unsigned char KiwiObjectVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KiwiObject/PublicHeader.h>


