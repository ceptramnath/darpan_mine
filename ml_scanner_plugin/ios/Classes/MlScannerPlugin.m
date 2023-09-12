#import "MlScannerPlugin.h"
#if __has_include(<ml_scanner_plugin/ml_scanner_plugin-Swift.h>)
#import <ml_scanner_plugin/ml_scanner_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ml_scanner_plugin-Swift.h"
#endif

@implementation MlScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMlScannerPlugin registerWithRegistrar:registrar];
}
@end
