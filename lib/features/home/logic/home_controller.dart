import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/record/screen/record_form_screen.dart';

// State Model
class HomeState {
  final int totalRecords;
  final String lastUpdate;

  HomeState({required this.totalRecords, required this.lastUpdate});

  HomeState copyWith({int? totalRecords, String? lastUpdate}) {
    return HomeState(
      totalRecords: totalRecords ?? this.totalRecords,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

// StateNotifier for Home
class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(HomeState(totalRecords: 10, lastUpdate: "2h"));

static  void onCreateRecord(BuildContext context) {
    context.push(RecordFormScreen.routeName,);
  }

 static void onNavigateToRecords() {
    print("Navigate to Records");
  }
}

// Provider
final homeProvider =
StateNotifierProvider<HomeController, HomeState>((ref) => HomeController());