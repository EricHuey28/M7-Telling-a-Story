# A utility class for the practices. Loads the icons and makes them reusable
# in multiple practices; allows also to get the icons by name, rather than having
# to specify the path every time.
class_name PracticeIcons extends Resource

const icons := {
	"book": preload("book.svg"),
	"coin": preload("coin.svg"),
	"coins": preload("coins.svg"),
	"compass": preload("compass.svg"),
	"gem": preload("gem.svg"),
	"key": preload("key.svg"),
	"potion": preload("potion.svg"),
	"purse": preload("purse.svg"),
	"ring": preload("ring.svg"),
	"scroll": preload("scroll.svg"),
	"shield": preload("shield.svg"),
	"shrimp": preload("shrimp.svg"),
	"sword": preload("sword.svg"),
	"times": preload("times.svg"),
	"torch": preload("torch.svg"),
}
static func get_texture(name: String) -> CompressedTexture2D:
	if name in icons:
		return icons[name]
	return icons["purse"]
