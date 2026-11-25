import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:no_pain_no_grad/gym/core/models/occupancy/occupancy_store.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/gym_occupancy/gym_occupancy.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/policies/clinet_model.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/policies/policies_view.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/check_in_out/check_in_out.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/home.dart';
import 'package:no_pain_no_grad/gym/view/customer_view/weights/weights.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('gymBox');
  PlansRepository.loadSavedPrices();
  OccupancyStore.instance.load();
//  NetworkHelper.initializeDio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home:CustomerHome(),
      );
  
  }
}
