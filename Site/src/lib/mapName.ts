export const mapNamePattern = /^[A-Za-z0-9][A-Za-z0-9 ._-]{0,63}\.rbxl$/

export const isValidMapName = (value: string): boolean =>
	mapNamePattern.test(value) && !value.includes("..")
