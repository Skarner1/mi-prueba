import 'package:flutter/material.dart';

class CatalogCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final VoidCallback? onTap;
  final bool checked;

  const CatalogCard({
    super.key,
    required this.imageAsset,
    required this.title,
    this.onTap,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    // tarjeta con borde blanco, sombra suave y fondo cyan degradado interior
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          children: [
            // area de imagen con degradado cyan
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
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF2B2B2B)),
                    ),
                  ),
                  if (checked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF40CEE4)),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.check, size: 18, color: Color(0xFF40CEE4)),
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