// Test file untuk aplikasi BisaBasa
// Berisi basic widget test untuk memastikan aplikasi dapat dijalankan

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bisabasa/main.dart';

void main() {
  testWidgets('BisaBasa app smoke test', (WidgetTester tester) async {
    // Build aplikasi dan trigger frame
    await tester.pumpWidget(const BisaBasaApp());

    // Verify bahwa aplikasi dapat dijalankan tanpa error
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Tunggu sampai semua animasi selesai
    await tester.pumpAndSettle();
    
    // Verify bahwa login page muncul (karena user belum login)
    expect(find.text('Masuk ke BisaBasa'), findsOneWidget);
  });
}
