/**
 * @file	JSROptionAnalyer.m
 * @brief	Define JSROptionAnalyzer class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#import "JSROptionAnalyzer.h"
#import "JSRConfig.h"
#import <Cobalt/Cobalt.h>

enum {
	OPTION_VERBOSE
} ;

static const struct CBOptionDefinition s_optdefs[] = {
	{OPTION_VERBOSE,	'v',	"verbose",	CNNilValue,	NULL,	"set verbose mode on"},
	CBEndOfOptionDefinition
} ;

@implementation JSROptionAnalyzer

+ (JSRConfig *) analyzeWithCount: (int) argc withArguments: (const char **) argv
{
	NSError * psrerr = nil ;
	CBCommandLine * cmdline ;
	cmdline = [CBCommandLine parseArguments: argv
				     withCounts: argc
			  withOptionDefinitions: s_optdefs
				      withError: &psrerr] ;
	if(cmdline == nil){
		[psrerr printToFile: stderr] ;
		return nil ;
	}
	
	JSRConfig * config = [[JSRConfig alloc] init] ;
	
	/* check options */
	CBOption * opt ;
	if((opt = [cmdline searchOptionById: OPTION_VERBOSE]) != nil){
		config.doVerbose = YES ;
	}
	
	/* get arguments */
	const struct CNListItem * item = [cmdline firstArgument] ;
	for( ; item ; item = item->nextItem){
		NSError *  urlerr ;
		NSString * filename = (NSString *) CNObjectInListItem(item) ;
		NSURL * url = [NSURL allocateURLForFile: filename error: &urlerr] ;
		if(url){
			[config addInputURL: url] ;
		} else {
			[urlerr printToFile: stderr] ;
			return nil ;
		}
	}
	
	return config ;
}

@end
