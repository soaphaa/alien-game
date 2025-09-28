extends CharacterBody2D
@export var speed = 250

func _physics_process(delta):
	if not get_parent().game_running:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.animation = "idle"
		move_and_slide()
		return
		
		
	if !is_on_wall():
		$AnimatedSprite2D.animation = "run"
		velocity.x = speed
			
	var vertical_direction =Input.get_axis("move_up", "move_down")
	velocity.y = 300 * vertical_direction
	
	print(velocity)
	
	move_and_slide()
