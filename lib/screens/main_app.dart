import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/home/data/last_update_time_data.dart';
import 'package:my_app/features/home/logic/record_count_reverpod.dart';
import 'package:my_app/features/home/screen/home_screen.dart';
import 'package:my_app/features/record/screen/record_form_screen.dart';
import 'package:my_app/screens/records_list_screen.dart';
import 'package:my_app/screens/settings_screen.dart';

import '../core/utils/fetch_function.dart';

enum AppTab { home, records, settings }

final currentTabProvider = StateProvider<AppTab>((ref) => AppTab.home);

class MainApp extends ConsumerWidget {
  const MainApp({super.key});
  static const routeName ="/mainApp" ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(currentTab)),
      ),

      /// 👉 এখানে তুমি তোমার আসল screen বসাবে
      body: _renderBody(currentTab),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _getTabIndex(currentTab),
          onTap: (i) {
            final tab = _getTabFromIndex(i);

            // index 2 হলে (মানে Settings tab এ গেলে) invalidate হবে
            if (i == 1) {
              ref.invalidate(recordsStreamProvider);
            }   else if (i == 2) {
              ref.invalidate(recordsStreamProvider);
            }    else if (i == 0) {
              ref.invalidate(recordCountProvider);
              ref.invalidate(lastActivityProvider);
            }

            ref.read(currentTabProvider.notifier).state = tab;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              activeIcon: Icon(Icons.list),
              label: 'Records',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        

      floatingActionButton: currentTab == AppTab.records
          ? FloatingActionButton(
        onPressed: () {
          context.push(RecordFormScreen.routeName);
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  /// placeholder body
  Widget _renderBody(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return const HomeScreen();
      case AppTab.records:
        return const RecordsListScreen();
      case AppTab.settings:
        return const SettingsScreen();
    }
  }

  String _getTitle(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return "My App";
      case AppTab.records:
        return "Records";
      case AppTab.settings:
        return "Settings";
    }
  }

  int _getTabIndex(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return 0;
      case AppTab.records:
        return 1;
      case AppTab.settings:
        return 2;
    }
  }
  AppTab _getTabFromIndex(int i) {
    switch (i) {
      case 0:
        return AppTab.home;
      case 1:
        return AppTab.records;
      case 2:
        return AppTab.settings;
      default:
        return AppTab.home;
    }
  }
}