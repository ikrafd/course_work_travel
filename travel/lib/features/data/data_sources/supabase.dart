//import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initializeSupabaseWithFirebase() async {
   String url = 'https://avgexnxrinidfgqsmlfq.supabase.co';
   String anonKey= 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF2Z2V4bnhyaW5pZGZncXNtbGZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ0NTc1MDEsImV4cCI6MjA1MDAzMzUwMX0.OOYlZbY7I9o03xcff6m0KMrHaViVdgE0hZcD9hPPnvA';
 
  await Supabase.initialize(
    url: url, 
    anonKey: anonKey,
  );
}