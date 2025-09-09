// import 'package:flutter/material.dart';
// import '../main.dart';
// import '../models/record.dart';
// import 'home_screen.dart';
// import 'records_list_screen.dart';
// import 'record_form_screen.dart';
// import 'record_details_screen.dart';
// import 'settings_screen.dart';
// import '../widgets/logout_dialog.dart';

// class MainApp extends StatelessWidget {
//   final Screen currentScreen;
//   final AppTab currentTab;
//   final Record? selectedRecord;
//   final Record? editingRecord;
//   final bool showLogoutDialog;
//   final Function(AppTab) onTabChange;
//   final VoidCallback onCreateRecord;
//   final Function(Record) onEditRecord;
//   final Function(Record) onViewRecord;
//   final Function(String) onDeleteRecord;
//   final Function(Record) onSaveRecord;
//   final VoidCallback onCancelForm;
//   final VoidCallback onBackToRecords;
//   final VoidCallback onNavigateToRecords;
//   final VoidCallback onShowLogoutDialog;
//   final VoidCallback onHideLogoutDialog;
//   final VoidCallback onLogout;

//   const MainApp({
//     super.key,
//     required this.currentScreen,
//     required this.currentTab,
//     this.selectedRecord,
//     this.editingRecord,
//     required this.showLogoutDialog,
//     required this.onTabChange,
//     required this.onCreateRecord,
//     required this.onEditRecord,
//     required this.onViewRecord,
//     required this.onDeleteRecord,
//     required this.onSaveRecord,
//     required this.onCancelForm,
//     required this.onBackToRecords,
//     required this.onNavigateToRecords,
//     required this.onShowLogoutDialog,
//     required this.onHideLogoutDialog,
//     required this.onLogout,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Show form screens (full screen)
//     if (currentScreen == Screen.recordForm) {
//       return RecordFormScreen(
//         record: editingRecord,
//         onSave: onSaveRecord,
//         onCancel: onCancelForm,
//       );
//     }

//     // Show details screen (full screen)
//     if (currentScreen == Screen.recordDetails && selectedRecord != null) {
//       return RecordDetailsScreen(
//         record: selectedRecord!,
//         onBack: onBackToRecords,
//         onEdit: onEditRecord,
//         onDelete: onDeleteRecord,
//       );
//     }

//     // Show main app with bottom navigation
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_getScreenTitle()),
//       ),
//       body: Stack(
//         children: [
//           _renderCurrentScreen(),
//           if (showLogoutDialog)
//             LogoutDialog(
//               isOpen: showLogoutDialog,
//               onConfirm: onLogout,
//               onCancel: onHideLogoutDialog,
//             ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _getCurrentTabIndex(),
//         onTap: (index) => onTabChange(_getTabFromIndex(index)),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_outlined),
//             activeIcon: Icon(Icons.list),
//             label: 'Records',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings_outlined),
//             activeIcon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//       floatingActionButton: currentTab == AppTab.records
//           ? FloatingActionButton(
//               onPressed: onCreateRecord,
//               child: const Icon(Icons.add),
//             )
//           : null,
//     );
//   }

//   Widget _renderCurrentScreen() {
//     switch (currentScreen) {
//       case Screen.home:
//         return HomeScreen(
//           onNavigateToRecords: onNavigateToRecords,
//           onCreateRecord: onCreateRecord,
//         );

//       case Screen.records:
//         return RecordsListScreen(
//           onEditRecord: onEditRecord,
//           onDeleteRecord: onDeleteRecord,
//           onViewRecord: onViewRecord,
//         );

//       case Screen.settings:
//         return SettingsScreen(
//           onLogout: onShowLogoutDialog,
//         );

//       default:
//         return HomeScreen(
//           onNavigateToRecords: onNavigateToRecords,
//           onCreateRecord: onCreateRecord,
//         );
//     }
//   }

//   String _getScreenTitle() {
//     switch (currentTab) {
//       case AppTab.home:
//         return 'My App';
//       case AppTab.records:
//         return 'Records';
//       case AppTab.settings:
//         return 'Settings';
//     }
//   }

//   int _getCurrentTabIndex() {
//     switch (currentTab) {
//       case AppTab.home:
//         return 0;
//       case AppTab.records:
//         return 1;
//       case AppTab.settings:
//         return 2;
//     }
//   }

//   AppTab _getTabFromIndex(int index) {
//     switch (index) {
//       case 0:
//         return AppTab.home;
//       case 1:
//         return AppTab.records;
//       case 2:
//         return AppTab.settings;
//       default:
//         return AppTab.home;
//     }
//   }
// }





import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/app_controller.dart';
import 'home_screen.dart';
import 'records_list_screen.dart';
import 'record_form_screen.dart';
import 'record_details_screen.dart';
import 'settings_screen.dart';
import '../widgets/logout_dialog.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppController>();

    return Obx(() {
      final screen = controller.currentScreen.value;
      final tab = controller.currentTab.value;

      // Form screen
      if (screen == Screen.recordForm) {
        return RecordFormScreen(
          record: controller.editingRecord.value,
          onSave: controller.saveRecord,
          onCancel: controller.cancelForm,
        );
      }

      // Details screen
      if (screen == Screen.recordDetails && controller.selectedRecord.value != null) {
        return RecordDetailsScreen(
          record: controller.selectedRecord.value!,
          onBack: controller.backToRecords,
          onEdit: controller.editRecord,
          onDelete: controller.deleteRecord,
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(tab)),
        ),
        body: Stack(
          children: [
            _renderScreen(controller),
            if (controller.showLogoutDialog.value)
              LogoutDialog(
                isOpen: controller.showLogoutDialog.value,
                onConfirm: controller.handleLogout,
                onCancel: () => controller.showLogoutDialog.value = false,
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _getTabIndex(tab),
          onTap: (i) => controller.changeTab(_getTabFromIndex(i)),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label:'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label:'Records'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label:'Settings'),
          ],
        ),
        floatingActionButton: tab == AppTab.records
            ? FloatingActionButton(
                onPressed: controller.createRecord,
                child: const Icon(Icons.add),
              )
            : null,
      );
    });
  }

  Widget _renderScreen(AppController c) {
    switch (c.currentScreen.value) {
      case Screen.home:
        return HomeScreen(
          onNavigateToRecords: c.backToRecords,
          onCreateRecord: c.createRecord,
        );
      case Screen.records:
        return RecordsListScreen(
          onEditRecord: c.editRecord,
          onDeleteRecord: c.deleteRecord,
          onViewRecord: c.viewRecord,
        );
      case Screen.settings:
        return SettingsScreen(
          onLogout: () => c.showLogoutDialog.value = true,
        );
      default:
        return const Center(child: Text("Unknown screen"));
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
