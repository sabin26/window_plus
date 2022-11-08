import 'package:flutter/material.dart';
import 'package:window_plus/window_plus.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowPlus.ensureInitialized(
    application: 'com.alexmercerind.window_plus',
  );
  WindowPlus.instance.setWindowCloseHandler(() async {
    bool result = false;
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text('Exit'),
        content: const Text('Do you want to close the window?'),
        actions: [
          TextButton(
            onPressed: () {
              result = true;
              Navigator.of(context).maybePop();
            },
            child: const Text('YES'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            child: const Text('NO'),
          ),
        ],
      ),
    );
    return result;
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF6200EA),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF1dE9B6),
          onSecondary: Color(0xFF000000),
          error: Color(0xFFFF0000),
          onError: Color(0xFFFFFFFF),
          background: Color(0xFFFFFFFF),
          onBackground: Color(0xFF000000),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF000000),
        ),
      ).copyWith(
        tooltipTheme: TooltipThemeData(
          verticalOffset: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: const Color(0xFF000000),
          ),
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      home: LayoutBuilder(
        builder: (context, _) {
          return Scaffold(
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('package:window_plus'),
                      ),
                      elevation: 4.0,
                      expandedHeight: 200.0,
                      pinned: true,
                      floating: true,
                      snap: false,
                      forceElevated: true,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: SizedBox.shrink(),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate.fixed(
                        [
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const SizedBox(width: 16.0),
                              TextButton(
                                onPressed: WindowPlus.instance.minimize,
                                child: const Text('MINIMIZE'),
                              ),
                              TextButton(
                                onPressed: WindowPlus.instance.maximize,
                                child: const Text('MAXIMIZE'),
                              ),
                              TextButton(
                                onPressed: WindowPlus.instance.restore,
                                child: const Text('RESTORE'),
                              ),
                              TextButton(
                                onPressed: WindowPlus.instance.close,
                                child: const Text('CLOSE'),
                              ),
                              TextButton(
                                onPressed: WindowPlus.instance.destroy,
                                child: const Text('DESTROY'),
                              ),
                              const SizedBox(width: 16.0),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'minimized: ${WindowPlus.instance.minimized}',
                                  ),
                                  Text(
                                    'maximized: ${WindowPlus.instance.maximized}',
                                  ),
                                  Text(
                                    'fullscreen: ${WindowPlus.instance.fullscreen}',
                                  ),
                                  Text(
                                    'hwnd: ${WindowPlus.instance.hwnd}',
                                  ),
                                  Text(
                                    'captionHeight: ${WindowPlus.instance.captionHeight}',
                                  ),
                                  Text(
                                    'captionButtonSize: ${WindowPlus.instance.captionButtonSize}',
                                  ),
                                  Text(
                                    'captionPadding: ${WindowPlus.instance.captionPadding}',
                                  ),
                                  FutureBuilder(
                                    future:
                                        WindowPlus.instance.savedWindowState,
                                    builder: (context, snapshot) =>
                                        !snapshot.hasData
                                            ? Text(
                                                'savedWindowState: ${snapshot.data.toString()}',
                                              )
                                            : Text(
                                                'savedWindowState: ${snapshot.data}',
                                              ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 200.0 - 28.0,
                  right: 32.0,
                  child: FloatingActionButton(
                    tooltip: WindowPlus.instance.fullscreen
                        ? 'Exit Fullscreen'
                        : 'Enter Fullscreen',
                    onPressed: () {
                      WindowPlus.instance
                          .setIsFullscreen(!WindowPlus.instance.fullscreen);
                    },
                    child: Icon(
                      WindowPlus.instance.fullscreen
                          ? Icons.fullscreen_exit
                          : Icons.fullscreen,
                    ),
                  ),
                ),
                WindowCaption(
                  brightness: Brightness.dark,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
