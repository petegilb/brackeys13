extends Control

@onready var resume_button: Button = $PanelContainer/VBoxContainer/ResumeButton
@onready var restart_button: Button = $PanelContainer/VBoxContainer/RestartButton
@onready var quit_button: Button = $PanelContainer/VBoxContainer/QuitButton

func _ready() -> void:
    resume_button.button_down.connect(_resume_button)
    restart_button.button_down.connect(_restart_button)
    quit_button.button_down.connect(_quit_button)

func _resume_button() -> void:
    Global._pause_game(false)
    self.visible = false

func _restart_button() -> void:
    print('restarting game')
    Global.game_paused = false
    Global.main.load_level_by_id('level1')

func _quit_button() -> void:
    print('quitting game')
    Global.quit_game()
