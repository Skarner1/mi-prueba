import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Ajusta el nombre del paquete si en tu pubspec.yaml el `name:` no es "eje".
// Si el package name es distinto reemplaza 'eje' por ese nombre en los imports.
import 'package:eje/features/hiring_tests/state/hiring_controller.dart';
import 'package:eje/features/hiring_tests/data/hiring_api.dart';
import 'package:eje/features/hiring_tests/data/hiring_item.dart';

// Mock de la API
class MockHiringApi extends Mock implements HiringApi {}

void main() {
  late MockHiringApi mockApi;
  late HiringController controller;

  setUp(() {
    mockApi = MockHiringApi();
    controller = HiringController(mockApi, cedula: '1000320178');
  });

  test('create should call api.createItem and reload items', () async {
    final created = HiringItem(id: 100, marca: 'M', sucursal: 'S', aspirante: 'A', cedula: '1000320178');

    when(() => mockApi.createItem(
      marca: any(named: 'marca'),
      sucursal: any(named: 'sucursal'),
      aspirante: any(named: 'aspirante'),
      cedula: any(named: 'cedula'),
    )).thenAnswer((_) async => created);

    when(() => mockApi.fetchItems(cedula: any(named: 'cedula'))).thenAnswer((_) async => [created]);

    final result = await controller.create('M', 'S', 'A');

    expect(result.id, created.id);
    expect(controller.items, isNotNull);
    expect(controller.items!.length, 1);
    expect(controller.items!.first.id, created.id);
    expect(controller.lastMessage, 'Creado correctamente');
  });

  test('remove should call deleteItem and update items when server deletes', () async {
    final item = HiringItem(id: 200, marca: 'X', sucursal: 'Y', aspirante: 'Z', cedula: '1000320178');

    // initial fetch returns the item
    when(() => mockApi.fetchItems(cedula: any(named: 'cedula'))).thenAnswer((_) async => [item]);

    // populate controller items
    await controller.load();
    expect(controller.items?.length, 1);

    // deleteItem succeeds
    when(() => mockApi.deleteItem(200, cedula: any(named: 'cedula'), bodyFields: any(named: 'bodyFields'))).thenAnswer((_) async {});

    // after deletion, fetchItems returns empty list
    when(() => mockApi.fetchItems(cedula: any(named: 'cedula'))).thenAnswer((_) async => []);

    await controller.remove(200);

    expect(controller.items, isNotNull);
    expect(controller.items!.isEmpty, true);
    expect(controller.lastMessage, 'Eliminado correctamente');
  });
}