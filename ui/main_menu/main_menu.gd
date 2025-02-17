extends Control

@onready var play_button : Button = $PanelContainer/MarginContainer/VBoxContainer/PlayButton
@onready var quit_button : Button = $PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
    play_button.button_down.connect(_play_button)
    quit_button.button_down.connect(_quit_button)

func _play_button() -> void:
    Global.main.load_level_by_id('test')

func _quit_button() -> void:
    Global.quit_game()
