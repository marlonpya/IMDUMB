# IMDUMB - Aplicación iOS de Películas

## Resumen del Proyecto

Aplicación iOS desarrollada en Swift que muestra un catalogo de peliculas organizadas por categorias. La aplicacion consume la API de The Movie Database (TMDB) y permite ver detalles de peliculas, actores y enviar recomendaciones.

**Arquitectura:** MVP (Model-View-Presenter) + Clean Architecture
**UI:** UIKit con archivos .xib exclusivamente
**Backend:** Firebase Remote Config para configuracion dinamica

El proyecto implementa un sistema de entornos (Dev, QA, Production) con diferentes fuentes de datos mediante el patron Factory.

---

## Tech Stack y Dependencias

### Lenguaje y Frameworks
- Swift 5.9+
- UIKit
- iOS 15.0+

### Dependencias (Swift Package Manager)
- **Alamofire** - Version 5.9.0
  - Proposito: Networking para consumo de API REST de TMDB
  - URL: https://github.com/Alamofire/Alamofire.git

- **Firebase iOS SDK** - Version 10.20.0
  - FirebaseCore
  - FirebaseRemoteConfig
  - Proposito: Configuracion remota y feature toggles
  - URL: https://github.com/firebase/firebase-ios-sdk.git

### Arquitectura
- Clean Architecture (Domain, Data, Presentation)
- MVP Pattern
- Inyeccion de dependencias manual
- Protocols para abstracciones (Repository, DataStore, UseCases)

---

## Como Correr el Proyecto

### Requisitos previos
- Xcode 15.0 o superior
- macOS con soporte para Xcode
- Conexion a internet (para QA y Production)

### Pasos de instalacion

**1. Clonar el repositorio**
```bash
git clone https://github.com/marlonpya/IMDUMB.git
cd IMDUMB
```

**2. Abrir el proyecto en Xcode**
```bash
open IMDUMB.xcodeproj
```

**3. Seleccionar el scheme apropiado**

El proyecto incluye 3 schemes con diferentes configuraciones:

- **IMDUMB-Dev**: Usa datos mock locales (no requiere red ni Firebase)
- **IMDUMB-QA**: Usa Firebase + TMDB API (requiere configuracion)
- **IMDUMB**: Produccion con Firebase + TMDB API

Para desarrollo rapido, usar IMDUMB-Dev que funciona sin configuracion adicional.

**4. Configurar GoogleService-Info.plist (solo para QA y Production)**

Si vas a usar los schemes IMDUMB-QA o IMDUMB:

a. Descarga el archivo GoogleService-Info.plist desde Firebase Console
b. Arrastra el archivo al proyecto en Xcode
c. Asegura que este agregado a los targets IMDUMB-QA y/o IMDUMB

Nota: El proyecto incluye un archivo de prueba para facilitar la evaluacion.

**5. Configurar Build Flags en Xcode**

Para que los schemes funcionen correctamente:

Target IMDUMB-Dev:
- Build Settings > Other Swift Flags
- Agregar: -D DEV (en Debug y Release)

Target IMDUMB-QA:
- Build Settings > Other Swift Flags
- Agregar: -D QA (en Debug y Release)

Target IMDUMB:
- No requiere flags adicionales

**6. Compilar y ejecutar**
```bash
Cmd + B  # Compilar
Cmd + R  # Ejecutar
```

El proyecto deberia compilar y ejecutar inmediatamente con el scheme IMDUMB-Dev.

---

## Endpoints y Mocks

### Entorno Development (IMDUMB-Dev)

Usa `MockDataStore` con datos hardcodeados en el codigo:
- 20+ peliculas organizadas en 4 categorias
- Actores de prueba
- Imagenes placeholder
- No requiere conexion a internet

Archivo: `IMDUMB/Data/DataStores/MockDataStore.swift`

### Entornos QA y Production (IMDUMB-QA, IMDUMB)

Usan `FirebaseDataStore` que combina Firebase Remote Config con TMDB API.

**API de TMDB:**
- Base URL: https://api.themoviedb.org/3
- Autenticacion: API Key en header

**Endpoints consumidos:**
- `GET /genre/movie/list` - Lista de categorias/generos
- `GET /discover/movie?with_genres={id}` - Peliculas por categoria
- `GET /movie/{id}` - Detalle de pelicula
- `GET /movie/{id}/credits` - Actores de una pelicula
- `GET /movie/{id}/images` - Imagenes de una pelicula

**Firebase Remote Config:**
- welcomeMessage (String) - Mensaje de bienvenida
- maintenanceMode (Boolean) - Modo mantenimiento
- recommendationsEnabled (Boolean) - Habilitar recomendaciones
- apiTimeout (Number) - Timeout de requests en segundos
- categoriesLimit (Number) - Limite de categorias a mostrar
- moviesPerCategory (Number) - Peliculas por categoria

Archivos:
- `IMDUMB/Data/Network/TMDBAPIClient.swift`
- `IMDUMB/Data/Network/TMDBEndpoint.swift`
- `IMDUMB/Data/Firebase/FirebaseConfigService.swift`
- `IMDUMB/Core/Utils/TMDBConfiguration.swift`

---

## Documentacion de SOLID

El proyecto implementa los 5 principios SOLID documentados en el archivo:

**Archivo:** `SOLID.md`

**Principios implementados:**

1. **SRP (Single Responsibility Principle)**
   - Cada clase MVP tiene una unica responsabilidad
   - View: UI y eventos
   - Presenter: Coordinacion
   - Interactor: Logica de negocio

2. **OCP (Open/Closed Principle)**
   - DataStore extensible via protocol
   - Nuevas implementaciones sin modificar codigo existente

3. **LSP (Liskov Substitution Principle)**
   - Cualquier DataStore es intercambiable
   - Repositorios dependen de abstracciones

4. **ISP (Interface Segregation Principle)**
   - Protocols especificos (MovieRepository, ConfigRepository)
   - Clientes no dependen de metodos que no usan

5. **DIP (Dependency Inversion Principle)**
   - Dependencias inyectadas via constructor
   - Capas altas no dependen de implementaciones concretas

Ver ejemplos de codigo y explicaciones detalladas en `SOLID.md`.

---

## Estructura del Proyecto

```
IMDUMB/
├── Domain/               # Entidades, Protocols, UseCases
├── Data/                 # Repositories, DataStores, Network
├── Presentation/         # View, Presenter, Interactor (MVP)
├── Core/                 # Extensions, Utils, Protocols
└── Resources/            # Assets, GoogleService-Info.plist
```

---

## Autor

Marlon Mauro Arteaga Morales
Febrero 2026
