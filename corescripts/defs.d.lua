-- Based on https://github.com/JohnnyMorganz/luau-lsp/blob/2bd0fb8a122932be67a16412591089e482bc3209/scripts/globalTypes.d.lua
-- Many void return types here are listed as `nil` instead of `()`, not fixing it

type Content = string
type Property = string
type ProtectedString = string
type BinaryString = string
type QDir = string
type QFont = string

declare class Enum
    function GetEnumItems(self): { any }
end

declare class EnumItem
    Name: string
    Value: number
    EnumType: Enum
    function IsA(self, enumName: string): boolean
end

declare debug: {
    info: (<R...>(thread, number, string) -> R...) & (<R...>(number, string) -> R...) & (<A..., R1..., R2...>((A...) -> R1..., string) -> R2...),
    traceback: ((string?, number?) -> string) & ((thread, string?, number?) -> string),
    profilebegin: (label: string) -> (),
    profileend: () -> (),
    setmemorycategory: (tag: string) -> (),
    resetmemorycategory: () -> (),
}

declare shared: any

declare function collectgarbage(mode: "count"): number
declare function warn<T...>(...: T...)
declare function tick(): number
declare function time(): number
declare function elapsedTime(): number
declare function wait(seconds: number?): (number, number)
declare function delay<T...>(delayTime: number?, callback: (T...) -> ())
declare function Delay<T...>(delayTime: number?, callback: (T...) -> ())
declare function spawn<T...>(callback: (T...) -> (), ...: any)
declare function Spawn<T...>(callback: (T...) -> (), ...: any)
declare function version(): string
declare function printidentity(prefix: string?)

declare class EnumAASamples extends EnumItem end
declare class EnumAASamples_INTERNAL extends Enum
	None: EnumAASamples
	["4"]: EnumAASamples
	["8"]: EnumAASamples
end
declare class EnumAccessType extends EnumItem end
declare class EnumAccessType_INTERNAL extends Enum
	Me: EnumAccessType
	Friends: EnumAccessType
	Everyone: EnumAccessType
	InviteOnly: EnumAccessType
end
declare class EnumActionType extends EnumItem end
declare class EnumActionType_INTERNAL extends Enum
	Nothing: EnumActionType
	Pause: EnumActionType
	Lose: EnumActionType
	Draw: EnumActionType
	Win: EnumActionType
end
declare class EnumAnimationPriority extends EnumItem end
declare class EnumAnimationPriority_INTERNAL extends Enum
	Idle: EnumAnimationPriority
	Movement: EnumAnimationPriority
	Action: EnumAnimationPriority
	Core: EnumAnimationPriority
end
declare class EnumAntialiasing extends EnumItem end
declare class EnumAntialiasing_INTERNAL extends Enum
	Automatic: EnumAntialiasing
	Off: EnumAntialiasing
	On: EnumAntialiasing
end
declare class EnumAxis extends EnumItem end
declare class EnumAxis_INTERNAL extends Enum
	X: EnumAxis
	Y: EnumAxis
	Z: EnumAxis
end
declare class EnumBinType extends EnumItem end
declare class EnumBinType_INTERNAL extends Enum
	Script: EnumBinType
	GameTool: EnumBinType
	Grab: EnumBinType
	Clone: EnumBinType
	Hammer: EnumBinType
end
declare class EnumBodyPart extends EnumItem end
declare class EnumBodyPart_INTERNAL extends Enum
	Head: EnumBodyPart
	Torso: EnumBodyPart
	LeftArm: EnumBodyPart
	RightArm: EnumBodyPart
	LeftLeg: EnumBodyPart
	RightLeg: EnumBodyPart
end
declare class EnumButton extends EnumItem end
declare class EnumButton_INTERNAL extends Enum
	Jump: EnumButton
	Dismount: EnumButton
end
declare class EnumButtonStyle extends EnumItem end
declare class EnumButtonStyle_INTERNAL extends Enum
	Custom: EnumButtonStyle
	RobloxButtonDefault: EnumButtonStyle
	RobloxButton: EnumButtonStyle
end
declare class EnumCameraMode extends EnumItem end
declare class EnumCameraMode_INTERNAL extends Enum
	Classic: EnumCameraMode
	LockFirstPerson: EnumCameraMode
end
declare class EnumCameraPanMode extends EnumItem end
declare class EnumCameraPanMode_INTERNAL extends Enum
	Classic: EnumCameraPanMode
	EdgeBump: EnumCameraPanMode
end
declare class EnumCameraType extends EnumItem end
declare class EnumCameraType_INTERNAL extends Enum
	Fixed: EnumCameraType
	Watch: EnumCameraType
	Attach: EnumCameraType
	Track: EnumCameraType
	Follow: EnumCameraType
	Custom: EnumCameraType
	Scriptable: EnumCameraType
end
declare class EnumCellBlock extends EnumItem end
declare class EnumCellBlock_INTERNAL extends Enum
	Solid: EnumCellBlock
	VerticalWedge: EnumCellBlock
	CornerWedge: EnumCellBlock
	InverseCornerWedge: EnumCellBlock
	HorizontalWedge: EnumCellBlock
end
declare class EnumCellMaterial extends EnumItem end
declare class EnumCellMaterial_INTERNAL extends Enum
	Empty: EnumCellMaterial
	Grass: EnumCellMaterial
	Sand: EnumCellMaterial
	Brick: EnumCellMaterial
	Granite: EnumCellMaterial
	Asphalt: EnumCellMaterial
	Iron: EnumCellMaterial
	Aluminum: EnumCellMaterial
	Gold: EnumCellMaterial
	WoodPlank: EnumCellMaterial
	WoodLog: EnumCellMaterial
	Gravel: EnumCellMaterial
	CinderBlock: EnumCellMaterial
	MossyStone: EnumCellMaterial
	Cement: EnumCellMaterial
	RedPlastic: EnumCellMaterial
	BluePlastic: EnumCellMaterial
	Water: EnumCellMaterial
end
declare class EnumCellOrientation extends EnumItem end
declare class EnumCellOrientation_INTERNAL extends Enum
	NegZ: EnumCellOrientation
	X: EnumCellOrientation
	Z: EnumCellOrientation
	NegX: EnumCellOrientation
end
declare class EnumCenterDialogType extends EnumItem end
declare class EnumCenterDialogType_INTERNAL extends Enum
	UnsolicitedDialog: EnumCenterDialogType
	PlayerInitiatedDialog: EnumCenterDialogType
	ModalDialog: EnumCenterDialogType
	QuitDialog: EnumCenterDialogType
end
declare class EnumChatColor extends EnumItem end
declare class EnumChatColor_INTERNAL extends Enum
	Blue: EnumChatColor
	Green: EnumChatColor
	Red: EnumChatColor
end
declare class EnumChatMode extends EnumItem end
declare class EnumChatMode_INTERNAL extends Enum
	Menu: EnumChatMode
	TextAndMenu: EnumChatMode
end
declare class EnumChatStyle extends EnumItem end
declare class EnumChatStyle_INTERNAL extends Enum
	Classic: EnumChatStyle
	Bubble: EnumChatStyle
	ClassicAndBubble: EnumChatStyle
end
declare class EnumConcurrencyModel extends EnumItem end
declare class EnumConcurrencyModel_INTERNAL extends Enum
	Serial: EnumConcurrencyModel
	Safe: EnumConcurrencyModel
	Logical: EnumConcurrencyModel
	Empirical: EnumConcurrencyModel
end
declare class EnumControlMode extends EnumItem end
declare class EnumControlMode_INTERNAL extends Enum
	MouseLockSwitch: EnumControlMode
	Classic: EnumControlMode
end
declare class EnumCoreGuiType extends EnumItem end
declare class EnumCoreGuiType_INTERNAL extends Enum
	PlayerList: EnumCoreGuiType
	Health: EnumCoreGuiType
	Backpack: EnumCoreGuiType
	Chat: EnumCoreGuiType
	All: EnumCoreGuiType
end
declare class EnumCreatorType extends EnumItem end
declare class EnumCreatorType_INTERNAL extends Enum
	User: EnumCreatorType
	Group: EnumCreatorType
end
declare class EnumCurrencyType extends EnumItem end
declare class EnumCurrencyType_INTERNAL extends Enum
	Default: EnumCurrencyType
	Robux: EnumCurrencyType
	Tix: EnumCurrencyType
end
declare class EnumD3DDEVTYPE extends EnumItem end
declare class EnumD3DDEVTYPE_INTERNAL extends Enum
	D3DDEVTYPE_HAL: EnumD3DDEVTYPE
	D3DDEVTYPE_REF: EnumD3DDEVTYPE
	D3DDEVTYPE_SW: EnumD3DDEVTYPE
	D3DDEVTYPE_NULLREF: EnumD3DDEVTYPE
end
declare class EnumD3DFORMAT extends EnumItem end
declare class EnumD3DFORMAT_INTERNAL extends Enum
	D3DFMT_UNKNOWN: EnumD3DFORMAT
	D3DFMT_R8G8B8: EnumD3DFORMAT
	D3DFMT_A8R8G8B8: EnumD3DFORMAT
	D3DFMT_X8R8G8B8: EnumD3DFORMAT
	D3DFMT_R5G6B5: EnumD3DFORMAT
	D3DFMT_X1R5G5B5: EnumD3DFORMAT
	D3DFMT_A1R5G5B5: EnumD3DFORMAT
	D3DFMT_A4R4G4B4: EnumD3DFORMAT
	D3DFMT_R3G3B2: EnumD3DFORMAT
	D3DFMT_A8: EnumD3DFORMAT
	D3DFMT_A8R3G3B2: EnumD3DFORMAT
	D3DFMT_X4R4G4B4: EnumD3DFORMAT
	D3DFMT_A2B10G10R10: EnumD3DFORMAT
	D3DFMT_A8B8G8R8: EnumD3DFORMAT
	D3DFMT_X8B8G8R8: EnumD3DFORMAT
	D3DFMT_G16R16: EnumD3DFORMAT
	D3DFMT_A2R10G10B10: EnumD3DFORMAT
	D3DFMT_A16B16G16R16: EnumD3DFORMAT
	D3DFMT_A8P8: EnumD3DFORMAT
	D3DFMT_P8: EnumD3DFORMAT
	D3DFMT_L8: EnumD3DFORMAT
	D3DFMT_A8L8: EnumD3DFORMAT
	D3DFMT_A4L4: EnumD3DFORMAT
	D3DFMT_V8U8: EnumD3DFORMAT
	D3DFMT_L6V5U5: EnumD3DFORMAT
	D3DFMT_X8L8V8U8: EnumD3DFORMAT
	D3DFMT_Q8W8V8U8: EnumD3DFORMAT
	D3DFMT_V16U16: EnumD3DFORMAT
	D3DFMT_A2W10V10U10: EnumD3DFORMAT
	D3DFMT_D16_LOCKABLE: EnumD3DFORMAT
	D3DFMT_D32: EnumD3DFORMAT
	D3DFMT_D15S1: EnumD3DFORMAT
	D3DFMT_D24S8: EnumD3DFORMAT
	D3DFMT_D24X8: EnumD3DFORMAT
	D3DFMT_D24X4S4: EnumD3DFORMAT
	D3DFMT_D16: EnumD3DFORMAT
	D3DFMT_D32F_LOCKABLE: EnumD3DFORMAT
	D3DFMT_D24FS8: EnumD3DFORMAT
	D3DFMT_L16: EnumD3DFORMAT
	D3DFMT_VERTEXDATA: EnumD3DFORMAT
	D3DFMT_INDEX16: EnumD3DFORMAT
	D3DFMT_INDEX32: EnumD3DFORMAT
	D3DFMT_Q16W16V16U16: EnumD3DFORMAT
	D3DFMT_R16F: EnumD3DFORMAT
	D3DFMT_G16R16F: EnumD3DFORMAT
	D3DFMT_A16B16G16R16F: EnumD3DFORMAT
	D3DFMT_R32F: EnumD3DFORMAT
	D3DFMT_G32R32F: EnumD3DFORMAT
	D3DFMT_A32B32G32R32F: EnumD3DFORMAT
	D3DFMT_CxV8U8: EnumD3DFORMAT
end
declare class EnumDialogPurpose extends EnumItem end
declare class EnumDialogPurpose_INTERNAL extends Enum
	Quest: EnumDialogPurpose
	Help: EnumDialogPurpose
	Shop: EnumDialogPurpose
end
declare class EnumDialogTone extends EnumItem end
declare class EnumDialogTone_INTERNAL extends Enum
	Neutral: EnumDialogTone
	Friendly: EnumDialogTone
	Enemy: EnumDialogTone
end
declare class EnumEasingDirection extends EnumItem end
declare class EnumEasingDirection_INTERNAL extends Enum
	In: EnumEasingDirection
	Out: EnumEasingDirection
	InOut: EnumEasingDirection
end
declare class EnumEasingStyle extends EnumItem end
declare class EnumEasingStyle_INTERNAL extends Enum
	Linear: EnumEasingStyle
	Sine: EnumEasingStyle
	Back: EnumEasingStyle
	Quad: EnumEasingStyle
	Quart: EnumEasingStyle
	Quint: EnumEasingStyle
	Bounce: EnumEasingStyle
	Elastic: EnumEasingStyle
end
declare class EnumEnviromentalPhysicsThrottle extends EnumItem end
declare class EnumEnviromentalPhysicsThrottle_INTERNAL extends Enum
	DefaultAuto: EnumEnviromentalPhysicsThrottle
	Disabled: EnumEnviromentalPhysicsThrottle
	Always: EnumEnviromentalPhysicsThrottle
	Skip2: EnumEnviromentalPhysicsThrottle
	Skip4: EnumEnviromentalPhysicsThrottle
	Skip8: EnumEnviromentalPhysicsThrottle
	Skip16: EnumEnviromentalPhysicsThrottle
end
declare class EnumErrorReporting extends EnumItem end
declare class EnumErrorReporting_INTERNAL extends Enum
	DontReport: EnumErrorReporting
	Prompt: EnumErrorReporting
	Report: EnumErrorReporting
end
declare class EnumExplosionType extends EnumItem end
declare class EnumExplosionType_INTERNAL extends Enum
	NoCraters: EnumExplosionType
	Craters: EnumExplosionType
	CratersAndDebris: EnumExplosionType
end
declare class EnumFilterResult extends EnumItem end
declare class EnumFilterResult_INTERNAL extends Enum
	Rejected: EnumFilterResult
	Accepted: EnumFilterResult
end
declare class EnumFont extends EnumItem end
declare class EnumFont_INTERNAL extends Enum
	Legacy: EnumFont
	Arial: EnumFont
	ArialBold: EnumFont
	SourceSans: EnumFont
	SourceSansBold: EnumFont
end
declare class EnumFontSize extends EnumItem end
declare class EnumFontSize_INTERNAL extends Enum
	Size8: EnumFontSize
	Size9: EnumFontSize
	Size10: EnumFontSize
	Size11: EnumFontSize
	Size12: EnumFontSize
	Size14: EnumFontSize
	Size18: EnumFontSize
	Size24: EnumFontSize
	Size36: EnumFontSize
	Size48: EnumFontSize
end
declare class EnumFormFactor extends EnumItem end
declare class EnumFormFactor_INTERNAL extends Enum
	Symmetric: EnumFormFactor
	Brick: EnumFormFactor
	Plate: EnumFormFactor
	Custom: EnumFormFactor
end
declare class EnumFrameStyle extends EnumItem end
declare class EnumFrameStyle_INTERNAL extends Enum
	Custom: EnumFrameStyle
	ChatBlue: EnumFrameStyle
	RobloxSquare: EnumFrameStyle
	RobloxRound: EnumFrameStyle
	ChatGreen: EnumFrameStyle
	ChatRed: EnumFrameStyle
end
declare class EnumFramerateManagerMode extends EnumItem end
declare class EnumFramerateManagerMode_INTERNAL extends Enum
	Automatic: EnumFramerateManagerMode
	On: EnumFramerateManagerMode
	Off: EnumFramerateManagerMode
end
declare class EnumFriendRequestEvent extends EnumItem end
declare class EnumFriendRequestEvent_INTERNAL extends Enum
	Issue: EnumFriendRequestEvent
	Revoke: EnumFriendRequestEvent
	Accept: EnumFriendRequestEvent
	Deny: EnumFriendRequestEvent
end
declare class EnumFriendStatus extends EnumItem end
declare class EnumFriendStatus_INTERNAL extends Enum
	Unknown: EnumFriendStatus
	NotFriend: EnumFriendStatus
	Friend: EnumFriendStatus
	FriendRequestSent: EnumFriendStatus
	FriendRequestReceived: EnumFriendStatus
end
declare class EnumFunctionalTestResult extends EnumItem end
declare class EnumFunctionalTestResult_INTERNAL extends Enum
	Passed: EnumFunctionalTestResult
	Warning: EnumFunctionalTestResult
	Error: EnumFunctionalTestResult
end
declare class EnumGearGenreSetting extends EnumItem end
declare class EnumGearGenreSetting_INTERNAL extends Enum
	AllGenres: EnumGearGenreSetting
	MatchingGenreOnly: EnumGearGenreSetting
end
declare class EnumGearType extends EnumItem end
declare class EnumGearType_INTERNAL extends Enum
	MeleeWeapons: EnumGearType
	RangedWeapons: EnumGearType
	Explosives: EnumGearType
	PowerUps: EnumGearType
	NavigationEnhancers: EnumGearType
	MusicalInstruments: EnumGearType
	SocialItems: EnumGearType
	BuildingTools: EnumGearType
	Transport: EnumGearType
end
declare class EnumGenre extends EnumItem end
declare class EnumGenre_INTERNAL extends Enum
	All: EnumGenre
	TownAndCity: EnumGenre
	Fantasy: EnumGenre
	SciFi: EnumGenre
	Ninja: EnumGenre
	Scary: EnumGenre
	Pirate: EnumGenre
	Adventure: EnumGenre
	Sports: EnumGenre
	Funny: EnumGenre
	WildWest: EnumGenre
	War: EnumGenre
	SkatePark: EnumGenre
	Tutorial: EnumGenre
end
declare class EnumGraphicsMode extends EnumItem end
declare class EnumGraphicsMode_INTERNAL extends Enum
	Automatic: EnumGraphicsMode
	Direct3D: EnumGraphicsMode
	OpenGL: EnumGraphicsMode
	NoGraphics: EnumGraphicsMode
end
declare class EnumHandlesStyle extends EnumItem end
declare class EnumHandlesStyle_INTERNAL extends Enum
	Resize: EnumHandlesStyle
	Movement: EnumHandlesStyle
end
declare class EnumHttpContentType extends EnumItem end
declare class EnumHttpContentType_INTERNAL extends Enum
	ApplicationJson: EnumHttpContentType
	ApplicationXml: EnumHttpContentType
	ApplicationUrlEncoded: EnumHttpContentType
	TextPlain: EnumHttpContentType
	TextXml: EnumHttpContentType
end
declare class EnumInOut extends EnumItem end
declare class EnumInOut_INTERNAL extends Enum
	Edge: EnumInOut
	Inset: EnumInOut
	Center: EnumInOut
end
declare class EnumInfoType extends EnumItem end
declare class EnumInfoType_INTERNAL extends Enum
	Asset: EnumInfoType
	Product: EnumInfoType
end
declare class EnumInputType extends EnumItem end
declare class EnumInputType_INTERNAL extends Enum
	NoInput: EnumInputType
	LeftTread: EnumInputType
	RightTread: EnumInputType
	Steer: EnumInputType
	Throtle: EnumInputType
	UpDown: EnumInputType
	Action1: EnumInputType
	Action2: EnumInputType
	Action3: EnumInputType
	Action4: EnumInputType
	Action5: EnumInputType
	Constant: EnumInputType
	Sin: EnumInputType
end
declare class EnumJointType extends EnumItem end
declare class EnumJointType_INTERNAL extends Enum
	None: EnumJointType
	Rotate: EnumJointType
	RotateP: EnumJointType
	RotateV: EnumJointType
	Glue: EnumJointType
	Weld: EnumJointType
	Snap: EnumJointType
end
declare class EnumKeywordFilterType extends EnumItem end
declare class EnumKeywordFilterType_INTERNAL extends Enum
	Include: EnumKeywordFilterType
	Exclude: EnumKeywordFilterType
end
declare class EnumLeftRight extends EnumItem end
declare class EnumLeftRight_INTERNAL extends Enum
	Left: EnumLeftRight
	Center: EnumLeftRight
	Right: EnumLeftRight
end
declare class EnumLevelOfDetailSetting extends EnumItem end
declare class EnumLevelOfDetailSetting_INTERNAL extends Enum
	High: EnumLevelOfDetailSetting
	Medium: EnumLevelOfDetailSetting
	Low: EnumLevelOfDetailSetting
end
declare class EnumMaterial extends EnumItem end
declare class EnumMaterial_INTERNAL extends Enum
	Plastic: EnumMaterial
	Wood: EnumMaterial
	Slate: EnumMaterial
	Concrete: EnumMaterial
	CorrodedMetal: EnumMaterial
	DiamondPlate: EnumMaterial
	Foil: EnumMaterial
	Grass: EnumMaterial
	Ice: EnumMaterial
	Marble: EnumMaterial
	Granite: EnumMaterial
	Brick: EnumMaterial
	Pebble: EnumMaterial
	Sand: EnumMaterial
	Fabric: EnumMaterial
	SmoothPlastic: EnumMaterial
end
declare class EnumMembershipType extends EnumItem end
declare class EnumMembershipType_INTERNAL extends Enum
	None: EnumMembershipType
	BuildersClub: EnumMembershipType
	TurboBuildersClub: EnumMembershipType
	OutrageousBuildersClub: EnumMembershipType
end
declare class EnumMeshType extends EnumItem end
declare class EnumMeshType_INTERNAL extends Enum
	Head: EnumMeshType
	Torso: EnumMeshType
	Wedge: EnumMeshType
	Prism: EnumMeshType
	Pyramid: EnumMeshType
	ParallelRamp: EnumMeshType
	RightAngleRamp: EnumMeshType
	CornerWedge: EnumMeshType
	Brick: EnumMeshType
	Sphere: EnumMeshType
	Cylinder: EnumMeshType
	FileMesh: EnumMeshType
end
declare class EnumMoveState extends EnumItem end
declare class EnumMoveState_INTERNAL extends Enum
	Stopped: EnumMoveState
	Coasting: EnumMoveState
	Pushing: EnumMoveState
	Stopping: EnumMoveState
	AirFree: EnumMoveState
end
declare class EnumNameOcclusion extends EnumItem end
declare class EnumNameOcclusion_INTERNAL extends Enum
	OccludeAll: EnumNameOcclusion
	EnemyOcclusion: EnumNameOcclusion
	NoOcclusion: EnumNameOcclusion
end
declare class EnumNormalId extends EnumItem end
declare class EnumNormalId_INTERNAL extends Enum
	Top: EnumNormalId
	Bottom: EnumNormalId
	Back: EnumNormalId
	Front: EnumNormalId
	Right: EnumNormalId
	Left: EnumNormalId
end
declare class EnumPacketPriority extends EnumItem end
declare class EnumPacketPriority_INTERNAL extends Enum
	IMMEDIATE_PRIORITY: EnumPacketPriority
	HIGH_PRIORITY: EnumPacketPriority
	MEDIUM_PRIORITY: EnumPacketPriority
	LOW_PRIORITY: EnumPacketPriority
end
declare class EnumPacketReliability extends EnumItem end
declare class EnumPacketReliability_INTERNAL extends Enum
	UNRELIABLE: EnumPacketReliability
	UNRELIABLE_SEQUENCED: EnumPacketReliability
	RELIABLE: EnumPacketReliability
	RELIABLE_ORDERED: EnumPacketReliability
	RELIABLE_SEQUENCED: EnumPacketReliability
end
declare class EnumPartType extends EnumItem end
declare class EnumPartType_INTERNAL extends Enum
	Ball: EnumPartType
	Block: EnumPartType
	Cylinder: EnumPartType
end
declare class EnumPhysicsReceiveMethod extends EnumItem end
declare class EnumPhysicsReceiveMethod_INTERNAL extends Enum
	Direct: EnumPhysicsReceiveMethod
	Interpolation: EnumPhysicsReceiveMethod
end
declare class EnumPhysicsSendMethod extends EnumItem end
declare class EnumPhysicsSendMethod_INTERNAL extends Enum
	ErrorComputation: EnumPhysicsSendMethod
	ErrorComputation2: EnumPhysicsSendMethod
	RoundRobin: EnumPhysicsSendMethod
	TopNErrors: EnumPhysicsSendMethod
end
declare class EnumPlayerChatType extends EnumItem end
declare class EnumPlayerChatType_INTERNAL extends Enum
	All: EnumPlayerChatType
	Team: EnumPlayerChatType
	Whisper: EnumPlayerChatType
end
declare class EnumPriorityMethod extends EnumItem end
declare class EnumPriorityMethod_INTERNAL extends Enum
	LastError: EnumPriorityMethod
	AccumulatedError: EnumPriorityMethod
	FIFO: EnumPriorityMethod
end
-- declare class EnumPrismSides extends EnumItem end
-- declare class EnumPrismSides_INTERNAL extends Enum
-- 	["3"]: EnumPrismSides
-- 	["5"]: EnumPrismSides
-- 	["6"]: EnumPrismSides
-- 	["8"]: EnumPrismSides
-- 	["10"]: EnumPrismSides
-- 	["20"]: EnumPrismSides
-- end
declare class EnumPrivilegeType extends EnumItem end
declare class EnumPrivilegeType_INTERNAL extends Enum
	Owner: EnumPrivilegeType
	Admin: EnumPrivilegeType
	Member: EnumPrivilegeType
	Visitor: EnumPrivilegeType
	Banned: EnumPrivilegeType
end
-- declare class EnumPyramidSides extends EnumItem end
-- declare class EnumPyramidSides_INTERNAL extends Enum
-- 	["3"]: EnumPyramidSides
-- 	["4"]: EnumPyramidSides
-- 	["5"]: EnumPyramidSides
-- 	["6"]: EnumPyramidSides
-- 	["8"]: EnumPyramidSides
-- 	["10"]: EnumPyramidSides
-- 	["20"]: EnumPyramidSides
-- end
declare class EnumQualityLevel extends EnumItem end
declare class EnumQualityLevel_INTERNAL extends Enum
	Automatic: EnumQualityLevel
	Level01: EnumQualityLevel
	Level02: EnumQualityLevel
	Level03: EnumQualityLevel
	Level04: EnumQualityLevel
	Level05: EnumQualityLevel
	Level06: EnumQualityLevel
	Level07: EnumQualityLevel
	Level08: EnumQualityLevel
	Level09: EnumQualityLevel
	Level10: EnumQualityLevel
	Level11: EnumQualityLevel
	Level12: EnumQualityLevel
	Level13: EnumQualityLevel
	Level14: EnumQualityLevel
	Level15: EnumQualityLevel
	Level16: EnumQualityLevel
	Level17: EnumQualityLevel
	Level18: EnumQualityLevel
	Level19: EnumQualityLevel
	Level20: EnumQualityLevel
	Level21: EnumQualityLevel
end
declare class EnumResolution extends EnumItem end
declare class EnumResolution_INTERNAL extends Enum
	Automatic: EnumResolution
	["720x526"]: EnumResolution
	["800x600"]: EnumResolution
	["1024x600"]: EnumResolution
	["1024x768"]: EnumResolution
	["1280x720"]: EnumResolution
	["1280x768"]: EnumResolution
	["1152x864"]: EnumResolution
	["1280x800"]: EnumResolution
	["1360x768"]: EnumResolution
	["1280x960"]: EnumResolution
	["1280x1024"]: EnumResolution
	["1440x900"]: EnumResolution
	["1600x900"]: EnumResolution
	["1600x1024"]: EnumResolution
	["1600x1200"]: EnumResolution
	["1680x1050"]: EnumResolution
	["1920x1080"]: EnumResolution
	["1920x1200"]: EnumResolution
end
declare class EnumReverbType extends EnumItem end
declare class EnumReverbType_INTERNAL extends Enum
	NoReverb: EnumReverbType
	GenericReverb: EnumReverbType
	PaddedCell: EnumReverbType
	Room: EnumReverbType
	Bathroom: EnumReverbType
	LivingRoom: EnumReverbType
	StoneRoom: EnumReverbType
	Auditorium: EnumReverbType
	ConcertHall: EnumReverbType
	Cave: EnumReverbType
	Arena: EnumReverbType
	Hangar: EnumReverbType
	CarpettedHallway: EnumReverbType
	Hallway: EnumReverbType
	StoneCorridor: EnumReverbType
	Alley: EnumReverbType
	Forest: EnumReverbType
	City: EnumReverbType
	Mountains: EnumReverbType
	Quarry: EnumReverbType
	Plain: EnumReverbType
	ParkingLot: EnumReverbType
	SewerPipe: EnumReverbType
	UnderWater: EnumReverbType
end
declare class EnumRuntimeUndoBehavior extends EnumItem end
declare class EnumRuntimeUndoBehavior_INTERNAL extends Enum
	Aggregate: EnumRuntimeUndoBehavior
	Snapshot: EnumRuntimeUndoBehavior
	Hybrid: EnumRuntimeUndoBehavior
end
declare class EnumSaveFilter extends EnumItem end
declare class EnumSaveFilter_INTERNAL extends Enum
	SaveAll: EnumSaveFilter
	SaveWorld: EnumSaveFilter
	SaveGame: EnumSaveFilter
end
declare class EnumSavedQualitySetting extends EnumItem end
declare class EnumSavedQualitySetting_INTERNAL extends Enum
	Automatic: EnumSavedQualitySetting
	QualityLevel1: EnumSavedQualitySetting
	QualityLevel2: EnumSavedQualitySetting
	QualityLevel3: EnumSavedQualitySetting
	QualityLevel4: EnumSavedQualitySetting
	QualityLevel5: EnumSavedQualitySetting
	QualityLevel6: EnumSavedQualitySetting
	QualityLevel7: EnumSavedQualitySetting
	QualityLevel8: EnumSavedQualitySetting
	QualityLevel9: EnumSavedQualitySetting
	QualityLevel10: EnumSavedQualitySetting
end
declare class EnumShadow extends EnumItem end
declare class EnumShadow_INTERNAL extends Enum
	Automatic: EnumShadow
	All: EnumShadow
	CharacterOnly: EnumShadow
	Off: EnumShadow
end
declare class EnumSizeConstraint extends EnumItem end
declare class EnumSizeConstraint_INTERNAL extends Enum
	RelativeXY: EnumSizeConstraint
	RelativeXX: EnumSizeConstraint
	RelativeYY: EnumSizeConstraint
end
declare class EnumSleepAdjustMethod extends EnumItem end
declare class EnumSleepAdjustMethod_INTERNAL extends Enum
	None: EnumSleepAdjustMethod
	LastSample: EnumSleepAdjustMethod
	AverageInterval: EnumSleepAdjustMethod
end
declare class EnumSoundType extends EnumItem end -- this is the most pre-any-decent-level-of-lua-understanding thing I've ever seen
declare class EnumSoundType_INTERNAL extends Enum
	NoSound: EnumSoundType
	Boing: EnumSoundType
	Bomb: EnumSoundType
	Break: EnumSoundType
	Click: EnumSoundType
	Clock: EnumSoundType
	Slingshot: EnumSoundType
	Page: EnumSoundType
	Ping: EnumSoundType
	Snap: EnumSoundType
	Splat: EnumSoundType
	Step: EnumSoundType
	StepOn: EnumSoundType
	Swoosh: EnumSoundType
	Victory: EnumSoundType
end
declare class EnumSpecialKey extends EnumItem end
declare class EnumSpecialKey_INTERNAL extends Enum
	Insert: EnumSpecialKey
	Home: EnumSpecialKey
	End: EnumSpecialKey
	PageUp: EnumSpecialKey
	PageDown: EnumSpecialKey
	ChatHotkey: EnumSpecialKey
end
declare class EnumStatus extends EnumItem end
declare class EnumStatus_INTERNAL extends Enum
	Poison: EnumStatus
	Confusion: EnumStatus
end
declare class EnumStuff extends EnumItem end
declare class EnumStuff_INTERNAL extends Enum
	Heads: EnumStuff
	Faces: EnumStuff
	Hats: EnumStuff
	TShirts: EnumStuff
	Shirts: EnumStuff
	Pants: EnumStuff
	Gears: EnumStuff
	Torsos: EnumStuff
	LeftArms: EnumStuff
	RightArms: EnumStuff
	LeftLegs: EnumStuff
	RightLegs: EnumStuff
	Bodies: EnumStuff
	Costumes: EnumStuff
end
declare class EnumStyle extends EnumItem end
declare class EnumStyle_INTERNAL extends Enum
	AlternatingSupports: EnumStyle
	BridgeStyleSupports: EnumStyle
	NoSupports: EnumStyle
end
declare class EnumSurfaceConstraint extends EnumItem end
declare class EnumSurfaceConstraint_INTERNAL extends Enum
	None: EnumSurfaceConstraint
	Hinge: EnumSurfaceConstraint
	SteppingMotor: EnumSurfaceConstraint
	Motor: EnumSurfaceConstraint
end
declare class EnumSurfaceType extends EnumItem end
declare class EnumSurfaceType_INTERNAL extends Enum
	Smooth: EnumSurfaceType
	Glue: EnumSurfaceType
	Weld: EnumSurfaceType
	Studs: EnumSurfaceType
	Inlet: EnumSurfaceType
	Universal: EnumSurfaceType
	Hinge: EnumSurfaceType
	Motor: EnumSurfaceType
	SteppingMotor: EnumSurfaceType
	Unjoinable: EnumSurfaceType
	SmoothNoOutlines: EnumSurfaceType
end
declare class EnumSwipeDirection extends EnumItem end
declare class EnumSwipeDirection_INTERNAL extends Enum
	Right: EnumSwipeDirection
	Left: EnumSwipeDirection
	Up: EnumSwipeDirection
	Down: EnumSwipeDirection
	None: EnumSwipeDirection
end
declare class EnumTeleportState extends EnumItem end
declare class EnumTeleportState_INTERNAL extends Enum
	RequestedFromServer: EnumTeleportState
	Started: EnumTeleportState
	WaitingForServer: EnumTeleportState
	Failed: EnumTeleportState
	InProgress: EnumTeleportState
end
declare class EnumTextXAlignment extends EnumItem end
declare class EnumTextXAlignment_INTERNAL extends Enum
	Left: EnumTextXAlignment
	Center: EnumTextXAlignment
	Right: EnumTextXAlignment
end
declare class EnumTextYAlignment extends EnumItem end
declare class EnumTextYAlignment_INTERNAL extends Enum
	Top: EnumTextYAlignment
	Center: EnumTextYAlignment
	Bottom: EnumTextYAlignment
end
declare class EnumThreadPoolConfig extends EnumItem end
declare class EnumThreadPoolConfig_INTERNAL extends Enum
	Auto: EnumThreadPoolConfig
	PerCore1: EnumThreadPoolConfig
	PerCore2: EnumThreadPoolConfig
	PerCore3: EnumThreadPoolConfig
	PerCore4: EnumThreadPoolConfig
	Threads1: EnumThreadPoolConfig
	Threads2: EnumThreadPoolConfig
	Threads3: EnumThreadPoolConfig
	Threads4: EnumThreadPoolConfig
	Threads8: EnumThreadPoolConfig
	Threads16: EnumThreadPoolConfig
end
declare class EnumTickCountSampleMethod extends EnumItem end
declare class EnumTickCountSampleMethod_INTERNAL extends Enum
	Fast: EnumTickCountSampleMethod
	Benchmark: EnumTickCountSampleMethod
	Precise: EnumTickCountSampleMethod
end
declare class EnumTopBottom extends EnumItem end
declare class EnumTopBottom_INTERNAL extends Enum
	Top: EnumTopBottom
	Center: EnumTopBottom
	Bottom: EnumTopBottom
end
declare class EnumTweenStatus extends EnumItem end
declare class EnumTweenStatus_INTERNAL extends Enum
	Canceled: EnumTweenStatus
	Completed: EnumTweenStatus
end
declare class EnumUploadSetting extends EnumItem end
declare class EnumUploadSetting_INTERNAL extends Enum
	Never: EnumUploadSetting
	Ask: EnumUploadSetting
	Always: EnumUploadSetting
end
declare class EnumUserInputState extends EnumItem end
declare class EnumUserInputState_INTERNAL extends Enum
	Begin: EnumUserInputState
	Change: EnumUserInputState
	End: EnumUserInputState
	None: EnumUserInputState
end
declare class EnumUserInputType extends EnumItem end
declare class EnumUserInputType_INTERNAL extends Enum
	MouseButton1: EnumUserInputType
	MouseButton2: EnumUserInputType
	MouseButton3: EnumUserInputType
	MouseWheel: EnumUserInputType
	MouseMovement: EnumUserInputType
	Touch: EnumUserInputType
	Keyboard: EnumUserInputType
	Focus: EnumUserInputType
	None: EnumUserInputType
end
declare class EnumVideoQualitySettings extends EnumItem end
declare class EnumVideoQualitySettings_INTERNAL extends Enum
	LowResolution: EnumVideoQualitySettings
	MediumResolution: EnumVideoQualitySettings
	HighResolution: EnumVideoQualitySettings
end
declare class EnumWaterDirection extends EnumItem end
declare class EnumWaterDirection_INTERNAL extends Enum
	NegX: EnumWaterDirection
	X: EnumWaterDirection
	NegY: EnumWaterDirection
	Y: EnumWaterDirection
	NegZ: EnumWaterDirection
	Z: EnumWaterDirection
end
declare class EnumWaterForce extends EnumItem end
declare class EnumWaterForce_INTERNAL extends Enum
	None: EnumWaterForce
	Small: EnumWaterForce
	Medium: EnumWaterForce
	Strong: EnumWaterForce
	Max: EnumWaterForce
end




type ENUM_LIST = {
	AASamples: EnumAASamples_INTERNAL,
	AccessType: EnumAccessType_INTERNAL,
	ActionType: EnumActionType_INTERNAL,
	AnimationPriority: EnumAnimationPriority_INTERNAL,
	Antialiasing: EnumAntialiasing_INTERNAL,
	Axis: EnumAxis_INTERNAL,
	BinType: EnumBinType_INTERNAL,
	BodyPart: EnumBodyPart_INTERNAL,
	Button: EnumButton_INTERNAL,
	ButtonStyle: EnumButtonStyle_INTERNAL,
	CameraMode: EnumCameraMode_INTERNAL,
	CameraPanMode: EnumCameraPanMode_INTERNAL,
	CameraType: EnumCameraType_INTERNAL,
	CellBlock: EnumCellBlock_INTERNAL,
	CellMaterial: EnumCellMaterial_INTERNAL,
	CellOrientation: EnumCellOrientation_INTERNAL,
	CenterDialogType: EnumCenterDialogType_INTERNAL,
	ChatColor: EnumChatColor_INTERNAL,
	ChatMode: EnumChatMode_INTERNAL,
	ChatStyle: EnumChatStyle_INTERNAL,
	ConcurrencyModel: EnumConcurrencyModel_INTERNAL,
	ControlMode: EnumControlMode_INTERNAL,
	CoreGuiType: EnumCoreGuiType_INTERNAL,
	CreatorType: EnumCreatorType_INTERNAL,
	CurrencyType: EnumCurrencyType_INTERNAL,
	D3DDEVTYPE: EnumD3DDEVTYPE_INTERNAL,
	D3DFORMAT: EnumD3DFORMAT_INTERNAL,
	DialogPurpose: EnumDialogPurpose_INTERNAL,
	DialogTone: EnumDialogTone_INTERNAL,
	EasingDirection: EnumEasingDirection_INTERNAL,
	EasingStyle: EnumEasingStyle_INTERNAL,
	EnviromentalPhysicsThrottle: EnumEnviromentalPhysicsThrottle_INTERNAL,
	ErrorReporting: EnumErrorReporting_INTERNAL,
	ExplosionType: EnumExplosionType_INTERNAL,
	FilterResult: EnumFilterResult_INTERNAL,
	Font: EnumFont_INTERNAL,
	FontSize: EnumFontSize_INTERNAL,
	FormFactor: EnumFormFactor_INTERNAL,
	FrameStyle: EnumFrameStyle_INTERNAL,
	FramerateManagerMode: EnumFramerateManagerMode_INTERNAL,
	FriendRequestEvent: EnumFriendRequestEvent_INTERNAL,
	FriendStatus: EnumFriendStatus_INTERNAL,
	FunctionalTestResult: EnumFunctionalTestResult_INTERNAL,
	GearGenreSetting: EnumGearGenreSetting_INTERNAL,
	GearType: EnumGearType_INTERNAL,
	Genre: EnumGenre_INTERNAL,
	GraphicsMode: EnumGraphicsMode_INTERNAL,
	HandlesStyle: EnumHandlesStyle_INTERNAL,
	HttpContentType: EnumHttpContentType_INTERNAL,
	InOut: EnumInOut_INTERNAL,
	InfoType: EnumInfoType_INTERNAL,
	InputType: EnumInputType_INTERNAL,
	JointType: EnumJointType_INTERNAL,
	KeywordFilterType: EnumKeywordFilterType_INTERNAL,
	LeftRight: EnumLeftRight_INTERNAL,
	LevelOfDetailSetting: EnumLevelOfDetailSetting_INTERNAL,
	Material: EnumMaterial_INTERNAL,
	MembershipType: EnumMembershipType_INTERNAL,
	MeshType: EnumMeshType_INTERNAL,
	MoveState: EnumMoveState_INTERNAL,
	NameOcclusion: EnumNameOcclusion_INTERNAL,
	NormalId: EnumNormalId_INTERNAL,
	PacketPriority: EnumPacketPriority_INTERNAL,
	PacketReliability: EnumPacketReliability_INTERNAL,
	PartType: EnumPartType_INTERNAL,
	PhysicsReceiveMethod: EnumPhysicsReceiveMethod_INTERNAL,
	PhysicsSendMethod: EnumPhysicsSendMethod_INTERNAL,
	PlayerChatType: EnumPlayerChatType_INTERNAL,
	PriorityMethod: EnumPriorityMethod_INTERNAL,
	-- PrismSides: EnumPrismSides_INTERNAL,
	PrivilegeType: EnumPrivilegeType_INTERNAL,
	-- PyramidSides: EnumPyramidSides_INTERNAL,
	QualityLevel: EnumQualityLevel_INTERNAL,
	Resolution: EnumResolution_INTERNAL,
	ReverbType: EnumReverbType_INTERNAL,
	RuntimeUndoBehavior: EnumRuntimeUndoBehavior_INTERNAL,
	SaveFilter: EnumSaveFilter_INTERNAL,
	SavedQualitySetting: EnumSavedQualitySetting_INTERNAL,
	Shadow: EnumShadow_INTERNAL,
	SizeConstraint: EnumSizeConstraint_INTERNAL,
	SleepAdjustMethod: EnumSleepAdjustMethod_INTERNAL,
	SoundType: EnumSoundType_INTERNAL,
	SpecialKey: EnumSpecialKey_INTERNAL,
	Status: EnumStatus_INTERNAL,
	Stuff: EnumStuff_INTERNAL,
	Style: EnumStyle_INTERNAL,
	SurfaceConstraint: EnumSurfaceConstraint_INTERNAL,
	SurfaceType: EnumSurfaceType_INTERNAL,
	SwipeDirection: EnumSwipeDirection_INTERNAL,
	TeleportState: EnumTeleportState_INTERNAL,
	TextXAlignment: EnumTextXAlignment_INTERNAL,
	TextYAlignment: EnumTextYAlignment_INTERNAL,
	ThreadPoolConfig: EnumThreadPoolConfig_INTERNAL,
	TickCountSampleMethod: EnumTickCountSampleMethod_INTERNAL,
	TopBottom: EnumTopBottom_INTERNAL,
	TweenStatus: EnumTweenStatus_INTERNAL,
	UploadSetting: EnumUploadSetting_INTERNAL,
	UserInputState: EnumUserInputState_INTERNAL,
	UserInputType: EnumUserInputType_INTERNAL,
	VideoQualitySettings: EnumVideoQualitySettings_INTERNAL,
	WaterDirection: EnumWaterDirection_INTERNAL,
	WaterForce: EnumWaterForce_INTERNAL,
} & { GetEnums: (self: ENUM_LIST) -> { Enum } }
declare Enum: ENUM_LIST

declare class Axes
	Back: boolean
	Bottom: boolean
	Front: boolean
	Left: boolean
	Right: boolean
	Top: boolean
	X: boolean
	Y: boolean
	Z: boolean
end

declare class Color3
	b: number
	g: number
	r: number
	function Lerp(self, color: Color3, alpha: number): Color3
	function ToHSV(self): (number, number, number)
	function ToHex(self): string
end

declare class BrickColor
	Color: Color3
	Name: string
	Number: number
	b: number
	g: number
	r: number
end

declare class Enums
	function GetEnums(self): { Enum }
end

declare class Faces -- no, every class doesn't have to be an instance
	Back: boolean
	Bottom: boolean
	Front: boolean
	Left: boolean
	Right: boolean
	Top: boolean
end

declare class RBXScriptConnection
	connected: boolean
	function disconnect(self): nil
end

declare class UDim
	Offset: number
	Scale: number
	function __add(self, other: UDim): UDim
	function __sub(self, other: UDim): UDim
	function __unm(self): UDim
end

declare class UDim2
	Height: UDim
	Width: UDim
	X: UDim
	Y: UDim
	function __add(self, other: UDim2): UDim2
	function __sub(self, other: UDim2): UDim2
	function __unm(self): UDim2
end

declare class Vector2
	magnitude: number
	unit: Vector2
	X: number
	Y: number
	x: number
	y: number
	function __add(self, other: Vector2): Vector2
	function __div(self, other: Vector2 | number): Vector2
	function __mul(self, other: Vector2 | number): Vector2
	function __sub(self, other: Vector2): Vector2
	function __unm(self): Vector2
end

declare class Rect
	Height: number
	Max: Vector2
	Min: Vector2
	Width: number
end

declare class Vector2int16
	X: number
	Y: number
	function __add(self, other: Vector2int16): Vector2int16
	function __div(self, other: Vector2int16 | number): Vector2int16
	function __mul(self, other: Vector2int16 | number): Vector2int16
	function __sub(self, other: Vector2int16): Vector2int16
	function __unm(self): Vector2int16
end

declare class Vector3
	Magnitude: number
	magnitude: number
	Unit: Vector3
	unit: Vector3
	X: number
	x: number
	Y: number
	y: number
	Z: number
	z: number
	function Angle(self, other: Vector3, axis: Vector3?): number
	function Cross(self, other: Vector3): Vector3
	function Dot(self, other: Vector3): number
	function FuzzyEq(self, other: Vector3, epsilon: number): boolean
	function Lerp(self, goal: Vector3, alpha: number): Vector3
	function __add(self, other: Vector3): Vector3
	function __div(self, other: Vector3 | number): Vector3
	function __mul(self, other: Vector3 | number): Vector3
	function __sub(self, other: Vector3): Vector3
	function __unm(self): Vector3
end

declare class RaycastResult
	Distance: number
	Instance: Instance
	Material: EnumMaterial
	Normal: Vector3
	Position: Vector3
end

declare class Ray
	Direction: Vector3
	Origin: Vector3
	Unit: Ray
	function ClosestPoint(self, point: Vector3): Vector3
	function Distance(self, point: Vector3): number
end

declare class CFrame
	lookVector: Vector3
	p: Vector3
	X: number
	Y: number
	Z: number
	function inverse(self): CFrame
	function pointToObjectSpace(self, v3: Vector3): Vector3
	function pointToWorldSpace(self, v3: Vector3): Vector3
	function toEulerAnglesXYZ(self): (number, number, number)
	function toObjectSpace(self, cf: CFrame): CFrame
	function toWorldSpace(self, cf: CFrame): CFrame
	function vectorToObjectSpace(self, v3: Vector3): Vector3
	function vectorToWorldSpace(self, v3: Vector3): Vector3
	function __add(self, other: Vector3): CFrame
	function __mul(self, other: CFrame): CFrame
	function __mul(self, other: Vector3): Vector3
	function __sub(self, other: Vector3): CFrame
end

declare class Region3
	CFrame: CFrame
	Size: Vector3
	function ExpandToGrid(self, Region: number): Region3
end

declare class Vector3int16
	X: number
	Y: number
	Z: number
	function __add(self, other: Vector3int16): Vector3int16
	function __div(self, other: Vector3int16 | number): Vector3int16
	function __mul(self, other: Vector3int16 | number): Vector3int16
	function __sub(self, other: Vector3int16): Vector3int16
	function __unm(self): Vector3int16
end

declare class Region3int16
	Max: Vector3int16
	Min: Vector3int16
end

export type RBXScriptSignal<T... = ...any> = {
    wait: (self: RBXScriptSignal<T...>, time: number?) -> T...,
    connect: (self: RBXScriptSignal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
    connectParallel: (self: RBXScriptSignal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
    once: (self: RBXScriptSignal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
}

type HttpRequestOptions = {
    Url: string,
    Method: "GET" | "HEAD" | "POST" | "PUT" | "DELETE" | "CONNECT" | "OPTIONS" | "TRACE" | "PATCH" | nil,
    Headers: { [string]: string }?,
    Body: string?,
}

type HttpResponseData = {
    Success: boolean,
    StatusCode: number,
    StatusMessage: string,
    Headers: { [string]: string },
    Body: string?,
}

-- lots of these types were previously declared as any, for the time being I think it's better to have them as their deprecated types than as any
-- perhaps change later depending on whether they're still deprecated in 2013

-- type Hat = any
declare class Hat extends Accoutrement
end

-- type RocketPropulsion = any
declare class RocketPropulsion extends BodyMover
	CartoonFactor: number
	MaxSpeed: number
	MaxThrust: number
	MaxTorque: Vector3
	ReachedTarget: RBXScriptSignal<>
	Target: BasePart -- technically Object, but can you really tell?
	TargetOffset: Vector3
	TargetRadius: number
	ThrustD: number
	ThrustP: number
	TurnD: number
	TurnP: number

	function Abort(self): nil
	function Fire(self): nil
end


-- type Skin = any
declare class Skin extends CharacterAppearance
	SkinColor: BrickColor
end

-- type CustomEvent = any
declare class CustomEvent extends Instance
	ReceiverConnected: RBXScriptSignal<CustomEventReceiver>
	ReceiverDisconnected: RBXScriptSignal<CustomEventReceiver>
	function GetAttachedReceivers(self): { CustomEventReceiver } -- tested
	function SetValue(self, newValue: number): nil -- why only a float?
end

-- type CustomEventReceiver = any
declare class CustomEventReceiver extends Instance
	EventConnected: RBXScriptSignal<CustomEvent>
	EventDisconnected: RBXScriptSignal<CustomEvent>
	Source: CustomEvent
	SourceValueChange: RBXScriptSignal<number>
	function GetCurrentValue(self): number
end

-- type BevelMesh = any -- looong deprecated
-- type CylinderMesh = any
-- type Hole = any
declare class Hole extends Feature
end

-- type MotorFeature = any
declare class MotorFeature extends Feature
end

type FunctionalTest = any
-- type GuiMain = any
declare class GuiMain extends ScreenGui
end

-- type FloorWire = any
declare class FloorWire extends GuiBase3d -- This thing is awesome, why on earth was it deprecated
	-- and I still won't grow up
	-- I'm a grown ass kid
	-- swear I should be locked up
	-- for stupid shit that I did
	-- but I'm a champion
	-- so I turned tragedy to triumph
	-- write code that's fire
	-- spit my soul through the FloorWire
	CycleOffset: number
	From: BasePart
	StudsBetweenTextures: number
	Texture: Content
	TextureSize: Vector2
	To: BasePart
	Velocity: number
	WireRadius: number
end

-- type SelectionPartLasso = any
declare class SelectionPartLasso extends SelectionLasso
	Part: BasePart
end

declare class GuiItem extends Instance
end

-- type Hopper = any
declare class Hopper extends GuiItem
end

-- type SelectionPointLasso = any
declare class SelectionPointLasso extends SelectionLasso
	Point: Vector3
end

-- type RotateP = any
declare class RotateP extends DynamicRotate
end

-- type RotateV = any
declare class RotateV extends DynamicRotate
end

-- type Glue = any
declare class Glue extends JointInstance
	F0: Vector3
	F1: Vector3
	F2: Vector3
	F3: Vector3
end


-- type ManualSurfaceJointInstance = any
declare class ManualSurfaceJointInstance extends JointInstance
end

-- type ManualGlue = any
declare class ManualGlue extends ManualSurfaceJointInstance
end

-- type ManualWeld = any
declare class ManualWeld extends ManualSurfaceJointInstance
end

type Rotate = any
type Snap = any
-- type JointsService = any
declare class JointsService extends Instance
	function ClearJoinAfterMoveJoints(self): nil
	function CreateJoinAfterMoveJoints(self): nil
	function SetJoinAfterMoveInstance(self, joinInstance: Instance): nil
	function SetJoinAfterMoveTarget(self, joinTarget: Instance): nil
	function ShowPermissibleJoints(self): nil
end

-- type Message = any
declare class Message extends Instance
	Text: string
end

-- type Hint = any
declare class Hint extends Message
end

-- type FlagStand = any
declare class FlagStand extends Part
	FlagCaptured: RBXScriptSignal<Instance> -- probably player, though difficult to test
	TeamColor: BrickColor
end

-- type SkateboardPlatform = any
declare class SkateboardPlatform extends Part
	Controller: SkateboardController -- tested..? SkateboradController seems to appear out of nowhere and is parented to somewhere
	ControllingHumanoid: Humanoid -- tested
end

-- type HopperBin = any
declare class HopperBin extends BackpackItem
	Active: boolean
	BinType: EnumBinType
	Deselected: RBXScriptSignal<>
	Selected: RBXScriptSignal<Instance>

	function Disable(self): nil
	function ToggleSelect(self): nil
end

-- turn it off and on again
-- check the power supply
-- it worked but now it's gone again
-- one more thing that we can try!
-- press Ctrl and try again
-- it works, we don't know why
-- system is alive again
-- well thank you for calling, goodbye

-- type Flag = any
declare class Flag extends Tool
	TeamColor: BrickColor
end

-- type Status = any
declare class Status extends Model
end

type PointsService = any
-- type DoubleConstrainedValue = any
declare class DoubleConstrainedValue extends Instance
	Changed: RBXScriptSignal<number>
	ConstrainedValue: number
	MaxValue: number
	MinValue: number
	Value: number
end

-- type IntConstrainedValue = any
declare class IntConstrainedValue extends Instance
	Changed: RBXScriptSignal<number>
	ConstrainedValue: number
	MaxValue: number
	MinValue: number
	Value: number
end

declare class Instance
	AncestryChanged: RBXScriptSignal<Instance, Instance?>
	Archivable: boolean
	Changed: RBXScriptSignal<Property> -- anotha one of them property thingz
	ChildAdded: RBXScriptSignal<Instance>
	ChildRemoved: RBXScriptSignal<Instance>
	ClassName: string
	DataCost: number
	DescendantAdded: RBXScriptSignal<Instance>
	DescendantRemoving: RBXScriptSignal<Instance>
	Name: string
	Parent: Instance?
	RobloxLocked: boolean

	function ClearAllChildren(self): nil
	function Clone(self): Instance
	function Destroy(self): nil -- camelCase variant also exists
	function Remove(self): nil -- camelCase variant also exists
	function FindFirstChild(self, name: string, recursive: boolean?): Instance? -- camelCase variant also exists
	function FindFirstDescendant(self, name: string): Instance?
	function GetChildren(self): { Instance }
	function GetDebugId(self, scopeLength: number?): string
	function GetFullName(self): string
	function IsA(self, className: string): boolean -- camelCase variant also exists
	function IsAncestorOf(self, descendant: Instance): boolean -- deprecated camelCase variant also exists
	function IsDescendantOf(self, ancestor: Instance): boolean -- camelCase variant also exists
	function WaitForChild(self, name: string): Instance
	function WaitForChild(self, name: string, timeout: number): Instance? -- deprecated camelCase variant also exists
end

declare class Accoutrement extends Instance
	AttachmentForward: Vector3
	AttachmentPoint: CFrame
	AttachmentPos: Vector3
	AttachmentRight: Vector3
	AttachmentUp: Vector3
end

declare class AdvancedDragger extends Instance
end

declare class Animation extends Instance
	AnimationId: Content
end

declare class AnimationController extends Instance
	function LoadAnimation(self, animation: Animation): AnimationTrack
end

declare class AnimationTrack extends Instance
	KeyframeReached: RBXScriptSignal<string>
	function AdjustSpeed(self, speed: number?): nil
	function AdjustWeight(self, weight: number?, fadeTime: number?): nil
	function Play(self, fadeTime: number?, weight: number?, speed: number?): nil
	function Stop(self, fadeTime: number?): nil
end

declare class Animator extends Instance
	function LoadAnimation(self, animation: Animation): AnimationTrack
end

declare class AssetService extends Instance
	function GetAssetVersions(self, placeId: number, pageNum: number): { any }
	function GetCreatorAssetID(self, creationID: number): number
	function GetPlacePermissions(self, placeId: number): { any }
	function RevertAsset(self, placeId: number, versionNumber: number): boolean
	function SetAssetRevertUrl(self, revertUrl: string): nil
	function SetAssetVersionsUrl(self, versionsUrl: string): nil
	function SetPlaceAccessUrl(self, accessUrl: string): boolean
	function SetPlacePermissions(self, placeId: number, accessType: EnumAccessType, inviteList: { any }): boolean
end

declare class Backpack extends GuiItem
end

declare class BadgeService extends Instance
	BadgeAwarded: RBXScriptSignal<string, number, number>
	function AwardBadge(self, userId: number, badgeId: number): boolean
	function IsDisabled(self, badgeId: number): boolean
	function IsLegal(self, badgeId: number): boolean
	function SetAwardBadgeUrl(self, url: string): nil
	function SetHasBadgeCooldown(self, seconds: number): nil
	function SetHasBadgeUrl(self, url: string): nil
	function SetIsBadgeDisabledUrl(self, url: string): nil
	function SetIsBadgeLegalUrl(self, url: string): nil
	function SetPlaceId(self, placeId: number): nil
	function GetBadgeInfoAsync(self, badgeId: number): { [any]: any }
	function UserHasBadgeAsync(self, userId: number, badgeId: number): boolean
end

declare class BasePlayerGui extends Instance
end

-- "Button" exists but isn't usable in any meaningful way

declare class CoreGui extends BasePlayerGui
	Version: number
	RobloxGui: ScreenGui -- graaah
end

declare class PlayerGui extends BasePlayerGui
end

declare class StarterGui extends BasePlayerGui
	CoreGuiChangedSignal: RBXScriptSignal<EnumCoreGuiType, boolean>
	ResetPlayerGuiOnSpawn: boolean
	ShowDevelopmentGui: boolean
	function GetCoreGuiEnabled(self, coreGuiType: EnumCoreGuiType): boolean
	function SetCoreGuiEnabled(self, coreGuiType: EnumCoreGuiType, enabled: boolean): nil
end

declare class BindableEvent extends Instance
	Event: RBXScriptSignal<...any>
	function Fire(self, ...: any): ()
end

declare class BindableFunction extends Instance
	OnInvoke: (...any) -> ...any
	function Invoke(self, ...: any): ...any
end

declare class BodyMover extends Instance
end

declare class BodyAngularVelocity extends BodyMover
	angularvelocity: Vector3
	maxTorque: Vector3
	P: number
end

declare class BodyForce extends BodyMover
	force: Vector3
end

declare class BodyGyro extends BodyMover
	cframe: CFrame
	D: number
	maxTorque: Vector3
	P: number
end

declare class BodyPosition extends BodyMover
	D: number
	maxForce: Vector3
	P: number
	position: Vector3
	ReachedTarget: RBXScriptSignal<>
	function GetLastForce(self): Vector3 -- lastForce also exists
end

declare class BodyThrust extends BodyMover
	force: Vector3
	location: Vector3
end

declare class BodyVelocity extends BodyMover
	maxForce: Vector3
	P: number
	velocity: Vector3
	function GetLastForce(self): Vector3 -- lastForce also exists
end

declare class CacheableContentProvider extends Instance
end

declare class MeshContentProvider extends CacheableContentProvider
end

declare class TextContentProvider extends CacheableContentProvider
end

declare class Camera extends Instance
	CoordinateFrame: CFrame -- no, .CFrame doesn't exist
	CameraSubject: Humanoid | BasePart | nil
	CameraType: EnumCameraType
	FieldOfView: number
	FirstPersonTransition: RBXScriptSignal<boolean>
	Focus: CFrame
	InterpolationFinished: RBXScriptSignal<>
	function GetPanSpeed(self): number
	function GetRoll(self): number
	function GetTiltSpeed(self): number
	function Interpolate(self, endPos: CFrame, endFocus: CFrame, duration: number): nil
	function PanUnits(self, units: number): nil
	function SetCameraPanMode(self, mode: EnumCameraPanMode?): nil
	function SetRoll(self, rollAngle: number): nil
	function TiltUnits(self, units: number): nil
	function Zoom(self, distance: number): boolean
end


declare class ChangeHistoryService extends Instance
	function GetCanRedo(self): any
	function GetCanUndo(self): any
	function Redo(self): nil
	function ResetWaypoints(self): nil
	function SetEnabled(self, state: boolean): nil
	function SetWaypoint(self, name: string): nil
	function Undo(self): nil
end

declare class CharacterAppearance extends Instance
end

declare class BodyColors extends CharacterAppearance
	-- rip no colour3s
	HeadColor: BrickColor
	LeftArmColor: BrickColor
	LeftLegColor: BrickColor
	RightArmColor: BrickColor
	RightLegColor: BrickColor
	TorsoColor: BrickColor
end

declare class CharacterMesh extends CharacterAppearance
	BaseTextureId: number
	BodyPart: EnumBodyPart
	MeshId: number
	OverlayTextureId: number
end

declare class Clothing extends CharacterAppearance
end

declare class Pants extends Clothing
	PantsTemplate: Content
end

declare class Shirt extends Clothing
	ShirtTemplate: Content
end

declare class ShirtGraphic extends CharacterAppearance
	Graphic: Content -- warning lel
end



declare class Chat extends Instance
	Chatted: RBXScriptSignal<BasePart, string, EnumChatColor>
	function Chat(self, partOrCharacter: Instance, message: string, color: EnumChatColor?): nil
end

declare class ClickDetector extends Instance
	MaxActivationDistance: number
	MouseClick: RBXScriptSignal<Player>
	MouseHoverEnter: RBXScriptSignal<Player>
	MouseHoverLeave: RBXScriptSignal<Player>
end

declare class ClusterPacketCache extends Instance
end

declare class CollectionService extends Instance
	ItemAdded: RBXScriptSignal<Instance>
	ItemRemoved: RBXScriptSignal<Instance>
	function GetCollection(self, tag: string): { Instance }
end

declare class Configuration extends Instance
end

declare class ContentFilter extends Instance
	function SetFilterLimits(self, outstandingRequests: number, cacheSize: number): nil
	function SetFilterUrl(self, url: string): nil
end

declare class ContentProvider extends Instance
	BaseUrl: string
	RequestQueueSize: number
	function Preload(self, contentId: string): nil
	function SetAssetUrl(self, url: string): nil
	function SetBaseUrl(self, url: string): nil
	function SetCacheSize(self, size: number): nil
	function SetThreadPool(self, count: number): nil
end

declare class ContextActionService extends Instance
	ContextButtonEnabled: boolean
	LocalToolEquipped: RBXScriptSignal<Tool>
	LocalToolUnequipped: RBXScriptSignal<Tool>
	function ActivateLocalTool(self): nil
	function DeactivateLocalTool(self): nil
	function GetCurrentLocalToolIcon(self): string
end

declare class Controller extends Instance
	ButtonChanged: RBXScriptSignal<EnumButton>
	function BindButton(self, button: EnumButton, caption: string): nil
	function GetButton(self, button: EnumButton): boolean
	function UnbindButton(self, button: EnumButton): nil
end

declare class HumanoidController extends Controller
end

declare class SkateboardController extends Controller
	AxisChanged: RBXScriptSignal<string>
	Steer: number
	Throttle: number
end

declare class VehicleController extends Controller
end

declare class ControllerService extends Instance
end

declare class CookiesService extends Instance
	-- "An error occurred" when calling any of these methods
	function DeleteCookieValue(self, key: string): nil
	function GetCookieValue(self, key: string): string
	function SetCookieValue(self, key: string, value: string): nil
end

declare class DataModelMesh extends Instance
	Offset: Vector3
	Scale: Vector3
	VertexColor: Vector3
end

declare class BlockMesh extends DataModelMesh -- technically extends BevelMesh, but that's deprecated
end

declare class CylinderMesh extends DataModelMesh -- same
end

declare class FileMesh extends DataModelMesh
	MeshId: Content
	TextureId: Content
end

declare class SpecialMesh extends FileMesh
	MeshType: EnumMeshType
end

declare class DataStoreInfo extends Instance
	CreatedTime: number
	DataStoreName: string
	UpdatedTime: number
end

declare class DataStoreKey extends Instance
	KeyName: string
end

declare class DataStoreKeyInfo extends Instance
	CreatedTime: number
	UpdatedTime: number
	Version: string
	function GetMetadata(self): { [any]: any }
	function GetUserIds(self): { number }
end

declare class DataStoreObjectVersionInfo extends Instance
	CreatedTime: number
	IsDeleted: boolean
	Version: string
end

declare class DataStoreOptions extends Instance
	AllScopes: boolean
	function SetExperimentalFeatures(self, experimentalFeatures: { [any]: any }): nil
end

declare class DataStoreService extends Instance
	function GetGlobalDataStore(self): GlobalDataStore
end

declare class Debris extends Instance
	function AddItem(self, item: Instance, lifetime: number?): nil
	function SetLegacyMaxItems(self, enabled: boolean): nil
end

declare class DebugSettings extends Instance
	DataModel: number
	InstanceCount: number
	IsScriptStackTracingEnabled: boolean
	JobCount: number
	PlayerCount: number
	ReportSoundWarnings: boolean
	RobloxVersion: string
	TickCountPreciseOverride: EnumTickCountSampleMethod

	LuaRamLimit: number

	function LegacyScriptMode(self): nil
end

declare class DebuggerBreakpoint extends Instance
	Condition: string
	IsEnabled: boolean
	Line: number
end

declare class DebuggerManager extends Instance
	DebuggerAdded: RBXScriptSignal<Instance>
	DebuggerRemoved: RBXScriptSignal<Instance>
	DebuggingEnabled: boolean
	function AddDebugger(self, script: Instance): Instance
	function EnableDebugging(self): nil
	function GetDebuggers(self): { Instance }
end

declare class DebuggerWatch extends Instance
	Expression: string
end

declare class Dialog extends Instance
	ConversationDistance: number
	DialogChoiceSelected: RBXScriptSignal<Player, DialogChoice>
	GoodbyeChoiceActive: boolean
	GoodbyeDialog: string
	InUse: boolean
	InitialPrompt: string
	Purpose: EnumDialogPurpose
	Tone: EnumDialogTone
	TriggerDistance: number
	TriggerOffset: Vector3
	function GetCurrentPlayers(self): { Player }
	function SetPlayerIsUsing(self, player: Instance, isUsing: boolean): nil
	function SignalDialogChoiceSelected(self, player: Instance, dialogChoice: Instance): nil
end

declare class DialogChoice extends Instance
	GoodbyeChoiceActive: boolean
	GoodbyeDialog: string
	ResponseDialog: string
	UserDialog: string
end

declare class Dragger extends Instance
	function AxisRotate(self, axis: EnumAxis?): nil
	function MouseDown(self, mousePart: Instance, pointOnMousePart: Vector3, parts: { Instance }): nil
	function MouseMove(self, mouseRay: Ray): nil
	function MouseUp(self): nil
end

declare class Explosion extends Instance
	BlastPressure: number
	BlastRadius: number
	DestroyJointRadiusPercent: number
	ExplosionType: EnumExplosionType
	Hit: RBXScriptSignal<BasePart, number>
	Position: Vector3
	TimeScale: number
	Visible: boolean
end

declare class FaceInstance extends Instance
	Face: EnumNormalId
end

declare class Decal extends FaceInstance
	Color3: Color3
	LocalTransparencyModifier: number
	Texture: Content
	Transparency: number
	ZIndex: number
end

declare class Texture extends Decal
	OffsetStudsU: number
	OffsetStudsV: number
	StudsPerTileU: number
	StudsPerTileV: number
end

declare class Feature extends Instance
	FaceId: EnumNormalId
	InOut: EnumInOut
	LeftRight: EnumLeftRight
	TopBottom: EnumTopBottom
end

declare class Fire extends Instance
	Color: Color3
	Enabled: boolean
	Heat: number
	SecondaryColor: Color3
	Size: number
	TimeScale: number
	function FastForward(self, numFrames: number): nil
end

declare class FlagStandService extends Instance
end

-- (sing to the tune of "you give love a bad name")
-- THIS INTEGRATION IS GOING TO HELL
-- YOU PROMISED ME JSON AND SENT XML
-- YOU SAY IT WORKS IN A RESTFUL WAY
-- THEN YOUR ERRORS COME BACK AS *200 OK*

declare class ForceField extends Instance
	Visible: boolean
end

-- WHOAAOA IT'S NO SURPRISE
-- METHOD NAMES IN URIS
-- YOUR DATA WON'T EVEN DESERIALIZE

-- YOUR API IS A HALL OF SHAME
-- YOU GIVE REST A BAD NAME
-- IT FALLS APART AND WE TAKE THE BLAME
-- YOU GIVE REST A BAD NAME
-- YOU GIVE REST
-- A BAD NAME

declare class FriendService extends Instance
	function SetBreakFriendUrl(self, url: string): nil
	function SetCreateFriendRequestUrl(self, url: string): nil
	function SetDeleteFriendRequestUrl(self, url: string): nil
	function SetEnabled(self, enable: boolean): nil
	function SetFriendsOnlineUrl(self, url: string): nil
	function SetGetFriendsUrl(self, url: string): nil
	function SetMakeFriendUrl(self, url: string): nil
end

-- BROKEN METHODS, MISSING DOCS
-- UPDATES FAIL CUZ OF DATABASE LOCKS
-- BREAKING CHANGES, EVERY TIME
-- YOUR EVERY RELEASE TAKES OUR SYSTEM OFFLINE
-- [chorus]

declare class GamePassService extends Instance
	function PlayerHasPass(self, player: Player, gamePassId: number): boolean
	function SetPlayerHasPassUrl(self, playerHasPassUrl: string): nil
end

declare class GameSettings extends Instance
	VideoCaptureEnabled: boolean
	VideoRecording: boolean
	VideoRecordingChangeRequest: RBXScriptSignal<boolean>
end

declare class GamepadService extends Instance
	GamepadCursorEnabled: boolean
	GamepadThumbstick1Changed: RBXScriptSignal<Vector2>
	function DisableGamepadCursor(self): nil
	function EnableGamepadCursor(self, guiObject: Instance): nil
	function GetGamepadCursorPosition(self): Vector2
	function SetGamepadCursorPosition(self, position: Vector2): nil
end

declare class GlobalDataStore extends Instance
	function GetAsync(self, key: string): (any, DataStoreKeyInfo)
	function IncrementAsync(self, key: string, delta: number?): (number, DataStoreKeyInfo)
	function SetAsync(self, key: string, value: any): string
	function UpdateAsync(self, key: string, transformFunction: ((any, DataStoreKeyInfo) -> (any, { number }?, {}?))): (any, DataStoreKeyInfo)
end

declare class GuiBase extends Instance
end

declare class GuiBase2d extends GuiBase
	AbsolutePosition: Vector2
	AbsoluteSize: Vector2
end

declare class GuiObject extends GuiBase2d
	Active: boolean
	AnchorPoint: Vector2
	BackgroundColor3: Color3
	BackgroundTransparency: number
	BorderColor3: Color3
	BorderSizePixel: number
	ClipsDescendants: boolean
	InputBegan: RBXScriptSignal<InputObject>
	InputChanged: RBXScriptSignal<InputObject>
	InputEnded: RBXScriptSignal<InputObject>
	Interactable: boolean
	LayoutOrder: number
	MouseEnter: RBXScriptSignal<number, number>
	MouseLeave: RBXScriptSignal<number, number>
	MouseMoved: RBXScriptSignal<number, number>
	MouseWheelBackward: RBXScriptSignal<number, number>
	MouseWheelForward: RBXScriptSignal<number, number>
	NextSelectionDown: GuiObject
	NextSelectionLeft: GuiObject
	NextSelectionRight: GuiObject
	NextSelectionUp: GuiObject
	Position: UDim2
	Rotation: number
	Selectable: boolean
	SelectionOrder: number
	Size: UDim2
	SizeConstraint: EnumSizeConstraint
	TouchLongPress: RBXScriptSignal<{ Vector2 }, EnumUserInputState>
	TouchPan: RBXScriptSignal<{ Vector2 }, Vector2, Vector2, EnumUserInputState>
	TouchPinch: RBXScriptSignal<{ Vector2 }, number, number, EnumUserInputState>
	TouchRotate: RBXScriptSignal<{ Vector2 }, number, number, EnumUserInputState>
	TouchSwipe: RBXScriptSignal<EnumSwipeDirection, number>
	TouchTap: RBXScriptSignal<{ Vector2 }>
	Transparency: number
	Visible: boolean
	ZIndex: number
	function TweenPosition(self, endPosition: UDim2, easingDirection: EnumEasingDirection?, easingStyle: EnumEasingStyle?, time: number?, override: boolean?, callback: ((...any) -> ...any)?): boolean
	function TweenSize(self, endSize: UDim2, easingDirection: EnumEasingDirection?, easingStyle: EnumEasingStyle?, time: number?, override: boolean?, callback: ((...any) -> ...any)?): boolean
	function TweenSizeAndPosition(self, endSize: UDim2, endPosition: UDim2, easingDirection: EnumEasingDirection?, easingStyle: EnumEasingStyle?, time: number?, override: boolean?, callback: ((...any) -> ...any)?): boolean
end

declare class Frame extends GuiObject
	Style: EnumFrameStyle
end

declare class GuiButton extends GuiObject
	Activated: RBXScriptSignal<InputObject, number>
	AutoButtonColor: boolean
	Modal: boolean
	MouseButton1Click: RBXScriptSignal<>
	MouseButton1Down: RBXScriptSignal<number, number>
	MouseButton1Up: RBXScriptSignal<number, number>
	MouseButton2Click: RBXScriptSignal<>
	MouseButton2Down: RBXScriptSignal<number, number>
	MouseButton2Up: RBXScriptSignal<number, number>
	Selected: boolean
	Style: EnumButtonStyle
end

declare class ImageButton extends GuiButton
	Image: Content
	ImageRectOffset: Vector2
	ImageRectSize: Vector2
end

declare class TextButton extends GuiButton
	ContentText: string
	Font: EnumFont
	LineHeight: number
	LocalizedText: string
	MaxVisibleGraphemes: number
	RichText: boolean
	Text: string
	TextBounds: Vector2
	TextColor3: Color3
	TextFits: boolean
	TextScaled: boolean
	TextSize: number
	TextStrokeColor3: Color3
	TextStrokeTransparency: number
	TextTransparency: number
	TextWrapped: boolean
	TextXAlignment: EnumTextXAlignment
	TextYAlignment: EnumTextYAlignment
	function SetTextFromInput(self, text: string): nil
end

declare class GuiLabel extends GuiObject
end

declare class ImageLabel extends GuiLabel
	Image: Content
	ImageRectOffset: Vector2
	ImageRectSize: Vector2
end

declare class TextLabel extends GuiLabel
	ContentText: string
	Font: EnumFont
	LineHeight: number
	Text: string
	TextBounds: Vector2
	TextColor3: Color3
	TextFits: boolean
	TextScaled: boolean
	TextSize: number
	TextStrokeColor3: Color3
	TextStrokeTransparency: number
	TextTransparency: number
	TextWrapped: boolean
	TextXAlignment: EnumTextXAlignment
	TextYAlignment: EnumTextYAlignment

	FontSize: EnumFontSize
end

declare class TextBox extends GuiObject
	ClearTextOnFocus: boolean
	FocusLost: RBXScriptSignal<boolean, InputObject>
	Font: EnumFont
	LineHeight: number
	ManualFocusRelease: boolean
	MaxVisibleGraphemes: number
	MultiLine: boolean
	OverlayNativeInput: boolean
	PlaceholderColor3: Color3
	PlaceholderText: string
	ReturnPressedFromOnScreenKeyboard: RBXScriptSignal<>
	RichText: boolean
	SelectionStart: number
	ShowNativeInput: boolean
	Text: string
	TextBounds: Vector2
	TextColor3: Color3
	TextEditable: boolean
	TextFits: boolean
	TextScaled: boolean
	TextSize: number
	TextStrokeColor3: Color3
	TextStrokeTransparency: number
	TextTransparency: number
	TextWrapped: boolean
	TextXAlignment: EnumTextXAlignment
	TextYAlignment: EnumTextYAlignment
	function CaptureFocus(self): nil
	function IsFocused(self): boolean
	function ReleaseFocus(self, submitted: boolean?): nil
	function ResetKeyboardMode(self): nil
	function SetTextFromInput(self, text: string): nil
end

declare class LayerCollector extends GuiBase2d
end

declare class BillboardGui extends LayerCollector
	Active: boolean
	Adornee: Instance
	AlwaysOnTop: boolean
	Brightness: number
	ClipsDescendants: boolean
	CurrentDistance: number
	DistanceLowerLimit: number
	DistanceStep: number
	DistanceUpperLimit: number
	ExtentsOffset: Vector3
	ExtentsOffsetWorldSpace: Vector3
	LightInfluence: number
	MaxDistance: number
	PlayerToHideFrom: Instance
	Size: UDim2
	SizeOffset: Vector2
	StudsOffset: Vector3
	StudsOffsetWorldSpace: Vector3
	function GetScreenSpaceBounds(self): any
end

declare class PluginGui extends LayerCollector
	PluginDragDropped: RBXScriptSignal<{ [any]: any }>
	PluginDragEntered: RBXScriptSignal<{ [any]: any }>
	PluginDragLeft: RBXScriptSignal<{ [any]: any }>
	PluginDragMoved: RBXScriptSignal<{ [any]: any }>
	Title: string
	WindowFocusReleased: RBXScriptSignal<>
	WindowFocused: RBXScriptSignal<>
	function BindToClose(self, func: ((...any) -> ...any)?): nil
	function GetRelativeMousePosition(self): Vector2
end

declare class QWidgetPluginGui extends PluginGui
end

declare class ScreenGui extends LayerCollector
end



declare class SurfaceGuiBase extends LayerCollector
	Active: boolean
	Adornee: Instance
	Face: EnumNormalId
end

declare class SurfaceGui extends SurfaceGuiBase
	AlwaysOnTop: boolean
	Brightness: number
	CanvasSize: Vector2
	ClipsDescendants: boolean
	HorizontalCurvature: number
	LightInfluence: number
	PixelsPerStud: number
	ToolPunchThroughDistance: number
	ZOffset: number
end

declare class GuiBase3d extends GuiBase
	Color3: Color3
	Transparency: number
	Visible: boolean
end



declare class InstanceAdornment extends GuiBase3d
	Adornee: Instance?
end

declare class SelectionBox extends InstanceAdornment
	LineThickness: number
	StudioSelectionBox: boolean
	SurfaceColor3: Color3
	SurfaceTransparency: number
end

declare class PVAdornment extends GuiBase3d
	Adornee: PVInstance
end

declare class PartAdornment extends GuiBase3d
	Adornee: BasePart?
end

declare class HandlesBase extends PartAdornment
end

declare class ArcHandles extends HandlesBase
	Axes: Axes
	MouseButton1Down: RBXScriptSignal<EnumAxis>
	MouseButton1Up: RBXScriptSignal<EnumAxis>
	MouseDrag: RBXScriptSignal<EnumAxis, number, number>
	MouseEnter: RBXScriptSignal<EnumAxis>
	MouseLeave: RBXScriptSignal<EnumAxis>
end

declare class Handles extends HandlesBase
	Faces: Faces
	MouseButton1Down: RBXScriptSignal<EnumNormalId>
	MouseButton1Up: RBXScriptSignal<EnumNormalId>
	MouseDrag: RBXScriptSignal<EnumNormalId, number>
	MouseEnter: RBXScriptSignal<EnumNormalId>
	MouseLeave: RBXScriptSignal<EnumNormalId>
	Style: EnumHandlesStyle
end

declare class SurfaceSelection extends PartAdornment
	TargetSurface: EnumNormalId
end

declare class SelectionLasso extends GuiBase3d
	Humanoid: Humanoid
end

declare class GuiService extends Instance
	AutoSelectGuiEnabled: boolean
	CloseInspectMenuRequest: RBXScriptSignal<>
	CoreGuiNavigationEnabled: boolean
	CoreGuiRenderOverflowed: RBXScriptSignal<>
	EmotesMenuOpenChanged: RBXScriptSignal<boolean>
	GuiNavigationEnabled: boolean
	InspectMenuEnabledChangedSignal: RBXScriptSignal<boolean>
	InspectPlayerFromUserIdWithCtxRequest: RBXScriptSignal<number, string>
	KeyPressed: RBXScriptSignal<string, string>
	MenuClosed: RBXScriptSignal<>
	MenuIsOpen: boolean
	MenuOpened: RBXScriptSignal<>
	NativeClose: RBXScriptSignal<>
	NetworkPausedEnabledChanged: RBXScriptSignal<boolean>
	Open9SliceEditor: RBXScriptSignal<Instance>
	PreferredTransparency: number
	PurchasePromptShown: RBXScriptSignal<>
	ReducedMotionEnabled: boolean
	SafeZoneOffsetsChanged: RBXScriptSignal<>
	SelectedCoreObject: GuiObject
	SelectedObject: GuiObject?
	SendCoreUiNotification: (title: string, text: string) -> nil
	SendNotification: (self: GuiService, title: string, text: string, text2: string, number: number, callback: (any) -> any) -> nil
	ShowLeaveConfirmation: RBXScriptSignal<>
	SpecialKeyPressed: RBXScriptSignal<EnumSpecialKey, string>
	TouchControlsEnabled: boolean

	EscapeKeyPressed: RBXScriptSignal<>
	BrowserWindowClosed: RBXScriptSignal<>
	IsWindows: boolean
	IsModalDialog: boolean
	UseLuaChat: boolean

	function AddCenterDialog(self, dialog: Instance, centerDialogType: EnumCenterDialogType, showFunction: ((...any) -> ...any), hideFunction: ((...any) -> ...any)): nil
	function AddKey(self, key: string): nil
	function AddSelectionParent(self, selectionName: string, selectionParent: Instance): nil
	function AddSelectionTuple(self, selectionName: string, selections: any): nil
	function AddSpecialKey(self, key: EnumSpecialKey): nil
	function BroadcastNotification(self, data: string, notificationType: number): nil
	function ClearError(self): nil
	function CloseInspectMenu(self): nil
	function CloseStatsBasedOnInputString(self, input: string): boolean
	function ForceTenFootInterface(self, isForced: boolean): nil
	function GetBrickCount(self): number
	function GetClosestDialogToPosition(self, position: Vector3): Instance
	function GetEmotesMenuOpen(self): boolean
	function GetGameplayPausedNotificationEnabled(self): boolean
	function GetGuiInset(self): (Vector2, Vector2)
	function GetInspectMenuEnabled(self): boolean
	function GetNotificationTypeList(self): { [any]: any }
	function GetResolutionScale(self): number
	function GetSafeZoneOffsets(self): { [any]: any }
	function GetScreenResolution(self): Vector2
	function GetUiMessage(self): string
	function InspectPlayerFromUserId(self, userId: number): nil
	function InspectPlayerFromUserIdWithCtx(self, userId: number, ctx: string): nil
	function IsMemoryTrackerEnabled(self): boolean
	function IsTenFootInterface(self): boolean
	function RemoveCenterDialog(self, dialog: Instance): nil
	function RemoveKey(self, key: string): nil
	function RemoveSelectionGroup(self, selectionName: string): nil
	function RemoveSpecialKey(self, key: EnumSpecialKey): nil
	function Select(self, selectionParent: Instance): nil
	function SetEmotesMenuOpen(self, isOpen: boolean): nil
	function SetGameplayPausedNotificationEnabled(self, enabled: boolean): nil
	function SetGlobalGuiInset(self, x1: number, y1: number, x2: number, y2: number): nil
	function SetHardwareSafeAreaInsets(self, left: number, top: number, right: number, bottom: number): nil
	function SetInspectMenuEnabled(self, enabled: boolean): nil
	function SetMenuIsOpen(self, open: boolean, menuName: string?): nil
	function SetPurchasePromptIsShown(self, isShown: boolean): nil
	function SetSafeZoneOffsets(self, top: number, bottom: number, left: number, right: number): nil
	function ShowStatsBasedOnInputString(self, input: string): boolean
	function ToggleFullscreen(self): nil

	function OpenBrowserWindow(self, url: string): nil
	function SetGlobalSizeOffsetPixel(self, x: number, y: number): nil
end

declare class GuidRegistryService extends Instance
end

declare class HttpService extends Instance
	HttpEnabled: boolean
	function GetAsync(self, url: string, nocache: boolean?, headers: any): string
	function JSONDecode(self, input: string): any
	function JSONEncode(self, input: any): string
	function PostAsync(self, url: string, data: string, content_type: EnumHttpContentType?, compress: boolean?, headers: any): string
	function UrlEncode(self, input: string): string
end

declare class Humanoid extends Instance
	Climbing: RBXScriptSignal<number>
	Died: RBXScriptSignal<>
	FallingDown: RBXScriptSignal<boolean>
	FreeFalling: RBXScriptSignal<boolean>
	GettingUp: RBXScriptSignal<boolean>
	Health: number
	HealthChanged: RBXScriptSignal<number>
	Jump: boolean
	Jumping: RBXScriptSignal<boolean>
	MaxHealth: number
	NameOcclusion: EnumNameOcclusion
	PlatformStand: boolean
	PlatformStanding: RBXScriptSignal<boolean>
	Ragdoll: RBXScriptSignal<boolean>
	Running: RBXScriptSignal<number>
	Seated: RBXScriptSignal<boolean, Seat>
	Sit: boolean
	Strafing: RBXScriptSignal<boolean>
	Swimming: RBXScriptSignal<number>
	TargetPoint: Vector3
	WalkSpeed: number
	WalkToPart: BasePart?
	WalkToPoint: Vector3
	function EquipTool(self, tool: Tool): nil
	function GetMoveVelocity(self): Vector3
	function MoveTo(self, location: Vector3, part: BasePart?): nil
	function RemoveAccessories(self): nil
	function SetClickToWalkEnabled(self, enabled: boolean): nil
	function TakeDamage(self, amount: number): nil
	function UnequipTools(self): nil
end

declare class InputObject extends Instance
	Delta: Vector3
	Position: Vector3
	UserInputState: EnumUserInputState
	UserInputType: EnumUserInputType
end

declare class InsertService extends Instance
	AllowClientInsertModels: boolean
	function GetBaseSets(self): { any }
	function GetCollection(self, categoryId: number): { any }
	function GetFreeDecals(self, searchText: string, pageNum: number): { any }
	function GetFreeModels(self, searchText: string, pageNum: number): { any }
	function GetLatestAssetVersionAsync(self, assetId: number): number
	function GetLocalFileContents(self, contentId: string): string
	function GetUserSets(self, userId: number): { any }
	function LoadAsset(self, assetId: number): Instance
	function LoadAssetVersion(self, assetVersionId: number): Instance
	function LoadAssetWithFormat(self, assetId: number, format: string): { Instance }
	function LoadLocalAsset(self, assetPath: string): Instance
	function LoadPackageAsset(self, url: Content): { Instance }
	function LoadPackageAssetAsync(self, url: Content): { Instance }

	function SetAssetUrl(self, assetUrl: string): nil
	function SetAssetVersionUrl(self, assetVersionUrl: string): nil
	function SetBaseSetsUrl(self, baseSetsUrl: string): nil
	function SetCollectionUrl(self, collectionUrl: string): nil
	function SetUserSetsUrl(self, userSetsUrl: string): nil
	function SetTrustLevel(self, trustLevel: number): nil
	function SetFreeModelUrl(self, freeModelUrl: string): nil
	function SetFreeDecalUrl(self, freeDecalUrl: string): nil
end

declare class JointInstance extends Instance
	C0: CFrame
	C1: CFrame
	Part0: BasePart?
	Part1: BasePart?
end

declare class DynamicRotate extends JointInstance
	BaseAngle: number
end

declare class Motor extends JointInstance
	CurrentAngle: number
	DesiredAngle: number
	MaxVelocity: number
	function SetDesiredAngle(self, value: number): nil
end

declare class Motor6D extends Motor
	ChildName: string
	ParentName: string
	Transform: CFrame
end

declare class VelocityMotor extends JointInstance
	CurrentAngle: number
	DesiredAngle: number
	Hole: Hole
	MaxVelocity: number
end

declare class Weld extends JointInstance
end

declare class Keyframe extends Instance
	Time: number
	function AddPose(self, pose: Pose): nil
	function GetPoses(self): { Instance }
	function RemovePose(self, pose: Pose): nil
end

declare class KeyframeSequence extends Instance
	Loop: boolean
	Priority: EnumAnimationPriority

	function AddKeyframe(self, keyframe: Keyframe): nil
	function GetKeyframes(self): { Keyframe } -- todo test probably keyframe argh, nevermind I am absolutely taking chances now
	function RemoveKeyframe(self, keyframe: Keyframe): nil
end

declare class KeyframeSequenceProvider extends Instance
	function GetAnimations(self, userId: number, page: number?): Instance
	function GetKeyframeSequence(self, assetId: Content): Instance
	function GetKeyframeSequenceById(self, assetId: number, useCache: boolean): Instance
	function GetMemStats(self): { [any]: any }
	function RegisterActiveKeyframeSequence(self, keyframeSequence: Instance): Content
	function RegisterKeyframeSequence(self, keyframeSequence: Instance): Content
end

declare class Light extends Instance
	Brightness: number
	Color: Color3
	Enabled: boolean
	Shadows: boolean
end

declare class PointLight extends Light
	Range: number
end

declare class SpotLight extends Light
	Angle: number
	Face: EnumNormalId
	Range: number
end

declare class SurfaceLight extends Light
	Angle: number
	Face: EnumNormalId
	Range: number
end

declare class Lighting extends Instance
	Ambient: Color3
	Brightness: number
	ClockTime: number
	ColorShift_Bottom: Color3
	ColorShift_Top: Color3
	EnvironmentDiffuseScale: number
	EnvironmentSpecularScale: number
	ExposureCompensation: number
	FogColor: Color3
	FogEnd: number
	FogStart: number
	GeographicLatitude: number
	GlobalShadows: boolean
	LightingChanged: RBXScriptSignal<boolean>
	OutdoorAmbient: Color3
	ShadowSoftness: number
	TempUseNewSkyRemovalBehaviour: boolean
	TimeOfDay: string
	function GetMinutesAfterMidnight(self): number
	function GetMoonDirection(self): Vector3
	function GetMoonPhase(self): number
	function GetSunDirection(self): Vector3
	function SetMinutesAfterMidnight(self, minutes: number): nil
end

declare class LoginService extends Instance
	LoginFailed: RBXScriptSignal<string>
	LoginSucceeded: RBXScriptSignal<string>
	function Logout(self): nil
	function PromptLogin(self): nil
end

declare class LuaSettings extends Instance
	AreScriptStartsReported: boolean
	DefaultWaitTime: number
	GcFrequency: number
	GcLimit: number
	GcPause: number
	GcStepMul: number
	WaitingThreadsBudget: number
end

declare class BaseScript extends Instance
	Disabled: boolean
	LinkedSource: Content
end

declare class CoreScript extends BaseScript
end

declare class Script extends BaseScript
	Source: ProtectedString
	function GetHash(self): string
end

declare class LocalScript extends Script
end

declare class ModuleScript extends Instance
	LinkedSource: Content
	Source: ProtectedString
end

declare class LuaWebService extends Instance
end

declare class MarketplaceService extends Instance
	ClientPurchaseSuccess: RBXScriptSignal<string, number, number>
	PromptPurchaseFinished: RBXScriptSignal<Player, number, boolean>
	PromptPurchaseRequested: RBXScriptSignal<Player, number, boolean, EnumCurrencyType>
	PromptRobloxPurchaseRequested: RBXScriptSignal<number, boolean>
	PromptSubscriptionPurchaseRequested: RBXScriptSignal<Instance, string>
	ServerPurchaseVerification: RBXScriptSignal<{ [any]: any }>

	function GetProductInfo(self, assetId: number, infoType: EnumInfoType?): { [any]: any }
	function PlayerOwnsAsset(self, player: Player, assetId: number): boolean
	function PromptProductPurchase(self, player: Player, productId: number, equipIfPurchased: boolean?, currencyType: EnumCurrencyType?): nil
	function PromptPurchase(self, player: Player, assetId: number, equipIfPurchased: boolean?, currencyType: EnumCurrencyType?): nil
	function SetDevProductInfoUrl(self, url: string): nil
	function SetPlayerOwnsAssetUrl(self, url: string): nil
	function SetProductInfoUrl(self, url: string): nil
	function SignalClientPurchaseSuccess(self, ticket: string, playerId: number, productId: number): nil
	function SignalPromptProductPurchaseFinished(self, player: Instance, productId: number, success: boolean): nil
	function SignalPromptPurchaseFinished(self, player: Instance, assetId: number, success: boolean): nil
end

declare class Mouse extends Instance
	Button1Down: RBXScriptSignal<>
	Button1Up: RBXScriptSignal<>
	Button2Down: RBXScriptSignal<>
	Button2Up: RBXScriptSignal<>
	Hit: CFrame
	Icon: Content
	Idle: RBXScriptSignal<>
	KeyDown: RBXScriptSignal<string>
	KeyUp: RBXScriptSignal<string>
	Move: RBXScriptSignal<>
	Origin: CFrame
	Target: BasePart
	TargetFilter: Instance
	TargetSurface: EnumNormalId
	UnitRay: Ray
	ViewSizeX: number
	ViewSizeY: number
	WheelBackward: RBXScriptSignal<>
	WheelForward: RBXScriptSignal<>
	X: number
	Y: number
end

declare class PlayerMouse extends Mouse
end

declare class PluginMouse extends Mouse
end

declare class NetworkMarker extends Instance
	Received: RBXScriptSignal<>
end

declare class NetworkPeer extends Instance
	function SetOutgoingKBPSLimit(self, limit: number): nil
end

declare class NetworkClient extends NetworkPeer
	ConnectionAccepted: RBXScriptSignal<string, Instance>
	ConnectionRejected: RBXScriptSignal<string>
	ConnectionFailed: RBXScriptSignal<string, number, string>
	Ticket: string
	-- function Connect(self, serverAddress: string, serverPort: number, id: number, threadSleepTime: number): nil -- I don't think this method actually exists
	function Disconnect(self, blockDuration: number?): nil
	function PlayerConnect(self, userId: number, server: string, serverPort: number, clientPort: number?, threadSleepTime: number?, userName: string?): Player
end

declare class NetworkServer extends NetworkPeer
	DataBasicFiltered: RBXScriptSignal<Instance, EnumFilterResult, Instance, string>
	DataCustomFiltered: RBXScriptSignal<Instance, EnumFilterResult, Instance, string>
	IncommingConnection: RBXScriptSignal<string, Instance> -- LOL
	Port: number
	function GetClientCount(self): number
	function SetIsPlayerAuthenticationRequired(self, value: boolean): nil
	function Start(self, port: number?, threadSleepTime: number?): nil
	function Stop(self, blockDuration: number?): nil
end

declare class NetworkReplicator extends Instance
	Disconnection: RBXScriptSignal<string, boolean, string>
	MachineAddress: string
	Port: number
	function CloseConnection(self): nil
	function DisableProcessPackets(self): nil
	function EnableProcessPackets(self): nil
	function GetPlayer(self): Instance -- probably Player but I can't check this
	function GetRakStatsString(self, verbosityLevel: number?): string
	function RequestCharacter(self): nil
	function SendMarker(self): Instance
	function SetPropSyncExpiration(self, secondso: number): nil
end

declare class ServerReplicator extends NetworkReplicator
	TicketProcessed: RBXScriptSignal<number, boolean, number>
	DeleteFilter: (deletingItem: Instance) -> EnumFilterResult
	EventFilter: (firingItem: Instance, event: string) -> EnumFilterResult
	NewFilter: (newItem: Instance, parent: Instance) -> EnumFilterResult
	PropertyFilter: (changingItem: Instance, member: string, value: any) -> EnumFilterResult
	function PreventTerrainChanges(self): nil
	function SetBasicFilteringEnabled(self, value: boolean): nil
end

declare class NetworkSettings extends Instance
	ArePhysicsRejectionsReported: boolean
	CanSendPacketBufferLimit: number
	DataGCRate: number
	DataMtuAdjust: number
	DataSendPriority: EnumPacketPriority
	DataSendRate: number
	EnableHeavyCompression: boolean
	ExperimentalPhysicsEnabled: boolean
	ExtraMemoryUsed: number
	FreeMemoryMBytes: number
	FreeMemoryPoolMBytes: number
	IncommingReplicationLag: number -- bruh
	IsQueueErrorComputed: boolean
	IsThrottledByCongestionControl: boolean
	IsThrottledByOutgoingBandwidthLimit: boolean
	NetworkOwnerRate: number
	PhysicsMtuAdjust: number
	PhysicsReceive: EnumPhysicsReceiveMethod
	PhysicsSend: EnumPhysicsSendMethod
	PhysicsSendPriority: EnumPacketPriority
	PhysicsSendRate: number
	PreferredClientPort: number
	PrintEvents: boolean
	PrintInstances: boolean
	PrintPhysicsErrors: boolean
	PrintProperties: boolean
	PrintSplitMessage: boolean
	PrintStreamInstanceQuota: boolean
	PrintTouches: boolean
	ReceiveRate: number
	RenderStreamedRegions: boolean
	SendPacketBufferLimit: number
	TouchSendRate: number
	TrackDataTypes: boolean
	TrackPhysicsDetails: boolean
	UseInstancePacketCache: boolean
	UsePhysicsPacketCache: boolean
end

declare class PVInstance extends Instance
end

declare class BasePart extends PVInstance
	Anchored: boolean
	BackParamA: number
	BackParamB: number
	BackSurface: EnumSurfaceType
	BackSurfaceInput: EnumSurfaceType
	BottomParamA: number
	BottomParamB: number
	BottomSurface: EnumSurfaceType
	BottomSurfaceInput: EnumSurfaceType
	BrickColor: BrickColor
	CFrame: CFrame
	CanCollide: boolean
	Color: Color3
	Elasticity: number
	Friction: number
	FrontParamA: number
	FrontParamB: number
	FrontSurface: EnumSurfaceType
	FrontSurfaceInput: EnumSurfaceType
	LeftParamA: number
	LeftParamB: number
	LeftSurface: EnumSurfaceType
	LeftSurfaceInput: EnumSurfaceType
	Locked: boolean
	Material: EnumMaterial
	Position: Vector3
	ReceiveAge: number
	Reflectance: number
	ResizeIncrement: number
	ResizeableFaces: Faces
	RightParamA: number
	RightParamB: number
	RightSurface: EnumSurfaceType
	RightSurfaceInput: EnumSurfaceType
	Rotation: Vector3
	RotVelocity: Vector3
	Size: Vector3
	SpecificGravity: number -- might be awesome actually?
	TopParamA: number -- now back to these params again
	TopParamB: number
	TopSurface: EnumSurfaceType
	TopSurfaceInput: EnumSurfaceType
	TouchEnded: RBXScriptSignal<BasePart>
	Touched: RBXScriptSignal<BasePart> -- even 2013 has better apis than modern js frameworks, it was truly ten years ahead of its time
	Transparency: number
	Velocity: Vector3
	function BreakJoints(self): nil
	function GetConnectedParts(self, recursive: boolean?): { BasePart }
	function GetMass(self): number
	function GetRootPart(self): BasePart
	function IsGrounded(self): boolean
	function MakeJoints(self): nil
	function Resize(self, normalId: EnumNormalId, deltaAmount: number): boolean
end

declare class CornerWedgePart extends BasePart
end

declare class FormFactorPart extends BasePart
	FormFactor: EnumFormFactor -- formFactor also exists
end

declare class Part extends FormFactorPart
	Shape: EnumPartType
end

declare class Platform extends Part
end

declare class Seat extends Part
	Disabled: boolean
end

declare class SpawnLocation extends Part
	AllowTeamChangeOnTouch: boolean
	Duration: number
	Neutral: boolean
	TeamColor: BrickColor
end

declare class WedgePart extends FormFactorPart
end

-- various other part types do exist, including WedgePart, PrismPart, PyramidPart, ParallelRampPart, RightAngleRampPart, etc
-- since they are NotBrowsable, they and their associated enums are not included

--[[
	declare class ParallelRampPart extends BasePart
	end
	
	declare class PrismPart extends BasePart
		Sides: EnumPrismSides
	end
	
	declare class PyramidPart extends BasePart
		Sides: EnumPyramidSides
	end
	
	declare class RightAngleRampPart extends BasePart
	end
]]

declare class Terrain extends BasePart
	MaxExtents: Region3int16
	function AutowedgeCell(self, x: number, y: number, z: number): boolean
	function AutowedgeCells(self, region: Region3int16): boolean
	function CellCenterToWorld(self, x: number, y: number, z: number): Vector3
	function CellCornerToWorld(self, x: number, y: number, z: number): Vector3
	function Clear(self): nil
	function CopyRegion(self, region: Region3int16): Instance -- "CopyRegion is not available" ?? bruh
	function CountCells(self): number
	function GetCell(self, x: number, y: number, z: number): { any } -- not quite sure what this returns
	function GetWaterCell(self, x: number, y: number, z: number): { any } -- "tuple"
	function PasteRegion(self, region: TerrainRegion, corner: Vector3int16, pasteEmptyCells: boolean): nil
	function SetCell(self, x: number, y: number, z: number, material: EnumCellMaterial, block: EnumCellBlock, orientation: EnumCellOrientation): nil
	function SetWaterCell(self, x: number, y: number, z: number, force: EnumWaterForce, direction: EnumWaterDirection): nil
	function WorldToCell(self, position: Vector3): Vector3
	function WorldToCellPreferEmpty(self, position: Vector3): Vector3
	function WorldToCellPreferSolid(self, position: Vector3): Vector3
end

declare class TrussPart extends BasePart
	Style: EnumStyle
end

declare class VehicleSeat extends BasePart
	AreHingesDetected: number
	Disabled: boolean
	HeadsUpDisplay: boolean
	MaxSpeed: number
	Steer: number
	Throttle: number
	Torque: number
	TurnSpeed: number
end

declare class Model extends PVInstance
	PrimaryPart: BasePart?
	function BreakJoints(self): nil
	function GetModelCFrame(self): CFrame
	function GetModelSize(self): Vector3
	function MakeJoints(self): nil
	function MoveTo(self, location: Vector3): nil
	function ResetOrientationToIdentity(self): nil
	function SetIdentityOrientation(self): nil
	function TranslateBy(self, offset: Vector3): nil
end

declare class BackpackItem extends Model
	TextureId: Content
end

declare class Tool extends BackpackItem
	Activated: RBXScriptSignal<>
	CanBeDropped: boolean
	Deactivated: RBXScriptSignal<>
	Enabled: boolean
	Equipped: RBXScriptSignal<Mouse>
	Grip: CFrame
	GripForward: Vector3
	GripPos: Vector3
	GripRight: Vector3
	GripUp: Vector3
	ManualActivationOnly: boolean
	RequiresHandle: boolean
	ToolTip: string
	Unequipped: RBXScriptSignal<>
	function Activate(self): nil
	function Deactivate(self): nil
end




declare class RootInstance extends Model -- huh
end

declare class Workspace extends RootInstance
	AirDensity: number
	AllowThirdPartySales: boolean
	CurrentCamera: Camera
	DistributedGameTime: number
	FallenPartsDestroyHeight: number
	GlobalWind: Vector3
	Gravity: number
	PersistentLoaded: RBXScriptSignal<Player>
	StreamingEnabled: boolean -- brand -- spanking -- new --
	Terrain: Terrain
	function CalculateJumpDistance(self, gravity: number, jumpPower: number, walkSpeed: number): number
	function CalculateJumpHeight(self, gravity: number, jumpPower: number): number
	function CalculateJumpPower(self, gravity: number, jumpHeight: number): number
	function ExperimentalSolverIsEnabled(self): boolean
	function GetNumAwakeParts(self): number
	function GetPhysicsThrottling(self): number
	function GetRealPhysicsFPS(self): number
	function GetServerTimeNow(self): number
	function PGSIsEnabled(self): boolean
	function SetPhysicsThrottleEnabled(self, value: boolean): nil
	function ZoomToExtents(self): nil

	function FindPartOnRay(self, ray: Ray, ignoreDescendantsInstance: Instance?, terrainCellsAreCubes: boolean?, ignoreWater: boolean?): { BasePart } -- deprecated camelCase variant also exists
	function FindPartOnRayWithIgnoreList(self, ray: Ray, ignoreDescendantsTable: { Instance }, terrainCellsAreCubes: boolean?, ignoreWater: boolean?): { BasePart }
	function FindPartsInRegion3(self, region: Region3, ignoreDescendantsInstance: Instance?, maxParts: number?): { BasePart } -- deprecated camelCase variant also exists
	function InsertContent(self, url: Content): { Instance } -- yep, it's { Instance }
	function IsRegion3Empty(self, region: Region3, ignoreDescendantsInstance: Instance?): boolean
	function IsRegion3EmptyWithIgnoreList(self, region: Region3, ignoreDescendantsTable: { Instance }): boolean
end

declare class PhysicsService extends Instance
end

declare class PhysicsSettings extends Instance
	AllowSleep: boolean
	AreAnchorsShown: boolean
	AreAssembliesShown: boolean
	AreAwakePartsHighlighted: boolean
	AreBodyTypesShown: boolean
	AreContactPointsShown: boolean
	AreJointCoordinatesShown: boolean
	AreMechanismsShown: boolean
	AreModelCoordsShown: boolean
	AreOwnersShown: boolean
	ArePartCoordsShown: boolean
	AreRegionsShown: boolean
	AreUnalignedPartsShown: boolean
	AreWorldCoordsShown: boolean
	IsReceiveAgeShown: boolean
	IsTreeShown: boolean
	ParallelPhysics: boolean -- 'ooh's and 'aah's all round
	PhysicsEnvironmentalThrottle: EnumEnviromentalPhysicsThrottle
	ThrottleAdjustTime: number
end

declare class Player extends Instance
	AccountAge: number
	AppearanceDidLoad: boolean
	CameraMode: EnumCameraMode
	CanLoadCharacterAppearance: boolean
	Character: Model?
	CharacterAdded: RBXScriptSignal<Model>
	CharacterAppearance: string
	CharacterRemoving: RBXScriptSignal<Model>
	ChatMode: EnumChatMode
	Chatted: RBXScriptSignal<string, Player?>
	DataComplexity: number
	DataComplexityLimit: number
	DataReady: boolean -- wow am I glad DataStores exist
	FriendStatusChanged: RBXScriptSignal<Player, EnumFriendStatus>
	Guest: boolean -- pfft
	HasBuildTools: boolean
	Idled: RBXScriptSignal<number> -- You have been disconnected for being idle for 27 minutes.
	MaximumSimulationRadius: number
	MembershipType: EnumMembershipType
	Neutral: boolean
	OnTeleport: RBXScriptSignal<EnumTeleportState, number, string>
	PersonalServerRank: number
	SimulationRadius: number
	TeamColor: BrickColor
	userId: number

	-- unsure if these exist at all times, they're children of Player
	Backpack: Backpack
	StarterGear: StarterGear
	PlayerGui: PlayerGui

	function ClearCharacterAppearance(self): nil
	function DistanceFromCharacter(self, point: Vector3): number
	function GetFriendStatus(self, player: Player): EnumFriendStatus
	function GetFriendsOnline(self, maxFriends: number?): { any }
	function GetMouse(self): Mouse
	function GetRankInGroup(self, groupId: number): number
	function GetRoleInGroup(self, groupId: number): string
	function GetUnder13(self): boolean
	function GetWebPersonalServerRank(self): number -- "[backend]" ??
	function IsBestFriendsWith(self, userId: number): boolean
	function IsFriendsWith(self, userId: number): boolean
	function IsInGroup(self, groupId: number): boolean
	function JumpCharacter(self): nil -- "An error occured" because of course it did
	function Kick(self, message: string?): nil
	function LoadBoolean(self, key: string): boolean
	function LoadCharacter(self, inGame: boolean?): nil
	function LoadCharacterAppearance(self, assetInstance: Instance): nil
	function LoadData(self): nil
	function LoadInstance(self, key: string): Instance
	function LoadNumber(self, key: string): number
	function LoadString(self, key: string): string -- lelelamayo
	function MoveCharacter(self, walkDirection: Vector2, maxWalkDelta: number): nil -- interestingly accepts a Vector2, :Move() won't exist until 163 (13/08/2014)
	function RemoveCharacter(self): nil
	function RequestFriendship(self, player: Player): nil
	function RevokeFriendship(self, player: Player): nil
	function SaveBoolean(self, key: string, value: boolean): nil
	function SaveData(self): nil
	function SaveInstance(self, key: string, value: Instance): nil
	function SaveLeaderboardData(self): nil
	function SaveNumber(self, key: string, value: number): nil
	function SaveString(self, key: string, value: string): nil
	function SetAccountAge(self, accountAge: number): nil
	function SetMembershipType(self, membershipType: EnumMembershipType): nil
	function SetSuperSafeChat(self, value: boolean): nil
	function SetWebPersonalServerRank(self, rank: number): nil -- "WritePlayerSecurity" ???
	function WaitForDataReady(self): nil
	
	function SetUnder13(self, value: boolean): nil -- of course "An error occured", may be either deprecated at an unknown time or could be one of the longest deprecated methods in API history
end

declare class Players extends Instance
	BubbleChat: boolean
	CharacterAutoLoads: boolean
	ClassicChat: boolean
	FriendRequestEvent: RBXScriptSignal<Player, Player, EnumFriendRequestEvent>
	GameAnnounce: RBXScriptSignal<string>
	LocalPlayer: Player
	MaxPlayers: number
	NumPlayers: number
	PlayerAdded: RBXScriptSignal<Player>
	PlayerAddedEarly: RBXScriptSignal<Player>
	PlayerChatted: RBXScriptSignal<EnumPlayerChatType, Player, string, Player?>
	PlayerRemoving: RBXScriptSignal<Player>
	PlayerRemovingLate: RBXScriptSignal<Player>
	function AddLeaderboardKey(self, key: string): nil -- this exists?? can't tell if it works
	function Chat(self, message: string): nil
	function CreateLocalPlayer(self, id: number): Player
	function GetPlayerByID(self, userId: number): Player?
	function GetPlayerFromCharacter(self, character: Model): Player?
	function GetPlayers(self): { Player }
	function ReportAbuse(self, player: Player, reason: string, optionalMessage: string): nil -- >be me >reviewing 2013 api at 4am >`optionalMessage` >required argument
	function SetAbuseReportUrl(self, url: string): nil
	function SetBuildUserPermissionsUrl(self, url: string): nil
	function SetChatFilterUrl(self, url: string): nil
	function SetChatStyle(self, style: EnumChatStyle?): nil
	function SetLoadDataUrl(self, url: string): nil
	function SetSaveDataUrl(self, url: string): nil
	function SetSaveLeaderboardDataUrl(self, url: string): nil
	function SetSysStatsUrl(self, url: string): nil
	function SetSysStatsUrlId(self, urlId: string): nil
	function TeamChat(self, message: string): nil
	function WhisperChat(self, message: string, player: Instance): nil -- todo test it's probably Player as well
end

declare class Plugin extends Instance
	Deactivation: RBXScriptSignal<>
	function Activate(self, exclusiveMouse: boolean): nil
	function CreateToolbar(self, name: string): Instance
	function GetMouse(self): PluginMouse
	function GetSetting(self, key: string): any
	function GetStudioUserId(self): number
	function SaveSelectedToRoblox(self): nil
	function SetSetting(self, key: string, value: any): nil
end

declare class PluginManager extends Instance
	function CreatePlugin(self): Plugin -- probably fucking Plugin, todo test AGAIN
end

declare class Pose extends Instance
	CFrame: CFrame
	MaskWeight: number
	Weight: number
	function AddSubPose(self, pose: Pose): nil -- finally, a typed return that isn't just Instance
	-- in Haskell you have the universal type, string -> string
	-- in 2013, we have Instance -> nil instead
	-- this bad boy can fit so much unclarity in it
	function GetSubPoses(self): { Instance }
	function RemoveSubPose(self, pose: Pose): nil
end

declare class ReflectionMetadata extends Instance
end

declare class ReflectionMetadataCallbacks extends Instance
end

declare class ReflectionMetadataClasses extends Instance
end

declare class ReflectionMetadataEvents extends Instance
end

declare class ReflectionMetadataFunctions extends Instance
end

declare class ReflectionMetadataItem extends Instance
	Browsable: boolean
	Deprecated: boolean
	IsBackend: boolean
	summary: string
end

-- confusing ass name broke the defs.d.lua parser I wrote in 20 seconds
declare class ReflectionMetadataClass extends ReflectionMetadataItem
	ExplorerImageIndex: number
	ExplorerOrder: number
	PreferredParent: string
end

declare class ReflectionMetadataMember extends ReflectionMetadataItem
end

declare class ReflectionMetadataProperties extends Instance
end

declare class ReflectionMetadataYieldFunctions extends Instance
end

-- Revel in this, you don't get it often.
-- Event-based programming over the network truly is timeless. Did I mention that 2013 was ten years ahead of its time?
declare class RemoteEvent extends Instance
	OnClientEvent: RBXScriptSignal<...any>
	OnServerEvent: RBXScriptSignal<(Player, ...any)>
	function FireAllClients(self, ...: any): ()
	function FireClient(self, player: Player, ...: any): ()
	function FireServer(self, ...: any): ()
end

-- Functionality that was brand new at the time, and in the decade since then, hasn't changed a jot.
-- Revolutionary then, now a staple of development and still something back-of-the-frontend/front-of-the-backend Typescript developers go wild for today.
declare class RemoteFunction extends Instance
	OnClientInvoke: (...any) -> ...any
	OnServerInvoke: (player: Player, ...any) -> ...any
	function InvokeClient(self, player: Player, ...: any): ...any
	function InvokeServer(self, ...: any): ...any
end

declare class RenderHooksService extends Instance
	function CaptureMetrics(self): nil
	function DisableQueue(self, qId: number): nil
	function EnableAdorns(self, enabled: boolean): nil
	function EnableQueue(self, qId: number): nil
	function GetDeltaAve(self): number
	function GetGPUDelay(self): number
	function GetPresentTime(self): number
	function GetRenderAve(self): number
	function GetRenderConfMax(self): number
	function GetRenderConfMin(self): number
	function GetRenderStd(self): number
	function PrintScene(self): nil
	function ReloadShaders(self): nil
	function ResizeWindow(self, width: number, height: number): nil
end

declare class RenderSettings extends Instance
	AASamples: EnumAASamples
	AlwaysDrawConnectors: boolean
	Antialiasing: EnumAntialiasing
	AutoFRMLevel: number
	DebugDisableInterpolation: boolean
	EagerBulkExecution: boolean
	EnableFRM: boolean
	FrameRateManager: EnumFramerateManagerMode
	graphicsMode: EnumGraphicsMode
	IsAggregationShown: boolean
	IsSynchronizedWithPhysics: boolean
	MeshCacheSize: number
	QualityLevel: EnumQualityLevel
	Resolution: EnumResolution
	Shadow: EnumShadow
	ShowBoundingBoxes: boolean
	TextureCacheSize: number
	UsesPaintMessage: boolean
	function GetMaxQualityLevel(self): number
end

declare class ReplicatedStorage extends Instance
end

declare class RunService extends Instance
	Heartbeat: RBXScriptSignal<number>
	RenderStepped: RBXScriptSignal<number>
	Stepped: RBXScriptSignal<number, number> -- "(double time, double step)" double time? no way
	function Pause(self): nil
	function Run(self): nil
	function Stop(self): nil
end

declare class RuntimeScriptService extends Instance
end

declare class ScriptContext extends Instance
	CamelCaseViolation: RBXScriptSignal<string, string, Instance> -- LOLL (also instance is probably a BaseScript or something)
	Error: RBXScriptSignal<string, string, Instance>
	GarbageCollectionFrequency: number
	GarbageCollectionLimit: number
	ScriptsDisabled: boolean
	function AddCoreScript(self, assetId: number, parent: Instance, name: string): nil -- player or instance
	function AddStarterScript(self, assetId: number): nil
	function GetHeapStats(self): { any } -- no clue
	function LibraryRegistrationComplete(self): nil
	function RegisterLibrary(self, libraryName: string, assetId: string): nil
	function RegisterRobloxLibrary(self, libraryName: string, assetId: string): nil -- must try this out and see wtf it does
	function SetCollectScriptStats(self, enable: boolean?): nil
	function SetTimeout(self, seconds: number): nil
end

declare class ScriptDebugger extends Instance
	BreakpointAdded: RBXScriptSignal<Instance>
	BreakpointRemoved: RBXScriptSignal<Instance>
	CurrentLine: number
	EncounteredBreak: RBXScriptSignal<number>
	IsDebugging: boolean
	IsPaused: boolean
	Resuming: RBXScriptSignal<>
	Script: Instance
	WatchAdded: RBXScriptSignal<Instance>
	WatchRemoved: RBXScriptSignal<Instance>
	function AddWatch(self, expression: string): Instance
	function GetBreakpoints(self): { Instance }
	function GetGlobals(self, stackFrame: number?): { [any]: any }
	function GetLocals(self, stackFrame: number?): { [any]: any }
	function GetStack(self): { any }
	function GetUpvalues(self, stackFrame: number?): { [any]: any }
	function GetWatchValue(self, watch: Instance): any
	function GetWatches(self): { Instance }
	function SetBreakpoint(self, line: number, isContextDependentBreakpoint: boolean): Instance
	function SetGlobal(self, name: string, value: any, stackFrame: number): nil
	function SetLocal(self, name: string, value: any, stackFrame: number?): nil
	function SetUpvalue(self, name: string, value: any, stackFrame: number?): nil
	function StepIn(self): nil
	function StepOut(self): nil
	function StepOver(self): nil
end

declare class ScriptService extends Instance -- you've heard of ServerScriptService,
end

declare class Selection extends Instance
	SelectionChanged: RBXScriptSignal<> -- "something changed! good luck figuring out what lmao"
	function Get(self): { Instance }
	function Set(self, selection: { Instance }): nil
end

declare class ServerScriptService extends Instance
end

declare class ServerStorage extends Instance
end

declare class ThumbnailGenerator extends Instance -- Tap in rcc before carrot gets it
	function Click(self, format: "PNG" | "OBJ", x: number, y: number, hideSky: boolean, crop: boolean?): string
end -- "Stop looking back, what God has for you, you have not seen before and it's not back there!! #NewCreature #GetOutofYourOwnWay #RCCService" - Josh Brown @JoshLB, sometime in 2016

declare class ServiceProvider extends Instance
	Close: RBXScriptSignal<>
	CloseLate: RBXScriptSignal<>
	ServiceAdded: RBXScriptSignal<Instance>
	ServiceRemoving: RBXScriptSignal<Instance>

	AssetService: AssetService
	BadgeService: BadgeService
	CacheableContentProvider: CacheableContentProvider
	ChangeHistoryService: ChangeHistoryService
	Chat: Chat
	ClusterPacketCache: ClusterPacketCache
	CollectionService: CollectionService
	ContentProvider: ContentProvider
	ContextActionService: ContextActionService
	ControllerService: ControllerService
	CookiesService: CookiesService
	CoreGui: CoreGui
	DataStoreService: DataStoreService
	Debris: Debris
	DebuggerManager: DebuggerManager
	FlagStandService: FlagStandService
	FriendService: FriendService
	GamePassService: GamePassService
	GamepadService: GamepadService
	GuiService: GuiService
	GuidRegistryService: GuidRegistryService
	HttpService: HttpService
	InsertService: InsertService
	KeyframeSequenceProvider: KeyframeSequenceProvider
	Lighting: Lighting
	LoginService: LoginService
	LuaWebService: LuaWebService
	MarketplaceService: MarketplaceService
	MeshContentProvider: MeshContentProvider
	NetworkClient: NetworkClient
	NetworkServer: NetworkServer
	NetworkSettings: NetworkSettings
	PhysicsService: PhysicsService
	Players: Players
	RenderSettings: RenderSettings
	ReplicatedStorage: ReplicatedStorage
	RunService: RunService
	RuntimeScriptService: RuntimeScriptService
	ScriptContext: ScriptContext
	ScriptService: ScriptService
	Selection: Selection
	ServerScriptService: ServerScriptService
	ServerStorage: ServerStorage
	SocialService: SocialService
	SoundService: SoundService
	SpawnerService: SpawnerService
	StarterGui: StarterGui
	StarterPack: StarterPack
	StarterPlayer: StarterPlayer
	Stats: Stats
	TaskScheduler: TaskScheduler
	TeamCreateData: TeamCreateData
	TeamCreateService: TeamCreateService
	Teams: Teams
	TeleportService: TeleportService
	TestService: TestService
	TimerService: TimerService
	UserInputService: UserInputService
	VirtualUser: VirtualUser
	Visit: Visit
	Workspace: Workspace

	LoadingGuiService: any
	ScriptInformationProvider: ScriptInformationProvider
	JointsService: JointsService
	ThumbnailGenerator: ThumbnailGenerator

	function FindService(self, className: string): Instance
	function GetService(self, service: "AssetService"): AssetService
	function GetService(self, service: "BadgeService"): BadgeService
	function GetService(self, service: "CacheableContentProvider"): CacheableContentProvider
	function GetService(self, service: "ChangeHistoryService"): ChangeHistoryService
	function GetService(self, service: "Chat"): Chat
	function GetService(self, service: "ClusterPacketCache"): ClusterPacketCache
	function GetService(self, service: "CollectionService"): CollectionService
	function GetService(self, service: "ContentProvider"): ContentProvider
	function GetService(self, service: "ContextActionService"): ContextActionService
	function GetService(self, service: "ControllerService"): ControllerService
	function GetService(self, service: "CookiesService"): CookiesService
	function GetService(self, service: "CoreGui"): CoreGui
	function GetService(self, service: "DataStoreService"): DataStoreService
	function GetService(self, service: "Debris"): Debris
	function GetService(self, service: "DebuggerManager"): DebuggerManager
	function GetService(self, service: "FlagStandService"): FlagStandService
	function GetService(self, service: "FriendService"): FriendService
	function GetService(self, service: "GamePassService"): GamePassService
	function GetService(self, service: "GamepadService"): GamepadService
	function GetService(self, service: "GuiService"): GuiService
	function GetService(self, service: "GuidRegistryService"): GuidRegistryService
	function GetService(self, service: "Hopper"): Hopper
	function GetService(self, service: "HttpService"): HttpService
	function GetService(self, service: "InsertService"): InsertService
	function GetService(self, service: "JointsService"): JointsService
	function GetService(self, service: "KeyframeSequenceProvider"): KeyframeSequenceProvider
	function GetService(self, service: "Lighting"): Lighting
	function GetService(self, service: "LoginService"): LoginService
	function GetService(self, service: "LuaWebService"): LuaWebService
	function GetService(self, service: "MarketplaceService"): MarketplaceService
	function GetService(self, service: "MeshContentProvider"): MeshContentProvider
	function GetService(self, service: "NetworkClient"): NetworkClient
	function GetService(self, service: "NetworkServer"): NetworkServer
	function GetService(self, service: "NetworkSettings"): NetworkSettings
	function GetService(self, service: "PhysicsService"): PhysicsService
	function GetService(self, service: "Players"): Players
	function GetService(self, service: "PointsService"): PointsService
	function GetService(self, service: "RenderSettings"): RenderSettings
	function GetService(self, service: "ReplicatedStorage"): ReplicatedStorage
	function GetService(self, service: "RunService"): RunService
	function GetService(self, service: "RuntimeScriptService"): RuntimeScriptService
	function GetService(self, service: "ScriptContext"): ScriptContext
	function GetService(self, service: "ScriptService"): ScriptService
	function GetService(self, service: "Selection"): Selection
	function GetService(self, service: "ServerScriptService"): ServerScriptService
	function GetService(self, service: "ServerStorage"): ServerStorage
	function GetService(self, service: "SocialService"): SocialService
	function GetService(self, service: "SoundService"): SoundService
	function GetService(self, service: "SpawnerService"): SpawnerService
	function GetService(self, service: "StarterGui"): StarterGui
	function GetService(self, service: "StarterPack"): StarterPack
	function GetService(self, service: "StarterPlayer"): StarterPlayer
	function GetService(self, service: "Stats"): Stats
	function GetService(self, service: "TaskScheduler"): TaskScheduler
	function GetService(self, service: "TeamCreateData"): TeamCreateData
	function GetService(self, service: "TeamCreateService"): TeamCreateService
	function GetService(self, service: "Teams"): Teams
	function GetService(self, service: "TeleportService"): TeleportService
	function GetService(self, service: "TestService"): TestService
	function GetService(self, service: "TimerService"): TimerService
	function GetService(self, service: "TweenService"): nil
	function GetService(self, service: "UserInputService"): UserInputService
	function GetService(self, service: "VirtualUser"): VirtualUser
	function GetService(self, service: "Visit"): Visit
	function GetService(self, service: "Workspace"): Workspace

	function GetService(self, service: "ScriptInformationProvider"): ScriptInformationProvider
	function GetService(self, service: "LoadingGuiService"): any
	function GetService(self, service: "PersonalServerService"): PersonalServerService
	function GetService(self, service: "Terrain"): Terrain
	function GetService(self, service: "ThumbnailGenerator"): ThumbnailGenerator
end

declare class DataModel extends ServiceProvider
	AllowedGearTypesChanged: RBXScriptSignal<>
	CreatorId: number
	CreatorType: EnumCreatorType
	GearGenreSetting: EnumGearGenreSetting
	Genre: EnumGenre
	GraphicsQualityChangeRequest: RBXScriptSignal<boolean>
	ItemChanged: RBXScriptSignal<Instance, Property> -- api ref says "Property" and I haven't a clue what that might mean, oh turns out it's just a string
	JobId: string
	Loaded: RBXScriptSignal<>
	LocalSaveEnabled: boolean
	PlaceId: number
	PlaceVersion: number
	RequestShutdown: (...any) -> ...any
	Workspace: Workspace
	function AddStat(self, displayName: string, stat: string): nil
	function ClearContent(self, resettingSimulation: boolean): nil
	function ClearMessage(self): nil
	function CreatePlace(self, placeName: string, templatePlaceID: number): number
	function FinishShutdown(self, localSave: boolean): nil
	function GetJobIntervalPeakFraction(self, jobname: string, greaterThan: number): number
	function GetJobsExtendedStats(self): { any }
	function GetJobsInfo(self): { any }
	function GetJobTimePeakFraction(self, jobname: string, greaterThan: number): number
	function GetObjects(self, url: Content): { Instance }
	function GetRemoteBuildMode(self): boolean
	function HttpGet(self, url: string, synchronous: boolean?): string
	function HttpGetAsync(self, url: string): string
	function HttpPost(self, url: string, data: string, synchronous: boolean?): string
	function HttpPostAsync(self, url: string, data: string): string
	function IsGearTypeAllowed(self, gearType: EnumGearType): boolean
	function IsLoaded(self): boolean
	function Load(self, url: Content): nil
	-- function Loaded(self): nil -- can't park there mate
	function LoadGame(self, assetID: number): nil
	function LoadPlugins(self): nil
	function LoadWorld(self, assetID: number): nil
	function RemoveStat(self, stat: string): nil
	function ReportMeasurement(self, id: string, key1: string, value1: string, key2: string, value2: string): nil
	function Save(self, url: Content): nil
	function SavePlace(self, saveFilter: EnumSaveFilter?): ...any
	function SaveStats(self): nil
	function SaveToRoblox(self): boolean
	function ServerSave(self): nil
	function SetCreatorId(self, creatorId: number, creatorType: EnumCreatorType): nil
	function SetGearSettings(self, genreRestriction: EnumGearGenreSetting, allowedGenres: number): nil
	function SetGenre(self, genre: EnumGenre): nil
	function SetJobsExtendedStatsWindow(self, seconds: number): nil
	function SetMessage(self, message: string): nil
	function SetMessageBrickCount(self): nil
	function SetPlaceId(self, placeId: number, robloxPlace: boolean?): nil
	function SetPlaceVersion(self, placeId: number): nil
	function SetRemoteBuildMode(self, buildModeEnabled: boolean): nil
	function SetScreenshotInfo(self, info: string): nil
	function SetServerSaveUrl(self, url: string): nil
	function SetVideoInfo(self, info: string): nil
	function Shutdown(self): nil
	function ToggleTools(self): nil
end

declare class App extends DataModel -- this class lasted about 20 versions, with 2013 being smack dab in the middle of its tiny lifespan
	Id: number
	function ConnectToGame(self, placeId: number, actionName: string): nil
	function FollowUser(self, userId: number): nil
	function GetCreations(self, userId: number, page: number?): { [any]: any } -- just says "Dictionary" and I'm not testing this. BETTER A WIDE TYPE THAN A WRONG ONE
	function SetAppId(self, newId: number): nil
	function UnloadGame(self): nil
end

declare class GenericSettings extends ServiceProvider
end

declare class UserSettings extends GenericSettings
	function Reset(self): nil
end

declare class Sky extends Instance
	CelestialBodiesShown: boolean
	SkyboxBk: Content
	SkyboxDn: Content
	SkyboxFt: Content
	SkyboxLf: Content
	SkyboxRt: Content
	SkyboxUp: Content
	StarCount: number
end

declare class Smoke extends Instance
	Color: Color3
	Enabled: boolean
	Opacity: number
	RiseVelocity: number
	Size: number
end

declare class SocialService extends Instance
	function SetBestFriendUrl(self, bestFriendUrl: string): nil
	function SetFriendUrl(self, friendUrl: string): nil
	function SetGroupRankUrl(self, groupRankUrl: string): nil
	function SetGroupRoleUrl(self, groupRoleUrl: string): nil
	function SetGroupUrl(self, groupUrl: string): nil
	function SetPackageContentsUrl(self, stuffUrl: string): nil
	function SetStuffUrl(self, stuffUrl: string): nil -- only 2013 would have a class, method, and url relating to "Stuff" that would still be in use four years later
end

declare class Sound extends Instance
	IsPaused: boolean
	IsPlaying: boolean
	Looped: boolean
	PlayOnRemove: boolean
	SoundId: Content
	Volume: number
	function Pause(self): nil
	function Play(self): nil
	function Stop(self): nil
end

declare class StockSound extends Sound
end

declare class SoundService extends Instance
	AmbientReverb: EnumReverbType
	DistanceFactor: number
	DopplerScale: number
	RolloffScale: number
	function PlayStockSound(self, sound: EnumSoundType): nil
	-- Every time I reload the language server to test it and it fails, I die a little inside
	-- just glad the Luau LSP actually shows errors in definition files now
	-- the hard bass of 7th Flicker is helping me cope
end

declare class Sparkles extends Instance
	Color: Color3
	Enabled: boolean
	SparkleColor: Color3
end

declare class SpawnerService extends Instance
end

declare class StarterGear extends Instance
end

declare class StarterPack extends GuiItem
end

declare class PlayerHUD extends GuiItem -- we're DEEP deep in the api now (aka it's now 5am)
end

declare class GuiRoot extends GuiItem
end

declare class ButtonBindingWidget extends GuiItem
end

declare class LocalBackpack extends GuiItem
	function GetOldSchoolBackpack(self): boolean -- I'm glad I have the Finobe OST to keep me company through these trying times
	function SetOldSchoolBackpack(self, show: boolean): nil -- is anybody going to use any of these functions? is anybody going to use any of these classes? is anybody here?
end

declare class StarterPlayer extends Instance
	CameraMaxZoomDistance: number
	CameraMinZoomDistance: number
	CameraMode: EnumCameraMode
	HealthDisplayDistance: number
	NameDisplayDistance: number
end

declare class Stats extends Instance
	MinReportInterval: number
	ReporterType: string
	function Report(self, category: string, data: { [any]: any }): nil -- oh, copilot is also here to keep me company! say hi copilot (copilot's response: "hi")
	function ReportJobsWindow(self): nil
	function ReportTaskScheduler(self, includeJobs: boolean?): nil
	function SetReportUrl(self, url: string): nil
end

declare class StatsItem extends Instance
	function GetValue(self): number
	function GetValueString(self): string
end

declare class ProfilingItem extends StatsItem -- dude what am I documenting, who's using this it was removed eight years ago
	function GetTimes(self, window: number?): ...any
	function GetTimesForFrames(self, frames: number?): ...any -- just saw that great talk from the creator of the Roc lang about why static typing is gonna take over the world and incremental typing isn't gonna cut it, now I see why
end

declare class RunningAverageItemDouble extends StatsItem
end

declare class RunningAverageItemInt extends StatsItem
end

declare class RunningAverageTimeIntervalItem extends StatsItem
end

declare class TotalCountTimeIntervalItem extends StatsItem
end

declare class StudioTool extends Instance -- I'm going insane
	Activated: RBXScriptSignal<>
	Deactivated: RBXScriptSignal<>
	Enabled: boolean
	Equipped: RBXScriptSignal<Instance> -- Test this it's probably a mouse cuz the api name says so
	Unequipped: RBXScriptSignal<>
end

-- `Studio` doesn't even exist
-- glad I've been testing to see whether methods return correct results on a class that won't exist for another five years

declare class TaskScheduler extends Instance
	AreArbitersThrottled: boolean -- Uhh carrot just got the Arbiter
	Concurrency: EnumConcurrencyModel
	NumRunningJobs: number
	NumSleepingJobs: number
	NumWaitingJobs: number
	PriorityMethod: EnumPriorityMethod
	SchedulerDutyCycle: number
	SchedulerRate: number
	SleepAdjustMethod: EnumSleepAdjustMethod
	ThreadAffinity: number
	ThreadPoolConfig: EnumThreadPoolConfig
	ThreadPoolSize: number
	ThrottledJobSleepTime: number
	function AddDummyJob(self, exclusive: boolean?, fps: number?): nil
end

declare class Team extends Instance
	AutoAssignable: boolean
	AutoColorCharacters: boolean
	Score: number
	TeamColor: BrickColor
end

declare class TeamCreateData extends Instance
end

declare class TeamCreateService extends Instance
	ToggleManageCollaborators: RBXScriptSignal<>
	function CloseGameIfUserDoesntHavePerms(self): nil
end

declare class Teams extends Instance
	function GetTeams(self): { Team }
	function RebalanceTeams(self): nil
end

declare class TeleportService extends Instance -- copilot and the Finobe OST (currently playing Whaley's World) may be the only things keeping me company at this time, but https://robloxapi.github.io/ref/ is still my guiding light and true companion through the night
	MenuTeleportAttempt: RBXScriptSignal<>
	function SetTeleportGui(self, gui: GuiObject): nil
	function Teleport(self, placeId: number, player: Player?, teleportData: any, customLoadingScreen: GuiObject?): nil
	function TeleportCancel(self): nil
	function TeleportToSpawnByName(self, placeId: number, spawnName: string, player: Player?, teleportData: any, customLoadingScreen: GuiObject?): nil
end

declare class TerrainRegion extends Instance
	SizeInCells: Vector3
end

declare class TestService extends Instance -- the comments I'm writing are beginning to actually help now, I can't remember the class I documented five seconds ago so I ctrl+F for the comment I just wrote instead
	AutoRuns: boolean
	Description: string
	ErrorCount: number
	Is30FpsThrottleEnabled: boolean
	IsPhysicsEnvironmentalThrottled: boolean
	IsSleepAllowed: boolean
	NumberOfPlayers: number
	ServerCollectConditionalResult: RBXScriptSignal<boolean, string, Instance, number> -- deep in thought now, wondering why RBXScriptSignal connection arguments don't have names attached
	ServerCollectResult: RBXScriptSignal<string, Instance, number> -- presumably because you add your own names in the function definition
	TestCount: number
	Timeout: number
	WarnCount: number
	function Check(self, condition: boolean, description: string, source: Instance?, line: number?): nil
	function Checkpoint(self, text: string, source: Instance?, line: number?): nil
	function DoCommand(self, name: string): nil
	function Done(self): nil
	function Error(self, description: string, source: Instance?, line: number?): nil
	function Fail(self, description: string, source: Instance?, line: number?): nil
	function GetCommandNames(self): { string } -- it's most certainly { string } but I'm not taking any chances at this point (edit: yeah it is, after opening up Mercury studio and typing `for i,v in pairs(thing) do print(i,v) end` for the hundredth time today)
	function IsCommandChecked(self, name: string): boolean
	function IsCommandEnabled(self, name: string): boolean -- what's killing me is the knowledge this file was machine-generated and I could probably have written a script to, in a fraction of a second, do what took me several months
	function Message(self, text: string, source: Instance?, line: number?): nil -- but I'm in too deep now, and the file has been cut from like 8000 to 4000 lines in the last couple days, so it feels so close
	function Require(self, condition: boolean, description: string, source: Instance?, line: number?): nil
	function Run(self): nil
	function Warn(self, condition: boolean, description: string, source: Instance?, line: number?): nil
end

declare class TextService extends Instance -- dear diary, today I stumbled apon another class which seems to be timeless yet had no methods or properties until years, or in some cases, decades later
end

declare class TimerService extends Instance -- what are they? accidentally exposed internal things? placeholders that were forgotten and given a new purpose later? or maybe it's part of the master plan, the grand design, the ultimate vision (rdc17 reference), it's David Baszucki's metaversal time travel 5D chess and we're all just board pieces
end

declare class Toolbar extends Instance
	function CreateButton(self, text: string, tooltip: string, iconname: string): Instance -- not enough brain power to think of what this could be
end

declare class TouchTransmitter extends Instance
end

declare class UserGameSettings extends Instance
	AllTutorialsDisabled: boolean
	ControlMode: EnumControlMode
	Fullscreen: boolean
	FullscreenChanged: RBXScriptSignal<boolean>
	SavedQualityLevel: EnumSavedQualitySetting
	StudioModeChanged: RBXScriptSignal<boolean>
	VideoUploadPromptBehavior: EnumUploadSetting

	function GetTutorialState(self, tutorialId: string): boolean
	function InFullScreen(self): boolean
	function InStudioMode(self): boolean
	function SetTutorialState(self, tutorialId: string, value: boolean): nil
end

declare class UserInputService extends Instance
	GamepadEnabled: boolean
	InputBegan: RBXScriptSignal<InputObject, boolean>
	InputChanged: RBXScriptSignal<InputObject, boolean>
	InputEnded: RBXScriptSignal<InputObject, boolean>
	JumpRequest: RBXScriptSignal<>
	KeyboardEnabled: boolean
	ModalEnabled: boolean
	MouseEnabled: boolean
	TouchEnded: RBXScriptSignal<InputObject> -- does every class must been an Instance
	TouchLongPress: RBXScriptSignal<{ Vector2 }, EnumUserInputState> -- I'm losing comprehension of the world around me
	TouchMoved: RBXScriptSignal<InputObject> -- Agn🔵sia
	TouchPan: RBXScriptSignal<{ Vector2 }, Vector2, Vector2, EnumUserInputState>
	TouchPinch: RBXScriptSignal<{ Vector2 }, number, number, EnumUserInputState>
	TouchRotate: RBXScriptSignal<{ Vector2 }, number, number, EnumUserInputState>
	TouchStarted: RBXScriptSignal<InputObject>
	TouchSwipe: RBXScriptSignal<EnumSwipeDirection, number>
	TouchTap: RBXScriptSignal<{ Vector2 }>

	function IsLuaTouchControls(self): boolean -- Mercury will never get mobile, I can feel it
	function RotateCamera(self, positionDelta: Vector2): nil
	function ZoomCamera(self, zoomDelta: number): nil
end

declare class BinaryStringValue extends Instance
	Changed: RBXScriptSignal<BinaryString>
end

declare class BoolValue extends Instance
	Changed: RBXScriptSignal<boolean>
	Value: boolean
end

declare class BrickColorValue extends Instance
	Changed: RBXScriptSignal<BrickColor>
	Value: BrickColor
end

declare class CFrameValue extends Instance
	Changed: RBXScriptSignal<CFrame>
	Value: CFrame
end

declare class Color3Value extends Instance
	Changed: RBXScriptSignal<Color3>
	Value: Color3
end


declare class ScriptInformationProvider extends Instance
	function SetAccessKey(self, access: string): nil
	function SetAssetUrl(self, url: string): nil
end

declare class PersonalServerService extends Instance
	function Promote(self, player: Player): nil
	function Demote(self, player: Player): nil
end


declare class IntValue extends Instance
	Changed: RBXScriptSignal<number>
	Value: number
end

declare class NumberValue extends Instance
	Changed: RBXScriptSignal<number>
	Value: number
end

declare class ObjectValue extends Instance
	Changed: RBXScriptSignal<Instance?>
	Value: Instance?
end

declare class RayValue extends Instance
	Changed: RBXScriptSignal<Ray>
	Value: Ray
end

declare class StringValue extends Instance
	Changed: RBXScriptSignal<string>
	Value: string
end

declare class Vector3Value extends Instance
	Changed: RBXScriptSignal<Vector3>
	Value: Vector3
end

declare class VirtualUser extends Instance
	function Button1Down(self, position: Vector2, camera: CFrame?): nil -- is the Identity CFrame like the Identity Matrix or like the Identity Function? Is that like the zero value in Go? Is that similar to all the nils that rust definitely doesn't have?
	function Button1Up(self, position: Vector2, camera: CFrame?): nil
	function Button2Down(self, position: Vector2, camera: CFrame?): nil
	function Button2Up(self, position: Vector2, camera: CFrame?): nil
	function CaptureController(self): nil -- be nice if some of this stuff worked, it "An error occured" last time I checked I think and I'm not testing it again
	function ClickButton1(self, position: Vector2, camera: CFrame?): nil
	function ClickButton2(self, position: Vector2, camera: CFrame?): nil
	function MoveMouse(self, position: Vector2, camera: CFrame?): nil
	function SetKeyDown(self, key: string): nil
	function SetKeyUp(self, key: string): nil
	function StartRecording(self): nil -- smh
	function StopRecording(self): string
	function TypeKey(self, key: string): nil
end

declare class Visit extends Instance
	function GetUploadUrl(self): string -- are we almost finished here? I can't tell anymore
	function SetPing(self, pingUrl: string, interval: number): nil
	function SetUploadUrl(self, url: string): nil
end

declare Instance: {
	new: ((className: "Accoutrement", parent: Instance?) -> Accoutrement) 
		& ((className: "Hat", parent: Instance?) -> Hat) 
		& ((className: "AdvancedDragger", parent: Instance?) -> AdvancedDragger) 
		& ((className: "Animation", parent: Instance?) -> Animation) 
		& ((className: "CurveAnimation", parent: Instance?) -> CurveAnimation) 
		& ((className: "KeyframeSequence", parent: Instance?) -> KeyframeSequence) 
		& ((className: "AnimationController", parent: Instance?) -> AnimationController) 
		& ((className: "Animator", parent: Instance?) -> Animator) 
		& ((className: "Backpack", parent: Instance?) -> Backpack) 
		& ((className: "BindableEvent", parent: Instance?) -> BindableEvent) 
		& ((className: "BindableFunction", parent: Instance?) -> BindableFunction) 
		& ((className: "BodyAngularVelocity", parent: Instance?) -> BodyAngularVelocity) 
		& ((className: "BodyForce", parent: Instance?) -> BodyForce) 
		& ((className: "BodyGyro", parent: Instance?) -> BodyGyro) 
		& ((className: "BodyPosition", parent: Instance?) -> BodyPosition) 
		& ((className: "BodyThrust", parent: Instance?) -> BodyThrust) 
		& ((className: "BodyVelocity", parent: Instance?) -> BodyVelocity) 
		& ((className: "RocketPropulsion", parent: Instance?) -> RocketPropulsion) 
		& ((className: "Camera", parent: Instance?) -> Camera) 
		& ((className: "BodyColors", parent: Instance?) -> BodyColors) 
		& ((className: "CharacterMesh", parent: Instance?) -> CharacterMesh) 
		& ((className: "Pants", parent: Instance?) -> Pants) 
		& ((className: "Shirt", parent: Instance?) -> Shirt) 
		& ((className: "ShirtGraphic", parent: Instance?) -> ShirtGraphic) 
		& ((className: "Skin", parent: Instance?) -> Skin) 
		& ((className: "ClickDetector", parent: Instance?) -> ClickDetector) 
		& ((className: "DragDetector", parent: Instance?) -> DragDetector) 
		& ((className: "Configuration", parent: Instance?) -> Configuration) 
		& ((className: "HumanoidController", parent: Instance?) -> HumanoidController) 
		& ((className: "SkateboardController", parent: Instance?) -> SkateboardController) 
		& ((className: "VehicleController", parent: Instance?) -> VehicleController) 
		& ((className: "CustomEvent", parent: Instance?) -> CustomEvent) 
		& ((className: "CustomEventReceiver", parent: Instance?) -> CustomEventReceiver) 
		& ((className: "CylinderMesh", parent: Instance?) -> CylinderMesh) 
		& ((className: "FileMesh", parent: Instance?) -> FileMesh) 
		& ((className: "SpecialMesh", parent: Instance?) -> SpecialMesh) 
		& ((className: "DataStoreOptions", parent: Instance?) -> DataStoreOptions) 
		& ((className: "DebuggerWatch", parent: Instance?) -> DebuggerWatch) 
		& ((className: "Dialog", parent: Instance?) -> Dialog) 
		& ((className: "DialogChoice", parent: Instance?) -> DialogChoice) 
		& ((className: "Dragger", parent: Instance?) -> Dragger) 
		& ((className: "Explosion", parent: Instance?) -> Explosion) 
		& ((className: "Decal", parent: Instance?) -> Decal) 
		& ((className: "Texture", parent: Instance?) -> Texture) 
		& ((className: "Hole", parent: Instance?) -> Hole) 
		& ((className: "MotorFeature", parent: Instance?) -> MotorFeature) 
		& ((className: "Fire", parent: Instance?) -> Fire) 
		& ((className: "ForceField", parent: Instance?) -> ForceField) 
		& ((className: "FunctionalTest", parent: Instance?) -> FunctionalTest) 
		& ((className: "Frame", parent: Instance?) -> Frame) 
		& ((className: "ImageButton", parent: Instance?) -> ImageButton) 
		& ((className: "TextButton", parent: Instance?) -> TextButton) 
		& ((className: "ImageLabel", parent: Instance?) -> ImageLabel) 
		& ((className: "TextLabel", parent: Instance?) -> TextLabel) 
		& ((className: "TextBox", parent: Instance?) -> TextBox) 
		& ((className: "BillboardGui", parent: Instance?) -> BillboardGui) 
		& ((className: "ScreenGui", parent: Instance?) -> ScreenGui) 
		& ((className: "GuiMain", parent: Instance?) -> GuiMain) 
		& ((className: "SurfaceGui", parent: Instance?) -> SurfaceGui) 
		& ((className: "FloorWire", parent: Instance?) -> FloorWire) 
		& ((className: "SelectionBox", parent: Instance?) -> SelectionBox) 
		& ((className: "ArcHandles", parent: Instance?) -> ArcHandles) 
		& ((className: "Handles", parent: Instance?) -> Handles) 
		& ((className: "SurfaceSelection", parent: Instance?) -> SurfaceSelection) 
		& ((className: "SelectionPartLasso", parent: Instance?) -> SelectionPartLasso) 
		& ((className: "SelectionPointLasso", parent: Instance?) -> SelectionPointLasso) 
		& ((className: "Humanoid", parent: Instance?) -> Humanoid) 
		& ((className: "RotateP", parent: Instance?) -> RotateP) 
		& ((className: "RotateV", parent: Instance?) -> RotateV) 
		& ((className: "Glue", parent: Instance?) -> Glue) 
		& ((className: "ManualGlue", parent: Instance?) -> ManualGlue) 
		& ((className: "ManualWeld", parent: Instance?) -> ManualWeld) 
		& ((className: "Motor", parent: Instance?) -> Motor) 
		& ((className: "Motor6D", parent: Instance?) -> Motor6D) 
		& ((className: "Rotate", parent: Instance?) -> Rotate) 
		& ((className: "Snap", parent: Instance?) -> Snap) 
		& ((className: "VelocityMotor", parent: Instance?) -> VelocityMotor) 
		& ((className: "Weld", parent: Instance?) -> Weld) 
		& ((className: "Keyframe", parent: Instance?) -> Keyframe) 
		& ((className: "PointLight", parent: Instance?) -> PointLight) 
		& ((className: "SpotLight", parent: Instance?) -> SpotLight) 
		& ((className: "SurfaceLight", parent: Instance?) -> SurfaceLight) 
		& ((className: "Script", parent: Instance?) -> Script) 
		& ((className: "LocalScript", parent: Instance?) -> LocalScript) 
		& ((className: "ModuleScript", parent: Instance?) -> ModuleScript) 
		& ((className: "Message", parent: Instance?) -> Message) 
		& ((className: "Hint", parent: Instance?) -> Hint) 
		& ((className: "CornerWedgePart", parent: Instance?) -> CornerWedgePart) 
		& ((className: "Part", parent: Instance?) -> Part) 
		& ((className: "FlagStand", parent: Instance?) -> FlagStand) 
		& ((className: "Seat", parent: Instance?) -> Seat) 
		& ((className: "SkateboardPlatform", parent: Instance?) -> SkateboardPlatform) 
		& ((className: "SpawnLocation", parent: Instance?) -> SpawnLocation) 
		& ((className: "WedgePart", parent: Instance?) -> WedgePart) 
		& ((className: "IntersectOperation", parent: Instance?) -> IntersectOperation) 
		& ((className: "TrussPart", parent: Instance?) -> TrussPart) 
		& ((className: "VehicleSeat", parent: Instance?) -> VehicleSeat) 
		& ((className: "Model", parent: Instance?) -> Model) 
		& ((className: "HopperBin", parent: Instance?) -> HopperBin) 
		& ((className: "Tool", parent: Instance?) -> Tool) 
		& ((className: "Flag", parent: Instance?) -> Flag) 
		& ((className: "Player", parent: Instance?) -> Player) 
		& ((className: "Pose", parent: Instance?) -> Pose) 
		& ((className: "ReflectionMetadata", parent: Instance?) -> ReflectionMetadata) 
		& ((className: "ReflectionMetadataCallbacks", parent: Instance?) -> ReflectionMetadataCallbacks) 
		& ((className: "ReflectionMetadataClasses", parent: Instance?) -> ReflectionMetadataClasses) 
		& ((className: "ReflectionMetadataEvents", parent: Instance?) -> ReflectionMetadataEvents) 
		& ((className: "ReflectionMetadataFunctions", parent: Instance?) -> ReflectionMetadataFunctions) 
		& ((className: "ReflectionMetadataClass", parent: Instance?) -> ReflectionMetadataClass) 
		& ((className: "ReflectionMetadataMember", parent: Instance?) -> ReflectionMetadataMember) 
		& ((className: "ReflectionMetadataProperties", parent: Instance?) -> ReflectionMetadataProperties) 
		& ((className: "ReflectionMetadataYieldFunctions", parent: Instance?) -> ReflectionMetadataYieldFunctions) 
		& ((className: "RemoteEvent", parent: Instance?) -> RemoteEvent) 
		& ((className: "RemoteFunction", parent: Instance?) -> RemoteFunction) 
		& ((className: "Sky", parent: Instance?) -> Sky) 
		& ((className: "Smoke", parent: Instance?) -> Smoke) 
		& ((className: "Sound", parent: Instance?) -> Sound) 
		& ((className: "Sparkles", parent: Instance?) -> Sparkles) 
		& ((className: "StarterGear", parent: Instance?) -> StarterGear) 
		& ((className: "Team", parent: Instance?) -> Team) 
		& ((className: "TerrainRegion", parent: Instance?) -> TerrainRegion) 
		& ((className: "TestService", parent: Instance?) -> TestService) 
		& ((className: "BinaryStringValue", parent: Instance?) -> BinaryStringValue) 
		& ((className: "BoolValue", parent: Instance?) -> BoolValue) 
		& ((className: "BrickColorValue", parent: Instance?) -> BrickColorValue) 
		& ((className: "CFrameValue", parent: Instance?) -> CFrameValue) 
		& ((className: "Color3Value", parent: Instance?) -> Color3Value) 
		& ((className: "DoubleConstrainedValue", parent: Instance?) -> DoubleConstrainedValue) 
		& ((className: "IntConstrainedValue", parent: Instance?) -> IntConstrainedValue) 
		& ((className: "IntValue", parent: Instance?) -> IntValue) 
		& ((className: "NumberValue", parent: Instance?) -> NumberValue) 
		& ((className: "ObjectValue", parent: Instance?) -> ObjectValue) 
		& ((className: "RayValue", parent: Instance?) -> RayValue) 
		& ((className: "StringValue", parent: Instance?) -> StringValue) 
		& ((className: "Vector3Value", parent: Instance?) -> Vector3Value) 
		& ((className: string, parent: Instance?) -> Instance),

	Lock: (instance: Instance, player: Player) -> nil,
	Unlock: (instance: Instance) -> nil,
}

declare Ray: {
	new: ((Origin: Vector3, Direction: Vector3) -> Ray),
}

declare BrickColor: {
	Red: (() -> BrickColor),
	Yellow: (() -> BrickColor),
	Blue: (() -> BrickColor),
	Gray: (() -> BrickColor),
	DarkGray: (() -> BrickColor),
	White: (() -> BrickColor),
	Random: (() -> BrickColor), -- no clue which of these is deprecated
	random: (() -> BrickColor), -- anyone know what that "unknown" song from the Finobe OST is? not in the bandcamp release, not in the youtube playlist, not in the now-nonexistent youtube deluxe edition, not in the soundcloud with the original album art, the one from 01:01 to 2:32 in the "[Tutorial] How to properly host a server on Finobe!" video by Shenzou
	Green: (() -> BrickColor), -- that shit is lost media to me
	Black: (() -> BrickColor),
	palette: ((paletteValue: number --[[0-63]]) -> BrickColor), -- I just looked in my downloads folder to find it and realised I have an abnormal number of Alonso drawings there, turns out it's in my other more different downloads folder at /Libraries/what/Documents/Downloads
	new: ((val: number) -> BrickColor) & ((r: number, g: number, b: number) -> BrickColor) & ((color: Color3) -> BrickColor) & ((name: "Alder" | "Artichoke" | "Baby blue" | "Beige" | "Black" | "Black metallic" | "Br. reddish orange" | "Br. yellowish green" | "Br. yellowish orange" | "Brick yellow" | "Bright blue" | "Bright bluish green" | "Bright bluish violet" | "Bright green" | "Bright orange" | "Bright purple" | "Bright red" | "Bright reddish lilac" | "Bright reddish violet" | "Bright violet" | "Bright yellow" | "Bronze" | "Brown" | "Burgundy" | "Burlap" | "Burnt Sienna" | "Buttermilk" | "CGA brown" | "Cadet blue" | "Camo" | "Carnation pink" | "Cashmere" | "Cloudy grey" | "Cocoa" | "Cool yellow" | "Copper" | "Cork" | "Crimson" | "Curry" | "Cyan" | "Daisy orange" | "Dark Curry" | "Dark Royal blue" | "Dark blue" | "Dark green" | "Dark grey" | "Dark grey metallic" | "Dark indigo" | "Dark nougat" | "Dark orange" | "Dark red" | "Dark stone grey" | "Dark taupe" | "Deep blue" | "Deep orange" | "Dirt brown" | "Dove blue" | "Dusty Rose" | "Earth blue" | "Earth green" | "Earth orange" | "Earth yellow" | "Eggplant" | "Electric blue" | "Faded green" | "Fawn brown" | "Fire Yellow" | "Flame reddish orange" | "Flame yellowish orange" | "Flint" | "Fog" | "Forest green" | "Fossil" | "Ghost grey" | "Gold" | "Grey" | "Grime" | "Gun metallic" | "Hot pink" | "Hurricane grey" | "Institutional white" | "Khaki" | "Lapis" | "Laurel green" | "Lavender" | "Lemon metalic" | "Lig. Yellowich orange" | "Lig. yellowish green" | "Light Royal blue" | "Light blue" | "Light bluish green" | "Light bluish violet" | "Light brick yellow" | "Light green (Mint)" | "Light grey" | "Light grey metallic" | "Light lilac" | "Light orange" | "Light orange brown" | "Light pink" | "Light purple" | "Light red" | "Light reddish violet" | "Light stone grey" | "Light yellow" | "Lilac" | "Lily white" | "Lime green" | "Linen" | "Magenta" | "Maroon" | "Mauve" | "Med. bluish green" | "Med. reddish violet" | "Med. yellowish green" | "Med. yellowish orange" | "Medium Royal blue" | "Medium blue" | "Medium bluish violet" | "Medium green" | "Medium lilac" | "Medium orange" | "Medium red" | "Medium stone grey" | "Mid gray" | "Mint" | "Moss" | "Mulberry" | "Navy blue" | "Neon green" | "Neon orange" | "New Yeller" | "Nougat" | "Olive" | "Olivine" | "Oyster" | "Parsley green" | "Pastel Blue" | "Pastel blue-green" | "Pastel brown" | "Pastel green" | "Pastel light blue" | "Pastel orange" | "Pastel violet" | "Pastel yellow" | "Pearl" | "Persimmon" | "Phosph. White" | "Pine Cone" | "Pink" | "Plum" | "Quill grey" | "Really black" | "Really blue" | "Really red" | "Red flip/flop" | "Reddish brown" | "Reddish lilac" | "Royal blue" | "Royal purple" | "Rust" | "Sage green" | "Salmon" | "Sand blue" | "Sand blue metallic" | "Sand green" | "Sand red" | "Sand violet" | "Sand violet metallic" | "Sand yellow" | "Sand yellow metallic" | "Sea green" | "Seashell" | "Shamrock" | "Silver" | "Silver flip/flop" | "Slime green" | "Smoky grey" | "Steel blue" | "Storm blue" | "Sunrise" | "Tawny" | "Teal" | "Terra Cotta" | "Toothpaste" | "Tr. Blue" | "Tr. Bright bluish violet" | "Tr. Brown" | "Tr. Flu. Blue" | "Tr. Flu. Green" | "Tr. Flu. Red" | "Tr. Flu. Reddish orange" | "Tr. Flu. Yellow" | "Tr. Green" | "Tr. Lg blue" | "Tr. Medi. reddish violet" | "Tr. Red" | "Tr. Yellow" | "Transparent" | "Turquoise" | "Warm yellowish orange" | "Wheat" | "White" | "Yellow flip/flop") -> BrickColor),
}

declare Vector2: {
	zero: Vector2, -- is this the identity thing? I can see the sun rising outside, It's nearing 6am, we're gonna be alright
	one: Vector2,
	xAxis: Vector2,
	yAxis: Vector2,
	new: ((x: number?, y: number?) -> Vector2),
}

declare Vector2int16: {
	new: ((x: number, y: number) -> Vector2int16), -- if you wanna know how this feels, just keep replaying Finobe OST - Battlefields (but only the part from 1:45 onwards)
}

declare Color3: { -- i'll play some Shop Demo now because that's goes hard
	new: ((red: number?, green: number?, blue: number?) -> Color3),
}

declare UDim: {
	new: ((Scale: number?, Offset: number?) -> UDim),
}

declare Axes: {
	new: ((axes: any) -> Axes),
}

declare Region3: {
	new: ((min: Vector3, max: Vector3) -> Region3),
}

declare Region3int16: {
	new: ((min: Vector3int16, max: Vector3int16) -> Region3int16),
}

declare UDim2: {
	fromScale: ((xScale: number, yScale: number) -> UDim2),
	fromOffset: ((xOffset: number, yOffset: number) -> UDim2), -- can't even tell what's on one line and what's line wrapped anymore
	new: ((x: UDim, y: UDim) -> UDim2) & ((xScale: number?, xOffset: number?, yScale: number?, yOffset: number?) -> UDim2),
}

declare CFrame: {
	Angles: ((rx: number, ry: number, rz: number) -> CFrame),
	fromOrientation: ((rx: number, ry: number, rz: number) -> CFrame),
	fromEulerAnglesXYZ: ((rx: number, ry: number, rz: number) -> CFrame),
	new: (() -> CFrame) & ((pos: Vector3) -> CFrame) & ((pos: Vector3, lookAt: Vector3) -> CFrame) & ((x: number, y: number, z: number) -> CFrame) & ((x: number, y: number, z: number, qX: number, qY: number, qZ: number, qW: number) -> CFrame) & ((x: number, y: number, z: number, R00: number, R01: number, R02: number, R10: number, R11: number, R12: number, R20: number, R21: number, R22: number) -> CFrame),
}

declare Faces: {
	new: ((normalIds: any) -> Faces),
}

declare Rect: {
	new: ((min: Vector2, max: Vector2) -> Rect) & ((minX: number, minY: number, maxX: number, maxY: number) -> Rect),
}

declare Vector3: {
	FromNormalId: ((normal: EnumNormalId) -> Vector3), -- uncapitalised names do Not exist here, wow
	FromAxis: ((axis: EnumAxis) -> Vector3),
	new: ((x: number?, y: number?, z: number?) -> Vector3),
}

declare Vector3int16: {
	new: ((x: number?, y: number?, z: number?) -> Vector3int16),
}

declare class GlobalSettings extends GenericSettings
    function GetFFlag(self, name: string): boolean
    function GetFVariable(self, name: string): string
    function GetFVariables(self, name: string): { [any]: any } -- of course I can't test this, because "An error occured"
end

declare _PLACE_ID: number
declare _IS_STUDIO_JOIN: string
declare _SERVER_ADDRESS: any
declare _SERVER_PORT: string
declare _CREATOR_ID: number
declare _USER_ID: number
declare _USER_NAME: any
declare _MEMBERSHIP_TYPE: any
declare _CHAR_APPEARANCE: string
declare _PING_URL: string

declare _BASE_URL: string
declare _THUMBNAIL_KEY: string
declare _RENDER_TYPE: string
declare _ASSET_ID: number

declare _MAP_LOCATION_EXISTS: boolean
declare _MAP_LOCATION: any
declare _SERVER_PORT: number
declare _SERVER_PRESENCE_URL: string

declare _SERVER: boolean
declare _CLIENT: boolean

declare game: DataModel
-- declare Game: DataModel -- removing this because I don't like it
declare workspace: Workspace
-- declare Workspace: Workspace -- same with this, just feeling mean today
declare plugin: Plugin
declare script: BaseScript
declare function loadfile(file: string): any
declare function dofile(file: string): any

-- fusion

-- pubtypes

--[[
	Stores common public-facing type information for Fusion APIs.
]]

type Set<T> = { [T]: any }

--[[
	General use types
]]

-- A unique symbolic value.
type Symbol = {
	type: "Symbol",
	name: string,
}

-- Types that can be expressed as vectors of numbers, and so can be animated.
type Animatable =
	number
	| CFrame
	| Color3
	| Ray
	| Rect
	| Region3
	| Region3int16
	| UDim
	| UDim2
	| Vector2
	| Vector2int16
	| Vector3
	| Vector3int16

-- A task which can be accepted for cleanup.
type Task =
	Instance
	| RBXScriptConnection
	| () -> () | { destroy: (any) -> () } | { Destroy: (any) -> () } | { Task }

-- Script-readable version information.
type Version = {
	major: number,
	minor: number,
	isRelease: boolean,
}

-- An object which stores a value scoped in time.
type Contextual<T> = {
	type: "Contextual",
	now: (Contextual<T>) -> T,
	is: (Contextual<T>, T) -> ContextualIsMethods,
}

type ContextualIsMethods = {
	during: <T, A...>(ContextualIsMethods, (A...) -> T, A...) -> T,
}

--[[
	Generic reactive graph types
]]

-- A graph object which can have dependents.
type Dependency = {
	dependentSet: Set<Dependent>,
}

-- A graph object which can have dependencies.
type Dependent = {
	update: (Dependent) -> boolean,
	dependencySet: Set<Dependency>,
}

-- An object which stores a piece of reactive state.
type StateObject<T> = Dependency & {
	type: "State",
	kind: string,
	_typeIdentifier: T,
}

-- Either a constant value of type T, or a state object containing type T.
type CanBeState<T> = StateObject<T> | T

-- Function signature for use callbacks.
type Use = <T>(target: CanBeState<T>) -> T

--[[
	Specific reactive graph types
]]

-- A state object whose value can be set at any time by the user.
type Value<T> = StateObject<T> & {
	kind: "State",
	set: (Value<T>, newValue: any, force: boolean?) -> (),
}

-- A state object whose value is derived from other objects using a callback.
type Computed<T> = StateObject<T> & Dependent & {
	kind: "Computed",
}

-- A state object whose value is derived from other objects using a callback.
type ForPairs<KO, VO> = StateObject<{ [KO]: VO }> & Dependent & {
	kind: "ForPairs",
}
-- A state object whose value is derived from other objects using a callback.
type ForKeys<KO, V> = StateObject<{ [KO]: V }> & Dependent & {
	kind: "ForKeys",
}
-- A state object whose value is derived from other objects using a callback.
type ForValues<K, VO> = StateObject<{ [K]: VO }> & Dependent & {
	kind: "ForKeys",
}

-- A state object which follows another state object using tweens.
type Tween<T> = StateObject<T> & Dependent & {
	kind: "Tween",
}

-- A state object which follows another state object using spring simulation.
type Spring<T> = StateObject<T> & Dependent & {
	kind: "Spring",
	setPosition: (Spring<T>, newPosition: Animatable) -> (),
	setVelocity: (Spring<T>, newVelocity: Animatable) -> (),
	addVelocity: (Spring<T>, deltaVelocity: Animatable) -> (),
}

-- An object which can listen for updates on another state object.
type Observer = Dependent & {
	kind: "Observer",
	onChange: (Observer, callback: () -> ()) -> (() -> ()),
}

--[[
	Instance related types
]]

-- Denotes children instances in an instance or component's property table.
type SpecialKey = {
	type: "SpecialKey",
	kind: string,
	stage: "self" | "descendants" | "ancestor" | "observer",
	apply: (
		SpecialKey,
		value: any,
		applyTo: Instance,
		cleanupTasks: { Task }
	) -> (),
}

-- A collection of instances that may be parented to another instance.
type Children = Instance | StateObject<Children> | { [any]: Children }

-- A table that defines an instance's properties, handlers and children.
type PropertyTable = { [string | SpecialKey]: any }

-- init

export type Fusion = {
	version: Version,

	New: (
		className: string
	) -> ((propertyTable: PropertyTable) -> Instance),
	Hydrate: (
		target: Instance
	) -> ((propertyTable: PropertyTable) -> Instance),
	Ref: SpecialKey,
	Cleanup: SpecialKey,
	Children: SpecialKey,
	Out: (propertyName: string) -> SpecialKey,
	OnEvent: (eventName: string) -> SpecialKey,
	OnChange: (propertyName: string) -> SpecialKey,

	Value: <T>(initialValue: T) -> Value<T>,
	Computed: <T>(callback: (Use) -> T, destructor: (T) -> ()?) -> Computed<T>,
	ForPairs: <KI, VI, KO, VO, M>(
		inputTable: CanBeState<{ [KI]: VI }>,
		processor: (Use, KI, VI) -> (KO, VO, M?),
		destructor: (KO, VO, M?) -> ()?
	) -> ForPairs<KO, VO>,
	ForKeys: <KI, KO, M>(
		inputTable: CanBeState<{ [KI]: any }>,
		processor: (Use, KI) -> (KO, M?),
		destructor: (KO, M?) -> ()?
	) -> ForKeys<KO, any>,
	ForValues: <VI, VO, M>(
		inputTable: CanBeState<{ [any]: VI }>,
		processor: (Use, VI) -> (VO, M?),
		destructor: (VO, M?) -> ()?
	) -> ForValues<any, VO>,
	Observer: (watchedState: StateObject<any>) -> Observer,

	Tween: <T>(goalState: StateObject<T>, tweenInfo: TweenInfo?) -> Tween<T>,
	Spring: <T>(
		goalState: StateObject<T>,
		speed: CanBeState<number>?,
		damping: CanBeState<number>?
	) -> Spring<T>,

	Contextual: <T>(defaultValue: T) -> Contextual<T>,
	cleanup: (...any) -> (),
	doNothing: (...any) -> (),
	peek: Use,
}

export type Server = {
	new: (Name: string) -> Server,
	Server: (Name: string) -> Server,
	Fire: (self: Server, Player: Player, EventName: string, ...any) -> (),
	FireAll: (self: Server, EventName: string, ...any) -> (),
	FireAllExcept: (self: Server, Player: Player, EventName: string, ...any) -> (),
	FireList: (self: Server, Players: {Player}, EventName: string, ...any) -> (),
	FireWithFilter: (self: Server, Filter: (Player) -> boolean, EventName: string, ...any) -> (),
	On: (self: Server, EventName: string, Callback: ((Player, ...any) -> ...any?)) -> (),
	Folder: (self: Server, Player: Player?) -> Model,
}

export type Client = {
	new: (self: Client, Name: string) -> Client,
	Client: (self: Client, Name: string) -> Client,
	Fire: (self: Client, EventName: string, ...any) -> Promise,
	Call: (self: Client, EventName: string, ...any) -> Promise,
	On: (self: Client, EventName: string, Callback: ((...any) -> ())?) -> Promise,
	Folder: (self: Client) -> Model,
	LocalFolder: (self: Client) -> Model,
}

export type Promise = {
	new: (Callback: (Resolve: (...any) -> (), Reject: (...any) -> ()) -> ()) -> Promise,
	Promise: (Callback: (Resolve: (...any) -> (), Reject: (...any) -> ()) -> ()) -> Promise,
	Reject: (a: any, b: any, c: any, d: any, e: any) -> Promise,
	_Resolve: (self: Promise, ...any) -> (),
	_Reject: (self: Promise, ...any) -> (),
	Then: (self: Promise, OnResolve: ((...any) -> ...any)?, OnReject: ((...any) -> ...any)?) -> Promise,
	Catch: (self: Promise, OnReject: ((...any) -> ())) -> ...any,
	Finally: (self: Promise, Finally: (() -> ())) -> ...any,
	Await: (self: Promise) -> ...any,
}

type SignalNode<T...> = {
	Next: SignalNode<T...>?,
	Callback: (T...) -> (),
}

export type Signal<T...> = {
	Root: SignalNode<T...>?,

	Connect: (self: Signal<T...>, Callback: (T...) -> ()) -> () -> (),
	Wait: (self: Signal<T...>) -> (Callback: (Resolve: (...any) -> (), Reject: (...any) -> ()) -> ()) -> Promise,
	Fire: (self: Signal<T...>, T...) -> (),
	DisconnectAll: (self: Signal<T...>) -> (),
}

export type Clock = {
	new: (Interval: number, Callback: () -> ()) -> Clock,
	Clock: (Interval: number, Callback: () -> ()) -> Clock,
	Pause: (self: Clock) -> (),
	Resume: (self: Clock) -> (),
	Advance: (self: Clock, Delta: number) -> (),
}

type RedCore = {
	Server: (Name: string, Definitions: {string}?) -> Server,
	Client: (Name: string) -> Client,

	Collection: <T...>(Tag: string, Start: (Instance) -> (T...), Stop: (T...) -> ()) -> () -> (),
	Ratelimit: <T>(Limit: number, Interval: number) -> (Key: T?) -> boolean,
	Promise: Promise,
	Signal: {
		new: <T...>() -> Signal<T...>,
		Connect: <T...>(self: Signal<T...>, Callback: (T...) -> ()) -> () -> (),
		Wait: <T...>(self: Signal<T...>) -> Promise,
		Fire: <T...>(self: Signal<T...>, T...) -> (),
		DisconnectAll: <T...>(self: Signal<T...>) -> (),
	},
	Clock: Clock,
	Spawn: <T...>(fn: (T...) -> (), T...) -> (), -- variadics SUCK
	Bin: () -> ((Item: (() -> ...any) | Instance | RBXScriptConnection) -> (), () -> ())
}

export type Red = {
	Help: () -> string,
	Load: (self: Red, Script: BaseScript) -> RedCore,
}

-- just plain useful

export type InstanceName =
	"Accoutrement"
	| "Hat"
	| "AdvancedDragger"
	| "Animation"
	| "CurveAnimation"
	| "KeyframeSequence"
	| "AnimationController"
	| "Animator"
	| "AudioDistortion"
	| "AudioFader"
	| "AudioFlanger"
	| "AudioListener"
	| "AudioPitchShifter"
	| "AudioPlayer"
	| "AudioReverb"
	| "AudioSearchParams"
	| "Backpack"
	| "BindableEvent"
	| "BindableFunction"
	| "BodyAngularVelocity"
	| "BodyForce"
	| "BodyGyro"
	| "BodyPosition"
	| "BodyThrust"
	| "BodyVelocity"
	| "RocketPropulsion"
	| "Camera"
	| "BodyColors"
	| "CharacterMesh"
	| "Pants"
	| "Shirt"
	| "ShirtGraphic"
	| "Skin"
	| "ClickDetector"
	| "DragDetector"
	| "Configuration"
	| "HumanoidController"
	| "SkateboardController"
	| "VehicleController"
	| "CustomEvent"
	| "CustomEventReceiver"
	| "CylinderMesh"
	| "FileMesh"
	| "SpecialMesh"
	| "DataStoreOptions"
	| "DebuggerWatch"
	| "Dialog"
	| "DialogChoice"
	| "Dragger"
	| "Explosion"
	| "Decal"
	| "Texture"
	| "Hole"
	| "MotorFeature"
	| "Fire"
	| "ForceField"
	| "FunctionalTest"
	| "Frame"
	| "ImageButton"
	| "TextButton"
	| "ImageLabel"
	| "TextLabel"
	| "TextBox"
	| "BillboardGui"
	| "ScreenGui"
	| "GuiMain"
	| "SurfaceGui"
	| "FloorWire"
	| "SelectionBox"
	| "ArcHandles"
	| "Handles"
	| "SurfaceSelection"
	| "SelectionPartLasso"
	| "SelectionPointLasso"
	| "Humanoid"
	| "RotateP"
	| "RotateV"
	| "Glue"
	| "ManualGlue"
	| "ManualWeld"
	| "Motor"
	| "Motor6D"
	| "Rotate"
	| "Snap"
	| "VelocityMotor"
	| "Weld"
	| "Keyframe"
	| "PointLight"
	| "SpotLight"
	| "SurfaceLight"
	| "Script"
	| "LocalScript"
	| "ModuleScript"
	| "Message"
	| "Hint"
	| "CornerWedgePart"
	| "Part"
	| "FlagStand"
	| "Seat"
	| "SkateboardPlatform"
	| "SpawnLocation"
	| "WedgePart"
	| "TrussPart"
	| "VehicleSeat"
	| "Model"
	| "HopperBin"
	| "Tool"
	| "Flag"
	| "Player"
	| "Pose"
	| "ReflectionMetadata"
	| "ReflectionMetadataCallbacks"
	| "ReflectionMetadataClasses"
	| "ReflectionMetadataEvents"
	| "ReflectionMetadataFunctions"
	| "ReflectionMetadataClass"
	| "ReflectionMetadataMember"
	| "ReflectionMetadataProperties"
	| "ReflectionMetadataYieldFunctions"
	| "RemoteEvent"
	| "RemoteFunction"
	| "Sky"
	| "Smoke"
	| "Sound"
	| "Sparkles"
	| "StarterGear"
	| "Team"
	| "TerrainRegion"
	| "TestService"
	| "BinaryStringValue"
	| "BoolValue"
	| "BrickColorValue"
	| "CFrameValue"
	| "Color3Value"
	| "DoubleConstrainedValue"
	| "IntConstrainedValue"
	| "IntValue"
	| "NumberValue"
	| "ObjectValue"
	| "RayValue"
	| "StringValue"
	| "Vector3Value"

declare LoadLibrary: ((libraryName: "RbxFusion") -> Fusion) & ((libraryName: "RbxRed") -> Red) & ((libraryName: string) -> any)

declare function settings(): GlobalSettings
declare function UserSettings(): UserSettings
declare function PluginManager(): PluginManager
declare function ypcall(f: (() -> any) | (() -> ()) | ((...any) -> (), (...any) -> ()) -> (), ...: any): (boolean, any)
