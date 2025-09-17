import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:havenote/app/app.dart';
import 'package:havenote/services/firebase_initializer.dart';

Future<void> main() async {
  await FirebaseInitializer.init();
  runApp(const ProviderScope(child: HavenoteApp()));
}
