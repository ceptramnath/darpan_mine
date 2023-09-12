#import "ZxingScannerPlugin.h"
#if __has_include(<zxing_scanner/zxing_scanner-Swift.h>)
#import <zxing_scanner/zxing_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "zxing_scanner-Swift.h"
#endif

@implementation ZxingScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZxingScannerPlugin registerWithRegistrar:registrar];
}
@end
