import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/cubit/cubit/users_cubit.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/control_on_users/hive_helper/user_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/cubit/cubit/bar_cubit.dart'
    as admin_bar;
import 'package:no_pain_no_grad/gym/view/admin_view/features/gym&bar/hive_helper/hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/cubit/cubit/coach_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/coach/hive_helper/coach_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/cubit/cubit/bar_cubit.dart'
    as customer_bar;
import 'package:no_pain_no_grad/gym/view/customer_view/gym_bar/hive_helper/bar_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/log_in/auth_hive_helper.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/log_in/cubit/cubit/auth_cubit.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/log_in/view/login_page.dart'
    show LoginPage;
import 'package:no_pain_no_grad/gym/core/models/occupancy/occupancy_store.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/policies/clinet_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // صناديق الجيم بتاعت الأسعار والإشغال
  await Hive.openBox('gymBox');
  PlansRepository.loadSavedPrices();
  OccupancyStore.instance.load();

  // صناديق الأدمن وتسجيل الدخول
  await Hive.openBox(AuthHiveHelper.authBox);
  await AuthHiveHelper.getSession();
  await UserHiveHelper.init();
  await AdminbarHiveHelper.init();

  // صناديق الكاستمر (البار والكوتش)
  if (!Hive.isBoxOpen(BarHiveHelper.barBox)) {
    await Hive.openBox(BarHiveHelper.barBox);
  }
  if (!Hive.isBoxOpen(CoachHiveHelper.coachBox)) {
    await Hive.openBox(CoachHiveHelper.coachBox);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit()..getUsers(),
        ),
        BlocProvider<admin_bar.BarCubit>(
          create: (_) => admin_bar.BarCubit()..getBarSettings(),
        ),
        BlocProvider<customer_bar.BarCubit>(
          create: (_) => customer_bar.BarCubit()..getBar(),
        ),
        BlocProvider<CoachCubit>(
          create: (_) => CoachCubit()..getCoaches(),
        ),
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}