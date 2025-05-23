extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_time: Timer = $coyote_time
@onready var jump_buffer_timer: Timer = $jump_buffer_timer


@export var buffer_time : float
@export var coyote : float

var can_jump : bool = true
var jump_buffer : bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		animation_player.play("jump")

	if Input.is_action_just_pressed("ui_accept"):
		if can_jump:
			jump()
		else :
			jump_buffer = true
			jump_buffer_timer.start(buffer_time)
	
	if is_on_floor():
		can_jump = true
		coyote_time.stop()
		
		if jump_buffer:
			jump()
			jump_buffer = false
		
	else :
		if coyote_time.is_stopped():
			coyote_time.start(coyote)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false
		velocity.x = direction * SPEED
		animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			animation_player.play("idle")

	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY
	can_jump = false


func _on_coyote_time_timeout() -> void:
	can_jump = false
	coyote_time.stop()


func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer = false
