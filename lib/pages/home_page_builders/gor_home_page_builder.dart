import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'home_page_builder.dart';

class GorontaloHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildAppBar(BuildContext context, String title) {
    return SliverAppBar(
      title: Text('gorontalo'.tr()),
      floating: true,
      snap: true,
    );
  }

  @override
  Widget buildBottomAppBar(BuildContext context) {
    // TODO: implement buildBottomAppBar
    throw UnimplementedError();
  }

  @override
  Widget buildDrawer(BuildContext context) {
    // TODO: implement buildDrawer
    throw UnimplementedError();
  }

  @override
  Widget buildBody(BuildContext context, Future<String> futureContent) {
    // The same body logic as the Nias one, but could have simpler styling.
    return FutureBuilder<String>(
      future: futureContent,
      builder: (context, snapshot) {
        // ... (builder logic is identical to Nias for now)
        // In the future, you might have simpler or no custom styling here.
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(snapshot.data ?? ''),
          );
        }
        // ... other states
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
