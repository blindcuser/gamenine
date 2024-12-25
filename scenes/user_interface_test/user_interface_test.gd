extends Control



func _on_button_rotate_camera_right_pressed() -> void:
	GlobalSignal.action_view_rotate_camera_right.emit()


func _on_button_rotate_camera_left_pressed() -> void:
	GlobalSignal.action_view_rotate_camera_left.emit()
