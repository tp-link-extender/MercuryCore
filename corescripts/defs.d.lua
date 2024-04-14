--#METADATA#{"CREATABLE_INSTANCES": ["Accoutrement", "Hat", "AdvancedDragger", "Animation", "AnimationController", "AnimationTrackState", "Animator", "Script", "LocalScript", "BindableEvent", "BindableFunction", "BodyAngularVelocity", "BodyForce", "BodyGyro", "BodyPosition", "BodyThrust", "BodyVelocity", "RocketPropulsion", "BoolValue", "BrickColorValue", "CFrameValue", "TextureContentProvider", "Camera", "BodyColors", "CharacterMesh", "Pants", "Shirt", "ShirtGraphic", "Skin", "ClickDetector", "Color3Value", "Configuration", "ContentFilter", "HumanoidController", "SkateboardController", "VehicleController", "CustomEvent", "CustomEventReceiver", "BlockMesh", "CylinderMesh", "FileMesh", "SpecialMesh", "DebugSettings", "DebuggerWatch", "Dialog", "DialogChoice", "DoubleConstrainedValue", "Dragger", "Explosion", "FWService", "Decal", "Texture", "FastLogSettings", "Hole", "MotorFeature", "Fire", "ForceField", "FunctionalTest", "GameSettings", "Frame", "NotificationObject", "ImageButton", "TextButton", "ImageLabel", "TextLabel", "NotificationBox", "TextBox", "BillboardGui", "ScreenGui", "GuiMain", "SurfaceGui", "FloorWire", "SelectionBox", "ArcHandles", "Handles", "SurfaceSelection", "SelectionPartLasso", "SelectionPointLasso", "TextureTrail", "Backpack", "HopperBin", "Tool", "Flag", "PlayerHUD", "Humanoid", "IntConstrainedValue", "IntValue", "RotateP", "RotateV", "Glue", "ManualGlue", "ManualWeld", "Motor", "Motor6D", "Rotate", "Snap", "VelocityMotor", "Weld", "Keyframe", "KeyframeSequence", "PointLight", "SpotLight", "LuaSettings", "Message", "Hint", "ModuleScript", "NetworkSettings", "NumberValue", "ObjectValue", "CornerWedgePart", "Part", "FlagStand", "Seat", "SkateboardPlatform", "SpawnLocation", "WedgePart", "ParallelRampPart", "PrismPart", "PyramidPart", "RightAngleRampPart", "TrussPart", "VehicleSeat", "Model", "PersonalServerService", "PhysicsSettings", "Player", "Pose", "RayValue", "ReflectionMetadata", "ReflectionMetadataCallbacks", "ReflectionMetadataClasses", "ReflectionMetadataEvents", "ReflectionMetadataFunctions", "ReflectionMetadataClass", "ReflectionMetadataMember", "ReflectionMetadataProperties", "ReflectionMetadataYieldFunctions", "RemoteEvent", "RemoteFunction", "RenderHooksService", "RenderSettings", "ScriptInformationProvider", "App", "Sky", "Smoke", "SocialService", "Sound", "StockSound", "Sparkles", "StarterGear", "ProfilingItem", "StringValue", "StudioTool", "TaskScheduler", "Team", "TerrainRegion", "TestService", "UserGameSettings", "Vector3Value"], "SERVICES": ["AssetService", "BadgeService", "CoreGui", "StarterGui", "CacheableContentProvider", "MeshContentProvider", "ChangeHistoryService", "Chat", "ClusterPacketCache", "CollectionService", "ContentProvider", "ContextActionService", "ControllerService", "CookiesService", "DataStoreService", "Debris", "DebugSettings", "FlagStandService", "FriendService", "GamePassService", "GameSettings", "Geometry", "Hopper", "StarterPack", "GuiService", "GuidRegistryService", "HttpService", "InsertService", "InstancePacketCache", "JointsService", "KeyframeSequenceProvider", "Lighting", "LoginService", "LuaSettings", "LuaWebService", "MarketplaceService", "NetworkClient", "NetworkServer", "NetworkSettings", "Workspace", "PhysicsPacketCache", "PhysicsService", "PhysicsSettings", "Players", "RenderSettings", "ReplicatedStorage", "RunService", "RuntimeScriptService", "ScriptContext", "ScriptService", "Selection", "ServerScriptService", "ServerStorage", "SoundService", "SpawnerService", "Stats", "TaskScheduler", "Teams", "TeleportService", "TestService", "TextService", "TimerService", "TweenService", "UserGameSettings", "UserInputService", "VirtualUser", "Visit"]}

-- Based on https://github.com/JohnnyMorganz/luau-lsp/blob/2bd0fb8a122932be67a16412591089e482bc3209/scripts/globalTypes.d.lua
-- I hope for the love of god this file is finally fixed after eight months of it being slowly edited leading to an anticlimactic three days of work culminating in it finally breaking and me rewriting it with the original script in like twenty minutes

type Content = string
type ProtectedString = string
type QDir = string
type QFont = string
type Object = Instance

declare class Enum
end

declare class EnumItem
    Name: string
    Value: number
end

declare shared: any

declare function collectgarbage(mode: "count"): number
declare function tick(): number
declare function time(): number
declare function wait(seconds: number?): (number, number)
declare function Delay<T...>(delayTime: number?, callback: (T...) -> ())
declare function delay<T...>(delayTime: number?, callback: (T...) -> ())
declare function Spawn<T...>(callback: (T...) -> ())
declare function version(): string
declare function printidentity(prefix: string?)

declare class EnumAASamples extends EnumItem end
declare class EnumAASamples_INTERNAL extends Enum
	["4"]: EnumAASamples
	["8"]: EnumAASamples
	None: EnumAASamples
end
declare class EnumAccessType extends EnumItem end
declare class EnumAccessType_INTERNAL extends Enum
	Everyone: EnumAccessType
	Friends: EnumAccessType
	InviteOnly: EnumAccessType
	Me: EnumAccessType
end
declare class EnumActionType extends EnumItem end
declare class EnumActionType_INTERNAL extends Enum
	Draw: EnumActionType
	Lose: EnumActionType
	Nothing: EnumActionType
	Pause: EnumActionType
	Win: EnumActionType
end
declare class EnumAnimationPriority extends EnumItem end
declare class EnumAnimationPriority_INTERNAL extends Enum
	Action: EnumAnimationPriority
	Core: EnumAnimationPriority
	Idle: EnumAnimationPriority
	Movement: EnumAnimationPriority
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
	Clone: EnumBinType
	GameTool: EnumBinType
	Grab: EnumBinType
	Hammer: EnumBinType
	Script: EnumBinType
end
declare class EnumBodyPart extends EnumItem end
declare class EnumBodyPart_INTERNAL extends Enum
	Head: EnumBodyPart
	LeftArm: EnumBodyPart
	LeftLeg: EnumBodyPart
	RightArm: EnumBodyPart
	RightLeg: EnumBodyPart
	Torso: EnumBodyPart
end
declare class EnumButton extends EnumItem end
declare class EnumButton_INTERNAL extends Enum
	Dismount: EnumButton
	Jump: EnumButton
end
declare class EnumButtonStyle extends EnumItem end
declare class EnumButtonStyle_INTERNAL extends Enum
	Custom: EnumButtonStyle
	RobloxButton: EnumButtonStyle
	RobloxButtonDefault: EnumButtonStyle
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
	Attach: EnumCameraType
	Custom: EnumCameraType
	Fixed: EnumCameraType
	Follow: EnumCameraType
	Scriptable: EnumCameraType
	Track: EnumCameraType
	Watch: EnumCameraType
end
declare class EnumCellBlock extends EnumItem end
declare class EnumCellBlock_INTERNAL extends Enum
	CornerWedge: EnumCellBlock
	HorizontalWedge: EnumCellBlock
	InverseCornerWedge: EnumCellBlock
	Solid: EnumCellBlock
	VerticalWedge: EnumCellBlock
end
declare class EnumCellMaterial extends EnumItem end
declare class EnumCellMaterial_INTERNAL extends Enum
	Aluminum: EnumCellMaterial
	Asphalt: EnumCellMaterial
	BluePlastic: EnumCellMaterial
	Brick: EnumCellMaterial
	Cement: EnumCellMaterial
	CinderBlock: EnumCellMaterial
	Empty: EnumCellMaterial
	Gold: EnumCellMaterial
	Granite: EnumCellMaterial
	Grass: EnumCellMaterial
	Gravel: EnumCellMaterial
	Iron: EnumCellMaterial
	MossyStone: EnumCellMaterial
	RedPlastic: EnumCellMaterial
	Sand: EnumCellMaterial
	Water: EnumCellMaterial
	WoodLog: EnumCellMaterial
	WoodPlank: EnumCellMaterial
end
declare class EnumCellOrientation extends EnumItem end
declare class EnumCellOrientation_INTERNAL extends Enum
	NegX: EnumCellOrientation
	NegZ: EnumCellOrientation
	X: EnumCellOrientation
	Z: EnumCellOrientation
end
declare class EnumCenterDialogType extends EnumItem end
declare class EnumCenterDialogType_INTERNAL extends Enum
	ModalDialog: EnumCenterDialogType
	PlayerInitiatedDialog: EnumCenterDialogType
	QuitDialog: EnumCenterDialogType
	UnsolicitedDialog: EnumCenterDialogType
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
	Bubble: EnumChatStyle
	Classic: EnumChatStyle
	ClassicAndBubble: EnumChatStyle
end
declare class EnumConcurrencyModel extends EnumItem end
declare class EnumConcurrencyModel_INTERNAL extends Enum
	Empirical: EnumConcurrencyModel
	Logical: EnumConcurrencyModel
	Safe: EnumConcurrencyModel
	Serial: EnumConcurrencyModel
end
declare class EnumControlMode extends EnumItem end
declare class EnumControlMode_INTERNAL extends Enum
	Classic: EnumControlMode
	MouseLockSwitch: EnumControlMode
end
declare class EnumCoreGuiType extends EnumItem end
declare class EnumCoreGuiType_INTERNAL extends Enum
	All: EnumCoreGuiType
	Backpack: EnumCoreGuiType
	Chat: EnumCoreGuiType
	Health: EnumCoreGuiType
	PlayerList: EnumCoreGuiType
end
declare class EnumCreatorType extends EnumItem end
declare class EnumCreatorType_INTERNAL extends Enum
	Group: EnumCreatorType
	User: EnumCreatorType
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
	D3DDEVTYPE_NULLREF: EnumD3DDEVTYPE
	D3DDEVTYPE_REF: EnumD3DDEVTYPE
	D3DDEVTYPE_SW: EnumD3DDEVTYPE
end
declare class EnumD3DFORMAT extends EnumItem end
declare class EnumD3DFORMAT_INTERNAL extends Enum
	D3DFMT_A16B16G16R16: EnumD3DFORMAT
	D3DFMT_A16B16G16R16F: EnumD3DFORMAT
	D3DFMT_A1R5G5B5: EnumD3DFORMAT
	D3DFMT_A2B10G10R10: EnumD3DFORMAT
	D3DFMT_A2R10G10B10: EnumD3DFORMAT
	D3DFMT_A2W10V10U10: EnumD3DFORMAT
	D3DFMT_A32B32G32R32F: EnumD3DFORMAT
	D3DFMT_A4L4: EnumD3DFORMAT
	D3DFMT_A4R4G4B4: EnumD3DFORMAT
	D3DFMT_A8: EnumD3DFORMAT
	D3DFMT_A8B8G8R8: EnumD3DFORMAT
	D3DFMT_A8L8: EnumD3DFORMAT
	D3DFMT_A8P8: EnumD3DFORMAT
	D3DFMT_A8R3G3B2: EnumD3DFORMAT
	D3DFMT_A8R8G8B8: EnumD3DFORMAT
	D3DFMT_CxV8U8: EnumD3DFORMAT
	D3DFMT_D15S1: EnumD3DFORMAT
	D3DFMT_D16: EnumD3DFORMAT
	D3DFMT_D16_LOCKABLE: EnumD3DFORMAT
	D3DFMT_D24FS8: EnumD3DFORMAT
	D3DFMT_D24S8: EnumD3DFORMAT
	D3DFMT_D24X4S4: EnumD3DFORMAT
	D3DFMT_D24X8: EnumD3DFORMAT
	D3DFMT_D32: EnumD3DFORMAT
	D3DFMT_D32F_LOCKABLE: EnumD3DFORMAT
	D3DFMT_G16R16: EnumD3DFORMAT
	D3DFMT_G16R16F: EnumD3DFORMAT
	D3DFMT_G32R32F: EnumD3DFORMAT
	D3DFMT_INDEX16: EnumD3DFORMAT
	D3DFMT_INDEX32: EnumD3DFORMAT
	D3DFMT_L16: EnumD3DFORMAT
	D3DFMT_L6V5U5: EnumD3DFORMAT
	D3DFMT_L8: EnumD3DFORMAT
	D3DFMT_P8: EnumD3DFORMAT
	D3DFMT_Q16W16V16U16: EnumD3DFORMAT
	D3DFMT_Q8W8V8U8: EnumD3DFORMAT
	D3DFMT_R16F: EnumD3DFORMAT
	D3DFMT_R32F: EnumD3DFORMAT
	D3DFMT_R3G3B2: EnumD3DFORMAT
	D3DFMT_R5G6B5: EnumD3DFORMAT
	D3DFMT_R8G8B8: EnumD3DFORMAT
	D3DFMT_UNKNOWN: EnumD3DFORMAT
	D3DFMT_V16U16: EnumD3DFORMAT
	D3DFMT_V8U8: EnumD3DFORMAT
	D3DFMT_VERTEXDATA: EnumD3DFORMAT
	D3DFMT_X1R5G5B5: EnumD3DFORMAT
	D3DFMT_X4R4G4B4: EnumD3DFORMAT
	D3DFMT_X8B8G8R8: EnumD3DFORMAT
	D3DFMT_X8L8V8U8: EnumD3DFORMAT
	D3DFMT_X8R8G8B8: EnumD3DFORMAT
end
declare class EnumDialogPurpose extends EnumItem end
declare class EnumDialogPurpose_INTERNAL extends Enum
	Help: EnumDialogPurpose
	Quest: EnumDialogPurpose
	Shop: EnumDialogPurpose
end
declare class EnumDialogTone extends EnumItem end
declare class EnumDialogTone_INTERNAL extends Enum
	Enemy: EnumDialogTone
	Friendly: EnumDialogTone
	Neutral: EnumDialogTone
end
declare class EnumEasingDirection extends EnumItem end
declare class EnumEasingDirection_INTERNAL extends Enum
	In: EnumEasingDirection
	InOut: EnumEasingDirection
	Out: EnumEasingDirection
end
declare class EnumEasingStyle extends EnumItem end
declare class EnumEasingStyle_INTERNAL extends Enum
	Back: EnumEasingStyle
	Bounce: EnumEasingStyle
	Elastic: EnumEasingStyle
	Linear: EnumEasingStyle
	Quad: EnumEasingStyle
	Quart: EnumEasingStyle
	Quint: EnumEasingStyle
	Sine: EnumEasingStyle
end
declare class EnumEnviromentalPhysicsThrottle extends EnumItem end
declare class EnumEnviromentalPhysicsThrottle_INTERNAL extends Enum
	Always: EnumEnviromentalPhysicsThrottle
	DefaultAuto: EnumEnviromentalPhysicsThrottle
	Disabled: EnumEnviromentalPhysicsThrottle
	Skip16: EnumEnviromentalPhysicsThrottle
	Skip2: EnumEnviromentalPhysicsThrottle
	Skip4: EnumEnviromentalPhysicsThrottle
	Skip8: EnumEnviromentalPhysicsThrottle
end
declare class EnumErrorReporting extends EnumItem end
declare class EnumErrorReporting_INTERNAL extends Enum
	DontReport: EnumErrorReporting
	Prompt: EnumErrorReporting
	Report: EnumErrorReporting
end
declare class EnumExplosionType extends EnumItem end
declare class EnumExplosionType_INTERNAL extends Enum
	Craters: EnumExplosionType
	CratersAndDebris: EnumExplosionType
	NoCraters: EnumExplosionType
end
declare class EnumFilterResult extends EnumItem end
declare class EnumFilterResult_INTERNAL extends Enum
	Accepted: EnumFilterResult
	Rejected: EnumFilterResult
end
declare class EnumFont extends EnumItem end
declare class EnumFont_INTERNAL extends Enum
	Arial: EnumFont
	ArialBold: EnumFont
	Legacy: EnumFont
	SourceSans: EnumFont
	SourceSansBold: EnumFont
end
declare class EnumFontSize extends EnumItem end
declare class EnumFontSize_INTERNAL extends Enum
	Size10: EnumFontSize
	Size11: EnumFontSize
	Size12: EnumFontSize
	Size14: EnumFontSize
	Size18: EnumFontSize
	Size24: EnumFontSize
	Size36: EnumFontSize
	Size48: EnumFontSize
	Size8: EnumFontSize
	Size9: EnumFontSize
end
declare class EnumFormFactor extends EnumItem end
declare class EnumFormFactor_INTERNAL extends Enum
	Brick: EnumFormFactor
	Custom: EnumFormFactor
	Plate: EnumFormFactor
	Symmetric: EnumFormFactor
end
declare class EnumFrameStyle extends EnumItem end
declare class EnumFrameStyle_INTERNAL extends Enum
	ChatBlue: EnumFrameStyle
	ChatGreen: EnumFrameStyle
	ChatRed: EnumFrameStyle
	Custom: EnumFrameStyle
	RobloxRound: EnumFrameStyle
	RobloxSquare: EnumFrameStyle
end
declare class EnumFramerateManagerMode extends EnumItem end
declare class EnumFramerateManagerMode_INTERNAL extends Enum
	Automatic: EnumFramerateManagerMode
	Off: EnumFramerateManagerMode
	On: EnumFramerateManagerMode
end
declare class EnumFriendRequestEvent extends EnumItem end
declare class EnumFriendRequestEvent_INTERNAL extends Enum
	Accept: EnumFriendRequestEvent
	Deny: EnumFriendRequestEvent
	Issue: EnumFriendRequestEvent
	Revoke: EnumFriendRequestEvent
end
declare class EnumFriendStatus extends EnumItem end
declare class EnumFriendStatus_INTERNAL extends Enum
	Friend: EnumFriendStatus
	FriendRequestReceived: EnumFriendStatus
	FriendRequestSent: EnumFriendStatus
	NotFriend: EnumFriendStatus
	Unknown: EnumFriendStatus
end
declare class EnumFunctionalTestResult extends EnumItem end
declare class EnumFunctionalTestResult_INTERNAL extends Enum
	Error: EnumFunctionalTestResult
	Passed: EnumFunctionalTestResult
	Warning: EnumFunctionalTestResult
end
declare class EnumGearGenreSetting extends EnumItem end
declare class EnumGearGenreSetting_INTERNAL extends Enum
	AllGenres: EnumGearGenreSetting
	MatchingGenreOnly: EnumGearGenreSetting
end
declare class EnumGearType extends EnumItem end
declare class EnumGearType_INTERNAL extends Enum
	BuildingTools: EnumGearType
	Explosives: EnumGearType
	MeleeWeapons: EnumGearType
	MusicalInstruments: EnumGearType
	NavigationEnhancers: EnumGearType
	PowerUps: EnumGearType
	RangedWeapons: EnumGearType
	SocialItems: EnumGearType
	Transport: EnumGearType
end
declare class EnumGenre extends EnumItem end
declare class EnumGenre_INTERNAL extends Enum
	Adventure: EnumGenre
	All: EnumGenre
	Fantasy: EnumGenre
	Funny: EnumGenre
	Ninja: EnumGenre
	Pirate: EnumGenre
	Scary: EnumGenre
	SciFi: EnumGenre
	SkatePark: EnumGenre
	Sports: EnumGenre
	TownAndCity: EnumGenre
	Tutorial: EnumGenre
	War: EnumGenre
	WildWest: EnumGenre
end
declare class EnumGraphicsMode extends EnumItem end
declare class EnumGraphicsMode_INTERNAL extends Enum
	Automatic: EnumGraphicsMode
	Direct3D: EnumGraphicsMode
	NoGraphics: EnumGraphicsMode
	OpenGL: EnumGraphicsMode
end
declare class EnumHandlesStyle extends EnumItem end
declare class EnumHandlesStyle_INTERNAL extends Enum
	Movement: EnumHandlesStyle
	Resize: EnumHandlesStyle
end
declare class EnumHttpContentType extends EnumItem end
declare class EnumHttpContentType_INTERNAL extends Enum
	ApplicationJson: EnumHttpContentType
	ApplicationUrlEncoded: EnumHttpContentType
	ApplicationXml: EnumHttpContentType
	TextPlain: EnumHttpContentType
	TextXml: EnumHttpContentType
end
declare class EnumInOut extends EnumItem end
declare class EnumInOut_INTERNAL extends Enum
	Center: EnumInOut
	Edge: EnumInOut
	Inset: EnumInOut
end
declare class EnumInfoType extends EnumItem end
declare class EnumInfoType_INTERNAL extends Enum
	Asset: EnumInfoType
	Product: EnumInfoType
end
declare class EnumInputType extends EnumItem end
declare class EnumInputType_INTERNAL extends Enum
	Action1: EnumInputType
	Action2: EnumInputType
	Action3: EnumInputType
	Action4: EnumInputType
	Action5: EnumInputType
	Constant: EnumInputType
	LeftTread: EnumInputType
	NoInput: EnumInputType
	RightTread: EnumInputType
	Sin: EnumInputType
	Steer: EnumInputType
	Throtle: EnumInputType
	UpDown: EnumInputType
end
declare class EnumJointType extends EnumItem end
declare class EnumJointType_INTERNAL extends Enum
	Glue: EnumJointType
	None: EnumJointType
	Rotate: EnumJointType
	RotateP: EnumJointType
	RotateV: EnumJointType
	Snap: EnumJointType
	Weld: EnumJointType
end
declare class EnumKeywordFilterType extends EnumItem end
declare class EnumKeywordFilterType_INTERNAL extends Enum
	Exclude: EnumKeywordFilterType
	Include: EnumKeywordFilterType
end
declare class EnumLeftRight extends EnumItem end
declare class EnumLeftRight_INTERNAL extends Enum
	Center: EnumLeftRight
	Left: EnumLeftRight
	Right: EnumLeftRight
end
declare class EnumLevelOfDetailSetting extends EnumItem end
declare class EnumLevelOfDetailSetting_INTERNAL extends Enum
	High: EnumLevelOfDetailSetting
	Low: EnumLevelOfDetailSetting
	Medium: EnumLevelOfDetailSetting
end
declare class EnumMaterial extends EnumItem end
declare class EnumMaterial_INTERNAL extends Enum
	Brick: EnumMaterial
	Concrete: EnumMaterial
	CorrodedMetal: EnumMaterial
	DiamondPlate: EnumMaterial
	Fabric: EnumMaterial
	Foil: EnumMaterial
	Granite: EnumMaterial
	Grass: EnumMaterial
	Ice: EnumMaterial
	Marble: EnumMaterial
	Pebble: EnumMaterial
	Plastic: EnumMaterial
	Sand: EnumMaterial
	Slate: EnumMaterial
	SmoothPlastic: EnumMaterial
	Wood: EnumMaterial
end
declare class EnumMembershipType extends EnumItem end
declare class EnumMembershipType_INTERNAL extends Enum
	BuildersClub: EnumMembershipType
	None: EnumMembershipType
	OutrageousBuildersClub: EnumMembershipType
	TurboBuildersClub: EnumMembershipType
end
declare class EnumMeshType extends EnumItem end
declare class EnumMeshType_INTERNAL extends Enum
	Brick: EnumMeshType
	CornerWedge: EnumMeshType
	Cylinder: EnumMeshType
	FileMesh: EnumMeshType
	Head: EnumMeshType
	ParallelRamp: EnumMeshType
	Prism: EnumMeshType
	Pyramid: EnumMeshType
	RightAngleRamp: EnumMeshType
	Sphere: EnumMeshType
	Torso: EnumMeshType
	Wedge: EnumMeshType
end
declare class EnumMoveState extends EnumItem end
declare class EnumMoveState_INTERNAL extends Enum
	AirFree: EnumMoveState
	Coasting: EnumMoveState
	Pushing: EnumMoveState
	Stopped: EnumMoveState
	Stopping: EnumMoveState
end
declare class EnumNameOcclusion extends EnumItem end
declare class EnumNameOcclusion_INTERNAL extends Enum
	EnemyOcclusion: EnumNameOcclusion
	NoOcclusion: EnumNameOcclusion
	OccludeAll: EnumNameOcclusion
end
declare class EnumNormalId extends EnumItem end
declare class EnumNormalId_INTERNAL extends Enum
	Back: EnumNormalId
	Bottom: EnumNormalId
	Front: EnumNormalId
	Left: EnumNormalId
	Right: EnumNormalId
	Top: EnumNormalId
end
declare class EnumPacketPriority extends EnumItem end
declare class EnumPacketPriority_INTERNAL extends Enum
	HIGH_PRIORITY: EnumPacketPriority
	IMMEDIATE_PRIORITY: EnumPacketPriority
	LOW_PRIORITY: EnumPacketPriority
	MEDIUM_PRIORITY: EnumPacketPriority
end
declare class EnumPacketReliability extends EnumItem end
declare class EnumPacketReliability_INTERNAL extends Enum
	RELIABLE: EnumPacketReliability
	RELIABLE_ORDERED: EnumPacketReliability
	RELIABLE_SEQUENCED: EnumPacketReliability
	UNRELIABLE: EnumPacketReliability
	UNRELIABLE_SEQUENCED: EnumPacketReliability
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
	AccumulatedError: EnumPriorityMethod
	FIFO: EnumPriorityMethod
	LastError: EnumPriorityMethod
end
declare class EnumPrismSides extends EnumItem end
declare class EnumPrismSides_INTERNAL extends Enum
	["10"]: EnumPrismSides
	["20"]: EnumPrismSides
	["3"]: EnumPrismSides
	["5"]: EnumPrismSides
	["6"]: EnumPrismSides
	["8"]: EnumPrismSides
end
declare class EnumPrivilegeType extends EnumItem end
declare class EnumPrivilegeType_INTERNAL extends Enum
	Admin: EnumPrivilegeType
	Banned: EnumPrivilegeType
	Member: EnumPrivilegeType
	Owner: EnumPrivilegeType
	Visitor: EnumPrivilegeType
end
declare class EnumPyramidSides extends EnumItem end
declare class EnumPyramidSides_INTERNAL extends Enum
	["10"]: EnumPyramidSides
	["20"]: EnumPyramidSides
	["3"]: EnumPyramidSides
	["4"]: EnumPyramidSides
	["5"]: EnumPyramidSides
	["6"]: EnumPyramidSides
	["8"]: EnumPyramidSides
end
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
	["1024x600"]: EnumResolution
	["1024x768"]: EnumResolution
	["1152x864"]: EnumResolution
	["1280x1024"]: EnumResolution
	["1280x720"]: EnumResolution
	["1280x768"]: EnumResolution
	["1280x800"]: EnumResolution
	["1280x960"]: EnumResolution
	["1360x768"]: EnumResolution
	["1440x900"]: EnumResolution
	["1600x1024"]: EnumResolution
	["1600x1200"]: EnumResolution
	["1600x900"]: EnumResolution
	["1680x1050"]: EnumResolution
	["1920x1080"]: EnumResolution
	["1920x1200"]: EnumResolution
	["720x526"]: EnumResolution
	["800x600"]: EnumResolution
	Automatic: EnumResolution
end
declare class EnumReverbType extends EnumItem end
declare class EnumReverbType_INTERNAL extends Enum
	Alley: EnumReverbType
	Arena: EnumReverbType
	Auditorium: EnumReverbType
	Bathroom: EnumReverbType
	CarpettedHallway: EnumReverbType
	Cave: EnumReverbType
	City: EnumReverbType
	ConcertHall: EnumReverbType
	Forest: EnumReverbType
	GenericReverb: EnumReverbType
	Hallway: EnumReverbType
	Hangar: EnumReverbType
	LivingRoom: EnumReverbType
	Mountains: EnumReverbType
	NoReverb: EnumReverbType
	PaddedCell: EnumReverbType
	ParkingLot: EnumReverbType
	Plain: EnumReverbType
	Quarry: EnumReverbType
	Room: EnumReverbType
	SewerPipe: EnumReverbType
	StoneCorridor: EnumReverbType
	StoneRoom: EnumReverbType
	UnderWater: EnumReverbType
end
declare class EnumRuntimeUndoBehavior extends EnumItem end
declare class EnumRuntimeUndoBehavior_INTERNAL extends Enum
	Aggregate: EnumRuntimeUndoBehavior
	Hybrid: EnumRuntimeUndoBehavior
	Snapshot: EnumRuntimeUndoBehavior
end
declare class EnumSaveFilter extends EnumItem end
declare class EnumSaveFilter_INTERNAL extends Enum
	SaveAll: EnumSaveFilter
	SaveGame: EnumSaveFilter
	SaveWorld: EnumSaveFilter
end
declare class EnumSavedQualitySetting extends EnumItem end
declare class EnumSavedQualitySetting_INTERNAL extends Enum
	Automatic: EnumSavedQualitySetting
	QualityLevel1: EnumSavedQualitySetting
	QualityLevel10: EnumSavedQualitySetting
	QualityLevel2: EnumSavedQualitySetting
	QualityLevel3: EnumSavedQualitySetting
	QualityLevel4: EnumSavedQualitySetting
	QualityLevel5: EnumSavedQualitySetting
	QualityLevel6: EnumSavedQualitySetting
	QualityLevel7: EnumSavedQualitySetting
	QualityLevel8: EnumSavedQualitySetting
	QualityLevel9: EnumSavedQualitySetting
end
declare class EnumShadow extends EnumItem end
declare class EnumShadow_INTERNAL extends Enum
	All: EnumShadow
	Automatic: EnumShadow
	CharacterOnly: EnumShadow
	Off: EnumShadow
end
declare class EnumSizeConstraint extends EnumItem end
declare class EnumSizeConstraint_INTERNAL extends Enum
	RelativeXX: EnumSizeConstraint
	RelativeXY: EnumSizeConstraint
	RelativeYY: EnumSizeConstraint
end
declare class EnumSleepAdjustMethod extends EnumItem end
declare class EnumSleepAdjustMethod_INTERNAL extends Enum
	AverageInterval: EnumSleepAdjustMethod
	LastSample: EnumSleepAdjustMethod
	None: EnumSleepAdjustMethod
end
declare class EnumSoundType extends EnumItem end
declare class EnumSoundType_INTERNAL extends Enum
	Boing: EnumSoundType
	Bomb: EnumSoundType
	Break: EnumSoundType
	Click: EnumSoundType
	Clock: EnumSoundType
	NoSound: EnumSoundType
	Page: EnumSoundType
	Ping: EnumSoundType
	Slingshot: EnumSoundType
	Snap: EnumSoundType
	Splat: EnumSoundType
	Step: EnumSoundType
	StepOn: EnumSoundType
	Swoosh: EnumSoundType
	Victory: EnumSoundType
end
declare class EnumSpecialKey extends EnumItem end
declare class EnumSpecialKey_INTERNAL extends Enum
	ChatHotkey: EnumSpecialKey
	End: EnumSpecialKey
	Home: EnumSpecialKey
	Insert: EnumSpecialKey
	PageDown: EnumSpecialKey
	PageUp: EnumSpecialKey
end
declare class EnumStatus extends EnumItem end
declare class EnumStatus_INTERNAL extends Enum
	Confusion: EnumStatus
	Poison: EnumStatus
end
declare class EnumStuff extends EnumItem end
declare class EnumStuff_INTERNAL extends Enum
	Bodies: EnumStuff
	Costumes: EnumStuff
	Faces: EnumStuff
	Gears: EnumStuff
	Hats: EnumStuff
	Heads: EnumStuff
	LeftArms: EnumStuff
	LeftLegs: EnumStuff
	Pants: EnumStuff
	RightArms: EnumStuff
	RightLegs: EnumStuff
	Shirts: EnumStuff
	TShirts: EnumStuff
	Torsos: EnumStuff
end
declare class EnumStyle extends EnumItem end
declare class EnumStyle_INTERNAL extends Enum
	AlternatingSupports: EnumStyle
	BridgeStyleSupports: EnumStyle
	NoSupports: EnumStyle
end
declare class EnumSurfaceConstraint extends EnumItem end
declare class EnumSurfaceConstraint_INTERNAL extends Enum
	Hinge: EnumSurfaceConstraint
	Motor: EnumSurfaceConstraint
	None: EnumSurfaceConstraint
	SteppingMotor: EnumSurfaceConstraint
end
declare class EnumSurfaceType extends EnumItem end
declare class EnumSurfaceType_INTERNAL extends Enum
	Glue: EnumSurfaceType
	Hinge: EnumSurfaceType
	Inlet: EnumSurfaceType
	Motor: EnumSurfaceType
	Smooth: EnumSurfaceType
	SmoothNoOutlines: EnumSurfaceType
	SteppingMotor: EnumSurfaceType
	Studs: EnumSurfaceType
	Universal: EnumSurfaceType
	Unjoinable: EnumSurfaceType
	Weld: EnumSurfaceType
end
declare class EnumSwipeDirection extends EnumItem end
declare class EnumSwipeDirection_INTERNAL extends Enum
	Down: EnumSwipeDirection
	Left: EnumSwipeDirection
	None: EnumSwipeDirection
	Right: EnumSwipeDirection
	Up: EnumSwipeDirection
end
declare class EnumTeleportState extends EnumItem end
declare class EnumTeleportState_INTERNAL extends Enum
	Failed: EnumTeleportState
	InProgress: EnumTeleportState
	RequestedFromServer: EnumTeleportState
	Started: EnumTeleportState
	WaitingForServer: EnumTeleportState
end
declare class EnumTextXAlignment extends EnumItem end
declare class EnumTextXAlignment_INTERNAL extends Enum
	Center: EnumTextXAlignment
	Left: EnumTextXAlignment
	Right: EnumTextXAlignment
end
declare class EnumTextYAlignment extends EnumItem end
declare class EnumTextYAlignment_INTERNAL extends Enum
	Bottom: EnumTextYAlignment
	Center: EnumTextYAlignment
	Top: EnumTextYAlignment
end
declare class EnumThreadPoolConfig extends EnumItem end
declare class EnumThreadPoolConfig_INTERNAL extends Enum
	Auto: EnumThreadPoolConfig
	PerCore1: EnumThreadPoolConfig
	PerCore2: EnumThreadPoolConfig
	PerCore3: EnumThreadPoolConfig
	PerCore4: EnumThreadPoolConfig
	Threads1: EnumThreadPoolConfig
	Threads16: EnumThreadPoolConfig
	Threads2: EnumThreadPoolConfig
	Threads3: EnumThreadPoolConfig
	Threads4: EnumThreadPoolConfig
	Threads8: EnumThreadPoolConfig
end
declare class EnumTickCountSampleMethod extends EnumItem end
declare class EnumTickCountSampleMethod_INTERNAL extends Enum
	Benchmark: EnumTickCountSampleMethod
	Fast: EnumTickCountSampleMethod
	Precise: EnumTickCountSampleMethod
end
declare class EnumTopBottom extends EnumItem end
declare class EnumTopBottom_INTERNAL extends Enum
	Bottom: EnumTopBottom
	Center: EnumTopBottom
	Top: EnumTopBottom
end
declare class EnumTweenStatus extends EnumItem end
declare class EnumTweenStatus_INTERNAL extends Enum
	Canceled: EnumTweenStatus
	Completed: EnumTweenStatus
end
declare class EnumUploadSetting extends EnumItem end
declare class EnumUploadSetting_INTERNAL extends Enum
	Always: EnumUploadSetting
	Ask: EnumUploadSetting
	Never: EnumUploadSetting
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
	Focus: EnumUserInputType
	Keyboard: EnumUserInputType
	MouseButton1: EnumUserInputType
	MouseButton2: EnumUserInputType
	MouseButton3: EnumUserInputType
	MouseMovement: EnumUserInputType
	MouseWheel: EnumUserInputType
	None: EnumUserInputType
	Touch: EnumUserInputType
end
declare class EnumVideoQualitySettings extends EnumItem end
declare class EnumVideoQualitySettings_INTERNAL extends Enum
	HighResolution: EnumVideoQualitySettings
	LowResolution: EnumVideoQualitySettings
	MediumResolution: EnumVideoQualitySettings
end
declare class EnumWaterDirection extends EnumItem end
declare class EnumWaterDirection_INTERNAL extends Enum
	NegX: EnumWaterDirection
	NegY: EnumWaterDirection
	NegZ: EnumWaterDirection
	X: EnumWaterDirection
	Y: EnumWaterDirection
	Z: EnumWaterDirection
end
declare class EnumWaterForce extends EnumItem end
declare class EnumWaterForce_INTERNAL extends Enum
	Max: EnumWaterForce
	Medium: EnumWaterForce
	None: EnumWaterForce
	Small: EnumWaterForce
	Strong: EnumWaterForce
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
	PrismSides: EnumPrismSides_INTERNAL,
	PrivilegeType: EnumPrivilegeType_INTERNAL,
	PyramidSides: EnumPyramidSides_INTERNAL,
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

declare class BrickColor
	Color: Color3
	Name: string
	Number: number
	b: number
	g: number
	r: number
end

declare class CFrame
	X: number
	Y: number
	Z: number
	function __add(self, other: Vector3): CFrame
	function __mul(self, other: CFrame): CFrame
	function __mul(self, other: Vector3): Vector3
	function __sub(self, other: Vector3): CFrame
	function components(self): (number, number, number, number, number, number, number, number, number, number, number, number)
	function inverse(self): CFrame
	function pointToObjectSpace(self, v3: Vector3): Vector3
	function pointToWorldSpace(self, v3: Vector3): Vector3
	function toObjectSpace(self, cf: CFrame): CFrame
	function toWorldSpace(self, cf: CFrame): CFrame
	function vectorToObjectSpace(self, v3: Vector3): Vector3
	function vectorToWorldSpace(self, v3: Vector3): Vector3
	lookVector: Vector3
	p: Vector3
end

declare class Color3
	b: number
	g: number
	r: number
end



declare class Faces
	Back: boolean
	Bottom: boolean
	Front: boolean
	Left: boolean
	Right: boolean
	Top: boolean
end

declare class RBXScriptConnection
	connected: boolean
	function disconnect(self): ()
end



declare class Ray
	Direction: Vector3
	Origin: Vector3
	Unit: Ray
	function ClosestPoint(self, point: Vector3): Vector3
	function Distance(self, point: Vector3): number
end

declare class Region3
	CFrame: CFrame
	Size: Vector3
end

declare class Region3int16
	Max: Vector3int16
	Min: Vector3int16
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
	X: number
	Y: number
	function __add(self, other: Vector2): Vector2
	function __div(self, other: Vector2 | number): Vector2
	function __mul(self, other: Vector2 | number): Vector2
	function __sub(self, other: Vector2): Vector2
	function __unm(self): Vector2
	function lerp(self, v: Vector2, alpha: number): Vector2
	magnitude: number
	unit: Vector2
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
	Unit: Vector3
	X: number
	Y: number
	Z: number
	function Cross(self, other: Vector3): Vector3
	function Dot(self, other: Vector3): number
	function Lerp(self, goal: Vector3, alpha: number): Vector3
	function __add(self, other: Vector3): Vector3
	function __div(self, other: Vector3 | number): Vector3
	function __mul(self, other: Vector3 | number): Vector3
	function __sub(self, other: Vector3): Vector3
	function __unm(self): Vector3
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



export type RBXScriptSignal<T... = ...any> = {
    wait: (self: RBXScriptSignal<T...>) -> T...,
    connect: (self: RBXScriptSignal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
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

declare class Instance
	AncestryChanged: RBXScriptSignal<Instance, Instance?>
	Archivable: boolean
	Changed: RBXScriptSignal<string>
	ChildAdded: RBXScriptSignal<Instance>
	ChildRemoved: RBXScriptSignal<Instance>
	ClassName: string
	DescendantAdded: RBXScriptSignal<Instance>
	DescendantRemoving: RBXScriptSignal<Instance>
	Name: string
	Parent: Instance?
	RobloxLocked: boolean
	archivable: boolean
	function ClearAllChildren(self): ()
	function Clone(self): Instance
	function Destroy(self): ()
	function FindFirstChild(self, name: string, recursive: boolean?): Instance?
	function GetChildren(self): { Instance }
	function GetDebugId(self, scopeLength: number?): string
	function GetFullName(self): string
	function IsA(self, className: string): boolean
	function IsAncestorOf(self, descendant: Instance): boolean
	function IsDescendantOf(self, ancestor: Instance): boolean
	function WaitForChild(self, name: string): Instance
	function WaitForChild(self, name: string, timeout: number): Instance?
end

declare class Accoutrement extends Instance
	AttachmentForward: Vector3
	AttachmentPoint: CFrame
	AttachmentPos: Vector3
	AttachmentRight: Vector3
	AttachmentUp: Vector3
end

declare class Hat extends Accoutrement
end

declare class AdvancedDragger extends Instance
end

declare class Animation extends Instance
	AnimationId: Content
end

declare class AnimationController extends Instance
	function LoadAnimation(self, animation: Animation): Instance
end

declare class AnimationTrack extends Instance
	KeyframeReached: RBXScriptSignal<string>
	function AdjustSpeed(self, speed: number?): ()
	function AdjustWeight(self, weight: number?, fadeTime: number?): ()
	function Play(self, fadeTime: number?, weight: number?, speed: number?): ()
	function Stop(self, fadeTime: number?): ()
end

declare class AnimationTrackState extends Instance
end

declare class Animator extends Instance
	function LoadAnimation(self, animation: Animation): AnimationTrack
end

declare class AssetService extends Instance
	function GetAssetVersions(self, placeId: number, pageNum: number?): { [any]: any }
	function GetCreatorAssetID(self, creationID: number): number
	function GetPlacePermissions(self, placeId: number): { [any]: any }
	function RevertAsset(self, placeId: number, versionNumber: number): boolean
	function SetAssetRevertUrl(self, revertUrl: string): ()
	function SetAssetVersionsUrl(self, versionsUrl: string): ()
	function SetPlaceAccessUrl(self, accessUrl: string): ()
	function SetPlacePermissions(self, placeId: number, accessType: EnumAccessType?, inviteList: { any }?): boolean
end

declare class BadgeService extends Instance
	BadgeAwarded: RBXScriptSignal<string>
	function AwardBadge(self, userId: number, badgeId: number): boolean
	function IsDisabled(self, badgeId: number): boolean
	function IsLegal(self, badgeId: number): boolean
	function SetAwardBadgeUrl(self, url: string): ()
	function SetHasBadgeCooldown(self, seconds: number): ()
	function SetHasBadgeUrl(self, url: string): ()
	function SetIsBadgeDisabledUrl(self, url: string): ()
	function SetIsBadgeLegalUrl(self, url: string): ()
	function SetPlaceId(self, placeId: number): ()
	function UserHasBadge(self, userId: number, badgeId: number): boolean
end

declare class BasePlayerGui extends Instance
end

declare class CoreGui extends BasePlayerGui
	Version: number
end

declare class PlayerGui extends BasePlayerGui
end

declare class StarterGui extends BasePlayerGui
	CoreGuiChangedSignal: RBXScriptSignal<EnumCoreGuiType, boolean>
	ResetPlayerGuiOnSpawn: boolean
	ShowDevelopmentGui: boolean
	function GetCoreGuiEnabled(self, coreGuiType: EnumCoreGuiType): boolean
	function SetCoreGuiEnabled(self, coreGuiType: EnumCoreGuiType, enabled: boolean): ()
end

declare class BaseScript extends Instance
	Disabled: boolean
	LinkedSource: Content
end

declare class CoreScript extends BaseScript
end

declare class StarterScript extends CoreScript
end

declare class Script extends BaseScript
	Source: ProtectedString
end

declare class LocalScript extends Script
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
	P: number
	angularvelocity: Vector3
	maxTorque: Vector3
end

declare class BodyForce extends BodyMover
	force: Vector3
end

declare class BodyGyro extends BodyMover
	D: number
	P: number
	cframe: CFrame
	maxTorque: Vector3
end

declare class BodyPosition extends BodyMover
	D: number
	P: number
	ReachedTarget: RBXScriptSignal<>
	function GetLastForce(self): Vector3
	function lastForce(self): Vector3
	maxForce: Vector3
	position: Vector3
end

declare class BodyThrust extends BodyMover
	force: Vector3
	location: Vector3
end

declare class BodyVelocity extends BodyMover
	P: number
	function GetLastForce(self): Vector3
	function lastForce(self): Vector3
	maxForce: Vector3
	velocity: Vector3
end

declare class RocketPropulsion extends BodyMover
	CartoonFactor: number
	MaxSpeed: number
	MaxThrust: number
	MaxTorque: Vector3
	ReachedTarget: RBXScriptSignal<>
	Target: Object
	TargetOffset: Vector3
	TargetRadius: number
	ThrustD: number
	ThrustP: number
	TurnD: number
	TurnP: number
	function Abort(self): ()
	function Fire(self): ()
end

declare class BoolValue extends Instance
	Changed: RBXScriptSignal<boolean>
	Value: boolean
end

declare class BrickColorValue extends Instance
	Changed: RBXScriptSignal<BrickColor>
	Value: BrickColor
end

declare class Button extends Instance
	Click: RBXScriptSignal<>
	function SetActive(self, active: boolean): ()
end

declare class CFrameValue extends Instance
	Changed: RBXScriptSignal<CFrame>
	Value: CFrame
end

declare class CacheableContentProvider extends Instance
end

declare class MeshContentProvider extends CacheableContentProvider
end

declare class TextureContentProvider extends CacheableContentProvider
end

declare class Camera extends Instance
	CameraSubject: Humanoid | BasePart | nil
	CameraType: EnumCameraType
	CoordinateFrame: CFrame
	FieldOfView: number
	Focus: CFrame
	InterpolationFinished: RBXScriptSignal<>
	function GetPanSpeed(self): number
	function GetRoll(self): number
	function GetTiltSpeed(self): number
	function Interpolate(self, endPos: CFrame, endFocus: CFrame, duration: number): ()
	function PanUnits(self, units: number): ()
	function SetCameraPanMode(self, mode: EnumCameraPanMode?): ()
	function SetRoll(self, rollAngle: number): ()
	function TiltUnits(self, units: number): boolean
	function Zoom(self, distance: number): boolean
end

declare class ChangeHistoryService extends Instance
	function GetCanRedo(self): any
	function GetCanUndo(self): any
	function Redo(self): ()
	function ResetWaypoints(self): ()
	function SetEnabled(self, state: boolean): ()
	function SetWaypoint(self, name: string): ()
	function Undo(self): ()
end

declare class CharacterAppearance extends Instance
end

declare class BodyColors extends CharacterAppearance
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
	Graphic: Content
end

declare class Skin extends CharacterAppearance
	SkinColor: BrickColor
end

declare class Chat extends Instance
	Chatted: RBXScriptSignal<BasePart, string, EnumChatColor>
	function Chat(self, partOrCharacter: Instance, message: string, color: EnumChatColor?): ()
end

declare class ChatFilter extends Instance
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
	function GetCollection(self, class: string): { Instance }
end

declare class Color3Value extends Instance
	Changed: RBXScriptSignal<Color3>
	Value: Color3
end

declare class Configuration extends Instance
end

declare class ContentFilter extends Instance
	function SetFilterLimits(self, outstandingRequests: number, cacheSize: number): ()
	function SetFilterUrl(self, url: string): ()
end

declare class ContentProvider extends Instance
	BaseUrl: string
	RequestQueueSize: number
	function Preload(self, contentId: Content): ()
	function SetAssetUrl(self, url: string): ()
	function SetBaseUrl(self, url: string): ()
	function SetCacheSize(self, count: number): ()
	function SetThreadPool(self, count: number): ()
end

declare class ContextActionService extends Instance
	ContextButtonEnabled: boolean
	LocalToolEquipped: RBXScriptSignal<Tool>
	LocalToolUnequipped: RBXScriptSignal<Tool>
	function ActivateLocalTool(self): ()
	function DeactivateLocalTool(self): ()
	function GetCurrentLocalToolIcon(self): string
end

declare class Controller extends Instance
	ButtonChanged: RBXScriptSignal<EnumButton>
	function BindButton(self, button: EnumButton, caption: string): ()
	function GetButton(self, button: EnumButton): boolean
	function UnbindButton(self, button: EnumButton): ()
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
end

declare class CustomEvent extends Instance
	ReceiverConnected: RBXScriptSignal<Instance>
	ReceiverDisconnected: RBXScriptSignal<Instance>
	function GetAttachedReceivers(self): { Instance }
	function SetValue(self, newValue: number): ()
end

declare class CustomEventReceiver extends Instance
	EventConnected: RBXScriptSignal<Instance>
	EventDisconnected: RBXScriptSignal<Instance>
	Source: Object
	SourceValueChanged: RBXScriptSignal<number>
	function GetCurrentValue(self): number
end

declare class DataModelMesh extends Instance
	Offset: Vector3
	Scale: Vector3
	VertexColor: Vector3
end

declare class BevelMesh extends DataModelMesh
end

declare class BlockMesh extends BevelMesh
end

declare class CylinderMesh extends BevelMesh
end

declare class FileMesh extends DataModelMesh
	MeshId: Content
	TextureId: Content
end

declare class SpecialMesh extends FileMesh
	MeshType: EnumMeshType
end

declare class DataStoreService extends Instance
	function GetGlobalDataStore(self): Instance
end

declare class Debris extends Instance
	function AddItem(self, item: Instance, lifetime: number?): ()
	function SetLegacyMaxItems(self, enabled: boolean): ()
end

declare class DebugSettings extends Instance
	AltCdnFailureCount: number
	AltCdnSuccessCount: number
	AvailablePhysicalMemory: number
	BlockMeshSize: number
	CPU: string
	CdnFailureCount: number
	CdnResponceTime: number
	CdnSuccessCount: number
	CpuCount: number
	CpuSpeed: number
	DataModel: number
	ElapsedTime: number
	EnforceInstanceCountLimit: boolean
	ErrorReporting: EnumErrorReporting
	GfxCard: string
	InstanceCount: number
	InstanceCountLimit: number
	IsFmodProfilingEnabled: boolean
	IsProfilingEnabled: boolean
	IsScriptStackTracingEnabled: boolean
	JobCount: number
	LastCdnFailureTimeSpan: number
	LuaRamLimit: number
	NameDatabaseBytes: number
	NameDatabaseSize: number
	OsIs64Bit: boolean
	OsPlatform: string
	OsPlatformId: number
	OsVer: string
	PageFaultsPerSecond: number
	PageFileBytes: number
	PixelShaderModel: number
	PlayerCount: number
	PrivateBytes: number
	PrivateWorkingSetBytes: number
	ProcessCores: number
	ProcessorTime: number
	ProfilingWindow: number
	RAM: number
	ReportExtendedMachineConfiguration: boolean
	ReportSoundWarnings: boolean
	Resolution: string
	RobloxFailureCount: number
	RobloxProductName: string
	RobloxRespoceTime: number
	RobloxSuccessCount: number
	RobloxVersion: string
	SIMD: string
	SystemProductName: string
	TickCountPreciseOverride: EnumTickCountSampleMethod
	TotalPhysicalMemory: number
	TotalProcessorTime: number
	VertexShaderModel: number
	VideoMemory: number
	VirtualBytes: number
	function LegacyScriptMode(self): ()
	function ResetCdnFailureCounts(self): any
	function SetBlockingRemove(self, value: boolean): ()
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
	function EnableDebugging(self): ()
	function GetDebuggers(self): { Instance }
end

declare class DebuggerWatch extends Instance
	Expression: string
	function CheckSyntax(self): ()
end

declare class Dialog extends Instance
	ConversationDistance: number
	DialogChoiceSelected: RBXScriptSignal<Player, DialogChoice>
	InUse: boolean
	InitialPrompt: string
	Purpose: EnumDialogPurpose
	Tone: EnumDialogTone
	function SignalDialogChoiceSelected(self, player: Instance, dialogChoice: Instance): ()
end

declare class DialogChoice extends Instance
	ResponseDialog: string
	UserDialog: string
end

declare class DoubleConstrainedValue extends Instance
	Changed: RBXScriptSignal<number>
	ConstrainedValue: number
	MaxValue: number
	MinValue: number
	Value: number
end

declare class Dragger extends Instance
	function AxisRotate(self, axis: EnumAxis?): ()
	function MouseDown(self, mousePart: Instance, pointOnMousePart: Vector3, parts: { Instance }): ()
	function MouseMove(self, mouseRay: Ray): ()
	function MouseUp(self): ()
end

declare class Explosion extends Instance
	BlastPressure: number
	BlastRadius: number
	ExplosionType: EnumExplosionType
	Hit: RBXScriptSignal<BasePart, number>
	Position: Vector3
end

declare class FWService extends Instance
end

declare class FaceInstance extends Instance
	Face: EnumNormalId
end

declare class Decal extends FaceInstance
	Shiny: number
	Specular: number
	Texture: Content
	Transparency: number
end

declare class Texture extends Decal
	StudsPerTileU: number
	StudsPerTileV: number
end

declare class FastLogSettings extends Instance
	function DumpLogs(self, filename: string): ()
	function Print(self, message: string): ()
	function SetVariable(self, group: string, channel: string?): ()
end

declare class Feature extends Instance
	FaceId: EnumNormalId
	InOut: EnumInOut
	LeftRight: EnumLeftRight
	TopBottom: EnumTopBottom
end

declare class Hole extends Feature
end

declare class MotorFeature extends Feature
end

declare class Fire extends Instance
	Color: Color3
	Enabled: boolean
	Heat: number
	SecondaryColor: Color3
	Size: number
end

declare class FlagStandService extends Instance
end

declare class ForceField extends Instance
end

declare class FriendService extends Instance
	function SetBreakFriendUrl(self, url: string): ()
	function SetCreateFriendRequestUrl(self, url: string): ()
	function SetDeleteFriendRequestUrl(self, url: string): ()
	function SetEnabled(self, enable: boolean): ()
	function SetFriendsOnlineUrl(self, url: string): ()
	function SetGetFriendsUrl(self, url: string): ()
	function SetMakeFriendUrl(self, url: string): ()
end

declare class FunctionalTest extends Instance
	Description: string
	function Error(self, message: string?): ()
	function Failed(self, message: string?): ()
	function Pass(self, message: string?): ()
	function Passed(self, message: string?): ()
	function Warn(self, message: string?): ()
end

declare class GamePassService extends Instance
	function PlayerHasPass(self, player: Instance, gamePassId: number): boolean
	function SetPlayerHasPassUrl(self, playerHasPassUrl: string): ()
end

declare class GameSettings extends Instance
	BubbleChatLifetime: number
	BubbleChatMaxBubbles: number
	ChatHistory: number
	ChatScrollLength: number
	CollisionSoundEnabled: boolean
	CollisionSoundVolume: number
	HardwareMouse: boolean
	ImageUploadPromptBehavior: EnumUploadSetting
	MaxCollisionSounds: number
	ReportAbuseChatHistory: number
	SoftwareSound: boolean
	SoundEnabled: boolean
	VideoCaptureEnabled: boolean
	VideoQuality: EnumVideoQualitySettings
	VideoRecordingChangeRequest: RBXScriptSignal<boolean>
end

declare class Geometry extends Instance
end

declare class GlobalDataStore extends Instance
	function GetAsync(self, key: string): (any, { [string]: any })
	function IncrementAsync(self, key: string, delta: number?, userIds: { number }?, options: { [string]: any }?): (number, { [string]: any })
	function OnUpdate(self, key: string, callback: ((...any) -> ...any)): RBXScriptConnection
	function SetAsync(self, key: string, value: any, userIds: { number }?, options: { [string]: any }?): string
	function UpdateAsync(self, key: string, transformFunction: ((any, { [string]: any }) -> (any, { number }?, {}?))): (any, { [string]: any })
end

declare class GuiBase extends Instance
end

declare class GuiBase2d extends GuiBase
	AbsolutePosition: Vector2
	AbsoluteSize: Vector2
end

declare class GuiObject extends GuiBase2d
	Active: boolean
	BackgroundColor3: Color3
	BackgroundTransparency: number
	BorderColor3: Color3
	BorderSizePixel: number
	ClipsDescendants: boolean
	DragBegin: RBXScriptSignal<UDim2>
	DragStopped: RBXScriptSignal<number, number>
	Draggable: boolean
	InputBegan: RBXScriptSignal<Instance>
	InputChanged: RBXScriptSignal<Instance>
	InputEnded: RBXScriptSignal<Instance>
	MouseEnter: RBXScriptSignal<number, number>
	MouseLeave: RBXScriptSignal<number, number>
	MouseMoved: RBXScriptSignal<number, number>
	MouseWheelBackward: RBXScriptSignal<number, number>
	MouseWheelForward: RBXScriptSignal<number, number>
	Position: UDim2
	Rotation: number
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

declare class NotificationObject extends Frame
end

declare class GuiButton extends GuiObject
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
	function SetVerb(self, verb: string): ()
end

declare class ImageButton extends GuiButton
	Image: Content
	ImageRectOffset: Vector2
	ImageRectSize: Vector2
end

declare class TextButton extends GuiButton
	Font: EnumFont
	FontSize: EnumFontSize
	Text: string
	TextBounds: Vector2
	TextColor3: Color3
	TextFits: boolean
	TextScaled: boolean
	TextStrokeColor3: Color3
	TextStrokeTransparency: number
	TextTransparency: number
	TextWrapped: boolean
	TextXAlignment: EnumTextXAlignment
	TextYAlignment: EnumTextYAlignment
end

declare class GuiLabel extends GuiObject
end

declare class ImageLabel extends GuiLabel
	Image: Content
	ImageRectOffset: Vector2
	ImageRectSize: Vector2
end

declare class TextLabel extends GuiLabel
	Font: EnumFont
	FontSize: EnumFontSize
	Text: string
	TextBounds: Vector2
	TextColor3: Color3
	TextFits: boolean
	TextScaled: boolean
	TextStrokeColor3: Color3
	TextStrokeTransparency: number
	TextTransparency: number
	TextWrapped: boolean
	TextXAlignment: EnumTextXAlignment
	TextYAlignment: EnumTextYAlignment
end

declare class NotificationBox extends GuiObject
end

declare class Scale9Frame extends GuiObject
	ScaleEdgeSize: Vector2int16
	SlicePrefix: string
end

declare class TextBox extends GuiObject
	ClearTextOnFocus: boolean
	FocusLost: RBXScriptSignal<boolean>
	Font: EnumFont
	FontSize: EnumFontSize
	MultiLine: boolean
	Text: string
	TextBounds: Vector2
	TextColor3: Color3
	TextFits: boolean
	TextScaled: boolean
	TextStrokeColor3: Color3
	TextStrokeTransparency: number
	TextTransparency: number
	TextWrapped: boolean
	TextXAlignment: EnumTextXAlignment
	TextYAlignment: EnumTextYAlignment
	function CaptureFocus(self): ()
end

declare class LayerCollector extends GuiBase2d
end

declare class BillboardGui extends LayerCollector
	Active: boolean
	Adornee: Object
	AlwaysOnTop: boolean
	Enabled: boolean
	ExtentsOffset: Vector3
	PlayerToHideFrom: Object
	Size: UDim2
	SizeOffset: Vector2
	StudsOffset: Vector3
end

declare class ScreenGui extends LayerCollector
end

declare class GuiMain extends ScreenGui
end

declare class SurfaceGui extends LayerCollector
	Active: boolean
	Adornee: Object
	CanvasSize: Vector2
	Enabled: boolean
	Face: EnumNormalId
end

declare class GuiBase3d extends GuiBase
	Color: BrickColor
	Transparency: number
	Visible: boolean
end

declare class FloorWire extends GuiBase3d
	CycleOffset: number
	From: Object
	StudsBetweenTextures: number
	Texture: Content
	TextureSize: Vector2
	To: Object
	Velocity: number
	WireRadius: number
end

declare class PVAdornment extends GuiBase3d
	Adornee: Object
end

declare class SelectionBox extends PVAdornment
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
	Humanoid: Object
end

declare class SelectionPartLasso extends SelectionLasso
	Part: Object
end

declare class SelectionPointLasso extends SelectionLasso
	Point: Vector3
end

declare class TextureTrail extends GuiBase3d
end

declare class GuiItem extends Instance
end

declare class Backpack extends GuiItem
end

declare class BackpackItem extends GuiItem
	TextureId: Content
end

declare class HopperBin extends BackpackItem
	Active: boolean
	BinType: EnumBinType
	Deselected: RBXScriptSignal<>
	Selected: RBXScriptSignal<Instance>
	function Disable(self): ()
	function ToggleSelect(self): ()
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
	ToolTip: string
	Unequipped: RBXScriptSignal<>
end

declare class Flag extends Tool
	TeamColor: BrickColor
end

declare class ButtonBindingWidget extends GuiItem
end

declare class GuiRoot extends GuiItem
end

declare class Hopper extends GuiItem
end

declare class LocalBackpack extends GuiItem
	function GetOldSchoolBackpack(self): boolean
	function SetOldSchoolBackpack(self, show: boolean): ()
end

declare class PlayerHUD extends GuiItem
end

declare class StarterPack extends GuiItem
end

declare class GuiService extends Instance
	BrowserWindowClosed: RBXScriptSignal<>
	EscapeKeyPressed: RBXScriptSignal<>
	IsModalDialog: boolean
	IsWindows: boolean
	KeyPressed: RBXScriptSignal<string, string>
	ShowLegacyPlayerList: boolean
	SpecialKeyPressed: RBXScriptSignal<EnumSpecialKey, string>
	UseLuaChat: boolean
	Version: number
	function AddCenterDialog(self, dialog: Instance, centerDialogType: EnumCenterDialogType, showFunction: ((...any) -> ...any), hideFunction: ((...any) -> ...any)): ()
	function AddKey(self, key: string): ()
	function AddSpecialKey(self, key: EnumSpecialKey): ()
	function GetScreenResolution(self): Vector2
	function OpenBrowserWindow(self, url: string): ()
	function RemoveCenterDialog(self, dialog: Instance): ()
	function RemoveKey(self, key: string): ()
	function SendNotification(self, title: string, text: string, image: string, duration: number, callback: ((...any) -> ...any)): ()
	function SetGlobalGuiInset(self, x1: number, y1: number, x2: number, y2: number): ()
end

declare class GuidRegistryService extends Instance
end

declare class HttpService extends Instance
	HttpEnabled: boolean
	function GetAsync(self, url: string, nocache: boolean?): string
	function JSONDecode(self, input: string): any
	function JSONEncode(self, input: any): string
	function PostAsync(self, url: string, data: string, content_type: EnumHttpContentType?): string
	function UrlEncode(self, input: string): string
end

declare class Humanoid extends Instance
	Climbing: RBXScriptSignal<number>
	CustomStatusAdded: RBXScriptSignal<string>
	CustomStatusRemoved: RBXScriptSignal<string>
	Died: RBXScriptSignal<>
	FallingDown: RBXScriptSignal<boolean>
	FreeFalling: RBXScriptSignal<boolean>
	GettingUp: RBXScriptSignal<boolean>
	Health: number
	HealthChanged: RBXScriptSignal<number>
	Jump: boolean
	Jumping: RBXScriptSignal<boolean>
	LeftLeg: Object
	MaxHealth: number
	NameOcclusion: EnumNameOcclusion
	PlatformStand: boolean
	PlatformStanding: RBXScriptSignal<boolean>
	Ragdoll: RBXScriptSignal<boolean>
	RightLeg: Object
	Running: RBXScriptSignal<number>
	Seated: RBXScriptSignal<boolean>
	Sit: boolean
	StatusAdded: RBXScriptSignal<EnumStatus>
	StatusRemoved: RBXScriptSignal<EnumStatus>
	Strafing: RBXScriptSignal<boolean>
	Swimming: RBXScriptSignal<number>
	TargetPoint: Vector3
	Torso: Object
	WalkSpeed: number
	WalkToPart: BasePart?
	WalkToPoint: Vector3
	function AddCustomStatus(self, status: string): boolean
	function AddStatus(self, status: EnumStatus?): boolean
	function EquipTool(self, tool: Tool): ()
	function GetStatuses(self): { any }
	function HasCustomStatus(self, status: string): boolean
	function HasStatus(self, status: EnumStatus?): boolean
	function LoadAnimation(self, animation: Animation): Instance
	function MoveTo(self, location: Vector3, part: BasePart): ()
	function RemoveCustomStatus(self, status: string): boolean
	function RemoveStatus(self, status: EnumStatus?): boolean
	function SetClickToWalkEnabled(self, enabled: boolean): ()
	function TakeDamage(self, amount: number): ()
	function UnequipTools(self): ()
end

declare class InsertService extends Instance
	function GetBaseSets(self): { any }
	function GetCollection(self, categoryId: number): { any }
	function GetFreeDecals(self, searchText: string, pageNum: number): { any }
	function GetFreeModels(self, searchText: string, pageNum: number): { any }
	function GetUserSets(self, userId: number): { any }
	function Insert(self, instance: Instance): ()
	function LoadAsset(self, assetId: number): Instance
	function LoadAssetVersion(self, assetVersionId: number): Instance
	function SetAdvancedResults(self, enable: boolean, user: boolean?): ()
	function SetAssetUrl(self, assetUrl: string): ()
	function SetAssetVersionUrl(self, assetVersionUrl: string): ()
	function SetBaseCategoryUrl(self, baseSetsUrl: string): ()
	function SetBaseSetsUrl(self, baseSetsUrl: string): ()
	function SetCollectionUrl(self, collectionUrl: string): ()
	function SetFreeDecalUrl(self, freeDecalUrl: string): ()
	function SetFreeModelUrl(self, freeModelUrl: string): ()
	function SetTrustLevel(self, trustLevel: number): ()
	function SetUserCategoryUrl(self, userSetsUrl: string): ()
	function SetUserSetsUrl(self, userSetsUrl: string): ()
end

declare class InstancePacketCache extends Instance
end

declare class IntConstrainedValue extends Instance
	Changed: RBXScriptSignal<number>
	ConstrainedValue: number
	MaxValue: number
	MinValue: number
	Value: number
end

declare class IntValue extends Instance
	Changed: RBXScriptSignal<number>
	Value: number
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

declare class RotateP extends DynamicRotate
end

declare class RotateV extends DynamicRotate
end

declare class Glue extends JointInstance
	F0: Vector3
	F1: Vector3
	F2: Vector3
	F3: Vector3
end

declare class ManualSurfaceJointInstance extends JointInstance
end

declare class ManualGlue extends ManualSurfaceJointInstance
end

declare class ManualWeld extends ManualSurfaceJointInstance
end

declare class Motor extends JointInstance
	CurrentAngle: number
	DesiredAngle: number
	MaxVelocity: number
	function SetDesiredAngle(self, value: number): ()
end

declare class Motor6D extends Motor
end

declare class Rotate extends JointInstance
end

declare class Snap extends JointInstance
end

declare class VelocityMotor extends JointInstance
	CurrentAngle: number
	DesiredAngle: number
	Hole: Object
	MaxVelocity: number
end

declare class Weld extends JointInstance
end

declare class JointsService extends Instance
	function ClearJoinAfterMoveJoints(self): ()
	function CreateJoinAfterMoveJoints(self): ()
	function SetJoinAfterMoveInstance(self, joinInstance: Instance): ()
	function SetJoinAfterMoveTarget(self, joinTarget: Instance): ()
	function ShowPermissibleJoints(self): ()
end

declare class Keyframe extends Instance
	Time: number
	function AddPose(self, pose: Pose): ()
	function GetPoses(self): { Instance }
	function RemovePose(self, pose: Pose): ()
end

declare class KeyframeSequence extends Instance
	Loop: boolean
	Priority: EnumAnimationPriority
	function AddKeyframe(self, keyframe: Keyframe): ()
	function GetKeyframes(self): { Instance }
	function RemoveKeyframe(self, keyframe: Keyframe): ()
end

declare class KeyframeSequenceProvider extends Instance
	function GetAnimations(self, userId: number, page: number?): { [any]: any }
	function GetKeyframeSequence(self, assetId: Content): Instance
	function GetKeyframeSequenceById(self, assetId: number, useCache: boolean): Instance
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

declare class Lighting extends Instance
	Ambient: Color3
	Brightness: number
	ColorShift_Bottom: Color3
	ColorShift_Top: Color3
	FogColor: Color3
	FogEnd: number
	FogStart: number
	GeographicLatitude: number
	GlobalShadows: boolean
	LightingChanged: RBXScriptSignal<boolean>
	OutdoorAmbient: Color3
	Outlines: boolean
	ShadowColor: Color3
	TimeOfDay: string
	function GetMinutesAfterMidnight(self): number
	function GetMoonDirection(self): Vector3
	function GetMoonPhase(self): number
	function GetSunDirection(self): Vector3
	function SetMinutesAfterMidnight(self, minutes: number): ()
end

declare class LocalWorkspace extends Instance
end

declare class LoginService extends Instance
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

declare class LuaWebService extends Instance
end

declare class MarketplaceService extends Instance
	ClientPurchaseSuccess: RBXScriptSignal<string, number, number>
	PromptProductPurchaseFinished: RBXScriptSignal<number, number, boolean>
	PromptProductPurchaseRequested: RBXScriptSignal<Player, number, boolean, EnumCurrencyType>
	PromptPurchaseFinished: RBXScriptSignal<Player, number, boolean>
	PromptPurchaseRequested: RBXScriptSignal<Player, number, boolean, EnumCurrencyType>
	ServerPurchaseVerification: RBXScriptSignal<{ [any]: any }>
	function GetProductInfo(self, assetId: number, infoType: EnumInfoType?): { [any]: any }
	function PlayerOwnsAsset(self, player: Player, assetId: number): boolean
	function PromptProductPurchase(self, player: Player, productId: number, equipIfPurchased: boolean?, currencyType: EnumCurrencyType?): ()
	function PromptPurchase(self, player: Player, assetId: number, equipIfPurchased: boolean?, currencyType: EnumCurrencyType?): ()
	function SetDevProductInfoUrl(self, url: string): ()
	function SetPlayerOwnsAssetUrl(self, url: string): ()
	function SetProductInfoUrl(self, url: string): ()
	function SignalClientPurchaseSuccess(self, ticket: string, playerId: number, productId: number): ()
	function SignalPromptProductPurchaseFinished(self, userId: number, productId: number, success: boolean): ()
	function SignalPromptPurchaseFinished(self, player: Instance, assetId: number, success: boolean): ()
end

declare class Message extends Instance
	Text: string
end

declare class Hint extends Message
end

declare class ModuleScript extends Instance
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
	Target: Object
	TargetFilter: Object
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
	function SetOutgoingKBPSLimit(self, limit: number): ()
end

declare class NetworkClient extends NetworkPeer
	ConnectionAccepted: RBXScriptSignal<string, Instance>
	ConnectionFailed: RBXScriptSignal<string, number, string>
	ConnectionRejected: RBXScriptSignal<string>
	Ticket: string
	function Disconnect(self, blockDuration: number?): ()
	function PlayerConnect(self, userId: number, server: string, serverPort: number, clientPort: number?, threadSleepTime: number?): Instance
end

declare class NetworkServer extends NetworkPeer
	DataBasicFiltered: RBXScriptSignal<Instance, EnumFilterResult, Instance, string>
	DataCustomFiltered: RBXScriptSignal<Instance, EnumFilterResult, Instance, string>
	IncommingConnection: RBXScriptSignal<string, Instance>
	Port: number
	function GetClientCount(self): number
	function Start(self, port: number?, threadSleepTime: number?): ()
	function Stop(self, blockDuration: number?): ()
end

declare class NetworkReplicator extends Instance
	Disconnection: RBXScriptSignal<string, boolean>
	MachineAddress: string
	Port: number
	function CloseConnection(self): ()
	function DisableProcessPackets(self): ()
	function EnableProcessPackets(self): ()
	function GetPlayer(self): Instance
	function GetRakStatsString(self, verbosityLevel: number?): string
	function RequestCharacter(self): ()
	function SendMarker(self): Instance
	function SetPropSyncExpiration(self, seconds: number): ()
end

declare class ServerReplicator extends NetworkReplicator
	TicketProcessed: RBXScriptSignal<number, boolean, number>
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
	IncommingReplicationLag: number
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
	WaitingForCharacterLogRate: number
end

declare class NumberValue extends Instance
	Changed: RBXScriptSignal<number>
	Value: number
end

declare class ObjectValue extends Instance
	Changed: RBXScriptSignal<Instance?>
	Value: Instance?
end

declare class PVInstance extends Instance
end

declare class BasePart extends PVInstance
	Anchored: boolean
	BackParamA: number
	BackParamB: number
	BackSurface: EnumSurfaceType
	BackSurfaceInput: EnumInputType
	BottomParamA: number
	BottomParamB: number
	BottomSurface: EnumSurfaceType
	BottomSurfaceInput: EnumInputType
	BrickColor: BrickColor
	CFrame: CFrame
	CanCollide: boolean
	Elasticity: number
	Friction: number
	FrontParamA: number
	FrontParamB: number
	FrontSurface: EnumSurfaceType
	FrontSurfaceInput: EnumInputType
	LeftParamA: number
	LeftParamB: number
	LeftSurface: EnumSurfaceType
	LeftSurfaceInput: EnumInputType
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
	RightSurfaceInput: EnumInputType
	RotVelocity: Vector3
	Rotation: Vector3
	Size: Vector3
	SpecificGravity: number
	StoppedTouching: RBXScriptSignal<Instance>
	TopParamA: number
	TopParamB: number
	TopSurface: EnumSurfaceType
	TopSurfaceInput: EnumInputType
	TouchEnded: RBXScriptSignal<BasePart>
	Touched: RBXScriptSignal<BasePart>
	Transparency: number
	Velocity: Vector3
	function BreakJoints(self): ()
	function GetConnectedParts(self, recursive: boolean?): { BasePart }
	function GetMass(self): number
	function GetRootPart(self): BasePart
	function IsGrounded(self): boolean
	function MakeJoints(self): ()
	function Resize(self, normalId: EnumNormalId, deltaAmount: number): boolean
end

declare class CornerWedgePart extends BasePart
end

declare class FormFactorPart extends BasePart
	FormFactor: EnumFormFactor
	formFactor: EnumFormFactor
end

declare class Part extends FormFactorPart
	Shape: EnumPartType
end

declare class FlagStand extends Part
	FlagCaptured: RBXScriptSignal<Instance>
	TeamColor: BrickColor
end

declare class Platform extends Part
end

declare class Seat extends Part
	Disabled: boolean
end

declare class SkateboardPlatform extends Part
	Controller: Object
	ControllingHumanoid: Object
	Equipped: RBXScriptSignal<Instance, Instance>
	MoveStateChanged: RBXScriptSignal<EnumMoveState, EnumMoveState>
	Steer: number
	StickyWheels: boolean
	Throttle: number
	Unequipped: RBXScriptSignal<Instance>
	function ApplySpecificImpulse(self, impulseWorld: Vector3): ()
end

declare class SpawnLocation extends Part
	AllowTeamChangeOnTouch: boolean
	Duration: number
	Neutral: boolean
	TeamColor: BrickColor
end

declare class WedgePart extends FormFactorPart
end

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

declare class Terrain extends BasePart
	MaxExtents: Region3int16
	function AutowedgeCell(self, x: number, y: number, z: number): boolean
	function AutowedgeCells(self, region: Region3int16): ()
	function CellCenterToWorld(self, x: number, y: number, z: number): Vector3
	function CellCornerToWorld(self, x: number, y: number, z: number): Vector3
	function Clear(self): ()
	function CopyRegion(self, region: Region3int16): TerrainRegion
	function CountCells(self): number
	function GetCell(self, x: number, y: number, z: number): any
	function GetWaterCell(self, x: number, y: number, z: number): any
	function PasteRegion(self, region: TerrainRegion, corner: Vector3int16, pasteEmptyCells: boolean): ()
	function SetCell(self, x: number, y: number, z: number, material: EnumCellMaterial, block: EnumCellBlock, orientation: EnumCellOrientation): ()
	function SetCells(self, region: Region3int16, material: EnumCellMaterial, block: EnumCellBlock, orientation: EnumCellOrientation): ()
	function SetWaterCell(self, x: number, y: number, z: number, force: EnumWaterForce, direction: EnumWaterDirection): ()
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
	function BreakJoints(self): ()
	function GetModelCFrame(self): CFrame
	function GetModelSize(self): Vector3
	function MakeJoints(self): ()
	function MoveTo(self, location: Vector3): ()
	function ResetOrientationToIdentity(self): ()
	function SetIdentityOrientation(self): ()
	function TranslateBy(self, offset: Vector3): ()
end

declare class RootInstance extends Model
end

declare class Workspace extends RootInstance
	CurrentCamera: Object
	DistributedGameTime: number
	StreamingEnabled: boolean
	Terrain: Terrain
	function BreakJoints(self, objects: { Instance }): ()
	function FindPartOnRay(self, ray: Ray, ignoreDescendentsInstance: Instance?, terrainCellsAreCubes: boolean?): any
	function FindPartOnRayWithIgnoreList(self, ray: Ray, ignoreDescendentsTable: { Instance }, terrainCellsAreCubes: boolean?): any
	function FindPartsInRegion3(self, region: Region3, ignoreDescendentsInstance: Instance?, maxParts: number?): { Instance }
	function FindPartsInRegion3WithIgnoreList(self, region: Region3, ignoreDescendentsTable: { Instance }, maxParts: number?): { Instance }
	function GetNumAwakeParts(self): number
	function GetPhysicsThrottling(self): number
	function GetRealPhysicsFPS(self): number
	function InsertContent(self, url: Content): { Instance }
	function IsRegion3Empty(self, region: Region3, ignoreDescendentsInstance: Instance?): boolean
	function IsRegion3EmptyWithIgnoreList(self, region: Region3, ignoreDescendentsTable: { Instance }): boolean
	function MakeJoints(self, objects: { Instance }): ()
	function SetPhysicsThrottleEnabled(self, value: boolean): ()
	function ZoomToExtents(self): ()
end

declare class Status extends Model
end

declare class PersonalServerService extends Instance
	RoleSets: string
	function Demote(self, player: Instance): ()
	function GetRoleSets(self, placeId: number): string
	function Promote(self, player: Instance): ()
	function SetPersonalServerGetRankUrl(self, personalServerGetRankUrl: string): ()
	function SetPersonalServerRoleSetsUrl(self, personalServerRoleSetsUrl: string): ()
	function SetPersonalServerSetRankUrl(self, personalServerSetRankUrl: string): ()
end

declare class PhysicsPacketCache extends Instance
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
	ParallelPhysics: boolean
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
	DataReady: boolean
	FriendStatusChanged: RBXScriptSignal<Instance, EnumFriendStatus>
	Guest: boolean
	HasBuildTools: boolean
	Idled: RBXScriptSignal<number>
	MaximumSimulationRadius: number
	MembershipType: EnumMembershipType
	Neutral: boolean
	OnTeleport: RBXScriptSignal<EnumTeleportState, number, string>
	PersonalServerRank: number
	SimulationRadius: number
	TeamColor: BrickColor
	function ClearCharacterAppearance(self): ()
	function DistanceFromCharacter(self, point: Vector3): number
	function GetFriendStatus(self, player: Instance): EnumFriendStatus
	function GetFriendsOnline(self, maxFriends: number?): { [any]: any }
	function GetMouse(self): Mouse
	function GetRankInGroup(self, groupId: number): number
	function GetRoleInGroup(self, groupId: number): string
	function GetUnder13(self): boolean
	function GetWebPersonalServerRank(self): string
	function IsBestFriendsWith(self, userId: number): boolean
	function IsFriendsWith(self, userId: number): boolean
	function IsInGroup(self, groupId: number): boolean
	function JumpCharacter(self): ()
	function Kick(self): ()
	function LoadBoolean(self, key: string): boolean
	function LoadCharacter(self, inGame: boolean?): ()
	function LoadCharacterAppearance(self, assetInstance: Instance): ()
	function LoadData(self): ()
	function LoadInstance(self, key: string): Instance
	function LoadNumber(self, key: string): number
	function LoadString(self, key: string): string
	function MoveCharacter(self, walkDirection: Vector2, maxWalkDelta: number): ()
	function RemoveCharacter(self): ()
	function RequestFriendship(self, player: Instance): ()
	function RevokeFriendship(self, player: Instance): ()
	function SaveBoolean(self, key: string, value: boolean): ()
	function SaveData(self): ()
	function SaveInstance(self, key: string, value: Instance): ()
	function SaveLeaderboardData(self): ()
	function SaveNumber(self, key: string, value: number): ()
	function SaveString(self, key: string, value: string): ()
	function SetAccountAge(self, accountAge: number): ()
	function SetMembershipType(self, membershipType: EnumMembershipType): ()
	function SetSuperSafeChat(self, value: boolean): ()
	function WaitForDataReady(self): boolean
	userId: number
end

declare class Players extends Instance
	BubbleChat: boolean
	CharacterAutoLoads: boolean
	ClassicChat: boolean
	FriendRequestEvent: RBXScriptSignal<Instance, Instance, EnumFriendRequestEvent>
	GameAnnounce: RBXScriptSignal<string>
	LocalPlayer: Player
	NumPlayers: number
	PlayerAdded: RBXScriptSignal<Player>
	PlayerAddedEarly: RBXScriptSignal<Instance>
	PlayerChatted: RBXScriptSignal<EnumPlayerChatType, Player, string, Player?>
	PlayerRemoving: RBXScriptSignal<Player>
	PlayerRemovingLate: RBXScriptSignal<Instance>
	function AddLeaderboardKey(self, key: string): ()
	function Chat(self, message: string): ()
	function CreateLocalPlayer(self, userId: number): Instance
	function GetPlayerByID(self, userID: number): Instance
	function GetPlayerFromCharacter(self, character: Model): Player?
	function GetPlayers(self): { Player }
	function ReportAbuse(self, player: Instance, reason: string, optionalMessage: string): ()
	function SetChatStyle(self, style: EnumChatStyle?): ()
	function SetLoadDataUrl(self, url: string): ()
	function SetSaveDataUrl(self, url: string): ()
	function SetSaveLeaderboardDataUrl(self, url: string): ()
	function SetSysStatsUrl(self, url: string): ()
	function SetSysStatsUrlId(self, urlId: string): ()
	function TeamChat(self, message: string): ()
	function WhisperChat(self, message: string, player: Instance): ()
end

declare class Plugin extends Instance
	Deactivation: RBXScriptSignal<>
	function Activate(self, exclusiveMouse: boolean): ()
	function CreateToolbar(self, name: string): Instance
	function GetMouse(self): PluginMouse
	function GetSetting(self, key: string): any
	function GetStudioUserId(self): number
	function SaveSelectedToRoblox(self): ()
	function SetSetting(self, key: string, value: any): ()
end

declare class PluginManager extends Instance
	function CreatePlugin(self): Instance
end

declare class Pose extends Instance
	CFrame: CFrame
	MaskWeight: number
	Weight: number
	function AddSubPose(self, pose: Pose): ()
	function GetSubPoses(self): { Instance }
	function RemoveSubPose(self, pose: Pose): ()
end

declare class RayValue extends Instance
	Changed: RBXScriptSignal<Ray>
	Value: Ray
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

declare class RemoteEvent extends Instance
	OnClientEvent: RBXScriptSignal<...any>
	OnServerEvent: RBXScriptSignal<(Player, ...any)>
	function FireAllClients(self, ...: any): ()
	function FireClient(self, player: Player, ...: any): ()
	function FireServer(self, ...: any): ()
end

declare class RemoteFunction extends Instance
	OnClientInvoke: (...any) -> ...any
	OnServerInvoke: (player: Player, ...any) -> ...any
	function InvokeClient(self, player: Player, ...: any): ...any
	function InvokeServer(self, ...: any): ...any
end

declare class RenderHooksService extends Instance
	function CaptureMetrics(self): ()
	function DisableQueue(self, qId: number): ()
	function EnableAdorns(self, enabled: boolean): ()
	function EnableQueue(self, qId: number): ()
	function GetDeltaAve(self): number
	function GetGPUDelay(self): number
	function GetPresentTime(self): number
	function GetRenderAve(self): number
	function GetRenderConfMax(self): number
	function GetRenderConfMin(self): number
	function GetRenderStd(self): number
	function PrintScene(self): ()
	function ReloadShaders(self): ()
	function ResizeWindow(self, width: number, height: number): ()
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
	graphicsMode: EnumGraphicsMode
end

declare class ReplicatedStorage extends Instance
end

declare class RunService extends Instance
	Heartbeat: RBXScriptSignal<number>
	RenderStepped: RBXScriptSignal<>
	Stepped: RBXScriptSignal<number, number>
	function Pause(self): ()
	function Run(self): ()
	function Stop(self): ()
end

declare class RuntimeScriptService extends Instance
end

declare class ScriptContext extends Instance
	CamelCaseViolation: RBXScriptSignal<Instance, string, Instance>
	GarbageCollectionFrequency: number
	GarbageCollectionLimit: number
	ScriptsDisabled: boolean
	function AddCoreScript(self, assetId: number, parent: Instance, name: string): ()
	function AddStarterScript(self, assetId: number): ()
	function GetHeapStats(self, clearHighwaterMark: boolean?): any
	function GetScriptStats(self): { any }
	function LibraryRegistrationComplete(self): ()
	function RegisterDevelopmentLibrary(self, libraryName: string, scriptInstance: Instance): ()
	function RegisterLibrary(self, libraryName: string, assetId: string): ()
	function RegisterRobloxLibrary(self, libraryName: string, assetId: string): ()
	function SetCollectScriptStats(self, enable: boolean?): ()
	function SetTimeout(self, seconds: number): ()
end

declare class ScriptDebugger extends Instance
	BreakpointAdded: RBXScriptSignal<Instance>
	BreakpointRemoved: RBXScriptSignal<Instance>
	CurrentLine: number
	EncounteredBreak: RBXScriptSignal<number>
	IsDebugging: boolean
	IsPaused: boolean
	Resuming: RBXScriptSignal<>
	Script: Object
	WatchAdded: RBXScriptSignal<Instance>
	WatchRemoved: RBXScriptSignal<Instance>
	function AddWatch(self, expression: string): Instance
	function GetBreakpoints(self): { Instance }
	function GetGlobals(self): { [any]: any }
	function GetLocals(self, stackFrame: number?): { [any]: any }
	function GetStack(self): { any }
	function GetUpvalues(self, stackFrame: number?): { [any]: any }
	function GetWatchValue(self, watch: Instance): any
	function GetWatches(self): { Instance }
	function Resume(self): ()
	function SetBreakpoint(self, line: number): Instance
	function SetGlobal(self, name: string, value: any): ()
	function SetLocal(self, name: string, value: any, stackFrame: number?): ()
	function SetUpvalue(self, name: string, value: any, stackFrame: number?): ()
	function StepIn(self): ()
	function StepOut(self): ()
	function StepOver(self): ()
end

declare class ScriptInformationProvider extends Instance
	function SetAssetUrl(self, url: string): ()
end

declare class ScriptService extends Instance
end

declare class Selection extends Instance
	SelectionChanged: RBXScriptSignal<>
	function Get(self): { Instance }
	function Set(self, selection: { Instance }): ()
end

declare class ServerScriptService extends Instance
end

declare class ServerStorage extends Instance
end

declare class ServiceProvider extends Instance
	Close: RBXScriptSignal<>
	CloseLate: RBXScriptSignal<>
	ServiceAdded: RBXScriptSignal<Instance>
	ServiceRemoving: RBXScriptSignal<Instance>
	function FindService(self, className: string): Instance
	function GetService(self, className: string): Instance
end

declare class DataModel extends ServiceProvider
	AllowedGearTypeChanged: RBXScriptSignal<>
	CreatorId: number
	CreatorType: EnumCreatorType
	GearGenreSetting: EnumGearGenreSetting
	Genre: EnumGenre
	GraphicsQualityChangeRequest: RBXScriptSignal<boolean>
	IsPersonalServer: boolean
	ItemChanged: RBXScriptSignal<Instance, string>
	JobId: string
	Loaded: RBXScriptSignal<>
	LocalSaveEnabled: boolean
	PlaceId: number
	PlaceVersion: number
	RequestShutdown: () -> boolean
	Workspace: Object
	function AddStat(self, displayName: string, stat: string): ()
	function ClearContent(self, resettingSimulation: boolean): ()
	function ClearMessage(self): ()
	function CreatePlace(self, placeName: string, templatePlaceID: number): number
	function FinishShutdown(self, localSave: boolean): ()
	function GetJobIntervalPeakFraction(self, jobname: string, greaterThan: number): number
	function GetJobTimePeakFraction(self, jobname: string, greaterThan: number): number
	function GetJobsExtendedStats(self): { any }
	function GetJobsInfo(self): { any }
	function GetObjects(self, url: Content): { Instance }
	function GetRemoteBuildMode(self): boolean
	function HttpGet(self, url: string, synchronous: boolean?): string
	function HttpGetAsync(self, url: string): string
	function HttpPost(self, url: string, data: string, synchronous: boolean?): string
	function HttpPostAsync(self, url: string, data: string): string
	function IsGearTypeAllowed(self, gearType: EnumGearType): boolean
	function IsLoaded(self): boolean
	function Load(self, url: Content): ()
	function LoadGame(self, assetID: number): ()
	function LoadWorld(self, assetID: number): ()
	function RemoveStat(self, stat: string): ()
	function ReportMeasurement(self, id: string, key1: string, value1: string, key2: string, value2: string): ()
	function SavePlace(self, saveFilter: EnumSaveFilter?): any
	function SaveStats(self): ()
	function SaveToRoblox(self): boolean
	function ServerSave(self): ()
	function SetCreatorId(self, creatorId: number, creatorType: EnumCreatorType): ()
	function SetGearSettings(self, genreRestriction: EnumGearGenreSetting, allowedGenres: number): ()
	function SetGenre(self, genre: EnumGenre): ()
	function SetJobsExtendedStatsWindow(self, seconds: number): ()
	function SetMessage(self, message: string): ()
	function SetMessageBrickCount(self): ()
	function SetPlaceId(self, placeId: number, robloxPlace: boolean?): ()
	function SetPlaceVersion(self, placeId: number): ()
	function SetRemoteBuildMode(self, buildModeEnabled: boolean): ()
	function SetScreenshotInfo(self, info: string): ()
	function SetServerSaveUrl(self, url: string): ()
	function SetVideoInfo(self, info: string): ()
	function Shutdown(self): ()
	function ToggleTools(self): ()
end

declare class App extends DataModel
	Id: number
	function ConnectToGame(self, placeId: number, actionName: string?): ()
	function FollowUser(self, userId: number): ()
	function GetCreations(self, userId: number, page: number?): { [any]: any }
	function SetAppId(self, newId: number): ()
	function UnloadGame(self): ()
end

declare class GenericSettings extends ServiceProvider
end

declare class UserSettings extends GenericSettings
	GameSettings: UserGameSettings
	function GetService(self, service: "UserGameSettings"): UserGameSettings
	function Reset(self): ()
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
	function SetBestFriendUrl(self, bestFriendUrl: string): ()
	function SetFriendUrl(self, friendUrl: string): ()
	function SetGroupRankUrl(self, groupRankUrl: string): ()
	function SetGroupRoleUrl(self, groupRoleUrl: string): ()
	function SetGroupUrl(self, groupUrl: string): ()
	function SetPackageContentsUrl(self, stuffUrl: string): ()
	function SetStuffUrl(self, stuffUrl: string): ()
end

declare class Sound extends Instance
	IsPaused: boolean
	IsPlaying: boolean
	Looped: boolean
	Pitch: number
	PlayOnRemove: boolean
	SoundId: Content
	Volume: number
	function Pause(self): ()
	function Play(self): ()
	function Stop(self): ()
end

declare class StockSound extends Sound
end

declare class SoundService extends Instance
	AmbientReverb: EnumReverbType
	DistanceFactor: number
	DopplerScale: number
	RolloffScale: number
	function PlayStockSound(self, sound: EnumSoundType): ()
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

declare class Stats extends Instance
	MinReportInterval: number
	ReporterType: string
	function Report(self, category: string, data: { [any]: any }): ()
	function ReportJobsStepWindow(self): ()
	function ReportTaskScheduler(self, includeJobs: boolean?): ()
	function SetReportUrl(self, url: string): ()
end

declare class StatsItem extends Instance
	function GetValue(self): number
	function GetValueString(self): string
end

declare class ProfilingItem extends StatsItem
	function GetTimes(self, window: number?): any
	function GetTimesForFrames(self, frames: number?): any
end

declare class RunningAverageItemDouble extends StatsItem
end

declare class RunningAverageItemInt extends StatsItem
end

declare class RunningAverageTimeIntervalItem extends StatsItem
end

declare class TotalCountTimeIntervalItem extends StatsItem
end

declare class StringValue extends Instance
	Changed: RBXScriptSignal<string>
	Value: string
end

declare class StudioTool extends Instance
	Activated: RBXScriptSignal<>
	Deactivated: RBXScriptSignal<>
	Enabled: boolean
	Equipped: RBXScriptSignal<Instance>
	Unequipped: RBXScriptSignal<>
end

declare class TaskScheduler extends Instance
	AreArbitersThrottled: boolean
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
	function AddDummyJob(self, exclusive: boolean?, fps: number?): ()
end

declare class Team extends Instance
	AutoAssignable: boolean
	AutoColorCharacters: boolean
	Score: number
	TeamColor: BrickColor
	function GetPlayers(self): { Player }
end

declare class Teams extends Instance
	function RebalanceTeams(self): ()
end

declare class TeleportService extends Instance
	ConfirmationCallback: (message: string, placeId: number, spawnName: string) -> boolean
	CustomizedTeleportUI: boolean
	ErrorCallback: (message: string) -> ()
	function Teleport(self, placeId: number, player: Player?): ()
	function TeleportCancel(self): ()
	function TeleportImpl(self, placeId: number, spawnName: string): ()
	function TeleportToSpawnByName(self, placeId: number, spawnName: string, player: Player?): ()
end

declare class TerrainRegion extends Instance
	SizeInCells: Vector3
end

declare class TestService extends Instance
	AutoRuns: boolean
	Description: string
	ErrorCount: number
	Is30FpsThrottleEnabled: boolean
	IsPhysicsEnvironmentalThrottled: boolean
	IsSleepAllowed: boolean
	NumberOfPlayers: number
	ServerCollectConditionalResult: RBXScriptSignal<boolean, string, Instance, number>
	ServerCollectResult: RBXScriptSignal<string, Instance, number>
	TestCount: number
	Timeout: number
	WarnCount: number
	function Check(self, condition: boolean, description: string, source: Instance?, line: number?): ()
	function Checkpoint(self, text: string, source: Instance?, line: number?): ()
	function DoCommand(self, name: string): ()
	function Done(self): ()
	function Error(self, description: string, source: Instance?, line: number?): ()
	function Fail(self, description: string, source: Instance?, line: number?): ()
	function GetCommandNames(self): { any }
	function IsCommandChecked(self, name: string): boolean
	function IsCommandEnabled(self, name: string): boolean
	function Message(self, text: string, source: Instance?, line: number?): ()
	function Require(self, condition: boolean, description: string, source: Instance?, line: number?): ()
	function Run(self): ()
	function Warn(self, condition: boolean, description: string, source: Instance?, line: number?): ()
end

declare class TextService extends Instance
end

declare class TimerService extends Instance
end

declare class Toolbar extends Instance
	function CreateButton(self, text: string, tooltip: string, iconname: string): Instance
end

declare class TouchTransmitter extends Instance
end

declare class TweenService extends Instance
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
	function SetTutorialState(self, tutorialId: string, value: boolean): ()
end

declare class UserInputService extends Instance
	GamepadEnabled: boolean
	InputBegan: RBXScriptSignal<Instance>
	InputChanged: RBXScriptSignal<Instance>
	InputEnded: RBXScriptSignal<Instance>
	JumpRequest: RBXScriptSignal<>
	KeyboardEnabled: boolean
	ModalEnabled: boolean
	MouseEnabled: boolean
	TouchEnabled: boolean
	TouchEnded: RBXScriptSignal<Instance>
	TouchLongPress: RBXScriptSignal<{ Vector2 }, EnumUserInputState>
	TouchMoved: RBXScriptSignal<Instance>
	TouchPan: RBXScriptSignal<{ Vector2 }, Vector2, Vector2, EnumUserInputState>
	TouchPinch: RBXScriptSignal<{ Vector2 }, number, number, EnumUserInputState>
	TouchRotate: RBXScriptSignal<{ Vector2 }, number, number, EnumUserInputState>
	TouchStarted: RBXScriptSignal<Instance>
	TouchSwipe: RBXScriptSignal<EnumSwipeDirection, number>
	TouchTap: RBXScriptSignal<{ Vector2 }>
	function IsLuaTouchControls(self): boolean
	function RotateCamera(self, positionDelta: Vector2): ()
	function ZoomCamera(self, zoomDelta: number): ()
end

declare class Vector3Value extends Instance
	Changed: RBXScriptSignal<Vector3>
	Value: Vector3
end

declare class VirtualUser extends Instance
	function Button1Down(self, position: Vector2, camera: CFrame?): ()
	function Button1Up(self, position: Vector2, camera: CFrame?): ()
	function Button2Down(self, position: Vector2, camera: CFrame?): ()
	function Button2Up(self, position: Vector2, camera: CFrame?): ()
	function CaptureController(self): ()
	function ClickButton1(self, position: Vector2, camera: CFrame?): ()
	function ClickButton2(self, position: Vector2, camera: CFrame?): ()
	function MoveMouse(self, position: Vector2, camera: CFrame?): ()
	function SetKeyDown(self, key: string): ()
	function SetKeyUp(self, key: string): ()
	function StartRecording(self): ()
	function StopRecording(self): string
	function TypeKey(self, key: string): ()
end

declare class Visit extends Instance
	function SetPing(self, pingUrl: string, interval: number): ()
	function SetUploadUrl(self, url: string): ()
end

declare Instance: {
	new: ((className: string) -> Instance),
	Lock: ((instance: Instance, instance2: Instance?) -> boolean),
	Unlock: ((instance: Instance) -> ()),
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
	random: (() -> BrickColor),
	Green: (() -> BrickColor),
	Black: (() -> BrickColor),
	palette: ((paletteValue: number) -> BrickColor),
	new: ((val: number) -> BrickColor) & ((r: number, g: number, b: number) -> BrickColor) & ((color: Color3) -> BrickColor) & ((name: "Alder" | "Artichoke" | "Baby blue" | "Beige" | "Black" | "Black metallic" | "Br. reddish orange" | "Br. yellowish green" | "Br. yellowish orange" | "Brick yellow" | "Bright blue" | "Bright bluish green" | "Bright bluish violet" | "Bright green" | "Bright orange" | "Bright purple" | "Bright red" | "Bright reddish lilac" | "Bright reddish violet" | "Bright violet" | "Bright yellow" | "Bronze" | "Brown" | "Burgundy" | "Burlap" | "Burnt Sienna" | "Buttermilk" | "CGA brown" | "Cadet blue" | "Camo" | "Carnation pink" | "Cashmere" | "Cloudy grey" | "Cocoa" | "Cool yellow" | "Copper" | "Cork" | "Crimson" | "Curry" | "Cyan" | "Daisy orange" | "Dark Curry" | "Dark Royal blue" | "Dark blue" | "Dark green" | "Dark grey" | "Dark grey metallic" | "Dark indigo" | "Dark nougat" | "Dark orange" | "Dark red" | "Dark stone grey" | "Dark taupe" | "Deep blue" | "Deep orange" | "Dirt brown" | "Dove blue" | "Dusty Rose" | "Earth blue" | "Earth green" | "Earth orange" | "Earth yellow" | "Eggplant" | "Electric blue" | "Faded green" | "Fawn brown" | "Fire Yellow" | "Flame reddish orange" | "Flame yellowish orange" | "Flint" | "Fog" | "Forest green" | "Fossil" | "Ghost grey" | "Gold" | "Grey" | "Grime" | "Gun metallic" | "Hot pink" | "Hurricane grey" | "Institutional white" | "Khaki" | "Lapis" | "Laurel green" | "Lavender" | "Lemon metalic" | "Lig. Yellowich orange" | "Lig. yellowish green" | "Light Royal blue" | "Light blue" | "Light bluish green" | "Light bluish violet" | "Light brick yellow" | "Light green (Mint)" | "Light grey" | "Light grey metallic" | "Light lilac" | "Light orange" | "Light orange brown" | "Light pink" | "Light purple" | "Light red" | "Light reddish violet" | "Light stone grey" | "Light yellow" | "Lilac" | "Lily white" | "Lime green" | "Linen" | "Magenta" | "Maroon" | "Mauve" | "Med. bluish green" | "Med. reddish violet" | "Med. yellowish green" | "Med. yellowish orange" | "Medium Royal blue" | "Medium blue" | "Medium bluish violet" | "Medium green" | "Medium lilac" | "Medium orange" | "Medium red" | "Medium stone grey" | "Mid gray" | "Mint" | "Moss" | "Mulberry" | "Navy blue" | "Neon green" | "Neon orange" | "New Yeller" | "Nougat" | "Olive" | "Olivine" | "Oyster" | "Parsley green" | "Pastel Blue" | "Pastel blue-green" | "Pastel brown" | "Pastel green" | "Pastel light blue" | "Pastel orange" | "Pastel violet" | "Pastel yellow" | "Pearl" | "Persimmon" | "Phosph. White" | "Pine Cone" | "Pink" | "Plum" | "Quill grey" | "Really black" | "Really blue" | "Really red" | "Red flip/flop" | "Reddish brown" | "Reddish lilac" | "Royal blue" | "Royal purple" | "Rust" | "Sage green" | "Salmon" | "Sand blue" | "Sand blue metallic" | "Sand green" | "Sand red" | "Sand violet" | "Sand violet metallic" | "Sand yellow" | "Sand yellow metallic" | "Sea green" | "Seashell" | "Shamrock" | "Silver" | "Silver flip/flop" | "Slime green" | "Smoky grey" | "Steel blue" | "Storm blue" | "Sunrise" | "Tawny" | "Teal" | "Terra Cotta" | "Toothpaste" | "Tr. Blue" | "Tr. Bright bluish violet" | "Tr. Brown" | "Tr. Flu. Blue" | "Tr. Flu. Green" | "Tr. Flu. Red" | "Tr. Flu. Reddish orange" | "Tr. Flu. Yellow" | "Tr. Green" | "Tr. Lg blue" | "Tr. Medi. reddish violet" | "Tr. Red" | "Tr. Yellow" | "Transparent" | "Turquoise" | "Warm yellowish orange" | "Wheat" | "White" | "Yellow flip/flop") -> BrickColor),
}

declare Vector2: {
	new: ((x: number?, y: number?) -> Vector2),
}

declare Vector2int16: {
	new: ((x: number?, y: number?) -> Vector2int16),
}

declare Color3: {
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
	new: ((x: UDim, y: UDim) -> UDim2) & ((xScale: number?, xOffset: number?, yScale: number?, yOffset: number?) -> UDim2),
}

declare CFrame: {
	Angles: ((rx: number, ry: number, rz: number) -> CFrame),
	fromAxisAngle: ((v: Vector3, r: number) -> CFrame),
	fromEulerAnglesXYZ: ((rx: number, ry: number, rz: number) -> CFrame),
	new: (() -> CFrame) & ((pos: Vector3) -> CFrame) & ((pos: Vector3, lookAt: Vector3) -> CFrame) & ((x: number, y: number, z: number) -> CFrame) & ((x: number, y: number, z: number, qX: number, qY: number, qZ: number, qW: number) -> CFrame) & ((x: number, y: number, z: number, R00: number, R01: number, R02: number, R10: number, R11: number, R12: number, R20: number, R21: number, R22: number) -> CFrame),
}

declare Faces: {
	new: ((normalIds: any) -> Faces),
}

declare Vector3: {
	FromNormalId: ((normal: EnumNormalId) -> Vector3),
	FromAxis: ((axis: EnumAxis) -> Vector3),
	new: ((x: number?, y: number?, z: number?) -> Vector3),
}

declare Vector3int16: {
	new: ((x: number?, y: number?, z: number?) -> Vector3int16),
}


type Studio = any -- This class is a mess
-- It doesn't exist in the API dump since it must have been redefined in 349 (2018/08/07) (which should never happen)
-- Since Mercury uses several FFlags, the types defined under it use nonexistent enums as well

declare class GlobalSettings extends GenericSettings
    Lua: LuaSettings
	["Game Options"]: GameSettings
	["Task Scheduler"]: TaskScheduler
    Studio: Studio
    Network: NetworkSettings
    Physics: PhysicsSettings
    Rendering: RenderSettings
    Diagnostics: DebugSettings
    function GetFFlag(self, name: string): boolean
    function GetFVariable(self, name: string): string
    function GetFVariables(self, name: string): { [any]: any } -- of course I can't test this, because "An error occured"
end

declare class ThumbnailGenerator extends Instance -- Tap in rcc before carrot gets it
	function Click(self, format: "PNG" | "OBJ", x: number, y: number, hideSky: boolean, crop: boolean?): string
end -- "Stop looking back, what God has for you, you have not seen before and it's not back there!! #NewCreature #GetOutofYourOwnWay #RCCService" - Josh Brown @JoshLB, sometime in 2016

declare game: DataModel
declare workspace: Workspace
declare plugin: Plugin
declare script: BaseScript
declare function loadfile(file: string): any
declare function dofile(file: string): any
declare function settings(): GlobalSettings
declare function UserSettings(): UserSettings
declare function PluginManager(): PluginManager
declare function ypcall(f: (() -> any) | (() -> ()) | ((...any) -> (), (...any) -> ()) -> (), ...: any): (boolean, any)

declare _PLACE_ID: number
declare _IS_STUDIO_JOIN: string
declare _SERVER_ADDRESS: any
declare _SERVER_PORT: string
declare _CREATOR_ID: number
declare _USER_ID: number
declare _USER_NAME: any
declare _MEMBERSHIP_TYPE: any

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

-- library types

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

-- lel
export type FakeTweenInfo = {
	Time: number,
	EasingStyle: EnumEasingStyle | string,
	EasingDirection: EnumEasingDirection | string,
	RepeatCount: number,
	Reverses: boolean,
	DelayTime: number,
}

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

	Tween: <T>(goalState: StateObject<T>, tweenInfo: FakeTweenInfo?) -> Tween<T>, -- fix dis sometime
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
	| "Animation"
	| "AnimationController"
	| "Animator"
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
	| "Configuration"
	| "HumanoidController"
	| "SkateboardController"
	| "VehicleController"
	| "CustomEvent"
	| "CustomEventReceiver"
	| "CylinderMesh"
	| "FileMesh"
	| "SpecialMesh"
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
