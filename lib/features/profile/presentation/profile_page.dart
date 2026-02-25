import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Text(text, style: GoogleFonts.montserrat(fontSize: 14, color: const Color(0xFF00A3D4), fontWeight: FontWeight.w600)),
    );
  }

  Widget _sectionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(text, style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF444444))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = 110.0;

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

          // bottom wave
          Positioned(
            bottom: -12,
            left: 0,
            right: 0,
            child: Image.asset('assets/images/vector_inferior.png', fit: BoxFit.cover, height: 120),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // top row (back + title)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back, color: Color(0xFF00249C))),
                      const SizedBox(width: 6),
                      Text('Perfil', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF00249C))),
                      const Spacer(),
                      Image.asset('assets/images/Logotipo_motion.png', height: 28),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // avatar central with gradient ring
                Center(
                  child: Container(
                    width: avatarSize + 18,
                    height: avatarSize + 18,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFE280BE), Color(0xFF40CEE4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6))],
                        ),
                        child: ClipOval(
                          child: Image.asset('assets/images/img_usuario.png', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Disponibilidad indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('General', style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, color: const Color(0xFF00A3D4))),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: Colors.greenAccent[400], shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                    const SizedBox(width: 8),
                    Text('Disponible', style: GoogleFonts.montserrat(color: const Color(0xFF6A6A6A))),
                  ],
                ),

                const SizedBox(height: 14),

                // card with sections
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('General'),
                          _sectionItem('Dark mode'),
                          _sectionItem('Notificaciones'),
                          _sectionItem('Seguridad'),
                          const SizedBox(height: 8),
                          Divider(color: const Color(0xFFE0E0E0), height: 18),
                          _sectionTitle('Organizacional'),
                          _sectionItem('Perfil'),
                          _sectionItem('Mensajes'),
                          _sectionItem('Llamadas'),
                          _sectionItem('Gente'),
                          _sectionItem('Calendario'),
                          // espacio para empujar el contenido arriba y mostrar onda inferior
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}// TODO Implement this library.