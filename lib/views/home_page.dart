import 'package:flutter/material.dart';
import 'package:sk/constants/api.dart';
import 'package:sk/views/widgets/tab_bar_widgets.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Movie TMDB'),
            bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'Popular',
                  ),
                  Tab(
                    text: 'TopRated',
                  ),
                  Tab(
                    text: 'Upcoming',
                  )
                ]
            ),
          ),
          body: TabBarView(
            children: [
              TabBarWidgets(api: Api.popularMovie),
              TabBarWidgets(api: Api.topRatedMovie),
              TabBarWidgets(api: Api.upComingMovie),
            ],
          )
      ),
    );
  }
}