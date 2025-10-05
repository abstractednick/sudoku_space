import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Permission status result
enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  provisional,
  unknown,
}

/// Singleton helper for managing app permissions
class PermissionsHelper {
  static PermissionsHelper? _instance;

  // Private constructor
  PermissionsHelper._();

  /// Get singleton instance
  static PermissionsHelper get instance {
    _instance ??= PermissionsHelper._();
    return _instance!;
  }

  /// Check if platform is Android
  bool get isAndroid => Platform.isAndroid;

  /// Check if platform is iOS
  bool get isIOS => Platform.isIOS;

  /// Check if platform supports permissions
  bool get isPermissionSupported => isAndroid || isIOS;

  /// Request notification permission
  Future<PermissionStatus> requestNotificationPermission() async {
    try {
      if (!isPermissionSupported) {
        return PermissionStatus.granted;
      }

      Permission permission;
      
      if (isAndroid) {
        // Android 13+ requires POST_NOTIFICATIONS permission
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            permission = Permission.notification;
          } else {
            // For older Android versions, notifications are granted by default
            return PermissionStatus.granted;
          }
        } else {
          permission = Permission.notification;
        }
      } else {
        permission = Permission.notification;
      }

      final status = await permission.request();
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error requesting notification permission: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Check notification permission status
  Future<PermissionStatus> getNotificationPermissionStatus() async {
    try {
      if (!isPermissionSupported) {
        return PermissionStatus.granted;
      }

      Permission permission;
      
      if (isAndroid) {
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            permission = Permission.notification;
          } else {
            return PermissionStatus.granted;
          }
        } else {
          permission = Permission.notification;
        }
      } else {
        permission = Permission.notification;
      }

      final status = await permission.status;
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error getting notification permission status: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Request ad tracking permission (iOS 14.5+)
  Future<PermissionStatus> requestAdTrackingPermission() async {
    try {
      if (!isIOS) {
        // Ad tracking is primarily an iOS concern
        return PermissionStatus.granted;
      }

      // For iOS, this would typically be handled through AppTrackingTransparency
      // This is a placeholder implementation
      final status = await Permission.appTrackingTransparency.request();
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error requesting ad tracking permission: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Check ad tracking permission status
  Future<PermissionStatus> getAdTrackingPermissionStatus() async {
    try {
      if (!isIOS) {
        return PermissionStatus.granted;
      }

      final status = await Permission.appTrackingTransparency.status;
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error getting ad tracking permission status: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Request storage permission (Android)
  Future<PermissionStatus> requestStoragePermission() async {
    try {
      if (!isAndroid) {
        return PermissionStatus.granted;
      }

      final status = await Permission.storage.request();
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error requesting storage permission: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Check storage permission status
  Future<PermissionStatus> getStoragePermissionStatus() async {
    try {
      if (!isAndroid) {
        return PermissionStatus.granted;
      }

      final status = await Permission.storage.status;
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error getting storage permission status: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Request camera permission (for future features)
  Future<PermissionStatus> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error requesting camera permission: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Check camera permission status
  Future<PermissionStatus> getCameraPermissionStatus() async {
    try {
      final status = await Permission.camera.status;
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error getting camera permission status: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Request microphone permission (for future features)
  Future<PermissionStatus> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error requesting microphone permission: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Check microphone permission status
  Future<PermissionStatus> getMicrophonePermissionStatus() async {
    try {
      final status = await Permission.microphone.status;
      return _mapPermissionStatus(status);
    } catch (e) {
      print('Error getting microphone permission status: $e');
      return PermissionStatus.unknown;
    }
  }

  /// Request all necessary permissions for the app
  Future<Map<String, PermissionStatus>> requestAllNecessaryPermissions() async {
    final results = <String, PermissionStatus>{};

    try {
      // Request notification permission
      results['notification'] = await requestNotificationPermission();

      // Request ad tracking permission (iOS only)
      if (isIOS) {
        results['ad_tracking'] = await requestAdTrackingPermission();
      }

      // Request storage permission (Android only)
      if (isAndroid) {
        results['storage'] = await requestStoragePermission();
      }

      print('All necessary permissions requested: $results');
    } catch (e) {
      print('Error requesting all necessary permissions: $e');
    }

    return results;
  }

  /// Check all necessary permissions status
  Future<Map<String, PermissionStatus>> getAllNecessaryPermissionsStatus() async {
    final results = <String, PermissionStatus>{};

    try {
      // Check notification permission
      results['notification'] = await getNotificationPermissionStatus();

      // Check ad tracking permission (iOS only)
      if (isIOS) {
        results['ad_tracking'] = await getAdTrackingPermissionStatus();
      }

      // Check storage permission (Android only)
      if (isAndroid) {
        results['storage'] = await getStoragePermissionStatus();
      }

      print('All necessary permissions status: $results');
    } catch (e) {
      print('Error getting all necessary permissions status: $e');
    }

    return results;
  }

  /// Open app settings for permission management
  Future<bool> openAppSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      print('Error opening app settings: $e');
      return false;
    }
  }

  /// Check if permission is permanently denied
  bool isPermissionPermanentlyDenied(PermissionStatus status) {
    return status == PermissionStatus.permanentlyDenied;
  }

  /// Check if permission is granted
  bool isPermissionGranted(PermissionStatus status) {
    return status == PermissionStatus.granted;
  }

  /// Check if permission is denied
  bool isPermissionDenied(PermissionStatus status) {
    return status == PermissionStatus.denied;
  }

  /// Get permission status message for user
  String getPermissionStatusMessage(String permissionName, PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return '$permissionName permission granted';
      case PermissionStatus.denied:
        return '$permissionName permission denied';
      case PermissionStatus.permanentlyDenied:
        return '$permissionName permission permanently denied. Please enable it in settings.';
      case PermissionStatus.restricted:
        return '$permissionName permission restricted';
      case PermissionStatus.limited:
        return '$permissionName permission limited';
      case PermissionStatus.provisional:
        return '$permissionName permission provisional';
      case PermissionStatus.unknown:
        return '$permissionName permission status unknown';
    }
  }

  /// Map permission_handler status to our enum
  PermissionStatus _mapPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return PermissionStatus.granted;
      case PermissionStatus.denied:
        return PermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return PermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return PermissionStatus.restricted;
      case PermissionStatus.limited:
        return PermissionStatus.limited;
      case PermissionStatus.provisional:
        return PermissionStatus.provisional;
      case PermissionStatus.unknown:
        return PermissionStatus.unknown;
    }
  }

  /// Check if device supports the permission
  bool isPermissionSupported(String permissionName) {
    switch (permissionName) {
      case 'notification':
        return isPermissionSupported;
      case 'ad_tracking':
        return isIOS;
      case 'storage':
        return isAndroid;
      case 'camera':
        return isPermissionSupported;
      case 'microphone':
        return isPermissionSupported;
      default:
        return false;
    }
  }

  /// Get recommended permissions for the app
  List<String> getRecommendedPermissions() {
    final permissions = <String>['notification'];
    
    if (isIOS) {
      permissions.add('ad_tracking');
    }
    
    if (isAndroid) {
      permissions.add('storage');
    }
    
    return permissions;
  }

  /// Check if all recommended permissions are granted
  Future<bool> areAllRecommendedPermissionsGranted() async {
    try {
      final statuses = await getAllNecessaryPermissionsStatus();
      
      for (final status in statuses.values) {
        if (!isPermissionGranted(status)) {
          return false;
        }
      }
      
      return true;
    } catch (e) {
      print('Error checking if all recommended permissions are granted: $e');
      return false;
    }
  }

  /// Request permissions with user-friendly dialog
  Future<Map<String, PermissionStatus>> requestPermissionsWithDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
  }) async {
    // This would typically show a custom dialog explaining why permissions are needed
    // For now, we'll just request the permissions directly
    
    print('Requesting permissions with dialog: $title - $message');
    return await requestAllNecessaryPermissions();
  }
}
