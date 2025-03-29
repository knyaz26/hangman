extends Node2D

class BloodParticle:
	var position: Vector2
	var velocity: Vector2
	var size: float
	var transparency: float
	var lifetime: float

	func _init():
		position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 1.5
		size = 10
		transparency = 1
		lifetime = 2

	func update(delta_time: float):
		position += velocity * delta_time
		size -= 5 * delta_time
		transparency -= 0.5 * delta_time
		lifetime -= delta_time

	func is_alive() -> bool:
		return lifetime > 0

var particles = []

func _ready():
	for i in range(50):
		particles.append(BloodParticle.new())

func _process(delta):
	for particle in particles:
		if particle.is_alive():
			particle.update(delta)
			draw_circle(particle.position, particle.size, Color(1, 0, 0, particle.transparency))
		else:
			particles.erase(particle)
