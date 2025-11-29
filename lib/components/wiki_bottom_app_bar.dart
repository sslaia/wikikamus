import 'package:flutter/material.dart';

class WikiBottomAppBar extends StatelessWidget {
  final List<Widget> children;

  const WikiBottomAppBar({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return _buildLandscapeLayout(context);
        } else {
          return _buildPortraitLayout(context);
        }
      },
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Container(
      width: 72.0,
      child: Material(
        elevation: 4.0,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}