import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';
import 'package:monstar/data/services/contribution_service/contribution_post_service.dart';

final textPostRepositoryProvider = Provider<TextPostRepository>((ref) {
  final postService = TextPostService();
  return TextPostRepositoryImpl(postService);
});
