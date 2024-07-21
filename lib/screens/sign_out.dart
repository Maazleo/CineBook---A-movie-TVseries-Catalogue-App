import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignOutScreen extends StatelessWidget {
  const SignOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Out'),
        backgroundColor: Colors.cyan.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Are you sure you want to sign out?',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: UserAccountsDrawerHeader(
                  accountName: Text('DenkoWatcher', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  accountEmail: Text('Helllo !!!!!!!!!!'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('lib/images/me.png'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                  ),
                ),
              ),
            ),

            const Spacer(),
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _showSignOutDialog(context);
                      },
                      child: const Text('Sign Out'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out of the app?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signOut(); // Call the sign-out method
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _signOut() {
    // Handle sign out logic here, e.g., clear user data
    // Exit the app
    SystemNavigator.pop(); // This will close the app
  }
}
