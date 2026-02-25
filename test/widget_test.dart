import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Ajusta el import al package name de tu proyecto si no es 'eje'
import 'package:eje/main.dart' show MyApp;
import 'package:eje/features/hiring_tests/data/hiring_item.dart';
import 'package:eje/features/hiring_tests/data/hiring_api.dart';

/// Fake simple de HiringApi para pruebas de widget.
/// Implementa los miembros requeridos por la interfaz HiringApi.
class FakeHiringApi implements HiringApi {
  // Implementamos el campo 'dio' que la interfaz requiere.
  @override
  final Dio dio = Dio();

  // Implementación de métodos usados por el controller/app.
  // Asegúrate que estos nombres y parámetros coincidan exactamente con tu HiringApi.
  @override
  Future<HiringItem> createItem({
    required String marca,
    required String sucursal,
    required String aspirante,
    required String cedula,
  }) async {
    return HiringItem(id: 1, marca: marca, sucursal: sucursal, aspirante: aspirante, cedula: cedula);
  }

  @override
  Future<void> deleteItem(int id, {required String cedula, Map<String, dynamic>? bodyFields}) async {
    return;
  }

  @override
  Future<List<HiringItem>> fetchItems({required String cedula}) async {
    return <HiringItem>[];
  }

  @override
  Future<HiringItem> updateItem(
      int id, {
        required String marca,
        required String sucursal,
        required String aspirante,
        required String cedula,
      }) async {
    return HiringItem(id: id, marca: marca, sucursal: sucursal, aspirante: aspirante, cedula: cedula);
  }

// Si HiringApi tiene más métodos/miembros, impleméntalos aquí con no-op
// o devolviendo datos dummy. Si aparece otro error de miembro faltante,
// pega la interfaz hiring_api.dart y lo adapto.
}

void main() {
  testWidgets('App loads without crashing (widget test)', (WidgetTester tester) async {
    final fakeApi = FakeHiringApi();

    await tester.pumpWidget(MyApp(api: fakeApi));

    await tester.pumpAndSettle();

    // Ajusta la comprobación a lo que renderiza tu splash estático.
    expect(find.textContaining('AUTOS DE LUJO', findRichText: false), findsWidgets);
  });
}