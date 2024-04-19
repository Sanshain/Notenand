import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: const Text('About'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'This is an open source application designed to quickly write and organize notes. '
                ' We hope that it will be useful for you!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ).padding(bottom: 20, horizontal: 15),
              InkWell(
                  child: const Text(
                    'Home page',
                    style: TextStyle(decoration: TextDecoration.underline, decorationColor: Colors.blue, color: Colors.blue),
                  ),
                  onTap: () {
                    launchUrl(Uri.parse('https://github.sanshain.io/Nodenand'));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
