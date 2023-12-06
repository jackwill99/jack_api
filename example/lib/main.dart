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

  late JackRestApi api;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      api = JackRestApi(baseUrl: "https://fakestoreapi.com");

      await api.init();

      cacheService = DataCacheService();
    });
  }

  void getProducts() {
    api.query(
      method: "GET",
      path: "/products",
      cacheOptions: JackApiCacheOptions(
        schemaName: "products",
        duration: const Duration(minutes: 10),
      ),
      isAlreadyToken: false,
      onSuccess: (data) async {
        debugPrint(
            "----------------------onSuccess $data----------------------");
      },
    );
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
                      data: "cache service",
                      expiry: Duration(seconds: 10),
                      key: "cacheService",
                      schemaName: "cacheService"),
                );
              },
              child: Text("Store data"),
            ),
            ElevatedButton(
              onPressed: () async {
                final data = await cacheService.read(
                    key: "cacheService", schemaName: "cacheService");
                debugPrint(
                    "----------------------cache read ${data}----------------------");
              },
              child: Text("Read data"),
            ),
            ElevatedButton(
              onPressed: () async {
                await cacheService.update(
                    key: "cacheService",
                    schemaName: "cacheService",
                    modifier: (String data) {
                      return "${data} haha";
                    });
              },
              child: Text("Update data"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getProducts,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
