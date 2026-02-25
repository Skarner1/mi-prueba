import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../hiring_tests/presentation/hiring_page.dart';

/// SplashPage que:
/// 1) reproduce la intro del logo (white -> gradient, logo scale/fade)
/// 2) al terminar muestra la pantalla estática con texto + logo + botón "¡ Iniciar !"
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // Intro controller (controls logo and background crossfade)
  late final AnimationController _introCtrl;
  late final Animation<double> _bgCross; // 0 = white, 1 = gradient
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // Crossfade controller to reveal static splash UI
  late final AnimationController _crossCtrl;
  late final Animation<double> _crossFade;

  static const String assetPath = 'assets/images/Logotipo_motion.png';
  bool _assetMissing = false;

  @override
  void initState() {
    super.initState();

    _introCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _bgCross = CurvedAnimation(parent: _introCtrl, curve: const Interval(0.28, 0.75, curve: Curves.easeInOut));
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _introCtrl, curve: const Interval(0.0, 1.0, curve: Curves.elasticOut)));
    _logoFade = CurvedAnimation(parent: _introCtrl, curve: const Interval(0.0, 0.85, curve: Curves.easeIn));

    _crossCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _crossFade = CurvedAnimation(parent: _crossCtrl, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) => _precacheAndStart());

    _introCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // start crossfade to static splash UI
        _crossCtrl.forward();
      }
    });
  }

  Future<void> _precacheAndStart() async {
    try {
      await precacheImage(const AssetImage(assetPath), context);
      if (kDebugMode) debugPrint('Splash: asset precached');
    } catch (e) {
      if (kDebugMode) debugPrint('Splash: asset precache failed: $e');
      setState(() => _assetMissing = true);
    } finally {
      _introCtrl.forward();
    }
  }

  @override
  void dispose() {
    _introCtrl.dispose();
    _crossCtrl.dispose();
    super.dispose();
  }

  Widget _logo(double height) {
    if (_assetMissing) {
      return Center(child: Text('motion', style: GoogleFonts.montserrat(fontSize: height * 0.35, color: const Color(0xFF40CEE4), fontWeight: FontWeight.w800)));
    }
    return Image.asset(
      assetPath,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (ctx, err, stack) {
        if (kDebugMode) debugPrint('Splash: Image.asset error: $err');
        return Center(child: Text('motion', style: GoogleFonts.montserrat(fontSize: height * 0.35, color: const Color(0xFF40CEE4), fontWeight: FontWeight.w800)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoHeight = size.height * 0.18;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: white -> gradient according to _bgCross.value
          AnimatedBuilder(
            animation: _introCtrl,
            builder: (_, __) {
              final t = _bgCross.value;
              if (t <= 0.0) {
                return Container(color: Colors.white);
              } else if (t >= 1.0) {
                return Container(decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE280BE), Color(0xFFFFFFFF), Color(0xFF40CEE4), Color(0xFF00249C)],
                    stops: [0.0, 0.45, 0.75, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ));
              } else {
                return Stack(
                  children: [
                    Container(color: Colors.white),
                    Opacity(
                      opacity: t,
                      child: Container(decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFE280BE), Color(0xFFFFFFFF), Color(0xFF40CEE4), Color(0xFF00249C)],
                          stops: [0.0, 0.45, 0.75, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      )),
                    ),
                  ],
                );
              }
            },
          ),

          // Intro logo: visible during intro, fades out as _crossFade grows
          AnimatedBuilder(
            animation: Listenable.merge([_introCtrl, _crossCtrl]),
            builder: (_, __) {
              final introOpacity = (1.0 - _crossFade.value).clamp(0.0, 1.0);
              final scale = _logoScale.value;
              final logoOpacity = _logoFade.value * introOpacity;
              return IgnorePointer(
                ignoring: _crossFade.value > 0.0,
                child: Opacity(
                  opacity: logoOpacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Center(child: _logo(logoHeight)),
                  ),
                ),
              );
            },
          ),

          // Static splash UI (revealed via cross-fade)
          FadeTransition(
            opacity: _crossFade,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('App de ventas', style: GoogleFonts.montserrat(fontSize: 14, color: const Color(0xFF40CEE4), fontWeight: FontWeight.w500))),
                    const SizedBox(height: 12),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('AUTOS DE LUJO', style: GoogleFonts.montserrat(fontSize: 36, color: const Color(0xFF00249C), fontWeight: FontWeight.w800, letterSpacing: 0.6))),
                    const SizedBox(height: 28),
                    SizedBox(height: logoHeight, child: _logo(logoHeight)),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacementNamed(HiringPage.routeName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF40CEE4), width: 2),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('¡ Iniciar !', style: GoogleFonts.montserrat(fontSize: 14, color: const Color(0xFF40CEE4), fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF40CEE4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}