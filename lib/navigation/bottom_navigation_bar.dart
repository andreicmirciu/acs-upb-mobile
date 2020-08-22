import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/people/people_page.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/profile/profile_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int tabIndex;

  AppBottomNavigationBar({this.tabIndex = 0});

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar>
    with TickerProviderStateMixin {
  var tabs;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 5);
    tabs = [
      HomePage(tabController),
      ChangeNotifierProvider(
          create: (_) => ClassProvider(), child: TimetablePage()),
      PortalPage(),
      ProfilePage(),
      PeoplePage(),
    ];
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        body: TabBarView(controller: tabController, children: tabs),
        bottomNavigationBar: SizedBox(
          height: 45,
          child: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: S.of(context).navigationHome,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
                text: S.of(context).navigationTimetable,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.public),
                text: S.of(context).navigationPortal,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.person),
                text: S.of(context).navigationProfile,
                iconMargin: EdgeInsets.all(0),
              ),
              Tab(
                icon: Icon(Icons.people),
                text: S.of(context).navigationPeople,
                iconMargin: EdgeInsets.all(0),
              ),
            ],
            labelColor: Theme.of(context).accentColor,
            labelPadding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
            unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
            indicatorColor: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
