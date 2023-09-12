#import "NewencPlugin.h"
#if __has_include(<newenc/newenc-Swift.h>)
#import <newenc/newenc-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "newenc-Swift.h"
#endif

@implementation NewencPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNewencPlugin registerWithRegistrar:registrar];
}
@end
