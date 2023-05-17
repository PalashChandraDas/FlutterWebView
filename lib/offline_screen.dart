import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //local_variable
    var offlineTxt = "ইন্টারনেট কানেকশন নেই";

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Lottie.asset("assets/offline.json")),
            ),
          ),
          const CircularProgressIndicator(
            color: Colors.pink,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 25,
                padding: const EdgeInsets.only(top: 2),
                width: MediaQuery.of(context).size.width,
                color: Colors.pink,
                child: Center(
                    child: Text(
                      offlineTxt,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14, fontFamily: "AdorshoLipi"),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
