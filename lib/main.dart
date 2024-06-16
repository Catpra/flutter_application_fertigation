import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/bluetooth_provider.dart'; // Add this line
import 'screens/home_page.dart';
import 'screens/input_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ],
      child: MaterialApp(
        title: 'Scheduler',
        theme: ThemeData(
          primaryColor: Colors.green,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green,
          ),
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            headlineSmall: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            bodyMedium: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.green,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.green,
            brightness: Brightness.dark,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.green,
          ),
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            headlineSmall: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            bodyMedium: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        themeMode: ThemeMode.system,
        home: HomePage(),
        routes: {
          '/input': (context) => InputPage(),
        },
      ),
    );
  }
}
