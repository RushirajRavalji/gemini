import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/provider/chatProvider.dart';
import 'package:flutter_authentication/theme/easyLoading.dart';
import 'package:flutter_authentication/views/splashScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void main() {
  Get.put(Authprovider());
  Get.put(ChatProvider());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initial: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => GetMaterialApp(
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            configLoading(context);
          });

          return EasyLoading.init()(context, child);
        },
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
