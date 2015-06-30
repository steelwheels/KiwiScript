/**
 * @file	KSConsoleLib.h
 * @brief	Define KSConsoleLib class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import <JavaScriptCore/JavaScriptCore.h>

@protocol KCConsoleExport <JSExport>
- (NSInteger) puts: (NSString *) src ;
@end

@interface KCConsoleLib : NSObject <KCConsoleExport>

@end

static inline void
KCAddConsoleLib(JSContext * context)
{
	context[@"console"] = [[KCConsoleLib alloc] init] ;
}

