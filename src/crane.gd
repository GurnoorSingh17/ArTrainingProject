extends Node3D

@export var Hook:Node3D
@export var MaxHieght:float
@export var MinHieght:float
@export var MoveSpeed : float
@export var Sfx:AudioStreamPlayer3D

func HookUp(delta:float):
	if !Hook.global_position.y>=MaxHieght:
		Hook.global_position.y+=MoveSpeed*delta
		Sfx.play()
	else:
		Sfx.stop()

func HookDown(delta:float):
	if !Hook.global_position.y<=MinHieght:
		Hook.global_position.y-=MoveSpeed*delta
		Sfx.play()
	else:
		Sfx.stop()
