import 'package:flutter/material.dart';
Future<dynamic> downloadVideoOrPlay(
    {VoidCallback? noButton, VoidCallback? yesButton,BuildContext? context, double? width,}) {
  return showDialog(
    context: context!,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 16,
        child: Container(
          width: width! * 0.2,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text(
                    'Are You Sure ?',
                    maxLines: 1,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'For Downloading Press Yes',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18,wordSpacing: 5),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: noButton,
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: yesButton,
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.deepOrange, fontSize: 24),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}