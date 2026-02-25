# App de Ventas - Autos de lujo

Resumen
-------
Aplicación Flutter para gestión de pruebas de contratación (CRUD de ítems). Esta entrega incluye el código fuente, tests y el APK de release.

Estado
------
- Tests: ✅ All tests passed
- APK: ✅ app-release-v1.0.0.apk (adjunto en Releases o disponible localmente en build/...)
- Versión: 1.0.0

Instrucciones de instalación y ejecución (desarrollo)
-----------------------------------------------------
Prerequisitos:
- Flutter SDK (versión estable)
- Android SDK / dispositivo o emulador
- Java JDK (si compilas Android)

Ejecutar local:
```bash
flutter pub get
flutter run
```

Generar APK release:
```bash
flutter clean
flutter pub get
flutter build apk --release
# APK generado: build/app/outputs/flutter-apk/app-release.apk
```

Instalar APK en dispositivo (opcional):
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

Endpoints / Backend
-------------------
La app consume el endpoint público:
https://monitoringinnovation.com/api/v1/hiring-tests/items/{cedula}

Datos de prueba
---------------
- Cédula de prueba: `1000320178`

Tests
-----
Ejecutar tests unitarios:
```bash
flutter test
```
Salida esperada:
```
All tests passed!
```



