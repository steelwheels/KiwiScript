/**
 * @file	KiwiEngine.h.
 * @brief	Bridge for KiwiEngine
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#	import <UIKit/UIKit.h>
#else
#	import <Cocoa/Cocoa.h>
#endif

//! Project version number for KiwiEngine.
FOUNDATION_EXPORT double KiwiEngineVersionNumber;

//! Project version string for KiwiEngine.
FOUNDATION_EXPORT const unsigned char KiwiEngineVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KiwiEngine/PublicHeader.h>


