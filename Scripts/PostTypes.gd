## this is just for prototyping might differ in the final game
enum POST_TYPE {
	ASMR            = 1 << 0,  # 1
	POLITICAL       = 1 << 1,  # 2
	COOKING         = 1 << 2,  # 4
	CATS_DOGS_PICS  = 1 << 3,  # 8
	TECHNOLOGY      = 1 << 4,  # 16
	METAL_MUSIC     = 1 << 5,  # 32
	FASHION         = 1 << 6,  # 64
	SHOWER_THOUGHTS = 1 << 7,  # 128
	BUSINESS        = 1 << 8,  # 256
	MEME            = 1 << 9,  # 512
	RANT            = 1 << 10, # 1024
	CELEB_GOSSIP    = 1 << 11, # 2048
	ASTROLOGY       = 1 << 12,  # 4096
	MAX_POST_TYPES  = 13
}

static func get_string_from_value(value: int) -> String:
	for key in POST_TYPE:
		if POST_TYPE[key] == value:
			return key
	return "UNKNOWN"
