import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseScreen<T> extends ConsumerWidget {
  final AsyncValue<T> state;
  final Widget Function(T data) onSuccess;
  final Widget? onLoading;
  final Widget? onError;
  final String? title;
  final bool enableRefresh;
  final Future<void> Function()? onRefresh;

  const BaseScreen({
    Key? key,
    required this.state,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.title,
    this.enableRefresh = false,
    this.onRefresh,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: Text(title!),
            )
          : null,
      body: enableRefresh
          ? RefreshIndicator(
              child: _buildBody(context),
              onRefresh: onRefresh ?? () async {},
            )
          : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return state.when(
      data: (data) => onSuccess(data),
      error: (e, _) =>
          onError ??
          Center(
            child: Text('Error: $e'),
          ),
      loading: () =>
          onLoading ??
          const Center(
            child: CircularProgressIndicator(),
          ),
    );
  }
}
