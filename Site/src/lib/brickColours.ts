// Names not needed for now but could be useful
export const brickHexes = Object.freeze({
	1: "f2f3f3", // White
	5: "d7c59a", // Brick yellow
	9: "e8bac8", // Light reddish violet
	11: "80bbdc", // Pastel Blue
	18: "cc8e69", // Nougat
	21: "c4281c", // Bright red
	23: "0d69ac", // Bright blue
	24: "f5cd30", // Bright yellow
	26: "1b2a35", // Black
	28: "287f47", // Dark green
	29: "a1c48c", // Medium green
	37: "4b974b", // Bright green
	38: "a05f35", // Dark orange
	101: "da867a", // Medium red
	102: "6e99ca", // Medium blue
	104: "6b327c", // Bright violet
	105: "e29b40", // Br. yellowish orange
	106: "da8541", // Bright orange
	107: "008f9c", // Bright bluish green
	119: "a4bd47", // Br. yellowish green
	125: "eab892", // Light orange
	135: "74869d", // Sand blue
	141: "27462d", // Earth green
	151: "789082", // Sand green
	153: "957977", // Sand red
	192: "694028", // Reddish brown
	194: "a3a2a5", // Medium stone grey
	199: "635f62", // Dark stone grey
	208: "e5e4df", // Light stone grey
	217: "7c5c46", // Brown
	226: "fdea8d", // Cool yellow
	1001: "f8f8f8", // Institutional white
	1002: "cdcdcd", // Mid gray
	1003: "111111", // Really black
	1004: "ff0000", // Really red
	1006: "b480ff", // Alder
	1007: "a34b4b", // Dusty Rose
	1008: "c1be42", // Olive
	1009: "ffff00", // New Yeller
	1010: "0000ff", // Really blue
	1011: "002060", // Navy blue
	1012: "2154b9", // Deep blue
	1013: "04afec", // Cyan
	1014: "aa5500", // CGA brown
	1015: "aa00aa", // Magenta
	1016: "ff66cc", // Pink
	1017: "ffaf00", // Deep orange
	1018: "12eed4", // Teal
	1019: "00ffff", // Toothpaste
	1020: "00ff00", // Lime green
	1021: "3a7d15", // Camo
	1022: "7f8e64", // Grime
	1023: "8c5b9f", // Lavender
	1024: "afddff", // Pastel light blue
	1025: "ffc9c9", // Pastel orange
	1026: "b1a7ff", // Pastel violet
	1027: "9ff3e9", // Pastel blue-green
	1028: "ccffcc", // Pastel green
	1029: "ffffcc", // Pastel yellow
	1030: "ffcc99", // Pastel brown
	1031: "6225d1", // Royal purple
	1032: "ff00bf", // Hot pink
})

export const brickToHex: { [k: number]: string } = brickHexes

export const brickColours = Object.keys(brickToHex).map(k => +k)
export type BrickColour = keyof typeof brickHexes
