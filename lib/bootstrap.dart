import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'data/supabase/supabase_initializer.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseInitializer.initialize();
  runApp(const ProviderScope(child: SertechApp()));
}
