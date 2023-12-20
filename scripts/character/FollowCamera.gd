extends Camera3D

const MAX_ZOOM_DISTANCE := 24.0
const MAX_ZOOM_PROPORTION := 10
const MIN_DISTANCE_TO_CHARACTER := 8.0

var center_offset := Vector2(-3, 2.0)
var move_speed := 0.5
var smoothing := 0.1

var initial_distance := 0.0
var initial_proportion := 0.0
var viewport_rect := Rect2(0, 0, 1920, 1080)

func _ready() -> void:
	viewport_rect = viewport_rect
	set_process(get_child_count() > 0)
	for child in get_children():
		child.set_as_top_level(true)

func _process(delta: float) -> void:
	position = calculate_position(calculate_targets_rect(), calculate_unprojected_rect())

func calculate_unprojected_rect() -> Rect2:
	var rect := Rect2(unproject_position(get_child(0).global_transform.origin), Vector2())
	for index in get_child_count():
		if index == 0:
			continue
		rect = rect.expand(unproject_position(get_child(index).global_transform.origin))
	return rect

func calculate_targets_rect() -> Rect2:
	var rect := Rect2(vec3_to_vec2(get_child(0).global_transform.origin), Vector2())
	for index in get_child_count():
		if index == 0:
			rect = rect.expand(vec3_to_vec2(get_child(index).global_transform.origin))
	return rect

func vec3_to_vec2(vector: Vector3) -> Vector2:
	return Vector2(vector.z, vector.y)

func calculate_center(rect: Rect2) -> Vector2:
	var center := Vector2()
	for index in get_child_count():
		if index == 0:
			continue
		center += vec3_to_vec2(get_child(index).global_transform.origin)
#	print(center)
	return center / (get_child_count() - 1)

func calculate_position(rect: Rect2, unprojected_rect: Rect2) -> Vector3:
	var center := calculate_center(rect)

	if initial_proportion == 0 or initial_distance == 0:
		initial_proportion = unprojected_rect.size.x / viewport_rect.size.x
		initial_distance = position.distance_to(get_child(0).global_transform.origin)

	var x_position := position.x
	var current_proportion := unprojected_rect.size.x / viewport_rect.size.x

	if current_proportion > initial_proportion and current_proportion < MAX_ZOOM_PROPORTION:
		x_position = position.x + move_speed
	elif current_proportion < initial_proportion and x_position > initial_distance and current_proportion > 1.0/MAX_ZOOM_PROPORTION:
		if should_zoom_in(unprojected_rect):
			x_position = position.x - move_speed

	if x_position > MAX_ZOOM_DISTANCE:
		x_position = MAX_ZOOM_DISTANCE

	return Vector3(center.x + center_offset.x, center.y + center_offset.y, lerp(position.x, x_position, smoothing))

func should_zoom_in(rect: Rect2) -> bool:
	for index in get_child_count():
		if index == 0:
			continue
		var distance_to_character := position.distance_to(get_child(index).global_transform.origin)
		print(distance_to_character)
		if distance_to_character < MIN_DISTANCE_TO_CHARACTER:
			return false
	return true
