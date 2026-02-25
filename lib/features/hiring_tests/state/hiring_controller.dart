// lib/features/hiring_tests/state/hiring_controller.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../data/hiring_api.dart';
import '../data/hiring_item.dart';

class HiringController extends ChangeNotifier {
  final HiringApi api;
  final String cedula;

  HiringController(this.api, {required this.cedula});

  List<HiringItem>? items;
  bool loading = false;
  String? error;

  /// Mensaje informativo de la última operación (útil para mostrar en SnackBar).
  String? lastMessage;

  Future<void> load() async {
    loading = true;
    error = null;
    lastMessage = null;
    notifyListeners();
    try {
      final result = await api.fetchItems(cedula: cedula);
      items = result;
    } on DioError catch (e) {
      error = 'Error de red: ${e.response?.statusCode} ${e.message}';
      items = [];
      lastMessage = error;
    } catch (e) {
      error = e.toString();
      items = [];
      lastMessage = error;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<HiringItem> create(String marca, String sucursal, String aspirante) async {
    try {
      final created = await api.createItem(
        marca: marca,
        sucursal: sucursal,
        aspirante: aspirante,
        cedula: cedula,
      );
      await load();
      lastMessage = 'Creado correctamente';
      notifyListeners();
      return created;
    } catch (e) {
      lastMessage = 'Error al crear: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<HiringItem> update(int id, String marca, String sucursal, String aspirante) async {
    try {
      final updated = await api.updateItem(
        id,
        marca: marca,
        sucursal: sucursal,
        aspirante: aspirante,
        cedula: cedula,
      );
      await load();
      lastMessage = 'Actualizado correctamente';
      notifyListeners();
      return updated;
    } catch (e) {
      lastMessage = 'Error al actualizar: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Remove optimista: eliminamos localmente primero para buena UX, luego
  /// intentamos borrar en servidor. Si el servidor no aplica el borrado,
  /// dejamos un mensaje informativo.
  Future<void> remove(int id) async {
    // Guardamos el item por si necesitamos restaurarlo
    HiringItem? removedItem;
    try {
      if (items != null) {
        try {
          removedItem = items!.firstWhere((it) => it.id == id);
        } catch (_) {
          removedItem = null;
        }
      }

      // Eliminación optimista: quitar de la lista local y notificar UI
      items = items?.where((it) => it.id != id).toList();
      notifyListeners();

      // Preparamos campos si los necesitamos para override
      Map<String, dynamic>? bodyFields;
      if (removedItem != null) bodyFields = removedItem.toJson();

      // Intento de eliminar en servidor (deleteItem aplica fallbacks y usa cedula)
      await api.deleteItem(id, cedula: cedula, bodyFields: bodyFields);

      // Forzamos recarga desde servidor para sincronizar estado
      await load();

      // Si tras recarga el item sigue existiendo en servidor, avisamos y mantenemos la eliminación local
      final stillExists = items?.any((it) => it.id == id) ?? false;
      if (stillExists) {
        lastMessage =
        'Intento de borrar en servidor completado, pero el registro sigue existiendo en el backend. Eliminado localmente para la UI. Contacta al backend para confirmar el endpoint de borrado.';
        notifyListeners();
        throw Exception(lastMessage);
      }

      // Si ya no existe, todo OK
      lastMessage = 'Eliminado correctamente';
      notifyListeners();
      return;
    } on DioError catch (dioErr) {
      final status = dioErr.response?.statusCode;
      final body = dioErr.response?.data;
      // Si servidor no acepta DELETE (405) aplicamos fallback local (ya se eliminó localmente)
      if (status == 405) {
        lastMessage = 'El servidor no permite DELETE (405). Eliminado localmente.';
        notifyListeners();
        throw Exception(lastMessage);
      }
      // En caso de otros errores, re-intentar recargar la lista
      try {
        await load();
      } catch (_) {}
      lastMessage = 'Error al eliminar en servidor: ${status ?? ''} ${body ?? dioErr.message}';
      notifyListeners();
      throw Exception(lastMessage);
    } catch (e) {
      // Fallback: ya eliminamos localmente; dejamos el mensaje
      lastMessage = 'Error inesperado al eliminar; eliminado localmente: $e';
      notifyListeners();
      rethrow;
    }
  }
}