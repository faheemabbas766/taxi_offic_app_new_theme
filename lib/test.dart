import 'dart:async';
import 'package:flutter/material.dart';
class MyTest extends StatefulWidget {
  const MyTest({super.key});

  @override
  State<MyTest> createState() => _MyTestState();
}

class _MyTestState extends State<MyTest> {
  void showFutureJobDialog(BuildContext context) {
    int seconds = 30;
    late Timer timer;

    void startTimer() {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          timer.cancel();
          Navigator.of(context).pop();
        }
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Admin has assigned you a future job. Do you accept?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Time remaining: $seconds seconds'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // Accept logic
                          timer.cancel();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Reject logic
                          timer.cancel();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Show'),
          onPressed: (){
            showFutureJobDialog(context);
            // showDialog(
            //   context: context,
            //   builder: (context) => Dialog(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //     elevation: 0,
            //     backgroundColor: Colors.transparent,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(10.0),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.5),
            //             spreadRadius: 3,
            //             blurRadius: 7,
            //             offset: Offset(0, 3),
            //           ),
            //         ],
            //       ),
            //       child: Padding(
            //         padding: EdgeInsets.all(20.0),
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             const Icon(
            //               Icons.add_alert,
            //               size: 40,
            //               color: Colors.red,
            //             ),
            //             SizedBox(height: 20),
            //             const Text(
            //               'Admin Assign you Future Booking',
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             const SizedBox(height: 20),
            //             Row(
            //               children: [
            //                 ElevatedButton(
            //                     onPressed:(){
            //                       Navigator.of(context).pop();
            //                     },
            //                     child: const Text('Accept')
            //                 ),
            //                 Spacer(),
            //                 ElevatedButton(
            //                     onPressed:(){
            //                       Navigator.of(context).pop();
            //                     },
            //                     child: const Text('Reject')
            //                 ),
            //               ],
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
