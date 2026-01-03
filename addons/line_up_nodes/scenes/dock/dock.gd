@tool
extends VBoxContainer
## Dock panel UI for the Line Up Nodes plugin
## Provides interface to align selected nodes in horizontal, vertical, or custom directions

# Reference to the parent EditorPlugin
var editor_plugin: EditorPlugin

# Alignment direction enumeration
enum NodeAlignmentMode {
	HORIZONTAL,
	VERTICAL,
	CUSTOM,
}

# UI Control references
var horizontal_radio_button: CheckBox
var vertical_radio_button: CheckBox
var custom_radio_button: CheckBox

var horizontal_distance_input: SpinBox
var vertical_distance_input: SpinBox
var custom_x_distance_input: SpinBox
var custom_y_distance_input: SpinBox

var preserve_selection_order_checkbox: CheckBox

var align_button: Button
var close_button: Button

# Current alignment mode
var current_alignment_mode: NodeAlignmentMode = NodeAlignmentMode.HORIZONTAL

var label_font_size: float


func _ready() -> void:
	_build_ui()
	_connect_signals()
	_update_input_states()


func _build_ui() -> void:
	# Set up the main container
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 8)

	# Header with icon and title
	var header_container := HBoxContainer.new()
	header_container.alignment = BoxContainer.ALIGNMENT_CENTER
	header_container.add_theme_constant_override("separation", 8)

	# Add icon (using Godot's built-in editor icon)
	var icon_texture := TextureRect.new()
	icon_texture.texture = get_theme_icon("Node", "EditorIcons")
	icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	icon_texture.custom_minimum_size = Vector2(24, 24)
	header_container.add_child(icon_texture)

	# Add title label
	var title_label := Label.new()
	title_label.text = "Line Up Nodes"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 20)
	header_container.add_child(title_label)

	add_child(header_container)

	# Add separator
	var separator1 := HSeparator.new()
	add_child(separator1)

	# Alignment Mode Section
	var alignment_mode_label := Label.new()
	alignment_mode_label.text = "Alignment Mode"
	#alignment_mode_label.add_theme_font_size_override("font_size", 14)
	add_child(alignment_mode_label)

	# Horizontal mode
	var horizontal_container := HBoxContainer.new()
	horizontal_radio_button = CheckBox.new()
	horizontal_radio_button.text = "Horizontal"
	horizontal_radio_button.button_pressed = true
	horizontal_container.add_child(horizontal_radio_button)
	add_child(horizontal_container)

	var horizontal_distance_container := HBoxContainer.new()
	horizontal_distance_container.add_theme_constant_override("separation", 8)
	var horizontal_distance_label := Label.new()
	horizontal_distance_label.text = "    Distance:"
	horizontal_distance_label.custom_minimum_size.x = 100
	horizontal_distance_input = SpinBox.new()
	horizontal_distance_input.min_value = -10000
	horizontal_distance_input.max_value = 10000
	horizontal_distance_input.value = 100
	horizontal_distance_input.step = 1
	horizontal_distance_input.custom_minimum_size.x = 150
	horizontal_distance_container.add_child(horizontal_distance_label)
	horizontal_distance_container.add_child(horizontal_distance_input)
	add_child(horizontal_distance_container)

	# Vertical mode
	var vertical_container := HBoxContainer.new()
	vertical_radio_button = CheckBox.new()
	vertical_radio_button.text = "Vertical"
	vertical_container.add_child(vertical_radio_button)
	add_child(vertical_container)

	var vertical_distance_container := HBoxContainer.new()
	vertical_distance_container.add_theme_constant_override("separation", 8)
	var vertical_distance_label := Label.new()
	vertical_distance_label.text = "    Distance:"
	vertical_distance_label.custom_minimum_size.x = 100
	vertical_distance_input = SpinBox.new()
	vertical_distance_input.min_value = -10000
	vertical_distance_input.max_value = 10000
	vertical_distance_input.value = 100
	vertical_distance_input.step = 1
	vertical_distance_input.custom_minimum_size.x = 150
	vertical_distance_container.add_child(vertical_distance_label)
	vertical_distance_container.add_child(vertical_distance_input)
	add_child(vertical_distance_container)

	# Custom mode
	var custom_container := HBoxContainer.new()
	custom_radio_button = CheckBox.new()
	custom_radio_button.text = "Custom"
	custom_container.add_child(custom_radio_button)
	add_child(custom_container)

	var custom_x_distance_container := HBoxContainer.new()
	custom_x_distance_container.add_theme_constant_override("separation", 8)
	var custom_x_distance_label := Label.new()
	custom_x_distance_label.text = "    X Distance:"
	custom_x_distance_label.custom_minimum_size.x = 100
	custom_x_distance_input = SpinBox.new()
	custom_x_distance_input.min_value = -10000
	custom_x_distance_input.max_value = 10000
	custom_x_distance_input.value = 100
	custom_x_distance_input.step = 1
	custom_x_distance_input.custom_minimum_size.x = 150
	custom_x_distance_container.add_child(custom_x_distance_label)
	custom_x_distance_container.add_child(custom_x_distance_input)
	add_child(custom_x_distance_container)

	var custom_y_distance_container := HBoxContainer.new()
	custom_y_distance_container.add_theme_constant_override("separation", 8)
	var custom_y_distance_label := Label.new()
	custom_y_distance_label.text = "    Y Distance:"
	custom_y_distance_label.custom_minimum_size.x = 100
	custom_y_distance_input = SpinBox.new()
	custom_y_distance_input.min_value = -10000
	custom_y_distance_input.max_value = 10000
	custom_y_distance_input.value = 100
	custom_y_distance_input.step = 1
	custom_y_distance_input.custom_minimum_size.x = 150
	custom_y_distance_container.add_child(custom_y_distance_label)
	custom_y_distance_container.add_child(custom_y_distance_input)
	add_child(custom_y_distance_container)

	# Add separator
	var separator2 := HSeparator.new()
	add_child(separator2)

	# Ordering Section
	var ordering_label := Label.new()
	ordering_label.text = "Ordering"
	#ordering_label.add_theme_font_size_override("font_size", 14)
	add_child(ordering_label)

	preserve_selection_order_checkbox = CheckBox.new()
	preserve_selection_order_checkbox.text = "Preserve Selection Order"
	preserve_selection_order_checkbox.button_pressed = true
	add_child(preserve_selection_order_checkbox)

	# Add separator
	var separator3 := HSeparator.new()
	add_child(separator3)

	# Action buttons
	var button_container := HBoxContainer.new()
	button_container.add_theme_constant_override("separation", 8)

	align_button = Button.new()
	align_button.text = "Align Nodes"
	align_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_container.add_child(align_button)

	close_button = Button.new()
	close_button.text = "Close"
	button_container.add_child(close_button)

	add_child(button_container)

	# Add spacer to push everything to the top
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(spacer)


func _connect_signals() -> void:
	# Connect radio button toggled signals to handle mutual exclusivity
	horizontal_radio_button.toggled.connect(_on_horizontal_radio_toggled)
	vertical_radio_button.toggled.connect(_on_vertical_radio_toggled)
	custom_radio_button.toggled.connect(_on_custom_radio_toggled)

	# Connect action buttons
	align_button.pressed.connect(_on_align_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)


func _on_horizontal_radio_toggled(button_pressed: bool) -> void:
	if button_pressed:
		current_alignment_mode = NodeAlignmentMode.HORIZONTAL
		vertical_radio_button.button_pressed = false
		custom_radio_button.button_pressed = false
		_update_input_states()


func _on_vertical_radio_toggled(button_pressed: bool) -> void:
	if button_pressed:
		current_alignment_mode = NodeAlignmentMode.VERTICAL
		horizontal_radio_button.button_pressed = false
		custom_radio_button.button_pressed = false
		_update_input_states()


func _on_custom_radio_toggled(button_pressed: bool) -> void:
	if button_pressed:
		current_alignment_mode = NodeAlignmentMode.CUSTOM
		horizontal_radio_button.button_pressed = false
		vertical_radio_button.button_pressed = false
		_update_input_states()


func _update_input_states() -> void:
	# Enable/disable inputs based on the current alignment mode
	horizontal_distance_input.editable = (current_alignment_mode == NodeAlignmentMode.HORIZONTAL)
	vertical_distance_input.editable = (current_alignment_mode == NodeAlignmentMode.VERTICAL)
	custom_x_distance_input.editable = (current_alignment_mode == NodeAlignmentMode.CUSTOM)
	custom_y_distance_input.editable = (current_alignment_mode == NodeAlignmentMode.CUSTOM)


func _on_align_button_pressed() -> void:
	_perform_alignment()


func _on_close_button_pressed() -> void:
	# Remove the dock from the editor
	if editor_plugin:
		editor_plugin.remove_control_from_docks(self)
		queue_free()


func _perform_alignment() -> void:
	# Get the current editor selection using EditorInterface
	var editor_interface := editor_plugin.get_editor_interface()
	var editor_selection := editor_interface.get_selection()
	var selected_nodes := editor_selection.get_selected_nodes()

	# Validate selection: need at least 2 nodes
	if selected_nodes.size() < 2:
		printerr("Line Up Nodes: At least 2 nodes must be selected")
		return

	# Filter to only nodes with positional data (Node2D or Node3D)
	var positional_nodes: Array[Node] = []
	for node in selected_nodes:
		if node is Node2D or node is Node3D:
			positional_nodes.append(node)

	if positional_nodes.size() < 2:
		printerr("Line Up Nodes: At least 2 Node2D or Node3D nodes must be selected")
		return

	# Sort nodes if not preserving selection order
	if not preserve_selection_order_checkbox.button_pressed:
		_sort_nodes_by_position(positional_nodes)

	# Get the anchor node (first node in the list)
	var anchor_node := positional_nodes[0]

	# Calculate the offset vector based on alignment mode
	var offset_vector := _get_offset_vector()

	# Use UndoRedo system for editor integration
	var undo_redo := editor_plugin.get_undo_redo()
	undo_redo.create_action("Align Nodes")

	# Apply alignment to each node after the anchor
	for i in range(1, positional_nodes.size()):
		var current_node := positional_nodes[i]
		var new_position := _calculate_new_position(anchor_node, offset_vector, i)

		# Record the undo/redo actions based on node type
		if current_node is Node2D:
			var node_2d := current_node as Node2D
			undo_redo.add_do_property(node_2d, "position", new_position)
			undo_redo.add_undo_property(node_2d, "position", node_2d.position)
		elif current_node is Node3D:
			var node_3d := current_node as Node3D
			undo_redo.add_do_property(node_3d, "global_position", new_position)
			undo_redo.add_undo_property(node_3d, "global_position", node_3d.global_position)

	undo_redo.commit_action()


func _get_offset_vector() -> Vector2:
	# Returns the offset vector based on the current alignment mode
	match current_alignment_mode:
		NodeAlignmentMode.HORIZONTAL:
			return Vector2(horizontal_distance_input.value, 0)
		NodeAlignmentMode.VERTICAL:
			return Vector2(0, vertical_distance_input.value)
		NodeAlignmentMode.CUSTOM:
			return Vector2(custom_x_distance_input.value, custom_y_distance_input.value)

	return Vector2.ZERO


func _calculate_new_position(anchor_node: Node, offset_vector: Vector2, step_index: int) -> Variant:
	# Calculates the new position for a node based on cumulative offset from anchor
	# Returns Vector2 for Node2D or Vector3 for Node3D

	var cumulative_offset := offset_vector * step_index

	if anchor_node is Node2D:
		var anchor_position := (anchor_node as Node2D).position
		return anchor_position + cumulative_offset
	elif anchor_node is Node3D:
		var anchor_position := (anchor_node as Node3D).global_position
		# For 3D nodes, apply offset in the XY plane (Z remains unchanged)
		return Vector3(
			anchor_position.x + cumulative_offset.x,
			anchor_position.y + cumulative_offset.y,
			anchor_position.z,
		)

	return Vector2.ZERO


func _sort_nodes_by_position(nodes: Array[Node]) -> void:
	# Sorts nodes by their position along the chosen axis
	# Uses in-place sorting with a custom comparator

	match current_alignment_mode:
		NodeAlignmentMode.HORIZONTAL:
			# Sort by X coordinate
			nodes.sort_custom(
				func(a: Node, b: Node) -> bool:
					var pos_a := _get_node_primary_position(a)
					var pos_b := _get_node_primary_position(b)
					return pos_a.x < pos_b.x
			)
		NodeAlignmentMode.VERTICAL:
			# Sort by Y coordinate
			nodes.sort_custom(
				func(a: Node, b: Node) -> bool:
					var pos_a := _get_node_primary_position(a)
					var pos_b := _get_node_primary_position(b)
					return pos_a.y < pos_b.y
			)
		NodeAlignmentMode.CUSTOM:
			# For custom mode, sort by the combined distance
			# This uses the magnitude of the position projection onto the offset direction
			var offset := _get_offset_vector()
			var offset_normalized := offset.normalized()
			nodes.sort_custom(
				func(a: Node, b: Node) -> bool:
					var pos_a := _get_node_primary_position(a)
					var pos_b := _get_node_primary_position(b)
					var projection_a := pos_a.dot(offset_normalized)
					var projection_b := pos_b.dot(offset_normalized)
					return projection_a < projection_b
			)


func _get_node_primary_position(node: Node) -> Vector2:
	# Gets the position of a node as a Vector2 (for sorting purposes)
	if node is Node2D:
		return (node as Node2D).position
	elif node is Node3D:
		var pos_3d := (node as Node3D).global_position
		return Vector2(pos_3d.x, pos_3d.y)

	return Vector2.ZERO
