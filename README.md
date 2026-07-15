# 💊🌦️ App_clima

> Encuentra la farmacia más cercana, revisa el clima antes de salir y visualízala en el mapa. Todo en una sola app.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Platform](https://img.shields.io/badge/plataforma-multiplataforma-blueviolet?style=for-the-badge)
![License](https://img.shields.io/badge/licencia-MIT-green?style=for-the-badge)

---

## 📋 Tabla de contenidos

- [Descripción](#-descripción)
- [Características](#-características)
- [Tecnologías utilizadas](#-tecnologías-utilizadas)
- [Requisitos previos](#-requisitos-previos)
- [Instalación](#-instalación)
- [Primeros pasos (modo debug)](#-primeros-pasos-modo-debug)
- [Compilación (build)](#-compilación-build)
- [Estructura del proyecto](#-estructura-del-proyecto)
- [Documentación adicional](#-documentación-adicional)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)

---

## 📝 Descripción

**App_clima** es una aplicación desarrollada en **Flutter**, con orientación principal a **Android** aunque construida de forma **multiplataforma** (Android, iOS, web, Linux, macOS y Windows, gracias al propio framework).

El propósito principal de la app es ayudar al usuario a:

1. 📍 **Encontrar la farmacia más cercana** a su ubicación actual.
2. 🌦️ **Consultar el clima** en tiempo real, para que el usuario pueda decidir si vale la pena salir a hacer el viaje hasta la farmacia.
3. 🗺️ **Visualizar en un mapa** (con `flutter_map`) dónde se encuentra la farmacia sugerida.

> [!NOTE]
> El inicio de sesión de la app es **exclusivo con cuenta de Google**. No existe registro con correo/contraseña.

---

## ✨ Características

- [x] Inicio de sesión exclusivo con **Google Sign-In** (vía Firebase Authentication).
- [x] Búsqueda de la farmacia más cercana según geolocalización.
- [x] Visualización del clima actual para evaluar si conviene salir.
- [x] Mapa interactivo con `flutter_map` mostrando la ubicación de la farmacia.
- [x] Arquitectura organizada por capas (`core`, `data`, `domain`, `presentation`).
- [x] Manejo de estado mediante `Provider`.
- [x] Soporte multiplataforma (foco principal en Android).

---

## 🛠️ Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| [Flutter](https://flutter.dev) | Framework principal de desarrollo UI multiplataforma |
| [Dart](https://dart.dev) | Lenguaje de programación |
| [Firebase Authentication](https://firebase.google.com/docs/auth) (`firebase_options.dart`) | Inicio de sesión exclusivo con cuenta de Google |
| [Google Sign-In](https://pub.dev/packages/google_sign_in) | Autenticación del usuario con su cuenta de Google |
| `Provider` (`app_provider.dart`) | Manejo de estado de la aplicación |
| [flutter_map](https://pub.dev/packages/flutter_map) | Renderizado del mapa (basado en OpenStreetMap) en `presentation/pages/map.dart` |
| API de geolocalización (`location_services.dart`) | Obtener la ubicación del usuario |
| API de farmacias y clima (`farmacia_clima_services.dart`) | Buscar farmacias cercanas y datos meteorológicos |

> [!TIP]
> Ajusta esta tabla según los paquetes exactos definidos en tu `pubspec.yaml`.

---

## ✅ Requisitos previos

Antes de instalar la app, asegúrate de tener:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión estable recomendada).
- [Android Studio](https://developer.android.com/studio) o [Visual Studio Code](https://code.visualstudio.com/) con los plugins de Flutter y Dart.
- Un emulador Android configurado, o un dispositivo físico con **depuración USB** habilitada.
- [Git](https://git-scm.com/) instalado.
- Una cuenta de [Firebase](https://console.firebase.google.com/) con **Authentication → Google** habilitado, y la [Firebase CLI](https://firebase.google.com/docs/cli) / [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) si necesitas regenerar `firebase_options.dart`.
- Una clave de API para el servicio de clima (ver [doc/CONFIGURACION.md](doc/CONFIGURACION.md)).

> [!IMPORTANT]
> Para que el inicio de sesión con Google funcione en Android, es obligatorio registrar la huella SHA-1 (y SHA-256) de tu certificado de firma en el proyecto de Firebase. Sin este paso, el login fallará. Ver [doc/CONFIGURACION.md](doc/CONFIGURACION.md).

Verifica que tu entorno esté correctamente configurado con:

```bash
flutter doctor
```

---

## 📥 Instalación

1. Clona este repositorio:

   ```bash
   git clone https://github.com/ncarvajal-code/App_clima.git
   cd App_clima
   ```

2. Instala las dependencias del proyecto:

   ```bash
   flutter pub get
   ```

3. Configura Firebase (con Google Sign-In habilitado) y la clave de API del clima. Consulta la guía detallada en [doc/CONFIGURACION.md](doc/CONFIGURACION.md).

> [!WARNING]
> Sin completar la configuración de Firebase/Google Sign-In del paso anterior, la app compilará pero **no podrás iniciar sesión** y por lo tanto no podrás acceder a la pantalla principal.

---

## ▶️ Primeros pasos (modo debug)

1. Conecta un dispositivo físico (con depuración USB activada) o inicia un emulador Android.

2. Verifica que el dispositivo sea reconocido:

   ```bash
   flutter devices
   ```

3. Ejecuta la app en modo debug:

   ```bash
   flutter run
   ```

4. Durante la ejecución en modo debug puedes usar:

   | Comando | Acción |
   |---|---|
   | `r` | Hot reload |
   | `R` | Hot restart |
   | `p` | Mostrar bordes de renderizado |
   | `q` | Salir de la ejecución |

5. Para ver logs detallados en tiempo real:

   ```bash
   flutter logs
   ```

> [!CAUTION]
> El login con Google no funciona en todos los emuladores Android por defecto: usa una imagen de emulador **con Google Play Services** (Google APIs / Google Play), o prueba directamente en un dispositivo físico.

---

## 📦 Compilación (build)

### Android (APK)

```bash
flutter build apk --release
```

El archivo generado quedará en:

```
build/app/outputs/flutter-apk/app-release.apk
```

### Android (App Bundle, recomendado para Play Store)

```bash
flutter build appbundle --release
```

### iOS *(si aplica en tu configuración)*

```bash
flutter build ios --release
```

> [!IMPORTANT]
> Cada `keystore` de firma (debug o release) genera una huella SHA-1 distinta. Si compilas en modo `release` con un keystore nuevo, debes agregar también esa huella en Firebase o el login con Google fallará solo en esa build.

---

## 📁 Estructura del proyecto

El código fuente en `lib/` está organizado siguiendo una arquitectura por capas:

```
lib/
├── core/
│   └── utils/
│       └── global.dart              # Constantes y utilidades globales
├── data/
│   ├── models/
│   │   ├── clima_model.dart         # Modelo de datos del clima
│   │   └── farmacia_model.dart      # Modelo de datos de una farmacia
│   └── services/
│       ├── farmacia_clima_services.dart  # Consumo de API de farmacias y clima
│       └── location_services.dart        # Obtención de la ubicación del usuario
├── domain/
│   └── entities/
│       └── usuario.dart             # Entidad de dominio del usuario
├── presentation/
│   ├── pages/
│   │   ├── home.dart                # Pantalla principal
│   │   ├── home_content.dart        # Contenido de la pantalla principal
│   │   ├── login.dart               # Pantalla de inicio de sesión con Google
│   │   ├── map.dart                 # Pantalla del mapa (flutter_map) con la farmacia
│   │   └── weather.dart             # Pantalla del clima
│   ├── providers/
│   │   └── app_provider.dart        # Manejo de estado de la aplicación
│   └── widgets/
│       └── home_content.dart        # Widgets reutilizables de la pantalla principal
├── firebase_options.dart            # Configuración generada por FlutterFire
└── main.dart                        # Punto de entrada de la aplicación
```

Consulta el detalle de cada capa en [doc/ARQUITECTURA.md](doc/ARQUITECTURA.md).

---

## 📚 Documentación adicional

En la carpeta [`/doc`](doc) encontrarás documentación complementaria:

- [doc/CONFIGURACION.md](doc/CONFIGURACION.md) — Configuración de Firebase con Google Sign-In, la clave de API del clima, `flutter_map` y permisos de ubicación.
- [doc/ARQUITECTURA.md](doc/ARQUITECTURA.md) — Descripción detallada de cada carpeta y archivo dentro de `lib/`.

---

## 🤝 Contribuir

Las contribuciones son bienvenidas. Para contribuir:

1. Haz un *fork* del proyecto.
2. Crea una rama para tu funcionalidad (`git checkout -b feature/nueva-funcionalidad`).
3. Haz *commit* de tus cambios (`git commit -m 'Agrega nueva funcionalidad'`).
4. Sube la rama (`git push origin feature/nueva-funcionalidad`).
5. Abre un *Pull Request*.

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más información.
