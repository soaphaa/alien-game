extends Node

#preloading obstacles
var obstacles_scene = preload("res://scenes/obstacles.tscn")
var obs_types = ["chicken", "cow", "pig", "sheep"]
var obstacles = []

var spawn_timer : float = 0.0
const SPAWN_INTERVAL : float = 2.0  # seconds
var spawn_x
var spawn_y

var score : int

#game variables
const ALIEN_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)
const SCORE_MODIFIER : int = 10
var speed : float
const START_SPEED : float = 2.0
var screen_size : Vector2i
var game_running : bool
var lastobs
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()
	pass # Replace with function body.

func new_game():
	#reset variables
	score = 0
	game_running = false
	
	$alien.position = Vector2(ALIEN_START_POS)
	$alien.velocity = Vector2i(0,0)
	$Camera2D.position = Vector2(CAM_START_POS)
	$ground.position = Vector2i(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		#speed
		speed = START_SPEED
		
		#generate obstacles
		generate_obs()
		
	#Ensure alien and cam move simultaneously
		$alien.position.x += speed
		$Camera2D.position.x = $alien.position.x + 200 #camera follows alien
		
		# move all obstacles left
		for obs in obstacles:
			obs.position.x -= speed
		
		if score >= 1000: 
			game_running = false;
		else: score += speed
		show_score()
		
		# spawn obstacles on interval
		spawn_timer += delta
		if spawn_timer >= SPAWN_INTERVAL:
			generate_obs()
			spawn_timer = 0.0
		
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HowToPlay.get_node("tutorialLabel").hide()
		
func generate_obs():
	if obstacles.is_empty():
		var obs = obstacles_scene.instantiate()  # instance obstacle scene
		var rng_obs = obs_types[randi() % obs_types.size()]  # pick a random animation
		
		# set the AnimatedSprite2D animation (replace 'AnimatedSprite2D' with your node's actual name)
		obs.get_node("AnimatedSprite2D").animation = rng_obs
		obs.get_node("AnimatedSprite2D").play()
		
		var obs_scale = obs.get_node("AnimatedSprite2D").scale
		 # spawn offscreen to the right
		spawn_x = screen_size.x + 100  # 50 pixels offscreen
		var min_y = 250
		var max_y = 550
		spawn_y = randf_range(min_y, max_y)  # returns a float between 215 and 550
		add_obs(obs, spawn_x, spawn_y)
	
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	# add to scene and track
	lastobs = obs
	add_child(obs)
	obstacles.append(obs)
	
		
func show_score():
	$HowToPlay.get_node("scoreLabel").text = "SCORE: " + str(score)
