// Faces, T-Shirts, Shirts, Pants + body parts; only one of each of these types can be worn
export const oneEquippable = Object.freeze([
	2, 11, 12, 18, 25, 26, 27, 28, 29, 30, 31,
])
// everything that can appear in the character tabs (Hats, Heads and Gear accumulate)
export const allowedTypes = Object.freeze(
	oneEquippable.concat([8, 17, 19, 32]) // + Hat, Head, Gear, Package
)
// items inside a package that can be worn (which is everything except packages themselves)
export const packageWearable = Object.freeze(allowedTypes.filter(t => t !== 32))
// slots replaced wholesale when a package is equipped (hats included)
export const packageConflicting = Object.freeze(oneEquippable.concat([8]))
export const bodyParts = Object.freeze([
	"Head",
	"LeftArm",
	"LeftLeg",
	"RightArm",
	"RightLeg",
	"Torso",
])

export type BodyPart = keyof User["bodyColours"]
export const isBodyPart = (part: string): part is BodyPart =>
	bodyParts.some(bodyPart => bodyPart === part)
