import 'package:flutter/material.dart';

abstract class HomePageBuilder {

  SliverAppBar buildAppBar(BuildContext context, String title);

  Widget buildDrawer(BuildContext context);

  Widget buildBottomAppBar(BuildContext context);

  Widget buildBody(BuildContext context, Future<String> futureContent);
}
