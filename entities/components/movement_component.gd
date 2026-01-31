extends Node

@export_group("Components")
@export var velocity_component: VelocityComponent
@export var hurtbox_component: HurtboxComponent
@export var animation_player: AnimationPlayer

@export_group("Animation Names")
@export var anim_walk_up: String = "walk_up"
@export var anim_walk_down: String = "walk_down"
@export var anim_walk_horizontal: String = "walk_horizontal"
@export var anim_idle: String = "idle"
@export var anim_stagger: String = "stagger"

@export_group("Extra options")
@export var stagger_on_hit: bool = true


func _ready() -> void:
	assert(velocity_component != null, "VelocityComponent not assigned in MovementComponent")
	assert(animation_player != null, "AnimationPlayer not assigned in MovementComponent")
	if hurtbox_component != null:
		hurtbox_component.connect("hit_taken", _take_hit)


func _exit_tree() -> void:
	if hurtbox_component != null:
		hurtbox_component.disconnect("hit_taken", _take_hit)


func _process(_delta: float) -> void:
	_animate_movement()


func _animate_movement():
	if velocity_component.velocity.x > 0:
		animation_player.play(anim_walk_horizontal)
		get_parent().scale.x = 1
	elif velocity_component.velocity.x < 0:
		animation_player.play(anim_walk_horizontal)
		get_parent().scale.x = -1
	elif velocity_component.velocity.y > 0:
		animation_player.play(anim_walk_down)
	elif velocity_component.velocity.y < 0:
		animation_player.play(anim_walk_up)
	else:
		animation_player.play(anim_idle)


func _take_hit(hit_box: HitboxComponent) -> void:
	if not stagger_on_hit:
		return
	var direction = (hurtbox_component.global_position - hit_box.position).normalized()
	velocity_component.stagger(direction, hit_box.hit_strength)