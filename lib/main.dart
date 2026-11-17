import 'package:flutter/material.dart';
import 'package:no_pain_no_grad/gym/view/admin_view/policies/policies_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  NetworkHelper.initializeDio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PoliciesScreen(),
      );
  
  }
}
