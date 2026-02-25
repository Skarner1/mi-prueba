import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledIconField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String svgAsset;
  final TextInputType keyboardType;

  const LabeledIconField({
    super.key,
    required this.label,
    required this.controller,
    required this.svgAsset,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    // Estilo pensado para parecerse al Figma: campo con bordes redondeados y fondo blanco
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEBEBF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          SvgPicture.asset(svgAsset, width: 20, height: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: GoogleFonts.montserrat(textStyle: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: label,
                hintStyle: GoogleFonts.montserrat(color: const Color(0xFF9E9E9E), fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}