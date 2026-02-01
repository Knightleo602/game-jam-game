class_name MovementComponent extends Node

@export_group("Components")
@export var velocity_component: VelocityComponent
@export var hurtbox_component: HurtboxComponent
@export var animated_sprite: AnimatedSprite2D
@export var knockback_component: KnockbackComponent

@export_group("Animation Names")
@export var anim_walk_up: String = "walk_up"
@export var anim_walk_down: String = "walk_down"
@export var anim_walk_horizontal: String = "walk_horizontal"
@export var anim_idle: String = "idle"
@export var anim_stagger: String = "stagger"


func _ready() -> void:
	assert(velocity_component != null, "VelocityComponent not assigned in MovementComponent")
	assert(animated_sprite != null, "AnimatedSprite2D not assigned in MovementComponent")
	assert(knockback_component != null, "KnockbackComponent not assigned in MovementComponent")
	if hurtbox_component != null:
		hurtbox_component.connect("hit_taken", _take_hit)


func _exit_tree() -> void:
	if hurtbox_component != null:
		hurtbox_component.disconnect("hit_taken", _take_hit)


func move(character: CharacterBody2D, direction: Vector2, delta: float = get_physics_process_delta_time()) -> void:
	if knockback_component.is_knockback_ative():
		knockback_component.move_knockback(character, delta)
		velocity_component.velocity = knockback_component.get_velocity()
	else:
		velocity_component.accelerate_towards(direction, delta)
		velocity_component.move(character)
	character.move_and_slide()


func animate_movement():
	if velocity_component.velocity.x > 10:
		# animated_sprite.play(anim_walk_horizontal)
		animated_sprite.scale.x = -1
		animated_sprite.play("walk")
	elif velocity_component.velocity.x < -10:
		# animated_sprite.play(anim_walk_horizontal)
		animated_sprite.scale.x = 1
		animated_sprite.play("walk")
	# elif velocity_component.velocity.y > 0:
		# animated_sprite.play(anim_walk_down)
	# elif velocity_component.velocity.y < 0:
	 	# animated_sprite.play(anim_walk_up)
	else:
		animated_sprite.play(anim_idle)


func _take_hit(hit_box: HitboxComponent) -> void:
	var direction = (hurtbox_component.global_position - hit_box.hit_source.global_position).normalized()
	# animated_sprite.play(anim_stagger)
	knockback_component.knockback(direction, hit_box.hit_strength)
