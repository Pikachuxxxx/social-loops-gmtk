enum PERSONA_TYPE {
	## prototypes
	TECH_BRO = 0,                 
	GOTH_GIRL,
	FINANCE_BRO,
	INFLUENCER,
	KAREN,
	SUGARDADDY,
	GENERIC,
	## will be added later
	#CAT_LOVER,
	#DOG_LOVER,
	#TROLL,
	#REPOSTER,
	#ZEALOT,
	#CLICKBAITER,
	#ANARCHIST,
	#CLOUT_CHASER,
	#LURKER,
	## special characters
	ZUCK,  # Mark Zuckerberg (Admin)
	#SNOOP_DOGG, # Snoop Dogg
	#SEONGI_HUN, # Seong Gi-Hun from Squid Game
	#SAE_BYEOK, # Sae-Byeok from Squid Game
	#SPOCK, # Spock from Star Trek
	EMINEM, # Eminem
	MAX_PERSONA_TYPES # This should always be the last item
}

## This is where we have different types of personas and their variant resource files
#const PERSONA_TYPE_RESOURCES = {
#	PERSONA_TYPE.TECH_BRO: ["res://Personas/Persona_TechBro_0.tres"],
#	PERSONA_TYPE.GOTH_GIRL: ["res://Personas/Persona_GothGirl_0.tres"],
#	PERSONA_TYPE.FINANCE_BRO: ["res://Personas/Persona_FinanceBro_0.tres"],
#	PERSONA_TYPE.INFLUENCER: ["res://Personas/Persona_Influencer_0.tres"],
#	PERSONA_TYPE.KAREN: ["res://Personas/Persona_Karen_0.tres"],
#	PERSONA_TYPE.SUGARDADDY: ["res://Personas/Persona_SugarDaddy_0.tres"],
#	PERSONA_TYPE.EMINEM: ["res://Personas/Persona_Eminem_0.tres"],
#	PERSONA_TYPE.ZUCK: ["res://Personas/Persona_Zuck_0.tres"],
#	#PERSONA_TYPE.SNOOP_DOGG: ["res://Personas/Persona_SnoopDogg_0.tres"],
#	#PERSONA_TYPE.SEONGI_HUN: ["res://Personas/Persona_SeongiHun_0.tres"],
#	#PERSONA_TYPE.SAE_BYEOK: ["res://Personas/Persona_SaeByeok_0.tres"],
#	#PERSONA_TYPE.SPOCK: ["res://Personas/Persona_Spock_0.tres"]
#}

const PERSONA_PICS = {
	PERSONA_TYPE.TECH_BRO: "res://assets/image/dps/tech_bro.png",
	PERSONA_TYPE.GOTH_GIRL: "res://assets/image/dps/goth_person.png",
	PERSONA_TYPE.FINANCE_BRO: "res://assets/image/dps/finance_bro.png",
	PERSONA_TYPE.INFLUENCER: "res://assets/image/dps/influencer_he.png",
	PERSONA_TYPE.KAREN: "res://assets/image/dps/karen.png",
	PERSONA_TYPE.SUGARDADDY: "res://assets/image/dps/sugar_daddy.png",
	PERSONA_TYPE.GENERIC: ["res://assets/image/dps/persona_1.png", 
	"res://assets/image/dps/persona_2.png",
	"res://assets/image/dps/persona_3.png",
	"res://assets/image/dps/persona_4.png",
	"res://assets/image/dps/persona_5.png"],
	PERSONA_TYPE.EMINEM: "res://assets/image/dps/eminem_1.png",
	PERSONA_TYPE.ZUCK: "res://assets/image/dps/zuck.png",
}

static var GROUPS_MAP = {
	"TECH_BRO": [
		"code_boi_420💻",
		"debug_daddy_007",
		"silicon_dreamz_98🌌",
		"keyboard_crusher_xx",
		"stack_lord_69👑",
		"cloud_clown_777☁️",
		"byte_bandito_404",
		"terminal_chad_88💻",
		"bug_broski_91🐞",
		"compile_king_55⚙️",
		"syntax_lord_333🔥",
		"tech_freak_22",
		"api_lover_101✨",
		"quantum_hypez_88🧠",
		"dev_dominator_77🚀",
		"backend_baller_96",
		"frontend_frenzy_42💡",
		"code_crasher_99💾",
		"binary_boi_666📈",
		"pixel_pirate_55🎨",
		"cache_king_88",
		"git_savage_24⚡",
		"keyboard_knight_99⚔️",
		"terminal_tyrant_xx🔥"
	],
	"GOTH_GIRL": [
		"bat_queen_420🦇",
		"shadow_princess_99🌑",
		"velvet_vampire_666🩸",
		"midnight_freakz_77🌌",
		"raven_babe_101",
		"eclipse_goth_88🌒",
		"doom_dancer_333🖤",
		"goth_cobweb_999🕸️",
		"sinister_sis_88",
		"batgirl_4eva⚰️",
		"morbid_lady_55",
		"phantom_queen_007👻",
		"rose_goddess_666💔",
		"dark_nymph_77🌙",
		"nocturnal_angel_99🕶️",
		"grim_babe_88💀",
		"void_witch_420✨",
		"haunted_harmony_99🎵",
		"mystic_morticia_xx🔮",
		"abyss_beauty_444👑",
		"black_rose_girl🖤",
		"shroud_soul_77🧙‍♀️",
		"bat_babe_99👩‍🎤"
	],
	"FINANCE_BRO": [
		"stonks_king_420📈",
		"money_master_99💰",
		"refund_boi_101💸",
		"penny_hustler_77💵",
		"cash_crook_007🤑",
		"stonks_daddy_44📊",
		"bankroll_boss_99🏦",
		"dividend_dude_88💹",
		"stonks_lord💸",
		"cash_cow_55🐄",
		"wallstreet_bae_88🏢",
		"profit_prince_999",
		"stonks_savage_22📈",
		"money_babe_101💰",
		"refund_queen_777",
		"cash_boi_66🤑",
		"stonks_mogul_99💸",
		"dividend_guru_333💹",
		"profit_master_88💵",
		"stonks_wizard_101📊",
		"bankroll_lord_55🏦",
		"stonks_chad_77💰",
		"money_maven_99💸",
		"cash_guru_88📈",
		"stonks_freak_55💹"
	],
	"INFLUENCER": [
		"filter_queen_99✨",
		"selfie_babe_101📸",
		"likes_lord_420👍",
		"viral_maven_77📊",
		"story_savage_333📖",
		"hashtag_hero_88🏷️",
		"content_boi_66📱",
		"post_master_999📮",
		"trend_tyrant_55📈",
		"shoutout_babe_88📣",
		"brand_boss_101💼",
		"stream_dream_99🎥",
		"followers_freak_77👥",
		"filter_goddess_333✨",
		"caption_king_44🖋️",
		"likes_lady_88👍",
		"viral_babe_101📊",
		"story_queen_55📖",
		"hashtag_guru_99🏷️",
		"content_master_77📱",
		"post_god_999📮",
		"trend_babe_88📈",
		"shoutout_lord_101📣",
		"brand_guru_333💼",
		"stream_king_44🎥"
	],
	"KAREN": [
		"karen_queen_999📞",
		"manager_babe_420🎤",
		"let_me_call_66📱",
		"refund_lady_007💰",
		"coupon_mama_77💵",
		"angry_chick_333😡",
		"wine_night_88🍷",
		"complain_savage_999📣",
		"refund_dreamz_55💳",
		"angry_lord_101📞",
		"manager_boss_88🎤",
		"coupon_queen_99💰",
		"let_me_speak_77📱",
		"angry_goddess_333😡",
		"wine_freakz_44🍷",
		"complain_champion_999📣",
		"manager_hero_55💳",
		"refund_boss_88📞",
		"angry_babe_101🎤",
		"coupon_princess_77💰",
		"let_me_manage_99📱",
		"wine_maven_333🍷",
		"complain_master_44📣",
		"manager_guru_999💳"
	],
	"SUGARDADDY": [
		"sugar_boi_007💸",
		"richer_dad_77💎",
		"money_master_333💰",
		"wealthy_hero_88🏦",
		"bankroll_guru_999🏦",
		"sugar_lord_66💸",
		"richer_king_101💎",
		"money_babe_55💰",
		"wealthy_god_99🏦",
		"bankroll_dreamz_77💸",
		"sugar_prince_333💎",
		"richer_maven_44💰",
		"money_boss_999🏦",
		"wealthy_lord_55💸",
		"bankroll_master_88💎",
		"sugar_queen_101💰",
		"richer_babe_99🏦",
		"money_guru_77💸",
		"wealthy_champ_333💎",
		"bankroll_hero_44💰",
		"sugar_maven_999🏦"
	],
	"ZUCK": ["Zuck"],
	"EMINEM": ["Eminem"]
}

static func get_random_username(persona_type: String) -> String:
	if GROUPS_MAP.has(persona_type):
		var group_names = GROUPS_MAP[persona_type]
		if group_names.size() > 0:
			return group_names[randi() % group_names.size()]
	return "user"  # Fallback if no groups are defined for the persona type

static func pick_random_persona_type() -> PERSONA_TYPE:
	# Weighted probabilities:
	#  - GENERIC: ~60%
	#  - Any prototype: ~38%
	#  - ZUCK: ~1%
	#  - EMINEM: ~1%
	var roll = randf()
	if roll < 0.60:
		# GENERIC, but assign a prototype internally if needed
		return PERSONA_TYPE.GENERIC
	elif roll < 0.98:
		# Prototypes (TECH_BRO to SUGARDADDY)
		var proto_index = randi() % PERSONA_TYPE.GENERIC
		return proto_index
	elif roll < 0.995:
		return PERSONA_TYPE.ZUCK
	else:
		return PERSONA_TYPE.EMINEM

static func get_random_prototype() -> PERSONA_TYPE:
	return randi() % PERSONA_TYPE.GENERIC

static func get_persona_pic(persona_type: PERSONA_TYPE) -> String:
	if PERSONA_PICS.has(persona_type):
		var pic = PERSONA_PICS[persona_type]
		if typeof(pic) == TYPE_ARRAY:
			return pic[randi() % pic.size()]
		return pic
	return "res://assets/image/dps/persona_3.png"  # Fallback if no picture is defined for the persona type
