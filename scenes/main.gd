extends Node3D

const MAINMENU = preload("res://ui/main_menu/main_menu.tscn")
const TESTSCENE = preload("res://scenes/test.tscn")

const LEVELS = {
    'mainmenu': MAINMENU,
    'test': TESTSCENE
}

var current_level : Node

func _ready() -> void:
    if not MAINMENU:
        printerr("main menu scene resource path is incorrect")
        get_tree().quit()
    
    current_level = MAINMENU.instantiate()
    self.add_child(current_level)

func load_level(level_resource : Resource) -> void:
    if current_level:
        unload_level()
    
    if not level_resource:
        printerr("level resource is not defined, level cannot be loaded...")
    
    current_level = level_resource.instantiate()
    self.add_child(current_level)
    
func unload_level() -> void:
    if is_instance_valid(current_level):
        current_level.queue_free()
    current_level = null

func load_level_by_id(level_id: String):
    load_level(LEVELS.get(level_id))
