import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soor_app/core/const/constans.dart';
import 'package:soor_app/core/di/di.dart';
import 'package:soor_app/core/utils/storage_helper.dart';
import 'package:soor_app/features/auth/logic/auth_cubit.dart';
import 'package:soor_app/features/home/home.dart';
import 'package:soor_app/features/auth/Login screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageHelper.init();
  await initDependencies();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppTheme.labelColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StorageHelper.isLoggedIn ? const Home() : const LoginScreen(),
      ),
    );
  }
}
