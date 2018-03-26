/**
 * @file	KiwiLibrary.swift
 * @brief	Bridge header for Objective-C
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
#       import <UIKit/UIKit.h>
#else
#       import <Cocoa/Cocoa.h>
#endif

//! Project version number for KiwiLibrary.
FOUNDATION_EXPORT double KiwiLibraryVersionNumber;

//! Project version string for KiwiLibrary.
FOUNDATION_EXPORT const unsigned char KiwiLibraryVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KiwiLibrary/PublicHeader.h>


