import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ws1/wave.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final TabController _tabController;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              floating: false,
              pinned: true,
              delegate: _SliverHeaderDelegate(
                  controller: _tabController,
                  isDark: _isDark,
                  onChanged: (value) {
                    setState(() {
                      _isDark = value;
                    });
                  }),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemCount: 40,
              itemBuilder: (context, index) {
                return Text('News $index');
              },
            ),
            ListView.builder(
              itemCount: 40,
              itemBuilder: (context, index) {
                return Text('Result $index');
              },
            ),
            ListView.builder(
              itemCount: 40,
              itemBuilder: (context, index) {
                return Text('History $index');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  final bool isDark;
  final void Function(bool)? onChanged;

  _SliverHeaderDelegate({
    required this.controller,
    required this.isDark,
    this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent));

    print('XXX shrinkPercentage = $shrinkPercentage');

    return SafeArea(
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 24),
                child: Align(
                  child: GestureDetector(
                    child: Icon(Icons.settings),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text('Dark mode'),
                                  Switch(
                                    value: isDark,
                                    onChanged: onChanged,
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              Image.asset(
                'assets/images/photo.jpg',
                width: MediaQuery.sizeOf(context).width *
                    (max(0.3, 1 - shrinkPercentage)),
              ),
              Stack(
                children: [
                  const MyAnimatedWaveCurves(),
                  TabBar(
                    controller: controller,
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: Colors.white,
                    indicatorColor: Colors.white,
                    tabs: const [
                      Tab(
                        text: 'News',
                      ),
                      Tab(
                        text: 'Results',
                      ),
                      Tab(
                        text: 'History',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 468;

  @override
  double get minExtent => 162;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
