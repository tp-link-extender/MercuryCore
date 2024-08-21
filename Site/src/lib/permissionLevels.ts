const permissions = Object.freeze([
	["white", "fa-user", "User"],
	["aqua", "fa-check", "Verified"],
	["violet", "fa-hammer", "Catalog Manager"],
	["orange", "fa-shield-alt", "Moderator"],
	["crimson", "fa-scale-balanced", "Administrator"],
])

export default (permissionLevel: number) => permissions[permissionLevel - 1]
