import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:monstar/components/core/app_textstyle.dart';

abstract class BaseView<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  final logger = Logger();
  Widget buildBody(BuildContext context);

  // Optional methods that can be overridden
  String? getScreenTitle() => null;
  Widget? getAppBarAction() => null;
  Widget? getAppBarLeading() => null;
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      leading: getAppBarLeading(),
      automaticallyImplyLeading: false,
      title: Text(
        getScreenTitle() ?? "",
        style: TextStyle(
          fontFamily: AppTextStyle.drawerFontStyle,
          color: const Color.fromARGB(255, 109, 105, 105),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: getAppBarAction(),
        ),
      ],
    );
  }

  Widget? buildBottomNavigationBar() => null;
  Widget? buildDrawer() => null;
  Color? get backgroundColor => null;
  bool get resizeToAvoidBottomInset => true;
  bool get useSafeArea => true;

  // Lifecycle methods
  @mustCallSuper
  void onInit() {
    logger.d("Init: $runtimeType");
  }

  void onDispose() {
    logger.d("Dispose: $runtimeType");
  }

  void onResume() {
    logger.d("Resume: $runtimeType");
  }

  void onPause() {
    logger.d("Pause: $runtimeType");
  }

  // Error handling
  Widget buildErrorWidget(Object error, StackTrace? stackTrace) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Error: ${error.toString()}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  // Loading widget
  Widget buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> onRefresh() async {}

  ScrollController? scrollController;

  void setupScrollController() {
    scrollController?.addListener(_scrollListener);
  }

  void _scrollListener() {}

  @override
  void initState() {
    super.initState();
    onInit();
    setupScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  void loadInitialData() {}

  @override
  void dispose() {
    scrollController?.removeListener(_scrollListener);
    scrollController?.dispose();
    onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        appBar: buildAppBar(context),
        body: useSafeArea
            ? SafeArea(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: buildBody(context),
                ),
              )
            : buildBody(context),
        bottomNavigationBar: buildBottomNavigationBar(),
        drawer: buildDrawer(),
      ),
    );
  }

  /// ALL METHOD FOR NAVIGATION and get the result from the next screen
  Future<dynamic> pushScreen(Widget screen, {Function(dynamic)? onSuccess}) {
    logger.d("Navigating to screen: ${screen.runtimeType}");
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    ).then((result) {
      if (onSuccess != null) onSuccess(result);
    });
  }

  /// Push màn hình mới và xóa màn hình hiện tại khỏi stack
  Future<dynamic> pushReplacementScreen(Widget screen) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  /// Push màn hình mới với animation từ phải sang trái
  Future<dynamic> pushScreenWithSlideAnimation(Widget screen) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Pop về màn hình trước với kết quả tùy chọn
  void popScreen<R>([R? result]) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, result);
    }
  }

  /// Pop về màn hình trước cho đến khi gặp màn hình thỏa mãn điều kiện
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.popUntil(context, predicate);
  }

  /// Pop về màn hình root (màn hình đầu tiên trong stack)
  void popToRoot() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

abstract class BaseViewKeepAliveMixin<T extends ConsumerStatefulWidget>
    extends BaseView<T> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        appBar: buildAppBar(context),
        body: useSafeArea
            ? SafeArea(
                child: RefreshIndicator(
                  child: buildBody(context),
                  onRefresh: onRefresh,
                ),
              )
            : buildBody(context),
      ),
    );
  }
}

mixin BaseViewPaginationMixin<T extends ConsumerStatefulWidget> on BaseView<T> {
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  @override
  void setupScrollController() {
    super.setupScrollController();
    scrollController?.addListener(_paginationListener);
  }

  void _paginationListener() {
    if (scrollController?.position.pixels ==
        scrollController?.position.maxScrollExtent) {
      loadMoreData();
    }
  }

  Future<void> loadMoreData() async {}

  void setLoadingMore(bool value) {
    _isLoadingMore = value;
  }
}
