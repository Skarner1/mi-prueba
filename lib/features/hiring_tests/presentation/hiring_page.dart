// lib/features/hiring_tests/presentation/hiring_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../state/hiring_controller.dart';
import 'widgets/labeled_icon_field.dart';
import 'widgets/plate_dialog.dart';

class HiringPage extends StatefulWidget {
  static const routeName = '/hiring';
  const HiringPage({super.key});

  @override
  State<HiringPage> createState() => _HiringPageState();
}

class _HiringPageState extends State<HiringPage> {
  final TextEditingController _marcaCtrl = TextEditingController();
  final TextEditingController _sucursalCtrl = TextEditingController();
  final TextEditingController _aspiranteCtrl = TextEditingController();

  int? _editingId;

  @override
  void dispose() {
    _marcaCtrl.dispose();
    _sucursalCtrl.dispose();
    _aspiranteCtrl.dispose();
    super.dispose();
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
  }

  // ... (métodos _openCreateOrEditSheet, _openDeleteConfirm, _showPlateDialog quedan igual que antes)
  // Para evitar repetir todo el código aquí, pega los métodos que ya tenías sin cambios.
  // A continuación continúa el build con la cabecera actualizada.

  Future<void> _openCreateOrEditSheet({dynamic item}) async {
    final controller = context.read<HiringController>();
    if (item != null) {
      _editingId = item.id as int?;
      _marcaCtrl.text = item.marca ?? '';
      _sucursalCtrl.text = item.sucursal ?? '';
      _aspiranteCtrl.text = item.aspirante ?? '';
    } else {
      _editingId = null;
      _marcaCtrl.clear();
      _sucursalCtrl.clear();
      _aspiranteCtrl.clear();
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.46,
          minChildSize: 0.32,
          maxChildSize: 0.9,
          builder: (_, controllerScroll) => Container(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 18,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC6007E), Color(0xFFE280BE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: SingleChildScrollView(
              controller: controllerScroll,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LabeledIconField(label: 'Marca', controller: _marcaCtrl, svgAsset: 'assets/icons/Vector_carro.svg'),
                  const SizedBox(height: 12),
                  LabeledIconField(label: 'Sucursal', controller: _sucursalCtrl, svgAsset: 'assets/icons/Vector_locacion.svg'),
                  const SizedBox(height: 12),
                  LabeledIconField(label: 'Aspirante', controller: _aspiranteCtrl, svgAsset: 'assets/icons/Vector_usuario.svg'),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancelar', style: GoogleFonts.montserrat()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            final marca = _marcaCtrl.text.trim();
                            final sucursal = _sucursalCtrl.text.trim();
                            final aspirante = _aspiranteCtrl.text.trim();
                            if (marca.isEmpty || sucursal.isEmpty || aspirante.isEmpty) {
                              _showToast('Todos los campos son obligatorios');
                              return;
                            }
                            try {
                              if (_editingId != null) {
                                await context.read<HiringController>().update(_editingId!, marca, sucursal, aspirante);
                                _showToast('Actualizado con éxito');
                              } else {
                                await context.read<HiringController>().create(marca, sucursal, aspirante);
                                _showToast('Creado con éxito');
                              }
                              Navigator.of(context).pop();
                            } catch (e) {
                              _showToast('Error: $e');
                            } finally {
                              _editingId = null;
                              _marcaCtrl.clear();
                              _sucursalCtrl.clear();
                              _aspiranteCtrl.clear();
                            }
                          },
                          child: Text(_editingId != null ? 'Guardar' : 'Crear', style: GoogleFonts.montserrat()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openDeleteConfirm(dynamic item) async {
    final controller = context.read<HiringController>();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Eliminar registro?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop(true);
                      } catch (e) {
                        _showToast('Error: $e');
                        Navigator.of(context).pop(false);
                      }
                    },
                    child: const Text('Eliminar'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    if (confirmed == true) {
      try {
        await controller.remove(item.id);
        final msg = controller.lastMessage ?? 'Eliminado';
        _showToast(msg);
      } catch (e) {
        final msg = controller.lastMessage ?? e.toString();
        _showToast(msg);
      }
    }
  }

  Future<void> _showPlateDialog(dynamic item) async {
    final result = await showDialog(
      context: context,
      builder: (_) => PlateDialog(marca: item.marca ?? ''),
    );

    if (result != null && result is Map<String, bool>) {
      final selected = result.entries.where((e) => e.value).map((e) => e.key).toList();
      _showToast(selected.isEmpty ? 'No se seleccionó nada' : 'Seleccionado: ${selected.join(', ')}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HiringController>();
    final items = controller.items ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3F8),
      body: Stack(
        children: [
          Positioned(
            top: -20,
            left: -10,
            right: -10,
            child: Image.asset('assets/images/vector_superior.png', fit: BoxFit.cover, height: 180),
          ),
          Positioned(
            bottom: -20,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/vector_inferior.png', fit: BoxFit.cover, height: 120),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ---- HEADER ACTUALIZADO: logo centrado y acciones agrupadas a la derecha ----
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Botón para abrir modal "crear"
                      IconButton(
                        onPressed: () => _openCreateOrEditSheet(),
                        icon: SvgPicture.asset('assets/icons/Vector_agregar.svg', width: 26, height: 26),
                        tooltip: 'Agregar',
                      ),

                      // Logo centrado (usa Expanded + Center para mantenerlo centrado independientemente del espacio)
                      Expanded(
                        child: Center(
                          child: Image.asset('assets/images/Logotipo_motion.png', height: 30, fit: BoxFit.contain),
                        ),
                      ),

                      // Acciones del lado derecho (agrupadas y más cerca del centro)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Catálogo',
                            onPressed: () => Navigator.of(context).pushNamed('/catalog'),
                            icon: SvgPicture.asset('assets/icons/Vector_carro.svg', width: 26, height: 26),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Perfil',
                            onPressed: () => Navigator.of(context).pushNamed('/profile'),
                            icon: SvgPicture.asset('assets/icons/Vector_usuario.svg', width: 26, height: 26),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            onPressed: () => controller.load(),
                            icon: const Icon(Icons.refresh, color: Color(0xFF9E9E9E)),
                            tooltip: 'Refrescar',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Resto del layout mantiene su estructura anterior
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 620),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0,6))],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        LabeledIconField(label: 'Marca', controller: _marcaCtrl, svgAsset: 'assets/icons/Vector_carro.svg'),
                        const SizedBox(height: 10),
                        LabeledIconField(label: 'Sucursal', controller: _sucursalCtrl, svgAsset: 'assets/icons/Vector_locacion.svg'),
                        const SizedBox(height: 10),
                        LabeledIconField(label: 'Aspirante', controller: _aspiranteCtrl, svgAsset: 'assets/icons/Vector_usuario.svg'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _marcaCtrl.clear(),
                                child: Text('Cancelar', style: GoogleFonts.montserrat()),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () async {
                                  final marca = _marcaCtrl.text.trim();
                                  final sucursal = _sucursalCtrl.text.trim();
                                  final aspirante = _aspiranteCtrl.text.trim();
                                  if (marca.isEmpty || sucursal.isEmpty || aspirante.isEmpty) {
                                    _showToast('Todos los campos son obligatorios');
                                    return;
                                  }
                                  try {
                                    await controller.create(marca, sucursal, aspirante);
                                    _marcaCtrl.clear();
                                    _sucursalCtrl.clear();
                                    _aspiranteCtrl.clear();
                                    _showToast('Creado');
                                  } catch (e) {
                                    _showToast('Error: $e');
                                  }
                                },
                                child: Text('Crear', style: GoogleFonts.montserrat()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 900),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Color(0xFFE280BE), borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              children: const [
                                Expanded(flex: 2, child: Text('Marca', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                                Expanded(flex: 2, child: Text('Sucursal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                                Expanded(flex: 3, child: Text('Aspirante', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                                SizedBox(width: 96),
                              ],
                            ),
                          ),

                          Expanded(
                            child: controller.loading
                                ? const Center(child: CircularProgressIndicator())
                                : items.isEmpty
                                ? const Center(child: Text('Sin registros', style: TextStyle(color: Color(0xFF9E9E9E))))
                                : ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF2F2F2)),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 2, child: Text(item.marca ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: const Color(0xFF555555)))),
                                      Expanded(flex: 2, child: Text(item.sucursal ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: const Color(0xFF999999)))),
                                      Expanded(flex: 3, child: Text(item.aspirante ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.montserrat(color: const Color(0xFF777777)))),
                                      const SizedBox(width: 8),

                                      SizedBox(
                                        width: 170,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              padding: const EdgeInsets.all(6),
                                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                              iconSize: 20,
                                              tooltip: 'Placa',
                                              onPressed: () => _showPlateDialog(item),
                                              icon: SvgPicture.asset('assets/icons/Vector_agregar.svg', width: 20, height: 20),
                                            ),
                                            const SizedBox(width: 8),

                                            IconButton(
                                              padding: const EdgeInsets.all(6),
                                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                              iconSize: 20,
                                              tooltip: 'Editar',
                                              onPressed: () => _openCreateOrEditSheet(item: item),
                                              icon: SvgPicture.asset('assets/icons/Boton_confirmar_1.svg', width: 20, height: 20),
                                            ),
                                            const SizedBox(width: 8),

                                            IconButton(
                                              padding: const EdgeInsets.all(6),
                                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                              iconSize: 20,
                                              tooltip: 'Eliminar',
                                              onPressed: () => _openDeleteConfirm(item),
                                              icon: SvgPicture.asset('assets/icons/Vector_quitar.svg', width: 20, height: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 18, top: 12),
                  child: Image.asset('assets/images/Logotipo_motion.png', height: 36, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}