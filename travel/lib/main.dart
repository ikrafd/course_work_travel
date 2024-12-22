import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/data/data_sources/supabase.dart';
import 'package:travel/features/data/repositories/user_impl.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/injection_container.dart';
import 'package:travel/my_app.dart';
import 'package:travel/simple_bloc_observer.dart';
import 'config/firebase.dart/firebase_options.dart';

void main() async {
  setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeSupabaseWithFirebase();
  await FirebaseService.initialize();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepositoryImpl()));
}
