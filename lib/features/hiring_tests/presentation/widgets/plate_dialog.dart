import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlateDialog extends StatefulWidget {
  final String marca;
  const PlateDialog({super.key, required this.marca});

  @override
  State<PlateDialog> createState() => _PlateDialogState();
}

class _PlateDialogState extends State<PlateDialog> {
  final Map<String, bool> _devices = {
    'GPS': false,
    'Sensores': false,
    'SIM': false,
    'Otros': false,
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 120),
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: const Color(0xFFE280BE).withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 10)),
            ],
            border: Border.all(color: const Color(0xFFE280BE), width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PLACA', style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF6B6B6B))),
              const SizedBox(height: 6),
              Text('Tipo de servicio', style: GoogleFonts.montserrat(fontSize: 14, color: const Color(0xFF40CEE4))),
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft, child: Text('Dispositivos', style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF8A8A8A)))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _devices.keys.map((k) {
                  final selected = _devices[k]!;
                  return GestureDetector(
                    onTap: () => setState(() => _devices[k] = !selected),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFFE280BE) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE280BE)),
                        boxShadow: selected ? [BoxShadow(color: const Color(0xFFE280BE).withOpacity(0.12), blurRadius: 8, offset: const Offset(0,4))] : null,
                      ),
                      child: Text(k, style: GoogleFonts.montserrat(color: selected ? Colors.white : const Color(0xFFB20068), fontWeight: FontWeight.w600)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft, child: Text('Marca: ${widget.marca}', style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF6B6B6B)))),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B6B6B),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      child: Text('Cerrar', style: GoogleFonts.montserrat()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(_devices);
                      },
                      child: Text('Aceptar', style: GoogleFonts.montserrat()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}