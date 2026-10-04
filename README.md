# Documentación Oficial: Shaders Plus v2.1.0

> **Desarrollado por:** Omega Studios  
> **Motor:** Godot 4  

**Shaders Plus v2.1.0** es una herramienta de desarrollo de shaders para Godot 4 que integra un **Asistente Visual de Creación**, apertura automática de archivos en el editor nativo y una librería central de 30 funciones matemáticas optimizadas (`.gdshaderinc`) de cero consumo de VRAM.

---

## 🚀 Novedades en la Versión 2.1.0

* **Integración con el Editor de Shaders:** Al generar un nuevo shader desde el asistente, el plugin escanea el sistema de archivos (`EditorInterface.get_resource_filesystem().scan()`) e invoca `EditorInterface.edit_resource()`, desplegando inmediatamente el panel inferior del Editor de Shaders con el archivo cargado y enfocado.
* **Flujo de Creación de 1 Clic:** Elimina la necesidad de buscar manualmente el archivo generado en el panel *FileSystem* para abrirlo.

---

## 📂 Estructura del Complemento

```text
res://addons/shaders_plus/
├── plugin.cfg                           # Configuración del complemento v2.1.0
├── plugin.gd                            # Script EditorPlugin + Interfaz GUI + Apertura Auto
├── shaders_plus.gdshaderinc             # Librería central con 30 funciones matemáticas
└── shaders/                             # Plantillas 2D y 3D de referencia

Flujo de Trabajo con el Asistente Visual

    Abrir la Herramienta: Selecciona Herramientas (Tools) -> Shaders Plus: Crear Nuevo Shader... en la barra superior de Godot 4.

    Seleccionar Categoría y Plantilla:

        2D (CanvasItem): Plantillas para rotación, ondas, distorsión de agua y efecto CRT.

        3D (Spatial): Plantillas para ruido de valor y escudos de fuerza con efecto Fresnel.

        Post-Procesado (Screen Shader): Filtros globales con Dithering 4x4 y posterización.

        Vanilla (Nativo Godot): Archivos limpios de Godot (canvas_item, spatial, particles, fog) sin dependencias.

    Configurar Ruta y Nombre: Define el nombre del archivo (ejemplo: mi_shader.gdshader) y la carpeta destino (res://).

    Generación y Enfoque Automático: Haz clic en Crear Shader. El archivo se escribirá en disco, se compilará en el proyecto y se abrirá automáticamente en la pestaña del Editor de Shaders.

## 📊 Matriz de Categorías y Preajustes

| Categoría | Preajuste | Tipo de Shader | Auto #include | Apertura Automática |
| :--- | :--- | :--- | :---: | :---: |
| **2D (CanvasItem)** | 2D Vanilla | `canvas_item` | No | Sí |
| **2D (CanvasItem)** | 2D Base + Shaders Plus | `canvas_item` | Sí | Sí |
| **2D (CanvasItem)** | 2D Efecto CRT / Scanlines | `canvas_item` | Sí | Sí |
| **2D (CanvasItem)** | 2D Ondas / Distorsión Agua | `canvas_item` | Sí | Sí |
| **3D (Spatial)** | 3D Vanilla | `spatial` | No | Sí |
| **3D (Spatial)** | 3D Base + Shaders Plus | `spatial` | Sí | Sí |
| **3D (Spatial)** | 3D Escudo Fresnel | `spatial` | Sí | Sí |
| **Post-Procesado** | Pantalla Retro Dithering | `canvas_item` | Sí | Sí |
| **Vanilla (Nativo)** | CanvasItem Vacío | `canvas_item` | No | Sí |
| **Vanilla (Nativo)** | Spatial Vacío | `spatial` | No | Sí |
| **Vanilla (Nativo)** | Particles Vacío | `particles` | No | Sí |
| **Vanilla (Nativo)** | Fog Vacío | `fog` | No | Sí |

• 1. Transformaciones y Coordenadas UV: Incluye funciones como sp_rotate2d, sp_pixelate, sp_twist, sp_scale_centered y sp_aspect_ratio para manipular el espacio UV.
• 2. Procesamiento de Color: Herramientas para ajuste cromático y de tonos, incluyendo sp_grayscale, sp_posterize, sp_brightness, sp_contrast, sp_saturation, sp_hue_shift e sp_invert.
• 3. Ruido y Generadores: Funciones deterministas y osciladores como sp_hash21, sp_value_noise, sp_sine_wave y sp_smooth_pulse.
• 4. Figuras Geométricas 2D: Generación de máscaras y efectos visuales mediante sp_circle, sp_box, sp_ring y sp_vignette.
• 5. Modos de Mezcla (Blending): Operadores de combinación de colores como sp_blend_overlay, sp_blend_multiply, sp_blend_screen y sp_blend_add.
• 6. Máscaras y Proyecciones: Utilidades avanzadas como sp_remap, sp_scanlines, sp_dither_4x4, sp_fresnel, sp_triplanar_uv_x y sp_triplanar_uv_y.
