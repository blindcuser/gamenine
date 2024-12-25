extends CharacterBody3D

var direction:Vector3 = Vector3.FORWARD

const SPEED = 200.0


func _physics_process(delta: float) -> void:
	
	self.velocity = direction * SPEED * delta
		
	move_and_slide()
	
func set_direction(_direction:Vector3) -> void:
	self.direction = _direction
	
func get_direction() -> Vector3:
	return self.direction
