import 'package:dyeus/screens/auth_page.dart';
import 'package:dyeus/widgets/auth_handler.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Home Page',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                )),
            actions: [
              IconButton(
                  onPressed: () async {
                    await AuthHandler.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) => const AuthPage()),
                        (route) => false);
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 32,
                  )),
              const SizedBox(width: 20),
            ]),
        body: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Center(
              child: Text('Hurray!!!!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 32))),
        ));
  }
}
