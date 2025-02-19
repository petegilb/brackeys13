class_name UIMeter
extends Control
## A UI component intended to show the players nervousness on screen.

### Signals ###

### Enums ###

### Constants ###

### Exported variables ###
@export var player: Player
@export var min_value := 0
@export var max_value := 100
@export var current_value := 100
@export var meter_dimensions := Vector2(100,25)
@export var font_size := 16.0

### Public variables ###

### Private variables ###

var _nervous_component: NervousComponent

### Onready variables ###
@onready var nervous_bar: ProgressBar = $NervousBar
@onready var nervous_bar_label: Label = $NervousBar/NervousProgressLabel
@onready var bar_label: Label = $BarLabel

### Built in virtual methods ###

func _ready() -> void:
	_nervous_component = player.nervous
	nervous_bar.size = meter_dimensions
	nervous_bar_label.size = meter_dimensions
	nervous_bar_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	nervous_bar.value = _nervous_component.nervousness
	nervous_bar_label.text = str(_nervous_component.nervousness)

func _process(_delta: float) -> void:
	_set_value(round(_nervous_component.nervousness))

### Public methods ###

### Private methods ###

func _set_value(new_value: int):
	current_value = clampi(new_value, min_value, max_value)
	nervous_bar.value = current_value
	nervous_bar_label.text = str(current_value)
