import 'package:flutter/material.dart';

abstract class HomePageBuilder {

  SliverAppBar buildHomePageAppBar(BuildContext context, String title);

  SliverAppBar buildWikiPageAppBar(BuildContext context, String title);

  Widget buildDrawer(BuildContext context);

  Widget buildHomePageBottomAppBar(BuildContext context);

  Widget buildWikiPageBottomAppBar(BuildContext context, String title);

  Widget buildBody(BuildContext context, Future<String> futureContent);
}
