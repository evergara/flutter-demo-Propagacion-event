import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class EventConfiguration {
  String eventDispacher;
  String data;

  EventConfiguration(this.eventDispacher, this.data);
}

class _MyAppState extends State<MyApp> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  late InAppWebViewController _webViewController;

  late EventConfiguration darkModo =
      EventConfiguration("superApp-accessibility-darkModo", "");
  late EventConfiguration imprimirFactura =
      EventConfiguration("superApp-accessibility-imprimirFactura", "10203040");
  late EventConfiguration goComponent =
      EventConfiguration("superApp-accessibility-goComponent", "componentes");
  late EventConfiguration latter =
      EventConfiguration("superApp-accessibility-latter", "");
  late EventConfiguration smallLatter =
      EventConfiguration("superApp-accessibility-smallLatter", "");
  late EventConfiguration biggerlatter =
      EventConfiguration("superApp-accessibility-biggerlatter", "");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text("InAppWebView")),
          body: SafeArea(
              child: Column(children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialData: InAppWebViewInitialData(data: """
                      <!DOCTYPE html>
                      <html lang="en">
                          <head>
                              <meta charset="UTF-8">
                              <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
                          </head>
                          <body>
                              <h1 id="color">JavaScript Handlers</h1>
                              <a style="margin: 50px; background: #333; color: #fff; font-weight: bold; font-size: 20px; padding: 15px; display: block;"
                          href="https://satemporalb2cepmsuperapp.z20.web.core.windows.net/#/home"
                          target="_blank">
                          Click here to open flutter in a popup!
                        </a>
                        <script type="text/javascript">

                       window.addEventListener('myCustomEvent', (e) => alert(e.detail.foo));
                            function fromFlutter(data) {
                            

                            var color = document.getElementById("color").innerHTML;
                            alert(data);
                           document.body.style.backgroundColor = "#000";
                           document.getElementById("color").style.color = "#FFF";
                            
                            // Do something
                            console.log("This is working now..." + data);
                            }

                          </script>
                              <script>
                                  window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                                      window.flutter_inappwebview.callHandler('handlerFoo')
                                        .then(function(result) {
                                          // print to the console the data coming
                                          // from the Flutter side.
                                          console.log(JSON.stringify(result));
                                          
                                          window.flutter_inappwebview
                                            .callHandler('handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result);
                                      });
                                  });
                              </script>
                          </body>
                      </html>
                      """),
                initialOptions: options,
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                  controller.addJavaScriptHandler(
                      handlerName: 'handlerFoo',
                      callback: (args) {
                        // return data to the JavaScript side!
                        return {'bar': 'bar_value', 'baz': 'baz_value'};
                      });

                  controller.addJavaScriptHandler(
                      handlerName: 'handlerFooWithArgs',
                      callback: (args) {
                        print(args);
                        // it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
                      });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                  // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                },
              ),
            ),
          ])),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  _webViewController
                      .evaluateJavascript(source: dispacherEvent(goComponent))
                      .then((value) => print(value));
                },
                child: Icon(Icons.input),
              ),
              FloatingActionButton(
                onPressed: () {
                  _webViewController
                      .evaluateJavascript(source: dispacherEvent(darkModo))
                      .then((value) => print(value));
                },
                child: Icon(Icons.dark_mode),
              ),
              FloatingActionButton(
                onPressed: () {
                  _webViewController
                      .evaluateJavascript(source: dispacherEvent(smallLatter))
                      .then((value) => print(value));
                },
                child: Icon(Icons.account_circle_outlined),
              ),
              FloatingActionButton(
                onPressed: () {
                  _webViewController
                      .evaluateJavascript(source: dispacherEvent(latter))
                      .then((value) => print(value));
                },
                child: Icon(Icons.account_circle),
              ),
              FloatingActionButton(
                onPressed: () {
                  _webViewController
                      .evaluateJavascript(source: dispacherEvent(biggerlatter))
                      .then((value) => print(value));
                },
                child: Icon(Icons.account_box),
              ),
              FloatingActionButton(
                onPressed: () {
                  _webViewController
                      .evaluateJavascript(
                          source: dispacherEvent(imprimirFactura))
                      .then((value) => print(value));
                },
                child: Icon(Icons.local_print_shop),
              )
            ],
          )),
    );
  }

  String dispacherEvent(EventConfiguration eventConfiguration) {
    String event =
        "window.document.dispatchEvent(new CustomEvent('${eventConfiguration.eventDispacher}'));";

    if (eventConfiguration.data != "") {
      event =
          "window.document.dispatchEvent(new CustomEvent('${eventConfiguration.eventDispacher}',  {detail: {data: '${eventConfiguration.data}'}}));";
    }
    print(event);
    return event;
  }
}
