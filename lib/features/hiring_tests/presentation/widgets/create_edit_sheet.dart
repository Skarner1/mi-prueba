import 'package:flutter/material.dart';
import '../../../../core/toast.dart';

class CreateEditSheet extends StatefulWidget {
  final String title;
  final String initialMarca;
  final String initialSucursal;
  final String initialAspirante;
  final Future<void> Function(String marca, String sucursal, String aspirante) onSubmit;

  const CreateEditSheet({
    super.key,
    required this.title,
    required this.initialMarca,
    required this.initialSucursal,
    required this.initialAspirante,
    required this.onSubmit,
  });

  @override
  State<CreateEditSheet> createState() => _CreateEditSheetState();
}

class _CreateEditSheetState extends State<CreateEditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _marcaCtrl = TextEditingController(text: widget.initialMarca);
  late final _sucursalCtrl = TextEditingController(text: widget.initialSucursal);
  late final _aspiranteCtrl = TextEditingController(text: widget.initialAspirante);

  bool _saving = false;

  @override
  void dispose() {
    _marcaCtrl.dispose();
    _sucursalCtrl.dispose();
    _aspiranteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await widget.onSubmit(
        _marcaCtrl.text.trim(),
        _sucursalCtrl.text.trim(),
        _aspiranteCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      AppToast.error(e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: bottom + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _marcaCtrl,
              decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Marca requerida' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sucursalCtrl,
              decoration: const InputDecoration(labelText: 'Sucursal', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Sucursal requerida' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _aspiranteCtrl,
              decoration: const InputDecoration(labelText: 'Aspirante', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Aspirante requerido' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}