import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../state/hiring_controller.dart';
import 'widgets/labeled_icon_field.dart';
import 'widgets/plate_dialog.dart';
import '../../catalog/presentation/catalog_page.dart';
import '../../profile/presentation/profile_page.dart';

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

  Future<void> _openCreateOrEditSheet({dynamic item}) async {
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
        return Container(
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
                    onPressed: () => Navigator.of(context).pop(true),
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
        _showToast(controller.lastMessage ?? 'Eliminado');
      } catch (e) {
        _showToast(e.toString());
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _openCreateOrEditSheet(),
                        icon: SvgPicture.asset('assets/icons/Vector_agregar.svg', width: 26, height: 26),
                      ),
                      Expanded(
                        child: Center(
                          child: Image.asset('assets/images/Logotipo_motion.png', height: 30, fit: BoxFit.contain),
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.load(),
                        icon: const Icon(Icons.refresh, color: Color(0xFF9E9E9E)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
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
                                onPressed: () {
                                  _marcaCtrl.clear();
                                  _sucursalCtrl.clear();
                                  _aspiranteCtrl.clear();
                                },
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
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                                SizedBox(width: 140),
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
                                                SizedBox(
                                                  width: 140,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        padding: const EdgeInsets.all(4),
                                                        constraints: const BoxConstraints(),
                                                        onPressed: () => _showPlateDialog(item),
                                                        icon: SvgPicture.asset('assets/icons/Vector_agregar.svg', width: 22, height: 22),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      IconButton(
                                                        padding: const EdgeInsets.all(4),
                                                        constraints: const BoxConstraints(),
                                                        onPressed: () => _openCreateOrEditSheet(item: item),
                                                        icon: SvgPicture.asset('assets/icons/Boton_confirmar_1.svg', width: 22, height: 22),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      IconButton(
                                                        padding: const EdgeInsets.all(4),
                                                        constraints: const BoxConstraints(),
                                                        onPressed: () => _openDeleteConfirm(item),
                                                        icon: SvgPicture.asset('assets/icons/Vector_quitar.svg', width: 22, height: 22),
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
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.of(context).pushReplacementNamed(CatalogPage.routeName);
          if (index == 2) Navigator.of(context).pushReplacementNamed(ProfilePage.routeName);
        },
        items: [
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Vector_locacion.svg', width: 24, color: const Color(0xFF00249C)), label: 'Inicio'),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Vector_carro.svg', width: 24), label: 'Catálogo'),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/Vector_usuario.svg', width: 24), label: 'Perfil'),
        ],
        selectedItemColor: const Color(0xFF00249C),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.montserrat(),
      ),
    );
  }
}