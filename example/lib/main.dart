import 'dart:async';

import 'package:example/api_service.dart';
import 'package:flutter/material.dart';
import 'package:jack_api/jack_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JackAPI Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'JackAPI Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DataCacheService cacheService;

  final ApiService api = ApiService();

  StreamController<bool> controller = StreamController<bool>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await api.init("https://fakestoreapi.com");
      await api.api.initCacheService();

      cacheService = DataCacheService();
    });

    controller.stream.listen((event) {
      debugPrint(
          "----------------------incoming data from stream $event----------------------");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                cacheService.store(
                  options: DataCacheOptions(
                    data: "cache service 1",
                    key: "cacheService",
                  ),
                );
              },
              child: const Text("Store data"),
            ),
            ElevatedButton(
              onPressed: () {
                cacheService.store(
                  options: DataCacheOptions(
                    data: "cache service 2",
                    key: "cacheService",
                  ),
                );
              },
              child: const Text("Store same data"),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = await cacheService.readAll(
                  key: "cacheService",
                );
                debugPrint(
                    "----------------------cache read $data----------------------");
              },
              child: const Text("Read data"),
            ),
            ElevatedButton(
              onPressed: () async {
                await cacheService.update(
                    key: "cacheService",
                    modifier: (data, extra) {
                      return ("$data modified", extra);
                    });
              },
              child: const Text("Update data"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await api.apiGetProducts(cacheService, controller);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
