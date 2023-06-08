import 'package:flutter/material.dart';
import 'package:roder/search/search_page.dart';
import 'package:roder/ui/home_page.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Near Me'),
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: headerWidget(context),
          ),
          // SliverToBoxAdapter(
          //   child: _getDBRides(),
          // ),
        ],
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          "Rides",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
