import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://uublfhhyfmksxpuofyvs.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV1YmxmaGh5Zm1rc3hwdW9meXZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzNzI1OTQsImV4cCI6MjA0ODk0ODU5NH0.MwpNYMeonQSakszp3b_4dPaTlkWbDvKURZzmh71OwmY',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
