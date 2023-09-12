#import "ScannerPlugin.h"
#if __has_include(<scanner_plugin/scanner_plugin-Swift.h>)
#import <scanner_plugin/scanner_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "scanner_plugin-Swift.h"
#endif

@implementation ScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScannerPlugin registerWithRegistrar:registrar];
}
@end
