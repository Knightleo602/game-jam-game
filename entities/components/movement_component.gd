class_name MovementComponent extends Node

@export_group("Components")
@export var velocity_component: VelocityComponent
@export var hurtbox_component: HurtboxComponent
@export var animated_sprite: AnimatedSprite2D

@export_group("Animation Names")
@export var anim_walk_up: String = "walk_up"
@export var anim_walk_down: String = "walk_down"
@export var anim_walk_horizontal: String = "walk_horizontal"
@export var anim_idle: String = "idle"
@export var anim_stagger: String = "stagger"

@export_group("Extra options")
@export var stagger_on_hit: bool = true
@export var animate = true


func _ready() -> void:
	assert(velocity_component != null, "VelocityComponent not assigned in MovementComponent")
	assert(animated_sprite != null, "AnimatedSprite2D not assigned in MovementComponent")
	if hurtbox_component != null:
		hurtbox_component.connect("hit_taken", _take_hit)


func _exit_tree() -> void:
	if hurtbox_component != null:
		hurtbox_component.disconnect("hit_taken", _take_hit)

func move(character: CharacterBody2D, direction: Vector2):
	velocity_component.accelerate_towards(direction)
	velocity_component.move(character)

func animate_movement():
	if not animate:
		return
	if velocity_component.velocity.x > 0:
		animated_sprite.play(anim_walk_horizontal)
		animated_sprite.scale.x = 1
	elif velocity_component.velocity.x < 0:
		animated_sprite.play(anim_walk_horizontal)
		animated_sprite.scale.x = -1
	elif velocity_component.velocity.y > 0:
		animated_sprite.play(anim_walk_down)
	elif velocity_component.velocity.y < 0:
		animated_sprite.play(anim_walk_up)
	else:
		animated_sprite.play(anim_idle)


func _take_hit(hit_box: HitboxComponent) -> void:
	if not stagger_on_hit:
		return
	var direction = (hurtbox_component.global_position - hit_box.position).normalized()
	velocity_component.stagger(direction, hit_box.hit_strength)
