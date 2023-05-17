import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'offline_screen.dart';

class MayapurTvWeb extends StatefulWidget {
  const MayapurTvWeb({Key? key}) : super(key: key);
  static const String routeName = "/mayapurtvweb";

  @override
  State<MayapurTvWeb> createState() => _MayapurTvWebState();
}

class _MayapurTvWebState extends State<MayapurTvWeb> {
  //declare_variable
  var tvUrl = "https://www.mayapur.tv";
  var appBarTitle = "মায়াপুর টিভি";
  var closeTv = "টিভি বন্ধ করুন";
  var isLoading = true;
  var isError = false;
  var errorMsg = "Please try again\nSomething went wrong";
  late WebViewController controller;

  @override
  void initState() {
    //set PORTRAIT_MODE only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    //set PORTRAIT_MODE only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnBackPressed(
      perform: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
        } else {
          controller.clearCache();
          CookieManager().clearCookies();
          // Get.to(() => const LiveTvScreen());
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: _appBarWidget(),
        body: _myBodyWidget(),
      ),
    );
  }

  _appBarWidget() {
    return AppBar(
      title: Text(appBarTitle),
      actions: [
        IconButton(
          onPressed: () {
            controller.reload();
          },
          icon: const Icon(Icons.refresh),
        ),
        PopupMenuButton<int>(
          onSelected: (value) => _onSelected(context, value),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0,
                  child: Text(closeTv),
                  ),
            ]),
      ],
      leading: IconButton(
        onPressed: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
          } else {
            controller.clearCache();
            CookieManager().clearCookies();
            Navigator.pop(context);
            // Get.to(() => const LiveTvScreen());
          }
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  _onSelected(BuildContext context, int value){
    switch(value) {
      case 0:
        controller.clearCache();
        CookieManager().clearCookies();
        // Get.to(()=> const LiveTvScreen());
        Navigator.pop(context);
        break;
    }
  }

  _myBodyWidget() {
    return SafeArea(
      child: Stack(
        children: [
          if (!isError)
            WebView(
              onWebResourceError: (error) {
                setState(() {
                  isError = true;
                });
              },
              initialUrl: tvUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onPageStarted: (url) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
          if (isError)
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.pink,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(errorMsg, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          (Provider.of<InternetConnectionStatus>(context) ==
                  InternetConnectionStatus.disconnected)
              ? const OfflineScreen()
              : isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.pink,
                    ))
                  : Stack(),
        ],
      ),
    );
  }
}
