import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  HomeController() : super(HomeState(totalRecords: 12, lastUpdate: "2h"));

  void onCreateRecord() {
    print("Navigate to Create Record");
  }

  void onNavigateToRecords() {
    print("Navigate to Records");
  }
}

// Provider
final homeProvider =
StateNotifierProvider<HomeController, HomeState>((ref) => HomeController());