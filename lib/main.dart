import 'package:flutter/material.dart';
import 'package:numbers_trivia/features/numbers_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      // theme: ThemeData(
      //   primaryColor: Colors.black54,
      // ),
      home: const NumberTriviaPage(),
    );
  }
}
