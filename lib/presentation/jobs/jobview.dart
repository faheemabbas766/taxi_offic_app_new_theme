import 'package:flutter/material.dart';
import '../../Api & Routes/routes.dart';
import '../drawer/drawer.dart';
import 'completedjobs.dart';
import 'currentjobs.dart';
import 'pendingjobs.dart';

class JobView extends StatefulWidget {
  const JobView({super.key});

  @override
  State<JobView> createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const CurrentJobs(),
    const PendingJobs(),
    const CompletedJobs(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    RouteManager.context=context;
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: const Drawer(
          child: AppDrawer(
            selectItemName: 'Jobs',
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red, // Replace with your desired color
        title: const Text(
          "Jobs View",
          style: TextStyle(fontSize: 20), // Adjust the font size as needed
        ),
      ),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: "Current Job",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: "Future Job",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check),
                label: "Complete Job",
              ),
            ],
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
          body: _tabs[_currentIndex],
        ),
      ),
    );
  }
}
