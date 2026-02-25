import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final bool checked;
  final VoidCallback? onTap;

  const CatalogCard({
    super.key,
    required this.imageAsset,
    required this.title,
    this.checked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          children: [
            // area imagen con degradado cyan interior
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: const LinearGradient(
                  colors: [Color(0xFF40CEE4), Color(0xFFBFEFF6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imageAsset, fit: BoxFit.cover, width: double.infinity),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF2B2B2B)),
                    ),
                  ),
                  // check pequeño en la esquina del card
                  AnimatedOpacity(
                    opacity: checked ? 1 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF40CEE4)),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.check, size: 18, color: Color(0xFF40CEE4)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}