import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'catalog_card.dart';

class CatalogPage extends StatefulWidget {
  static const routeName = '/catalog';
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  // demo: lista de imagenes/títulos (reemplaza por datos reales si tienes endpoint)
  final List<Map<String, String>> _items = [
    {'image': 'assets/images/frame_carro_1.png', 'title': 'Mazda MX5'},
    {'image': 'assets/images/frame_carro_2.png', 'title': 'Nissan GT R'},
    {'image': 'assets/images/frame_carro_3.png', 'title': 'Toyota Supra'},
    {'image': 'assets/images/frame_carro_4.png', 'title': 'BMW M4'},
  ];

  final Set<int> _checked = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F3F8),
      body: Stack(
        children: [
          // top decorative
          Positioned(
            top: -24,
            left: -8,
            right: -8,
            child: Image.asset('assets/images/vector_superior.png', fit: BoxFit.cover, height: 180),
          ),

          // bottom decorative
          Positioned(
            bottom: -12,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/vector_inferior.png', fit: BoxFit.cover, height: 120),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF00249C)),
                      ),
                      const SizedBox(width: 6),
                      Text('Catálogo', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF00249C))),
                      const Spacer(),
                      // logo pequeño (opcional)
                      Image.asset('assets/images/Logotipo_motion.png', height: 28),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // listado de cards
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final it = _items[index];
                      return CatalogCard(
                        imageAsset: it['image']!,
                        title: it['title']!,
                        checked: _checked.contains(index),
                        onTap: () {
                          setState(() {
                            if (_checked.contains(index)) _checked.remove(index);
                            else _checked.add(index);
                          });

                          // ejemplo: abrir modal de detalle (opcional)
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(it['title']!, style: GoogleFonts.montserrat()),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(it['image']!, fit: BoxFit.cover),
                                  const SizedBox(height: 8),
                                  Text('Detalle del vehículo', style: GoogleFonts.montserrat()),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cerrar', style: GoogleFonts.montserrat())),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}