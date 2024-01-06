import 'package:flutter/material.dart';
import '../../Api & Routes/routes.dart';
import '../Language/appLocalizations.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor, // Replace with your desired color
        title: Text(
          AppLocalizations.of('Jobs'),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color:
            Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: const Drawer(
          child: AppDrawer(
            selectItemName: 'Jobs',
          ),
        ),
      ),
      body: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.work, color: Theme.of(context).cardColor),
                label: "Current Job",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info, color: Theme.of(context).cardColor),
                label: "Future Job",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check, color: Theme.of(context).cardColor),
                label: "Complete Job",
              ),
            ],
            selectedItemColor: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).primaryColor,
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
          body: _tabs[_currentIndex],
        ),
      ),
    );
  }
}
