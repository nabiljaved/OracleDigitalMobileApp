import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OracleDigital',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'images/logo.jpeg',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              // const Text(
              //   'My App',
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Set the AppBar height to 0
        child: AppBar(
          backgroundColor: Colors.black, // Set status bar color to black
          elevation: 0, // Remove AppBar shadow
        ),
      ),
      body: const WebViewWithCache(
        initialUrl: "https://oracledigital.ae/",
      ),
    );
  }
}

class WebViewWithCache extends StatefulWidget {
  final String initialUrl;

  const WebViewWithCache({super.key, required this.initialUrl});

  @override
  // ignore: library_private_types_in_public_api
  _WebViewWithCacheState createState() => _WebViewWithCacheState();
}

class _WebViewWithCacheState extends State<WebViewWithCache> {
  bool _isConnected = true;
  bool _isLoading = true; // To track if the web page is still loading.

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    final result = await InternetConnectionChecker().hasConnection;
    setState(() {
      _isConnected = result;
    });
  }

  void _handleRefresh() async {
    await checkInternetConnection();
  }

  void _onPageFinished(String url) {
    // Called when the web page finishes loading.
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? Stack(
            children: [
              WebView(
                initialUrl: widget.initialUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished:
                    _onPageFinished, // Callback when page finished loading.
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ),
            ],
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off,
                  size: 60,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  'No Internet',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Oracle Digital',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                const Text(
                  'Best Digital Marketing Company',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleRefresh,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
  }
}
