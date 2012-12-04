//
//  GFAppDelegate.m
//  gsFix
//
//  Created by Adam D on 20/11/12.
//  Copyright (c) 2012 HASHBANG Productions. All rights reserved.
//

#import "GFAppDelegate.h"

@implementation GFAppDelegate

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

-(IBAction)performFix:(id)sender {
	NSString *fixer = [[NSBundle mainBundle] pathForResource:@"fixer" ofType:@"sh"];
	
	// http://stackoverflow.com/a/6269915/709376
	AuthorizationRef authorizationRef;
	if (AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef) != errAuthorizationSuccess) {
		NSAlert *alert = [[NSAlert alloc] init];
		alert.messageText = NSLocalizedString(@"Whoops! An error occurred.", nil);
		alert.informativeText = NSLocalizedString(@"Couldn't create the authorization request.", nil);
		[alert runModal];
		[alert release];
		return;
	}
	
	AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
	AuthorizationRights rights = {1, &right};
	if (AuthorizationCopyRights(authorizationRef, &rights, NULL, kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights, NULL) != errAuthorizationSuccess) {
		return;
	}
	
	FILE *file = NULL;
	
	if (AuthorizationExecuteWithPrivileges(authorizationRef, "/bin/bash", kAuthorizationFlagDefaults, (char *[]){ (char *)[fixer UTF8String] }, &file) != errAuthorizationSuccess) {
		NSAlert *alert = [[NSAlert alloc] init];
		alert.messageText = NSLocalizedString(@"Whoops! An error occurred.", nil);
		alert.informativeText = NSLocalizedString(@"Couldn't start the fixer script.", nil);
		[alert runModal];
		[alert release];
		return;
	}
	
	AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
	
	NSAlert *alert = [[NSAlert alloc] init];
	alert.messageText = NSLocalizedString(@"Your hosts file has been fixed.", nil);
	alert.informativeText = NSLocalizedString(@"You can now try restoring again.", nil);
	[alert runModal];
	[alert release];
}

-(IBAction)visitHbang:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.hbang.ws/"]];
}

@end
