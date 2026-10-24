class_name PathFinding extends Node2D
@onready var timer:Timer=$timer
var bestdirection:Array[float]
var worstdirection:Array[float] = [0,0,0,0,0,0,0,0]
var raycast:Array[RayCast2D]

var vectors:Array[Vector2]=[
	Vector2(0,-1),
	Vector2(1,-1),
	Vector2(1,0),
	Vector2(1,1),
	Vector2(0,1),
	Vector2(-1,1),
	Vector2(-1, 0),
	Vector2(-1,-1)
]

var movement_dir:Vector2=Vector2.ZERO
var best_dir:Vector2=Vector2.ZERO

func _ready() -> void:
	for c in get_children():
		if c is RayCast2D:
			raycast.append(c)
	
	for i in vectors.size():
		vectors[i] = vectors[i].normalized()
		
	_on_timer_timeout()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement_dir = lerp(movement_dir,best_dir,10*delta)
	pass


func _on_timer_timeout() -> void:
	var player_direction:Vector2=global_position.direction_to(get_tree().get_first_node_in_group("player").global_position)
	for i in 8:
		worstdirection[i]=0
	for i in 8:
		if raycast[i].is_colliding():
			worstdirection[i]+=4
			if i != 0:
				worstdirection[i-1]+=1
			else:
				worstdirection[7]+=1
			if i != 7:
				worstdirection[i+1]+=1
			else:
				worstdirection[0]+=1
				
	if worstdirection.max() == 0:
		best_dir=player_direction
		return
	bestdirection.clear()
	for v in vectors:
		bestdirection.append(v.dot(player_direction))
	for i in 8:
		bestdirection[i] -= worstdirection[i]
		
	best_dir = vectors[bestdirection.find(bestdirection.max())]	
