import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/storage_service/flutter_secure_storage_service.dart';

final avatarProvider = FutureProvider<String?>((ref) async {
  return StorageService.instance.read('imageAvatar');
});
