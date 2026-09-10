extends Control


@export var Crane:Node3D
var PressedUp:bool
var PressedDown:bool


func _physics_process(delta: float) -> void:
	if PressedDown:
		Crane.HookDown(delta)
	if PressedUp:
		Crane.HookUp(delta)


func _on_down_button_down() -> void:
	PressedDown = true
	Crane.Sfx.play()


func _on_down_button_up() -> void:
	PressedDown = false
	Crane.Sfx.stop()


func _on_up_button_down() -> void:
	PressedUp = true
	Crane.Sfx.play()

func _on_up_button_up() -> void:
	PressedUp = false
	Crane.Sfx.stop()
