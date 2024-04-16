import 'package:flutter/widgets.dart';

class InitialPageParam {
  final bool isLogin;
  Widget? updatePage;
  Widget? beforeLoginWidget;
  Widget? afterLoginWidget;
  Widget? customSplashScreenContent;

  InitialPageParam({
    this.isLogin = false,
    this.updatePage,
    this.beforeLoginWidget,
    this.afterLoginWidget,
    this.customSplashScreenContent,
  });
}
