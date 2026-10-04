@tool
extends EditorPlugin

var _dialog: ConfirmationDialog
var _category_opt: OptionButton
var _template_opt: OptionButton
var _name_input: LineEdit
var _path_input: LineEdit
var _info_label: Label

const TEMPLATES = {
	"2D (CanvasItem)": [
		{"name": "2D Vanilla (Godot Limpio)", "type": "canvas_item", "inc": false, "code": "void fragment() {\n\t// COLOR = texture(TEXTURE, UV);\n}"},
		{"name": "2D Base + Shaders Plus", "type": "canvas_item", "inc": true, "code": "void fragment() {\n\tvec2 rot_uv = sp_rotate2d(UV, TIME * 0.5);\n\tvec4 tex = texture(TEXTURE, rot_uv);\n\tCOLOR = vec4(tex.rgb, tex.a);\n}"},
		{"name": "2D Efecto CRT / Scanlines", "type": "canvas_item", "inc": true, "code": "uniform float density : hint_range(10.0, 300.0) = 120.0;\n\nvoid fragment() {\n\tvec4 tex = texture(TEXTURE, UV);\n\tfloat scan = sp_scanlines(UV, density, 0.3);\n\tfloat vig = sp_vignette(UV, 0.4, 0.5);\n\tCOLOR = vec4(tex.rgb * scan * vig, tex.a);\n}"},
		{"name": "2D Ondas y Distorsión de Agua", "type": "canvas_item", "inc": true, "code": "uniform float wave_speed : hint_range(0.1, 10.0) = 2.0;\nuniform float wave_freq : hint_range(1.0, 50.0) = 15.0;\n\nvoid fragment() {\n\tvec2 uv = UV;\n\tuv.x += sp_sine_wave(uv.y, wave_freq, wave_speed, TIME) * 0.02;\n\tCOLOR = texture(TEXTURE, uv);\n}"}
	],
	"3D (Spatial)": [
		{"name": "3D Vanilla (Godot Limpio)", "type": "spatial", "inc": false, "code": "void fragment() {\n\t// ALBEDO = vec3(1.0);\n}"},
		{"name": "3D Base + Shaders Plus", "type": "spatial", "inc": true, "code": "void fragment() {\n\tfloat noise = sp_value_noise(UV * 10.0 + TIME);\n\tALBEDO = vec3(noise);\n}"},
		{"name": "3D Escudo de Fuerza / Fresnel", "type": "spatial", "inc": true, "code": "render_mode blend_add, depth_draw_opaque, cull_disabled;\nuniform vec4 color : source_color = vec4(0.2, 0.7, 1.0, 1.0);\n\nvoid fragment() {\n\tfloat f = sp_fresnel(4.0, NORMAL, VIEW);\n\tfloat pulse = sp_smooth_pulse(0.8, 1.2, 3.0, TIME);\n\tALBEDO = color.rgb * pulse;\n\tALPHA = f * color.a;\n}"}
	],
	"Post-Procesado (Screen Shader)": [
		{"name": "Pantalla Retro Dithering & Posterizado", "type": "canvas_item", "inc": true, "code": "uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;\n\nvoid fragment() {\n\tvec4 sc = texture(screen_texture, SCREEN_UV);\n\tvec3 post = sp_posterize(sc.rgb, 8.0);\n\tfloat dither = sp_dither_4x4(FRAGCOORD.xy, sp_grayscale(post).r);\n\tCOLOR = vec4(post * dither, sc.a);\n}"}
	],
	"Vanilla (Nativo Godot)": [
		{"name": "CanvasItem Vacío", "type": "canvas_item", "inc": false, "code": "void fragment() {\n\t// Shader nativo 2D\n}"},
		{"name": "Spatial Vacío", "type": "spatial", "inc": false, "code": "void fragment() {\n\t// Shader nativo 3D\n}"},
		{"name": "Particles Vacío", "type": "particles", "inc": false, "code": "void process() {\n\t// Shader nativo de partículas\n}"},
		{"name": "Fog (Niebla 3D) Vacío", "type": "fog", "inc": false, "code": "void fog() {\n\t// Shader nativo de niebla\n}"}
	]
}

func _enter_tree() -> void:
	add_tool_menu_item("Shaders Plus: Crear Nuevo Shader...", _open_wizard)
	_build_ui()

func _exit_tree() -> void:
	remove_tool_menu_item("Shaders Plus: Crear Nuevo Shader...")
	if is_instance_valid(_dialog):
		_dialog.queue_free()

func _build_ui() -> void:
	_dialog = ConfirmationDialog.new()
	_dialog.title = "Shaders Plus v2.1 - Creador de Shaders"
	_dialog.size = Vector2i(520, 360)
	_dialog.ok_button_text = "Crear Shader"

	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 12)

	# Categoría
	var cat_hbox = HBoxContainer.new()
	var cat_lbl = Label.new()
	cat_lbl.text = "Categoría de Shader:"
	cat_lbl.custom_minimum_size.x = 160
	_category_opt = OptionButton.new()
	_category_opt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for cat in TEMPLATES.keys():
		_category_opt.add_item(cat)
	_category_opt.item_selected.connect(_on_category_changed)
	cat_hbox.add_child(cat_lbl)
	cat_hbox.add_child(_category_opt)
	main_vbox.add_child(cat_hbox)

	# Plantilla / Preset
	var tpl_hbox = HBoxContainer.new()
	var tpl_lbl = Label.new()
	tpl_lbl.text = "Plantilla / Preajuste:"
	tpl_lbl.custom_minimum_size.x = 160
	_template_opt = OptionButton.new()
	_template_opt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_template_opt.item_selected.connect(_on_template_changed)
	tpl_hbox.add_child(tpl_lbl)
	tpl_hbox.add_child(_template_opt)
	main_vbox.add_child(tpl_hbox)

	# Nombre de archivo
	var name_hbox = HBoxContainer.new()
	var name_lbl = Label.new()
	name_lbl.text = "Nombre del archivo:"
	name_lbl.custom_minimum_size.x = 160
	_name_input = LineEdit.new()
	_name_input.text = "mi_nuevo_shader"
	_name_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_hbox.add_child(name_lbl)
	name_hbox.add_child(_name_input)
	main_vbox.add_child(name_hbox)

	# Carpeta de destino
	var path_hbox = HBoxContainer.new()
	var path_lbl = Label.new()
	path_lbl.text = "Guardar en carpeta:"
	path_lbl.custom_minimum_size.x = 160
	_path_input = LineEdit.new()
	_path_input.text = "res://"
	_path_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	path_hbox.add_child(path_lbl)
	path_hbox.add_child(_path_input)
	main_vbox.add_child(path_hbox)

	# Etiqueta informativa
	_info_label = Label.new()
	_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info_label.modulate = Color(0.4, 0.8, 1.0)
	main_vbox.add_child(_info_label)

	_dialog.add_child(main_vbox)
	_dialog.confirmed.connect(_generate_shader)

	EditorInterface.get_base_control().add_child(_dialog)
	_update_templates()

func _open_wizard() -> void:
	_dialog.popup_centered()

func _on_category_changed(_idx: int) -> void:
	_update_templates()

func _on_template_changed(_idx: int) -> void:
	_update_info()

func _update_templates() -> void:
	_template_opt.clear()
	var cat_name = _category_opt.get_item_text(_category_opt.selected)
	var list = TEMPLATES[cat_name]
	for item in list:
		_template_opt.add_item(item["name"])
	_update_info()

func _update_info() -> void:
	var cat_name = _category_opt.get_item_text(_category_opt.selected)
	var list = TEMPLATES[cat_name]
	if _template_opt.selected >= 0 and _template_opt.selected < list.size():
		var tpl = list[_template_opt.selected]
		var inc_text = "Incluye librería (#include)" if tpl["inc"] else "Shader Vanilla Estándar"
		_info_label.text = "Tipo: %s | %s" % [tpl["type"], inc_text]

func _generate_shader() -> void:
	var cat_name = _category_opt.get_item_text(_category_opt.selected)
	var tpl = TEMPLATES[cat_name][_template_opt.selected]
	
	var raw_name = _name_input.text.strip_edges()
	if not raw_name.ends_with(".gdshader"):
		raw_name += ".gdshader"
		
	var target_folder = _path_input.text.strip_edges()
	if not target_folder.ends_with("/"):
		target_folder += "/"
		
	var full_path = target_folder + raw_name
	
	var content = "shader_type %s;\n\n" % tpl["type"]
	if tpl["inc"]:
		content += '#include "res://addons/shaders_plus/shaders_plus.gdshaderinc"\n\n'
	content += tpl["code"] + "\n"
	
	var file = FileAccess.open(full_path, FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()
		print("[Shaders Plus] Shader creado con éxito en: ", full_path)
		
		# Refresca el panel de archivos de Godot
		EditorInterface.get_resource_filesystem().scan()
		
		# Carga el recurso recién creado y abre automáticamente la pestaña Editor de Shaders
		var new_shader = ResourceLoader.load(full_path)
		if new_shader:
			EditorInterface.edit_resource(new_shader)
	else:
		printerr("[Shaders Plus] Error al crear el archivo en: ", full_path)
