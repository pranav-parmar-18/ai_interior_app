import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdManager {
  static const _storageKey = 'device_unique_id';
  static final _storage = FlutterSecureStorage();
  static final _uuid = Uuid();

  /// Returns a persistent unique ID for this device.
  static Future<String> getDeviceId() async {
    // Check if ID already exists
    String? storedId = await _storage.read(key: _storageKey);
    if (storedId != null) return storedId;

    // Generate new UUID and save it
    String newId = _uuid.v4();
    await _storage.write(key: _storageKey, value: newId);
    return newId;
  }
}