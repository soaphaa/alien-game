extends Button



func _on_pressed() -> void:
 get_tree().change_scene_to_file("res://main_map.tscn")


func _on_story_button_pressed() -> void:
 get_tree().change_scene_to_file("res://story_screen.tscn")
