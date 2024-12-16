
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mitti_bot/src/freeman.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();



  // Set device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  // Run the app
  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: () {
          return const FreemanApp();
        },
      ),
    ),
  );
}
