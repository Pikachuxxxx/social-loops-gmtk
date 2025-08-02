enum PERSONA_TYPE {
	## prototypes
	TECH_BRO = 0,                 
	GOTH_GIRL,
	FINANCE_BRO,
	INFLUENCER,
	KAREN,
	SUGARDADDY,
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
	SNOOP_DOGG, # Snoop Dogg
	SEONGI_HUN, # Seong Gi-Hun from Squid Game
	SAE_BYEOK, # Sae-Byeok from Squid Game
	SPOCK, # Spock from Star Trek
	MAX_PERSONA_TYPES # This should always be the last item

}

## This is where we have different types of personas and their variant resource files
const PERSONA_TYPE_RESOURCES = {
	PERSONA_TYPE.TECH_BRO: ["res://Personas/Persona_TechBro_0.tres"],
	PERSONA_TYPE.GOTH_GIRL: ["res://Personas/Persona_GothGirl_0.tres"],
	PERSONA_TYPE.FINANCE_BRO: ["res://Personas/Persona_FinanceBro_0.tres"],
	PERSONA_TYPE.INFLUENCER: ["res://Personas/Persona_Influencer_0.tres"],
	PERSONA_TYPE.KAREN: ["res://Personas/Persona_Karen_0.tres"],
	PERSONA_TYPE.SUGARDADDY: ["res://Personas/Persona_SugarDaddy_0.tres"],
	#PERSONA_TYPE.CAT_LOVER: ["res://Resources/Personas/CatLover.tres"],
	#PERSONA_TYPE.DOG_LOVER: ["res://Resources/Personas/DogLover.tres"],
	#PERSONA_TYPE.TROLL: ["res://Resources/Personas/Troll.tres"],
	#PERSONA_TYPE.REPOSTER: ["res://Resources/Personas/Reposter.tres"],
	#PERSONA_TYPE.ZEALOT: ["res://Resources/Personas/Zealot.tres"],
	#PERSONA_TYPE.CLICKBAITER: ["res://Resources/Personas/Clickbaiter.tres"],
	#PERSONA_TYPE.ANARCHIST: ["res://Resources/Personas/Anarchist.tres"],
	#PERSONA_TYPE.CLOUT_CHASER: ["res://Resources/Personas/CloutChaser.tres"],
	#PERSONA_TYPE.LURKER: ["res://Resources/Personas/Lurker.tres"],
	PERSONA_TYPE.ZUCK: ["res://Personas/Persona_Zuck_0.tres"],
	PERSONA_TYPE.SNOOP_DOGG: ["res://Personas/Persona_SnoopDogg_0.tres"],
	PERSONA_TYPE.SEONGI_HUN: ["res://Personas/Persona_SeongiHun_0.tres"],
	PERSONA_TYPE.SAE_BYEOK: ["res://Personas/Persona_SaeByeok_0.tres"],
	PERSONA_TYPE.SPOCK: ["res://Personas/Persona_Spock_0.tres"]
}
