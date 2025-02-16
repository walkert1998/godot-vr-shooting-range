class_name Item extends Resource

@export var base_item_id: String
@export var item_name: String
@export_multiline var item_description: String
@export var item_type: ItemType
# Used for determining size of item icon in grid
@export var item_size: IntPair
@export var stackable: bool = false
# Kept just in case I limit stacks in future
@export var max_stack_size: int = 0
# Kept in case I do item degradation
@export var item_max_health: int = 100
@export var item_icon_horizontal: Texture2D
@export var item_grid: String = "0,0"
# Measuerd in kilograms, just in case for future work
@export var item_weight: float = 1.0
@export_file var pickup_object: String
@export_file var inventory_3d_view_path: String

enum ItemType {
	Misc,
	Weapon,
	Clothing,
	Ammo,
	Consumable,
	Key,
	Ring,
}
