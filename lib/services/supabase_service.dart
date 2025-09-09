// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../models/record.dart';

// /// Supabase Service for database operations
// /// 
// /// SETUP INSTRUCTIONS:
// /// 1. Add supabase_flutter to your pubspec.yaml:
// ///    dependencies:
// ///      supabase_flutter: ^2.3.4
// /// 
// /// 2. Replace SUPABASE_URL with your project URL
// /// 3. Replace SUPABASE_ANON_KEY with your anon/public key
// /// 4. Create the 'records' table in your Supabase database
// /// 5. Set up Row Level Security (RLS) policies
// /// 
// /// DATABASE SCHEMA:
// /// Create this table in your Supabase SQL editor:
// /// 
// /// CREATE TABLE records (
// ///   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
// ///   title TEXT NOT NULL,
// ///   details TEXT NOT NULL,
// ///   status TEXT NOT NULL CHECK (status IN ('active', 'pending', 'archived')),
// ///   value DECIMAL(10,2) NOT NULL DEFAULT 0,
// ///   user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
// ///   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
// ///   updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
// /// );
// /// 
// /// -- Enable RLS
// /// ALTER TABLE records ENABLE ROW LEVEL SECURITY;
// /// 
// /// -- Policy to allow users to see only their own records
// /// CREATE POLICY "Users can view own records" ON records
// ///   FOR SELECT USING (auth.uid() = user_id);
// /// 
// /// -- Policy to allow users to insert their own records
// /// CREATE POLICY "Users can insert own records" ON records
// ///   FOR INSERT WITH CHECK (auth.uid() = user_id);
// /// 
// /// -- Policy to allow users to update their own records
// /// CREATE POLICY "Users can update own records" ON records
// ///   FOR UPDATE USING (auth.uid() = user_id);
// /// 
// /// -- Policy to allow users to delete their own records
// /// CREATE POLICY "Users can delete own records" ON records
// ///   FOR DELETE USING (auth.uid() = user_id);
// class SupabaseService {
//   // Your Supabase project URL
//   static const String SUPABASE_URL = 'https://fviknrqqekcgqwzmksrq.supabase.co';
  
//   // Your Supabase anon key
//   static const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2aWtucnFxZWtjZ3F3em1rc3JxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzODU1ODIsImV4cCI6MjA3MTk2MTU4Mn0.9jc7NKCg8m7l_wFC54nakXiGhfJPSGq-Ts2w33Ko2MY';
  
//   static SupabaseClient? _client;
  
//   // Google Sign-In instance
//   static final GoogleSignIn _googleSignIn = GoogleSignIn(
//     // Add your Google OAuth client ID here (from Firebase Console)
//     // For development, you can leave this empty and it will use the default
//     // scopes: ['email', 'profile'],
//     serverClientId: 'YOUR_GOOGLE_OAUTH_CLIENT_ID', // Replace with your client ID
//   );
  
//   /// Initialize Supabase client
//   /// Call this in your main() function before runApp()
//   static Future<void> initialize() async {
//     try {
//       await Supabase.initialize(
//         url: SUPABASE_URL,
//         anonKey: SUPABASE_ANON_KEY,
//         debug: true, // Set to false in production
//       );
//       _client = Supabase.instance.client;
//       print('Supabase initialized successfully');
//     } catch (e) {
//       // PLACEHOLDER: For development, continue without Supabase
//       print('Supabase initialization failed: $e');
//       print('Using mock data for development');
//     }
//   }
  
//   /// Get Supabase client instance
//   static SupabaseClient get client {
//     if (_client == null) {
//       throw Exception('Supabase not initialized. Call SupabaseService.initialize() first.');
//     }
//     return _client!;
//   }
  
//   /// Check if Supabase is properly configured
//   static bool get isConfigured {
//     return _client != null && 
//            SUPABASE_URL != 'https://your-project-id.supabase.co' &&
//            SUPABASE_ANON_KEY != 'your-anon-key-here';
//   }
  
//   // AUTHENTICATION METHODS
  
//   /// Check if user is currently signed in
//   static bool get isSignedIn {
//     try {
//       if (!isConfigured) return false;
//       return client.auth.currentUser != null;
//     } catch (e) {
//       return false;
//     }
//   }
  
//   /// Get current user
//   static User? get currentUser {
//     try {
//       if (!isConfigured) return null;
//       return client.auth.currentUser;
//     } catch (e) {
//       return null;
//     }
//   }
  
//   /// Reset password - sends reset email
//   static Future<void> resetPassword(String email) async {
//     if (!isConfigured) {
//       throw AuthException('Supabase not configured.');
//     }
    
//     try {
//       await client.auth.resetPasswordForEmail(email);
//     } catch (e) {
//       throw AuthException('Password reset failed: $e');
//     }
//   }
  
//   /// Sign up with email and password
//   static Future<AuthResponse> signUp(String email, String password, {String? name}) async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Return mock response for development
//       await Future.delayed(Duration(milliseconds: 1000));
//       throw AuthException('Supabase not configured. Please add your credentials.');
//     }
    
//     try {
//       print('Attempting Supabase sign up for: $email');
      
//       final response = await client.auth.signUp(
//         email: email,
//         password: password,
//         data: name != null ? {'name': name} : null,
//       );
      
//       print('Sign up response: ${response.user?.email}');
//       print('User ID: ${response.user?.id}');
//       print('Email confirmed: ${response.user?.emailConfirmedAt != null}');
      
//       if (response.user == null) {
//         throw AuthException('Registration failed. Please try again.');
//       }
      
//       return response;
//     } catch (e) {
//       print('Supabase sign up error: $e');
      
//       // Handle specific Supabase errors
//       if (e is AuthException) {
//         throw e;
//       }
      
//       String errorMessage = e.toString().toLowerCase();
//       if (errorMessage.contains('email_address_invalid') || 
//           errorMessage.contains('invalid email')) {
//         throw AuthException('ইমেইল ঠিকানা সঠিক নয়। অন্য ইমেইল দিয়ে চেষ্টা করুন।');
//       } else if (errorMessage.contains('weak_password') || 
//                  errorMessage.contains('password')) {
//         throw AuthException('পাসওয়ার্ড খুবই দুর্বল। কমপক্ষে ৮ অক্ষর ব্যবহার করুন।');
//       } else if (errorMessage.contains('already_registered') || 
//                  errorMessage.contains('already exists') ||
//                  errorMessage.contains('user_already_exists')) {
//         throw AuthException('এই ইমেইল দিয়ে আগেই একাউন্ট তৈর��� হয়েছে। Login করুন।');
//       } else if (errorMessage.contains('signup_disabled') || 
//                  errorMessage.contains('signups not allowed')) {
//         throw AuthException('নতুন একাউন্ট তৈরি করা এখন বন্ধ আছে।');
//       }
      
//       throw AuthException('Registration failed: $errorMessage');
//     }
//   }
  
//   /// Sign in with email and password
//   static Future<AuthResponse> signIn(String email, String password) async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Return mock response for development
//       await Future.delayed(Duration(milliseconds: 1000));
//       throw AuthException('Supabase not configured. Please add your credentials.');
//     }
    
//     try {
//       print('Attempting Supabase sign in for: $email');
      
//       final response = await client.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
      
//       if (response.user == null) {
//         throw AuthException('Login failed. Please check your email and password.');
//       }
      
//       print('Sign in successful: ${response.user!.email}');
//       print('User ID: ${response.user!.id}');
//       print('Email confirmed: ${response.user!.emailConfirmedAt != null}');
      
//       // Allow login even if email is not confirmed (for development)
//       return response;
      
//     } catch (e) {
//       print('Supabase sign in error: $e');
      
//       // Handle specific Supabase errors
//       if (e is AuthException) {
//         throw e;
//       }
      
//       String errorMessage = e.toString().toLowerCase();
//       if (errorMessage.contains('invalid login credentials') || 
//           errorMessage.contains('invalid_credentials')) {
//         throw AuthException('আপনার ইমেইল বা পাসওয়ার্ড ভুল। অনুগ্রহ করে আবার চেষ্টা করুন।');
//       } else if (errorMessage.contains('email not confirmed') || 
//                  errorMessage.contains('email_not_confirmed')) {
//         // For development, we'll allow unconfirmed emails to sign in
//         // In production, you should handle email confirmation properly
//         throw AuthException('আপনার ইমেইল এখনো confirm করা হয়নি। Supabase settings এ email confirmation disable করুন।');
//       } else if (errorMessage.contains('too many requests')) {
//         throw AuthException('অনেক বার চেষ্টা করেছেন। কিছুক্ষণ অপেক্ষা করে আবার চেষ্টা করুন।');
//       }
      
//       throw AuthException('Login failed: $errorMessage');
//     }
//   }
  
//   /// Sign out current user
//   static Future<void> signOut() async {
//     try {
//       if (isConfigured) {
//         await client.auth.signOut();
//       }
      
//       // Also sign out from Google if user was signed in with Google
//       final GoogleSignInAccount? currentGoogleUser = _googleSignIn.currentUser;
//       if (currentGoogleUser != null) {
//         await _googleSignIn.signOut();
//       }
//     } catch (e) {
//       throw AuthException('Sign out failed: $e');
//     }
//   }
  
//   /// Get current user
//   static User? get currentUser {
//     if (!isConfigured) return null;
//     return client.auth.currentUser;
//   }
  
//   /// Check if user is signed in
//   static bool get isSignedIn {
//     return currentUser != null;
//   }
  
//   /// Sign in with Google
//   static Future<AuthResponse> signInWithGoogle() async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Return mock response for development
//       await Future.delayed(Duration(milliseconds: 1500));
//       throw AuthException('Supabase not configured. Please add your credentials.');
//     }
    
//     try {
//       // Trigger Google Sign-In flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
//       if (googleUser == null) {
//         throw AuthException('Google sign-in was cancelled');
//       }
      
//       // Obtain Google authentication credentials
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
//       final accessToken = googleAuth.accessToken;
//       final idToken = googleAuth.idToken;
      
//       if (accessToken == null) {
//         throw AuthException('Failed to get Google access token');
//       }
      
//       if (idToken == null) {
//         throw AuthException('Failed to get Google ID token');
//       }
      
//       // Sign in to Supabase using Google credentials
//       final response = await client.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );
      
//       return response;
//     } catch (e) {
//       // Sign out from Google if Supabase authentication fails
//       await _googleSignIn.signOut();
      
//       if (e is AuthException) {
//         rethrow;
//       }
      
//       throw AuthException('Google sign-in failed: $e');
//     }
//   }
  
//   /// Sign out and disconnect Google account
//   static Future<void> signOutWithGoogle() async {
//     try {
//       // Sign out from Supabase
//       if (isConfigured) {
//         await client.auth.signOut();
//       }
      
//       // Sign out from Google
//       await _googleSignIn.signOut();
//       await _googleSignIn.disconnect();
//     } catch (e) {
//       // Continue with sign out even if there are errors
//       print('Error during Google sign-out: $e');
//     }
//   }
  
//   // RECORD CRUD OPERATIONS
  
//   /// Get all records for current user
//   static Future<List<Record>> getRecords({
//     String? search,
//     RecordStatus? status,
//   }) async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Return mock data for development
//       await Future.delayed(Duration(milliseconds: 500));
//       List<Record> mockRecords = Record.getSampleRecords();
      
//       // Apply mock filtering
//       if (search != null && search.isNotEmpty) {
//         mockRecords = mockRecords.where((record) =>
//           record.title.toLowerCase().contains(search.toLowerCase()) ||
//           record.details.toLowerCase().contains(search.toLowerCase())
//         ).toList();
//       }
      
//       if (status != null) {
//         mockRecords = mockRecords.where((record) => record.status == status).toList();
//       }
      
//       return mockRecords;
//     }
    
//     try {
//       // Get all records for user first
//       final data = await client
//           .from('learning_records')  // Make sure this matches your table name
//           .select()
//           .eq('user_id', currentUser!.id)
//           .order('updated_at', ascending: false);
      
//       // Convert to Record objects
//       var records = data.map<Record>((json) => Record.fromJson(json)).toList();
      
//       // Apply search filter in Dart if provided
//       if (search != null && search.isNotEmpty) {
//         records = records.where((record) =>
//           record.title.toLowerCase().contains(search.toLowerCase()) ||
//           record.details.toLowerCase().contains(search.toLowerCase())
//         ).toList();
//       }
      
//       // Apply status filter in Dart if provided
//       if (status != null) {
//         records = records.where((record) => record.status == status).toList();
//       }
      
//       return records;
//     } catch (e) {
//       throw DatabaseException('Failed to fetch records: $e');
//     }
//   }
  
//   /// Get single record by ID
//   static Future<Record?> getRecord(String id) async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Return mock data
//       await Future.delayed(Duration(milliseconds: 300));
//       final mockRecords = Record.getSampleRecords();
//       return mockRecords.firstWhere(
//         (record) => record.id == id,
//         orElse: () => mockRecords.first,
//       );
//     }
    
//     try {
//       final data = await client
//         .from('learning_records')  // Make sure this matches your table name
//         .select()
//         .eq('id', id)
//         .eq('user_id', currentUser!.id)
//         .single();
      
//       return Record.fromJson(data);
//     } catch (e) {
//       if (e.toString().contains('No rows found')) {
//         return null;
//       }
//       throw DatabaseException('Failed to fetch record: $e');
//     }
//   }
  
//   /// Create new record
//   static Future<Record> createRecord(Record record) async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Simulate creation
//       await Future.delayed(Duration(milliseconds: 800));
//       return Record(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: record.title,
//         details: record.details,
//         status: record.status,
//         value: record.value,
//         updatedAt: DateTime.now(),
//       );
//     }
    
//     // Check if user is authenticated
//     final user = currentUser;
//     if (user == null) {
//       throw DatabaseException('User not authenticated. Please sign in again.');
//     }
    
//     if (user.id.isEmpty) {
//       throw DatabaseException('Invalid user ID. Please sign in again.');
//     }
    
//     // Validate record data
//     if (record.title.trim().isEmpty) {
//       throw DatabaseException('Record title cannot be empty');
//     }
    
//     if (record.details.trim().isEmpty) {
//       throw DatabaseException('Record details cannot be empty');
//     }
    
//     print('Creating record for user: ${user.id}');
//     print('Record data: ${record.toJson()}');
    
//     try {
//       final insertData = {
//         'title': record.title.trim(),
//         'details': record.details.trim(),
//         'status': record.status.toString().split('.').last,
//         'value': record.value,
//         'user_id': user.id,
//       };
      
//       print('Insert data: $insertData');
      
//       final data = await client
//         .from('learning_records')  // Make sure this matches your table name
//         .insert(insertData)
//         .select()
//         .single();
      
//       print('Record created successfully: $data');
//       return Record.fromJson(data);
//     } catch (e) {
//       print('Error creating record: $e');
//       throw DatabaseException('Failed to create record: $e');
//     }
//   }
  
//   /// Update existing record
//   static Future<Record> updateRecord(Record record) async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Simulate update
//       await Future.delayed(Duration(milliseconds: 800));
//       return record.copyWith(updatedAt: DateTime.now());
//     }
    
//     try {
//       final data = await client
//         .from('learning_records')  // Make sure this matches your table name
//         .update({
//           'title': record.title,
//           'details': record.details,
//           'status': record.status.toString().split('.').last,
//           'value': record.value,
//           'updated_at': DateTime.now().toIso8601String(),
//         })
//         .eq('id', record.id)
//         .eq('user_id', currentUser!.id)
//         .select()
//         .single();
      
//       return Record.fromJson(data);
//     } catch (e) {
//       throw DatabaseException('Failed to update record: $e');
//     }
//   }
  
//   /// Delete record
//   static Future<void> deleteRecord(String id) async {
//     if (!isConfigured) {
//       // PLACEHOLDER: Simulate deletion
//       await Future.delayed(Duration(milliseconds: 500));
//       print('Mock: Record $id deleted successfully');
//       return;
//     }
    
//     try {
//       await client
//         .from('learning_records')  // Make sure this matches your table name
//         .delete()
//         .eq('id', id)
//         .eq('user_id', currentUser!.id);
//     } catch (e) {
//       throw DatabaseException('Failed to delete record: $e');
//     }
//   }
  
//   /// Listen to record changes (real-time updates)
//   static Stream<List<Record>> watchRecords() {
//     if (!isConfigured) {
//       // PLACEHOLDER: Return empty stream
//       return Stream.empty();
//     }
    
//     return client
//       .from('learning_records')  // Make sure this matches your table name
//       .stream(primaryKey: ['id'])
//       .eq('user_id', currentUser!.id)
//       .order('updated_at', ascending: false)
//       .map((data) => data.map<Record>((json) => Record.fromJson(json)).toList());
//   }
// }

// /// Custom exceptions for Supabase operations
// class AuthException implements Exception {
//   final String message;
  
//   const AuthException(this.message);
  
//   @override
//   String toString() => 'AuthException: $message';
// }

// class DatabaseException implements Exception {
//   final String message;
  
//   const DatabaseException(this.message);
  
//   @override
//   String toString() => 'DatabaseException: $message';
// }






/////
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/record.dart';

class SupabaseService {
  static const String SUPABASE_URL = 'https://fviknrqqekcgqwzmksrq.supabase.co';
  static const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2aWtucnFxZWtjZ3F3em1rc3JxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzODU1ODIsImV4cCI6MjA3MTk2MTU4Mn0.9jc7NKCg8m7l_wFC54nakXiGhfJPSGq-Ts2w33Ko2MY';

  static SupabaseClient? _client;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: 'YOUR_GOOGLE_OAUTH_CLIENT_ID',
  );

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_ANON_KEY,
      debug: true,
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client => _client!;

  static User? get currentUser => client.auth.currentUser;
  static bool get isSignedIn => currentUser != null;

  // ----------------------
  // AUTH
  // ----------------------

  static Future<AuthResponse> signUp(String email, String password, {String? name}) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: name != null ? {'name': name} : null,
    );
    return response;
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
    }
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  static Future<AuthResponse> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null) throw Exception('No Google ID token');

    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }




  // ----------------------
  // RECORD CRUD (demo)
  // ----------------------
static Future<Record> createRecord(Record record) async {
  final data = await client
      .from('records')
      .insert({
        'title': record.title,
        'details': record.details,
        'status': record.status.toString().split('.').last,
        'value': record.value,
        'user_id': currentUser!.id,
      })
      .select()
      .single();

  return Record.fromJson(data);
}

static Future<Record> updateRecord(Record record) async {
  final data = await client
      .from('records')
      .update({
        'title': record.title,
        'details': record.details,
        'status': record.status.toString().split('.').last,
        'value': record.value,
        'updated_at': DateTime.now().toIso8601String(),
      })
      .eq('id', record.id)
      .eq('user_id', currentUser!.id)
      .select()
      .single();

  return Record.fromJson(data);
}







  static Future<List<Record>> getRecords() async {
    final data = await client
        .from('records')
        .select()
        .eq('user_id', currentUser!.id)
        .order('updated_at', ascending: false);

    return data.map<Record>((json) => Record.fromJson(json)).toList();
  }




  static Future<void> deleteRecord(String id) async {
  if (currentUser == null) {
    throw Exception("User not logged in");
  }

  try {
    await client
        .from('records')
        .delete()
        .eq('id', id)
        .eq('user_id', currentUser!.id);
  } catch (e) {
    throw Exception("Delete failed: $e");
  }
}

}


