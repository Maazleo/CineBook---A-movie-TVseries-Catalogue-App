import 'package:cinebook/screens/my_films_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/my_tv_shows_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/popular_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/watch_later_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/favourite_screen.dart';
import 'screens/diary_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/my_list_screen.dart';
import 'screens/sign_out.dart';

void main() {
  runApp(const CineBook());
}

class CineBook extends StatelessWidget {
  const CineBook({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineBook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(backgroundColor: Colors.cyan.shade600).copyWith(secondary: Colors.amber),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/search': (context) =>  SearchScreen(category: '', onMovieSelected: (movie) {  }, onTVShowSelected: (tvShow) {  },),
        '/profile': (context) => const ProfileScreen(),
        '/watch_later': (context) =>  WatchLaterScreen(),
        '/settings': (context) => SettingsScreen(),
        '/my_list': (context) => const MyCineBoxScreen(),
        '/diary': (context) =>  DiaryScreen(),
        '/reviews': (context) =>  ReviewsScreen(),
        '/sign_out': (context) =>  const SignOutScreen(),
        '/mytvshows': (context) =>   MyTVShowsScreen(),
        '/myfilms': (context) =>   MyFilmsScreen(),

      },
    );
  }
}
