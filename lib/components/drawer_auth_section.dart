import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wikikamus/providers/auth_provider.dart';

class DrawerAuthSection extends StatelessWidget {
  const DrawerAuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'wikimedia_auth'.tr(),
        style: GoogleFonts.gelasio(
          textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      children: [
        Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if (auth.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (auth.isLoggedIn) {
              return ListTile(
                leading: const Icon(Icons.logout),
                title: Text('logout'.tr()),
                onTap: () {
                  auth.logout();
                  Navigator.of(context).pop();
                },
              );
            } else {
              return ListTile(
                leading: const Icon(Icons.login),
                title: Text('login'.tr()),
                onTap: () async {
                  await auth.login();
                  Navigator.of(context).pop();
                },
              );
            }
          },
        ),
      ],
    );
  }
}
