extends Area3D

@export var grab_point: XRToolsGrabPointHand
@export var attached_pickup: XRToolsPickable
@onready var collider: CollisionShape3D = $CollisionShape3D
var supporting: bool = false
var supporting_hand: XRToolsFunctionPickup

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func enable_support():
	collider.set_deferred("disabled", false)

func disable_support():
	collider.set_deferred("disabled", true)

func _on_area_entered(area: Area3D) -> void:
	if !attached_pickup.is_picked_up() or supporting:
		return
	var controller = area.find_parent("*Hand")
	print("Found area: " + area.name)
	if controller is XRController3D and controller != attached_pickup.get_picked_up_by_controller():
		supporting_hand = controller.find_child("*FunctionPickup") as XRToolsFunctionPickup
		grab_point.enabled = true
		attached_pickup.second_hand_grab = XRToolsPickable.SecondHandGrab.SECOND
		supporting_hand._pick_up_object(attached_pickup)
		print_debug(attached_pickup._grab_driver.secondary)
		supporting = true
		#disable_support()

func _on_area_exited(area: Area3D) -> void:
	if !attached_pickup.is_picked_up() or !supporting:
		return
	var controller = area.find_parent("*Hand") as XRController3D
	print_debug(area)
	if controller != null and controller != attached_pickup.get_picked_up_by_controller():
		#if !check_if_hand_in_area():
		release_supporting_hand()

func check_if_hand_in_area() -> bool:
	for body in get_overlapping_areas():
		if body.find_parent("*Hand").get_parent() != attached_pickup.get_picked_up_by_controller():
			return true
	return false

func release_supporting_hand():
	if supporting_hand:
		supporting_hand.drop_object()
		supporting_hand = null
		attached_pickup.supporting_hand = null
	attached_pickup.second_hand_grab = XRToolsPickable.SecondHandGrab.IGNORE
	supporting = false
	grab_point.enabled = false
	print_debug("Supporting disabled: " + str(supporting))
