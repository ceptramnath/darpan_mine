#import "AgeCalculatorPlugin.h"
#if __has_include(<age_calculator/age_calculator-Swift.h>)
#import <age_calculator/age_calculator-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "age_calculator-Swift.h"
#endif

@implementation AgeCalculatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAgeCalculatorPlugin registerWithRegistrar:registrar];
}
@end
