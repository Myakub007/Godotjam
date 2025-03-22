extends Area2D

signal hit # sends signal to editor after a collision ,custom signal

@export var speed = 400 #pixels move per frame
var screen_size #Size of screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO #sets velocity of the player to zero as a vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"): # positive y-axis is downwards
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO,screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v =false
		$AnimatedSprite2D.flip_h = velocity.x <0
		
	elif velocity.y!=0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	# below line deffered -> disable collision so that only 1 hit is taken at a time
	$CollisionShape2D.set_deferred("disabled",true)
	#deferred waits until collision is processed
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	#reset the position and collision detection to default at start of game 
	
	
