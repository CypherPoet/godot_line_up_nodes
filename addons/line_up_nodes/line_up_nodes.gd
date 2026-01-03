@tool
extends EditorPlugin
## EditorPlugin that adds a dock panel for aligning selected nodes in a straight line.
## Supports horizontal, vertical, and custom vector alignment modes.

var dock_panel: Control


func _enter_tree() -> void:
	# Create and register the dock panel when the plugin is enabled
	dock_panel = preload("uid://ds8vjpui6u6rt").new()
	dock_panel.editor_plugin = self

	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock_panel)


func _exit_tree() -> void:
	# Unregister and clean up the dock panel when the plugin is disabled
	if dock_panel:
		remove_control_from_docks(dock_panel)
		dock_panel.queue_free()
