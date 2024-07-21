import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock data
  final String profilePictureUrl =
      'https://www.example.com/profile_picture.jpg'; // Replace with actual URL
  final String userName = 'Maaz Denk';
  final String email = 'maazmasroorhuss@gmail.com';
  final String bio = 'Flutter developer | Netflix enthusiast | Cinephile';
  final int Movies = 120;
  final int TVshows = 150;
  final List<String> socialMediaLinks = [
    'https://twitter.com/johndoe',
    'https://linkedin.com/in/johndoe',
    'https://github.com/johndoe'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              backgroundImage: AssetImage('lib/images/splash.png'),
              radius: 100,
              // Replace with actual URL
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                bio,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildFollowSection(),
            const SizedBox(height: 20),
            _buildSocialMediaLinks(),
            const SizedBox(height: 20),
            _buildEditProfileButton(),
            const SizedBox(height: 20),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFollowInfo('Movies', Movies),
        const SizedBox(width: 40),
        _buildFollowInfo('TVshows', TVshows),
      ],
    );
  }

  Widget _buildFollowInfo(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white
            ,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialMediaLinks.map((link) {
        return IconButton(
          icon: _getSocialMediaIcon(link),
          onPressed: () {
            // Handle social media link click
          },
        );
      }).toList(),
    );
  }

  Icon _getSocialMediaIcon(String url) {
    if (url.contains('twitter')) {
      return const Icon(Icons.alternate_email); // Replace with Twitter icon
    } else if (url.contains('linkedin')) {
      return const Icon(Icons.business); // Replace with LinkedIn icon
    } else if (url.contains('github')) {
      return const Icon(Icons.code); // Replace with GitHub icon
    } else {
      return const Icon(Icons.link);
    }
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to edit profile screen
      },
      child: const Text('Edit Profile'),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        _buildInfoTile('More','.....'),
        _buildInfoTile('Know me', '...............'),
        _buildInfoTile('Stats', '...........'),
      ],
    );
  }

  Widget _buildInfoTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to edit info screen
          },
        ),
      ),
    );
  }
}
