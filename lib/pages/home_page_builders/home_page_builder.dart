import 'package:flutter/material.dart';

enum PageType {
  home,
  wiki,
}

abstract class HomePageBuilder {

  SliverAppBar buildHomePageAppBar(BuildContext context, String title);
  SliverAppBar buildWikiPageAppBar(BuildContext context, String title);
  Widget buildWikiPageBottomAppBar(BuildContext context, String title);
  Widget buildHomePageBottomAppBar(BuildContext context);
  Widget buildDrawer(BuildContext context);

  Widget buildBody(BuildContext context, Future<String> futureContent,  PageType pageType);
}
