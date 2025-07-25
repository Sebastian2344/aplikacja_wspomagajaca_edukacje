import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiztale/login_and_register_module/data/repository/auth_repository.dart';

import 'firebase_options.dart';
import 'login_and_register_module/cubit/auth_cubit.dart';
import 'login_and_register_module/data/data_source/auth_source.dart';
import 'login_and_register_module/presentation/menu_auth.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(BlocProvider(
    create: (context) => AuthCubit(AuthRepository(FirebaseAuthDataSource(FirebaseAuth.instance, FirebaseFirestore.instance)))..isLogged(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MenuAuth(),
    );
  }
}