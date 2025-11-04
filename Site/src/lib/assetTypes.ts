const types = Object.freeze({
	1: "Image",
	2: "T-Shirt",
	3: "Audio",
	4: "Mesh",
	5: "Lua",
	8: "Hat",
	10: "Model",
	11: "Shirt",
	12: "Pants",
	13: "Decal",
	16: "Avatar",
	17: "Head",
	18: "Face",
	19: "Gear",
	24: "Animation",
	25: "Arms",
	26: "Legs",
	27: "Torso",
	28: "Right Arm",
	29: "Left Arm",
	30: "Left Leg",
	31: "Right Leg",
	32: "Package",
	35: "App",
	37: "Code",
	38: "Plugin",
	42: "Face Accessory",
} as { [_: number]: string })

export default types
export const typeToNumber: { [_: string]: number } = Object.fromEntries(
	Object.entries(types).map(([key, value]) => [value, +key])
)
