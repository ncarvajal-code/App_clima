# ⚙️ Configuración del proyecto

Esta guía detalla la configuración necesaria para que **App_clima** funcione correctamente en un entorno local de desarrollo.

## 📋 Tabla de contenidos

- [Configuración de Firebase y Google Sign-In](#-configuración-de-firebase-y-google-sign-in)
- [Configuración del mapa (flutter_map)](#-configuración-del-mapa-flutter_map)
- [Clave de API del clima](#-clave-de-api-del-clima)
- [Permisos de ubicación](#-permisos-de-ubicación)
- [Variables de entorno](#-variables-de-entorno)

---

## 🔥 Configuración de Firebase y Google Sign-In

El proyecto usa **Firebase Authentication** (ver `lib/firebase_options.dart`) con **inicio de sesión exclusivo mediante cuenta de Google**. No hay registro con correo/contraseña.

1. Crea un proyecto en la [consola de Firebase](https://console.firebase.google.com/).
2. En **Authentication → Sign-in method**, habilita el proveedor **Google**.
3. Instala la Firebase CLI y la herramienta FlutterFire:

   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```

4. Inicia sesión y vincula el proyecto:

   ```bash
   firebase login
   flutterfire configure
   ```

   Esto generará (o actualizará) automáticamente el archivo `lib/firebase_options.dart` con las credenciales de tu propio proyecto de Firebase.

5. Asegúrate de que los archivos nativos también estén presentes:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

> [!IMPORTANT]
> Google Sign-In en Android **requiere registrar la huella digital SHA-1** (y opcionalmente SHA-256) de tu certificado de firma en la configuración del proyecto en Firebase. Sin este paso, el login con Google fallará con un error de autenticación, aunque el resto de la app compile sin problemas.

Para obtener la huella SHA-1 de tu keystore de debug:

```bash
keytool -list -v \
  -alias androiddebugkey \
  -keystore ~/.android/debug.keystore \
  -storepass android -keypass android
```

Luego agrega esa huella en **Firebase → Configuración del proyecto → Tus apps → Android → Agregar huella digital**, y vuelve a descargar el `google-services.json` actualizado.

> [!CAUTION]
> Si compilas una versión `release` con un keystore distinto al de debug, esa build tendrá una huella SHA-1 diferente. Debes agregarla también en Firebase, o el login con Google solo funcionará en modo debug.

---

## 🗺️ Configuración del mapa (flutter_map)

El mapa de `presentation/pages/map.dart` se construye con [`flutter_map`](https://pub.dev/packages/flutter_map), basado en mosaicos (tiles) de **OpenStreetMap**, por lo que **no requiere una clave de API** como sí ocurriría con Google Maps.

> [!NOTE]
> Al usar mosaicos de OpenStreetMap, es una buena práctica configurar un `userAgentPackageName` propio en el `TileLayer` (por ejemplo, el nombre del paquete de la app) para cumplir con la [política de uso de OpenStreetMap](https://operations.osmfoundation.org/policies/tiles/).

Ejemplo de configuración básica dentro del `TileLayer`:

```dart
TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'com.tu_dominio.app_clima',
)
```

> [!TIP]
> Si en el futuro necesitas mayor volumen de tráfico o un estilo de mapa distinto, puedes reemplazar el `urlTemplate` por un proveedor de mosaicos alternativo (ej. Mapbox, MapTiler), lo cual sí podría requerir una clave de API propia.

---

## 🌦️ Clave de API del clima

| Servicio | Uso en la app | Dónde obtener la clave |
|---|---|---|
| API de clima (ej. OpenWeatherMap) | Obtener condiciones climáticas actuales (`clima_model.dart`, `farmacia_clima_services.dart`) | [OpenWeatherMap](https://openweathermap.org/api) |
| API de farmacias / lugares | Buscar la farmacia más cercana (`farmacia_model.dart`, `farmacia_clima_services.dart`) | Según el proveedor que utilices (ej. Google Places, Overpass API de OpenStreetMap) |

> [!TIP]
> Si usas la **Overpass API** de OpenStreetMap para buscar farmacias, no necesitas clave de API, lo cual mantiene consistencia con el uso de `flutter_map`.

---

## 📍 Permisos de ubicación

`lib/data/services/location_services.dart` necesita acceso a la ubicación del usuario para encontrar la farmacia más cercana y centrar el mapa.

### Android

En `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### iOS

En `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Necesitamos tu ubicación para encontrar la farmacia más cercana.</string>
```

---

## 🌱 Variables de entorno

Se recomienda no exponer la clave de la API del clima directamente en el código fuente (por ejemplo, en `core/utils/global.dart`). Puedes usar un archivo `.env` en la raíz del proyecto junto con el paquete [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv):

```
WEATHER_API_KEY=tu_clave_aqui
```

> [!WARNING]
> Asegúrate de agregar `.env`, `google-services.json` y `GoogleService-Info.plist` al archivo `.gitignore` para no subir tus claves y credenciales al repositorio.
