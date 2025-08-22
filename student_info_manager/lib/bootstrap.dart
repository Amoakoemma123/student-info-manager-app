import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'models/student.dart';
import 'models/course.dart';
import 'models/enrollment.dart';

Future<void> bootstrapApp(FutureOr<Widget> Function() builder) async {
	WidgetsFlutterBinding.ensureInitialized();
	if (!kIsWeb) {
		final Directory appDir = await getApplicationDocumentsDirectory();
		Hive.init(appDir.path);
	}
	await Hive.initFlutter();

	if (!Hive.isAdapterRegistered(1)) {
		Hive.registerAdapter(StudentAdapter());
	}
	if (!Hive.isAdapterRegistered(2)) {
		Hive.registerAdapter(CourseAdapter());
	}
	if (!Hive.isAdapterRegistered(3)) {
		Hive.registerAdapter(EnrollmentAdapter());
	}

	final Widget appWidget = await Future.sync(builder);
	runApp(appWidget);
}