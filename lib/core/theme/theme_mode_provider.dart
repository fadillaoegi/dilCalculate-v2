import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
