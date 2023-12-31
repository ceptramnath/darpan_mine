package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import com.example.zxing_scanner.ZxingScannerPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    ZxingScannerPlugin.registerWith(registry.registrarFor("com.example.zxing_scanner.ZxingScannerPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
