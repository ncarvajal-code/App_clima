# 🏗️ Arquitectura del proyecto

Este documento describe la organización del código dentro de `lib/` para **App_clima**.

## 📋 Tabla de contenidos

- [Visión general](#-visión-general)
- [core/](#-core)
- [data/](#-data)
- [domain/](#-domain)
- [presentation/](#-presentation)
- [Archivos raíz de lib/](#-archivos-raíz-de-lib)
- [Flujo de datos](#-flujo-de-datos)

---

## 🔎 Visión general

El proyecto sigue una organización inspirada en **Clean Architecture**, separando el código en capas: `core`, `data`, `domain` y `presentation`.

```
lib/
├── core/
│   └── utils/
│       └── global.dart
├── data/
│   ├── models/
│   │   ├── clima_model.dart
│   │   └── farmacia_model.dart
│   └── services/
│       ├── farmacia_clima_services.dart
│       └── location_services.dart
├── domain/
│   └── entities/
│       └── usuario.dart
├── presentation/
│   ├── pages/
│   │   ├── home.dart
│   │   ├── home_content.dart
│   │   ├── login.dart
│   │   ├── map.dart
│   │   └── weather.dart
│   ├── providers/
│   │   └── app_provider.dart
│   └── widgets/
│       └── home_content.dart
├── firebase_options.dart
└── main.dart
```

---

## 🧩 core/

Contiene utilidades transversales usadas por el resto de la app.

| Archivo | Responsabilidad |
|---|---|
| `core/utils/global.dart` | Constantes, valores globales y funciones de utilidad compartidas por toda la app (por ejemplo, la clave de la API del clima o helpers genéricos). |

> [!WARNING]
> Si `global.dart` contiene claves de API en texto plano, evita subir ese archivo con valores reales a un repositorio público. Ver [doc/CONFIGURACION.md](CONFIGURACION.md).

---

## 🧩 data/

Capa encargada de obtener y modelar los datos que consume la app.

### models/

| Archivo | Responsabilidad |
|---|---|
| `data/models/clima_model.dart` | Representa la estructura de los datos del clima obtenidos desde la API meteorológica (temperatura, condición, etc.). |
| `data/models/farmacia_model.dart` | Representa la estructura de los datos de una farmacia (nombre, dirección, coordenadas, horario, etc.). |

### services/

| Archivo | Responsabilidad |
|---|---|
| `data/services/farmacia_clima_services.dart` | Realiza las llamadas a las APIs externas para obtener la farmacia más cercana y los datos del clima asociados a esa ubicación. |
| `data/services/location_services.dart` | Gestiona la obtención de la ubicación (GPS) del usuario y los permisos necesarios. |

---

## 🧩 domain/

Capa que define las entidades centrales del negocio, independientes de la fuente de datos.

| Archivo | Responsabilidad |
|---|---|
| `domain/entities/usuario.dart` | Entidad que representa al usuario autenticado con su cuenta de Google dentro de la aplicación. |

---

## 🧩 presentation/

Capa de interfaz de usuario: pantallas, estado y widgets.

### pages/

| Archivo | Responsabilidad |
|---|---|
| `presentation/pages/home.dart` | Pantalla principal de la app, punto de entrada tras iniciar sesión. |
| `presentation/pages/home_content.dart` | Contenido central que se muestra dentro de la pantalla principal. |
| `presentation/pages/login.dart` | Pantalla de inicio de sesión, **exclusiva con Google Sign-In** (sin correo/contraseña). |
| `presentation/pages/map.dart` | Pantalla que muestra el mapa (con `flutter_map`) con la ubicación de la farmacia sugerida. |
| `presentation/pages/weather.dart` | Pantalla que muestra el detalle del clima actual. |

### providers/

| Archivo | Responsabilidad |
|---|---|
| `presentation/providers/app_provider.dart` | Maneja el estado global de la aplicación (por ejemplo, sesión del usuario de Google, farmacia seleccionada, clima actual) usando `Provider`. |

### widgets/

| Archivo | Responsabilidad |
|---|---|
| `presentation/widgets/home_content.dart` | Widgets reutilizables usados dentro del contenido de la pantalla principal (tarjetas, secciones, etc.). |

> [!NOTE]
> Existen dos archivos llamados `home_content.dart` (uno en `pages/` y otro en `widgets/`). Verifica en el código cuál corresponde a la pantalla y cuál a los componentes reutilizables para evitar confusiones al importar.

---

## 📄 Archivos raíz de lib/

| Archivo | Responsabilidad |
|---|---|
| `firebase_options.dart` | Configuración de Firebase generada automáticamente por la herramienta FlutterFire CLI. No se edita manualmente. |
| `main.dart` | Punto de entrada de la aplicación. Inicializa Firebase, los providers y define la pantalla inicial (login). |

---

## 🔄 Flujo de datos

1. El usuario abre la app y se autentica exclusivamente con su **cuenta de Google** en `login.dart`.
2. Al ingresar, `home.dart` / `home_content.dart` cargan la pantalla principal.
3. `location_services.dart` obtiene la ubicación actual del usuario.
4. `farmacia_clima_services.dart` usa esa ubicación para consultar la farmacia más cercana (`farmacia_model.dart`) y el clima asociado (`clima_model.dart`).
5. `app_provider.dart` mantiene y distribuye ese estado hacia las pantallas.
6. `weather.dart` muestra el clima para que el usuario decida si vale la pena el viaje.
7. `map.dart` renderiza con `flutter_map` la ubicación de la farmacia sugerida.

> [!TIP]
> Actualiza este documento a medida que la arquitectura real del proyecto evolucione.
