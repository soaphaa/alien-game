extends CharacterBody2D
@export var speed = 300
@export var climb_speed = 300
@export var gravity = 30
@export var jump_velocity = -400

var on_ladder : bool
var climbing: bool 

@onready var anim = $AnimatedSprite2D

func _on_body_entered(_body: Node2D):
	on_ladder = true

func _on_body_exited(_body: Node2D):
	on_ladder = false
	anim.play('standing')

func _physics_process(delta: float) -> void:
	var grounded = is_on_floor()
	var horizontal_dir = Input.get_axis('move_left', 'move_right')
	
	if on_ladder: 
		var vertical_dir = Input.get_axis('move_up', 'move_down')
		if vertical_dir:
			velocity.y = vertical_dir * climb_speed
			climbing = not grounded
		else:
			velocity.y = move_toward(velocity.y, 0, climb_speed)
			if grounded: climbing = false
		if climbing:
			if vertical_dir: anim.play('climbing')
			else: anim.pause()
	elif not grounded:
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed('jump') and not climbing:
		velocity.y = jump_velocity
		
	if horizontal_dir:
		velocity.x = speed * horizontal_dir
		if on_ladder: climbing = not grounded
		else: climbing = false
	else: 
		velocity.x = move_toward(velocity.x, 0, speed)
		if not climbing: anim.play('standing')
		
	if grounded and horizontal_dir: 
		if Input.is_action_pressed("move_right"):
			anim.play('running')
		elif Input.is_action_pressed("move_left"):
			anim.play('running_backwards')
	
	move_and_slide()
	
	print(velocity)


func _on_laser_mesh_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
