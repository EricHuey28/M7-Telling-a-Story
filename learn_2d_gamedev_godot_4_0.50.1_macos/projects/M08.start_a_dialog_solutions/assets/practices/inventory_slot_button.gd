@tool
class_name InventorySlotButton extends PanelContainer

signal pressed

var _text_label := Label.new()
var _texture_rect := TextureRect.new()
var _amount_label := Label.new()
var _price_label := Label.new()
var _coin_image := TextureRect.new()
var _times_image := TextureRect.new()
var _bottom_numbers_container := HBoxContainer.new()

@export var text := "": set = set_text
@export var amount := 0: set = set_amount
@export var price := 0: set = set_price

var texture: Texture = null: set = set_texture

var colors_list: Array[Color] = [
	Color.html("10B2EF"),
	Color.html("FF417D"),
	Color.html("FFD500"),
	Color.html("9FDD51")
]

func _init() -> void:
	custom_minimum_size = Vector2(160, 190)
	theme_type_variation = "InventorySlotPanel"
	var v_box_container := VBoxContainer.new()
	v_box_container.theme_type_variation = "InventorySlotVBoxContainer"
	v_box_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v_box_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	v_box_container.add_child(_text_label)
	
	_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_texture_rect.size_flags_vertical = SIZE_EXPAND_FILL
	_texture_rect.size_flags_horizontal = SIZE_EXPAND_FILL
	_texture_rect.modulate = colors_list.pick_random()
	
	v_box_container.add_child(_texture_rect)
	
	_times_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_times_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_times_image.custom_minimum_size = Vector2.ONE * 16
	_times_image.texture = PracticeIcons.get_texture("times")
	_bottom_numbers_container.add_child(_times_image)
	
	_bottom_numbers_container.add_child(_amount_label)
	
	var expander := Control.new()
	expander.custom_minimum_size = Vector2(32, 32)
	expander.size_flags_horizontal = SIZE_EXPAND_FILL
	_bottom_numbers_container.add_child(expander)
	
	_coin_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_coin_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_coin_image.custom_minimum_size = Vector2(32, 32)
	_coin_image.texture = PracticeIcons.get_texture("coins")
	_bottom_numbers_container.add_child(_coin_image)
	
	_bottom_numbers_container.add_child(_price_label)
	_bottom_numbers_container.hide()
	
	
	v_box_container.add_child(_bottom_numbers_container)
	v_box_container.propagate_call("set_mouse_filter", [MOUSE_FILTER_IGNORE], true)
	
	var button := Button.new()
	button.theme_type_variation = "InventorySlotButton"
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	button.pressed.connect(func() -> void:
		pressed.emit()
	)
	
	add_child(button)
	add_child(v_box_container)
	_determine_bottom_box_visibility()


func set_texture(new_texture: Texture) -> void:
	texture = new_texture
	_texture_rect.texture = texture
	_texture_rect.modulate = colors_list.pick_random()


func set_text(new_text: String) -> void:
	text = new_text
	_text_label.text = text
	texture = PracticeIcons.get_texture(text)
	_determine_bottom_box_visibility()

func set_amount(new_amount: int) -> void:
	amount = new_amount
	_amount_label.text = str(amount)
	_determine_bottom_box_visibility()
		

func set_price(new_price: int) -> void:
	price = new_price
	_price_label.text = str(price)
	_determine_bottom_box_visibility()
	

func _determine_bottom_box_visibility() -> void:
	_text_label.visible = text.length() > 0
	
	_price_label.visible = price > 0
	_coin_image.visible = price > 0
	_amount_label.visible = amount > 0
	_times_image.visible = amount > 0
	
	_bottom_numbers_container.visible = price > 0 or amount > 0
