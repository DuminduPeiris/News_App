import 'package:flutter/material.dart';
import 'package:news_app/views/splash_screen.dart';
import 'package:provider/provider.dart';
//import 'views/home_view.dart';  
import 'viewmodels/news_viewmodel.dart';  
// import 'package:news_app/views/splash_screen.dart';
// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsViewModel(),
      child: MaterialApp(
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


