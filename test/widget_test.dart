import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:navigasi_argumen/main.dart';

void main() {
  final game = {
    'title': 'Test Game',
    'thumbnail': 'https://example.com/thumbnail.jpg',
    'short_description': 'Ringkasan game',
    'description': 'Deskripsi lengkap game.',
    'genre': 'Action',
    'platform': 'PC (Windows)',
    'publisher': 'Test Publisher',
    'release_date': '2024-01-01',
    'screenshots': [
      {'image': 'https://example.com/cover.jpg'},
    ],
  };

  testWidgets('loads a game and passes its details through the named route', (
    WidgetTester tester,
  ) async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/game');
      expect(request.url.queryParameters['id'], '475');
      return http.Response(jsonEncode(game), 200);
    });

    await tester.pumpWidget(MyApp(client: client));
    await tester.pumpAndSettle();

    expect(find.text('Test Game'), findsOneWidget);
    expect(find.text('Genre: Action'), findsOneWidget);
    expect(find.text('Platform: PC (Windows)'), findsOneWidget);

    await tester.tap(find.text('Ketuk kartu untuk melihat detail'));
    await tester.pumpAndSettle();

    expect(find.text('Test Game'), findsOneWidget);
    expect(find.text('Ringkasan game'), findsOneWidget);
    expect(find.text('Deskripsi lengkap game.'), findsOneWidget);

    await tester.tap(find.text('Kembali ke game'));
    await tester.pumpAndSettle();
    expect(find.text('Genre: Action'), findsOneWidget);

    client.close();
  });

  testWidgets('shows an API error and retries the request', (
    WidgetTester tester,
  ) async {
    var requestCount = 0;
    final client = MockClient((request) async {
      requestCount++;
      if (requestCount == 1) {
        return http.Response('Unavailable', 503);
      }
      return http.Response(jsonEncode(game), 200);
    });

    await tester.pumpWidget(MyApp(client: client));
    await tester.pumpAndSettle();

    expect(find.textContaining('HTTP 503'), findsOneWidget);

    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();

    expect(requestCount, 2);
    expect(find.text('Test Game'), findsOneWidget);
    client.close();
  });
}
