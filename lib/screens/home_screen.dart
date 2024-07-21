import 'package:flutter/material.dart';
import 'films_screen.dart';
import 'tv_shows_screen.dart';
import 'my_list_screen.dart';
import 'my_tv_shows_screen.dart';  // New import
import 'my_films_screen.dart';  // New import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineBook',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 25),),
        backgroundColor: Colors.cyan.shade100,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () => Navigator.of(context).pushNamed('/search'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Films'),
            Tab(text: 'TV Shows'),
            Tab(text: 'My CineBOX'),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.cyan.shade700,
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              currentAccountPictureSize: Size(70, 70),
              accountName: Text('DenkoWatcher', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              accountEmail: Text('Have your own CINEBOOK'),
              currentAccountPicture: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('lib/images/splash.png'),
                  radius: 50, // Increase radius to make the image larger
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black38,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Profile'),
              onTap: () => Navigator.of(context).pushNamed('/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.white),
              title: const Text('My List'),
              onTap: () => Navigator.of(context).pushNamed('/my_list'),
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.white),
              title: const Text('Diary'),
              onTap: () => Navigator.of(context).pushNamed('/diary'),
            ),
            ListTile(
              leading: const Icon(Icons.search_rounded, color: Colors.white),
              title: const Text('Search'),
              onTap: () => Navigator.of(context).pushNamed('/search'),
            ),
            ListTile(
              leading: const Icon(Icons.tv_outlined, color: Colors.white),
              title: const Text('My TV Shows'),
              onTap: () => Navigator.of(context).pushNamed('/mytvshows'),
            ),
            ListTile(
              leading: const Icon(Icons.movie_creation_outlined, color: Colors.white),
              title: const Text('My Films'),
              onTap: () => Navigator.of(context).pushNamed('/myfilms'),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review, color: Colors.white),
              title: const Text('Reviews'),
              onTap: () => Navigator.of(context).pushNamed('/reviews'),
            ),
            ListTile(
              leading: const Icon(Icons.watch_later_outlined, color: Colors.white),
              title: const Text('Watch later'),
              onTap: () => Navigator.of(context).pushNamed('/watch_later'),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings'),
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text('Sign out'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/sign_out');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FilmsScreen(),
          TVShowsScreen(),
          const MyCineBoxScreen(),  // New screen for nested tabs
        ],
      ),
    );
  }
}

class MyCineBoxScreen extends StatefulWidget {
  const MyCineBoxScreen({super.key});

  @override
  _MyCineBoxScreenState createState() => _MyCineBoxScreenState();
}

class _MyCineBoxScreenState extends State<MyCineBoxScreen> with SingleTickerProviderStateMixin {
  late TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nestedTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan.shade100,
        title: TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'My TV Shows'),
            Tab(text: 'My Films'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _nestedTabController,
        children: [
          MyTVShowsScreen(),
          MyFilmsScreen(),
        ],
      ),
    );
  }
}
