import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/button/arrow_back_button.dart';
import 'package:monstar/components/core/app_textstyle.dart';

import '../../resources/constants/text_size.dart';

abstract class BaseScreen<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  Widget buildBody(BuildContext context);

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      leading: ArrowBackButton(),
      title: Text(
        getScreenTitle() ?? "",
        style: TextStyle(
          fontFamily: AppTextStyle.drawerFontStyle,
          fontSize: AppTextSize.superHuge,
          color: Colors.grey,
        ),
      ),
      centerTitle: true,
    );
  }

  String? getScreenTitle() {
    return null;
  }

  // hàm khởi tạo dữ liệu ban đầu, override tùy màn hình
  void loadInitialData() {}

  // hàm xử lý cuộn trang, override tùy màn hình
  void setupScrollListener() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void pushScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
    );
  }

  void showButtomDialog(BuildContext context, String text) {
    var sizeWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            color: Colors.blueGrey,
            width: sizeWidth - 50,
            height: 100,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  void pushReplacementScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => screen),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /* 
   Lắng nghe sự thay đổi của 1 Provider bất kì rồi thực hiện 1 hành động khi có sự thay đổi
   VM: is generic Type, cho phép sử dụng với bất kì ViewModel nào
   Providerbase<VM> là 1 provider cung cấp giá trị kiểu VM
   Function(VM state) : hàm Callback được truyền vào, được gọi mỗi khi state của Provider thay đổi
   */
  // hàm này sử dụng như : showLog, chạy logic nền khi state thay đổi mà không rebuild UI
  void listenStateChanges<VM>(
    ProviderBase<VM> provider,
    Function(VM state) listener,
  ) {
    ref.listen(provider, (previous, next) {
      listener(next);
    });
  }

  // theo dõi state trong provider, update UI
  T watchState<VM>(ProviderListenable<T> provider) {
    return ref.watch(provider);
  }
}
