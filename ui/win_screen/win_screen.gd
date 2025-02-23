extends Control

@onready var restart_button: Button = $PanelContainer/VBoxContainer/RestartButton
@onready var quit_button: Button = $PanelContainer/VBoxContainer/QuitButton

func _ready() -> void:
    restart_button.button_down.connect(_restart_button)
    quit_button.button_down.connect(_quit_button)

func _restart_button() -> void:
    print('restarting game')
    Global.game_paused = false
    Global.main.load_level_by_id('level1')

func _quit_button() -> void:
    print('quitting game')
    Global.quit_game()
