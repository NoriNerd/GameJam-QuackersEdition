class_name Player
extends Area2D

export var speed = 100
var screen_size

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum State {IDLE, WALK, INTERACT}
# Called when the node enters the scene tree for the first time.
var _state: int = State.IDLE
func _ready():
	screen_size = get_viewport_rect().size
	SignalBus.connect("interact", self, "on_interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if _state != State.INTERACT:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
			
	#Update velocity to match speed//
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	$AnimatedSprite.play()

#Prevent duck from leaving screen [Probably remove when camera following happens]
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

#Animations and State Handling
	if _state == State.IDLE:
		$AnimatedSprite.animation = "idle"
		if velocity.x != 0 or velocity.y != 0:
			_state = State.WALK
			
	elif _state == State.WALK:
		if velocity.x == 0 and velocity.y == 0:
			_state = State.IDLE
		elif velocity.x != 0:
			$AnimatedSprite.animation = "walk_horizontal"
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y != 0:
			if velocity.y < 0:
				$AnimatedSprite.animation = "up"
			else:
				$AnimatedSprite.animation = "down"
	
	elif _state == State.INTERACT:
		$AnimatedSprite.animation = "idle"
			



func on_interact():
	if _state != State.INTERACT:
		_state = State.INTERACT
	else:
		_state = State.IDLE
		
