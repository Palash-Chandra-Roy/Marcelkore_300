// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/record.dart';

// /// API Service for handling all HTTP requests
// /// 
// /// REPLACE THESE PLACEHOLDERS:
// /// 1. Replace BASE_URL with your actual API endpoint
// /// 2. Replace API_KEY with your actual API key
// /// 3. Add proper error handling for your specific API
// /// 4. Update request/response models to match your API
// class ApiService {
//   // PLACEHOLDER: Replace with your actual API base URL
//   static const String BASE_URL = 'https://fviknrqqekcgqwzmksrq.supabase.co';
  
//   // PLACEHOLDER: Replace with your actual API key
//   static const String API_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2aWtucnFxZWtjZ3F3em1rc3JxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzODU1ODIsImV4cCI6MjA3MTk2MTU4Mn0.9jc7NKCg8m7l_wFC54nakXiGhfJPSGq-Ts2w33Ko2MY';
  
//   // PLACEHOLDER: Add your authentication token storage
//   static String? _authToken;
  
//   /// Set authentication token after login
//   static void setAuthToken(String token) {
//     _authToken = token;
//   }
  
//   /// Clear authentication token on logout
//   static void clearAuthToken() {
//     _authToken = null;
//   }
  
//   /// Get default headers for API requests
//   static Map<String, String> get _headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     // PLACEHOLDER: Replace with your API key header name
//     'X-API-Key': API_KEY,
//     if (_authToken != null) 'Authorization': 'Bearer $_authToken',
//   };
  
//   /// Handle API response and extract data
//   static dynamic _handleResponse(http.Response response) {
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return jsonDecode(response.body);
//     } else {
//       // PLACEHOLDER: Customize error handling for your API
//       throw ApiException(
//         statusCode: response.statusCode,
//         message: 'API Error: ${response.statusCode}',
//         details: response.body,
//       );
//     }
//   }
  
//   // AUTHENTICATION METHODS
  
//   /// Login user with email and password
//   /// PLACEHOLDER: Update request/response format to match your API
//   static Future<Map<String, dynamic>> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$BASE_URL/auth/login'),
//         headers: _headers,
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//       );
      
//       final data = _handleResponse(response);
      
//       // PLACEHOLDER: Update to match your API response format
//       if (data['token'] != null) {
//         setAuthToken(data['token']);
//       }
      
//       return data;
//     } catch (e) {
//       // PLACEHOLDER: For now, return mock success response
//       // Remove this in production and handle real API errors
//       await Future.delayed(Duration(milliseconds: 1000)); // Simulate network delay
      
//       // Mock successful login
//       setAuthToken('mock_token_12345');
//       return {
//         'success': true,
//         'token': 'mock_token_12345',
//         'user': {
//           'id': '1',
//           'email': email,
//           'name': 'John Doe',
//         }
//       };
//     }
//   }
  
//   /// Register new user
//   /// PLACEHOLDER: Update request/response format to match your API
//   static Future<Map<String, dynamic>> register(String name, String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$BASE_URL/auth/register'),
//         headers: _headers,
//         body: jsonEncode({
//           'name': name,
//           'email': email,
//           'password': password,
//         }),
//       );
      
//       final data = _handleResponse(response);
      
//       // PLACEHOLDER: Update to match your API response format
//       if (data['token'] != null) {
//         setAuthToken(data['token']);
//       }
      
//       return data;
//     } catch (e) {
//       // PLACEHOLDER: For now, return mock success response
//       // Remove this in production and handle real API errors
//       await Future.delayed(Duration(milliseconds: 1000)); // Simulate network delay
      
//       // Mock successful registration
//       setAuthToken('mock_token_12345');
//       return {
//         'success': true,
//         'token': 'mock_token_12345',
//         'user': {
//           'id': '1',
//           'email': email,
//           'name': name,
//         }
//       };
//     }
//   }
  
//   /// Logout user
//   static Future<void> logout() async {
//     try {
//       await http.post(
//         Uri.parse('$BASE_URL/auth/logout'),
//         headers: _headers,
//       );
//     } catch (e) {
//       // PLACEHOLDER: Handle logout error
//       print('Logout error: $e');
//     } finally {
//       clearAuthToken();
//     }
//   }
  
//   // RECORD CRUD METHODS
  
//   /// Get all records with optional filtering
//   /// PLACEHOLDER: Update URL parameters and response format to match your API
//   static Future<List<Record>> getRecords({
//     String? search,
//     RecordStatus? status,
//     int page = 1,
//     int limit = 20,
//   }) async {
//     try {
//       final queryParams = <String, String>{
//         'page': page.toString(),
//         'limit': limit.toString(),
//         if (search != null && search.isNotEmpty) 'search': search,
//         if (status != null) 'status': status.toString().split('.').last,
//       };
      
//       final uri = Uri.parse('$BASE_URL/records').replace(queryParameters: queryParams);
      
//       final response = await http.get(uri, headers: _headers);
//       final data = _handleResponse(response);
      
//       // PLACEHOLDER: Update to match your API response format
//       final List<dynamic> recordsData = data['records'] ?? data['data'] ?? data;
      
//       return recordsData.map<Record>((json) => Record.fromJson(json)).toList();
//     } catch (e) {
//       // PLACEHOLDER: For now, return mock data
//       // Remove this in production and handle real API errors
//       await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
      
//       // Return mock records for demo purposes
//       List<Record> allRecords = Record.getSampleRecords();
      
//       // Apply mock filtering
//       if (search != null && search.isNotEmpty) {
//         allRecords = allRecords.where((record) =>
//           record.title.toLowerCase().contains(search.toLowerCase()) ||
//           record.details.toLowerCase().contains(search.toLowerCase())
//         ).toList();
//       }
      
//       if (status != null) {
//         allRecords = allRecords.where((record) => record.status == status).toList();
//       }
      
//       return allRecords;
//     }
//   }
  
//   /// Get single record by ID
//   /// PLACEHOLDER: Update URL and response format to match your API
//   static Future<Record> getRecord(String id) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$BASE_URL/records/$id'),
//         headers: _headers,
//       );
      
//       final data = _handleResponse(response);
      
//       // PLACEHOLDER: Update to match your API response format
//       return Record.fromJson(data['record'] ?? data);
//     } catch (e) {
//       // PLACEHOLDER: For now, return mock data
//       await Future.delayed(Duration(milliseconds: 300));
      
//       // Return mock record
//       final mockRecords = Record.getSampleRecords();
//       return mockRecords.firstWhere(
//         (record) => record.id == id,
//         orElse: () => mockRecords.first,
//       );
//     }
//   }
  
//   /// Create new record
//   /// PLACEHOLDER: Update request/response format to match your API
//   static Future<Record> createRecord(Record record) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$BASE_URL/records'),
//         headers: _headers,
//         body: jsonEncode(record.toJson()),
//       );
      
//       final data = _handleResponse(response);
      
//       // PLACEHOLDER: Update to match your API response format
//       return Record.fromJson(data['record'] ?? data);
//     } catch (e) {
//       // PLACEHOLDER: For now, simulate successful creation
//       await Future.delayed(Duration(milliseconds: 800));
      
//       // Return the record with a generated ID
//       return Record(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: record.title,
//         details: record.details,
//         status: record.status,
//         value: record.value,
//         updatedAt: DateTime.now(),
//       );
//     }
//   }
  
//   /// Update existing record
//   /// PLACEHOLDER: Update request/response format to match your API
//   static Future<Record> updateRecord(Record record) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$BASE_URL/records/${record.id}'),
//         headers: _headers,
//         body: jsonEncode(record.toJson()),
//       );
      
//       final data = _handleResponse(response);
      
//       // PLACEHOLDER: Update to match your API response format
//       return Record.fromJson(data['record'] ?? data);
//     } catch (e) {
//       // PLACEHOLDER: For now, simulate successful update
//       await Future.delayed(Duration(milliseconds: 800));
      
//       // Return the updated record
//       return record.copyWith(updatedAt: DateTime.now());
//     }
//   }
  
//   /// Delete record
//   /// PLACEHOLDER: Update URL and response handling to match your API
//   static Future<void> deleteRecord(String id) async {
//     try {
//       final response = await http.delete(
//         Uri.parse('$BASE_URL/records/$id'),
//         headers: _headers,
//       );
      
//       _handleResponse(response);
//     } catch (e) {
//       // PLACEHOLDER: For now, simulate successful deletion
//       await Future.delayed(Duration(milliseconds: 500));
      
//       // In production, handle real deletion errors
//       print('Mock: Record $id deleted successfully');
//     }
//   }
// }

// /// Custom exception for API errors
// class ApiException implements Exception {
//   final int statusCode;
//   final String message;
//   final String? details;
  
//   const ApiException({
//     required this.statusCode,
//     required this.message,
//     this.details,
//   });
  
//   @override
//   String toString() {
//     return 'ApiException: $message (Status: $statusCode)';
//   }
// }

// /// Extension to add copyWith method to Record
// extension RecordExtension on Record {
//   Record copyWith({
//     String? id,
//     String? title,
//     String? details,
//     RecordStatus? status,
//     double? value,
//     DateTime? updatedAt,
//   }) {
//     return Record(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       details: details ?? this.details,
//       status: status ?? this.status,
//       value: value ?? this.value,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }







import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String SUPABASE_URL = 'https://fviknrqqekcgqwzmksrq.supabase.co';
  static const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2aWtucnFxZWtjZ3F3em1rc3JxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzODU1ODIsImV4cCI6MjA3MTk2MTU4Mn0.9jc7NKCg8m7l_wFC54nakXiGhfJPSGq-Ts2w33Ko2MY';

  static SupabaseClient? _client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_ANON_KEY,
      debug: true,
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client => _client!;
}
