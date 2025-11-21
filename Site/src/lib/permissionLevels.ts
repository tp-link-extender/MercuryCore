// warning: fa classes not scanned by unocss
const permissions = Object.freeze([
	["white", "fa-user", "User"],
	["aqua", "fa-check", "Verified"],
	["violet", "fa-hammer", "Catalog Manager"],
	["orange", "fa-shield-alt", "Moderator"],
	["crimson", "fa-scale-balanced", "Administrator"],
])

const permissionMembershipTypes = Object.freeze([
	"None",
	"BuildersClub", // ig since we have little use for this @tm
	"BuildersClub",
	"TurboBuildersClub",
	"OutrageousBuildersClub",
])

export const membershipType = (permissionLevel: number) =>
	`Enum.MembershipType.${permissionMembershipTypes[permissionLevel - 1]}`

export default (permissionLevel: number) => permissions[permissionLevel - 1]
