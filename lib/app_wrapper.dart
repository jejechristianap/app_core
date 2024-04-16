import 'package:app_core/pages/config_page.dart';
import 'package:app_core/pages/splash_screen_page.dart';
import 'package:app_core/params/initial_page_param.dart';
import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppWrapper extends StatefulWidget {
  final String title;
  final GlobalKey<NavigatorState>? navigatorKey;
  final InitialPageParam initialPageParam;
  final List<Map<String, Widget>>? customMonitoring;
  final bool isShowCustomMonitoring;

  const AppWrapper({
    super.key,
    required this.initialPageParam,
    this.title = '',
    this.navigatorKey,
    this.customMonitoring,
    this.isShowCustomMonitoring = false,
  });

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  Widget build(BuildContext context) {
    return _shouldWrapWithGestureDetector(
      isWrapped: _isShowCustomMonitoring(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: widget.title,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: false,
            ),
            home: Builder(
              builder: (context) => _getInitialPage(),
            ),
            navigatorKey: widget.navigatorKey,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child ?? _getChild,
              );
            },
          );
        },
      ),
    );
  }

  Widget _getInitialPage() {
    Widget? splashScreen = widget.initialPageParam.customSplashScreenContent;
    if (splashScreen != null) {
      return SplashScreenPage(
        content: splashScreen,
        nextPage: _getChild,
      );
    }
    return _getChild;
  }

  Widget _shouldWrapWithGestureDetector({
    bool isWrapped = false,
    required Widget child,
  }) {
    if (!isWrapped) {
      return child;
    }
    return GestureDetector(
      child: child,
      onLongPress: () {
        BuildContext? context = widget.navigatorKey?.currentState?.context;
        if (context != null) {
          Navigation.present(
            context: context,
            page: ConfigPage(
              customMonitoring: widget.customMonitoring,
            ),
          );
        }
      },
    );
  }

  Widget get _getChild {
    InitialPageParam paramPage = widget.initialPageParam;
    if (paramPage.updatePage != null) {
      return paramPage.updatePage ?? const SizedBox.shrink();
    }

    return widget.initialPageParam.isLogin
        ? paramPage.afterLoginWidget ?? const SizedBox.shrink()
        : paramPage.beforeLoginWidget ?? const SizedBox.shrink();
  }

  bool _isShowCustomMonitoring() {
    // always show custom monitoring on debug mode
    if (kDebugMode) {
      return true;
    }

    return widget.isShowCustomMonitoring;
  }
}
