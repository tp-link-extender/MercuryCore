-- You know what this is guyz
-- HELIODEX'S (not so anymore now) BASIC NEW FUNCTION

type Return<T> = (props: { [string]: any }) -> T

type New =
	((className: never) -> never) -- induces a never type, not good enough but whatever
	& ((className: "Accoutrement") -> Return<Accoutrement>)
	& ((className: "Hat") -> Return<Hat>)
	& ((className: "AdvancedDragger") -> Return<AdvancedDragger>)
	& ((className: "Animation") -> Return<Animation>)
	& ((className: "CurveAnimation") -> Return<CurveAnimation>)
	& ((className: "KeyframeSequence") -> Return<KeyframeSequence>)
	& ((className: "AnimationController") -> Return<AnimationController>)
	& ((className: "AnimationRigData") -> Return<AnimationRigData>)
	& ((className: "Animator") -> Return<Animator>)
	& ((className: "AudioDeviceInput") -> Return<AudioDeviceInput>)
	& ((className: "AudioDeviceOutput") -> Return<AudioDeviceOutput>)
	& ((className: "AudioDistortion") -> Return<AudioDistortion>)
	& ((className: "AudioEcho") -> Return<AudioEcho>)
	& ((className: "AudioEmitter") -> Return<AudioEmitter>)
	& ((className: "AudioEqualizer") -> Return<AudioEqualizer>)
	& ((className: "AudioFader") -> Return<AudioFader>)
	& ((className: "AudioFlanger") -> Return<AudioFlanger>)
	& ((className: "AudioListener") -> Return<AudioListener>)
	& ((className: "AudioPitchShifter") -> Return<AudioPitchShifter>)
	& ((className: "AudioPlayer") -> Return<AudioPlayer>)
	& ((className: "AudioReverb") -> Return<AudioReverb>)
	& ((className: "AudioSearchParams") -> Return<AudioSearchParams>)
	& ((className: "Backpack") -> Return<Backpack>)
	& ((className: "BindableEvent") -> Return<BindableEvent>)
	& ((className: "BindableFunction") -> Return<BindableFunction>)
	& ((className: "BodyAngularVelocity") -> Return<BodyAngularVelocity>)
	& ((className: "BodyForce") -> Return<BodyForce>)
	& ((className: "BodyGyro") -> Return<BodyGyro>)
	& ((className: "BodyPosition") -> Return<BodyPosition>)
	& ((className: "BodyThrust") -> Return<BodyThrust>)
	& ((className: "BodyVelocity") -> Return<BodyVelocity>)
	& ((className: "RocketPropulsion") -> Return<RocketPropulsion>)
	& ((
		className: "BubbleChatMessageProperties"
	) -> Return<BubbleChatMessageProperties>)
	& ((className: "Camera") -> Return<Camera>)
	& ((className: "BodyColors") -> Return<BodyColors>)
	& ((className: "CharacterMesh") -> Return<CharacterMesh>)
	& ((className: "Pants") -> Return<Pants>)
	& ((className: "Shirt") -> Return<Shirt>)
	& ((className: "ShirtGraphic") -> Return<ShirtGraphic>)
	& ((className: "Skin") -> Return<Skin>)
	& ((className: "ClickDetector") -> Return<ClickDetector>)
	& ((className: "DragDetector") -> Return<DragDetector>)
	& ((className: "Configuration") -> Return<Configuration>)
	& ((className: "AngularVelocity") -> Return<AngularVelocity>)
	& ((className: "AnimationConstraint") -> Return<AnimationConstraint>)
	& ((className: "BallSocketConstraint") -> Return<BallSocketConstraint>)
	& ((className: "HingeConstraint") -> Return<HingeConstraint>)
	& ((className: "LineForce") -> Return<LineForce>)
	& ((className: "LinearVelocity") -> Return<LinearVelocity>)
	& ((className: "PlaneConstraint") -> Return<PlaneConstraint>)
	& ((className: "Plane") -> Return<Plane>)
	& ((className: "RigidConstraint") -> Return<RigidConstraint>)
	& ((className: "RodConstraint") -> Return<RodConstraint>)
	& ((className: "RopeConstraint") -> Return<RopeConstraint>)
	& ((className: "CylindricalConstraint") -> Return<CylindricalConstraint>)
	& ((className: "PrismaticConstraint") -> Return<PrismaticConstraint>)
	& ((className: "SpringConstraint") -> Return<SpringConstraint>)
	& ((className: "Torque") -> Return<Torque>)
	& ((
		className: "TorsionSpringConstraint"
	) -> Return<TorsionSpringConstraint>)
	& ((className: "UniversalConstraint") -> Return<UniversalConstraint>)
	& ((className: "HumanoidController") -> Return<HumanoidController>)
	& ((className: "SkateboardController") -> Return<SkateboardController>)
	& ((className: "VehicleController") -> Return<VehicleController>)
	& ((className: "AirController") -> Return<AirController>)
	& ((className: "ClimbController") -> Return<ClimbController>)
	& ((className: "GroundController") -> Return<GroundController>)
	& ((className: "SwimController") -> Return<SwimController>)
	& ((className: "ControllerManager") -> Return<ControllerManager>)
	& ((className: "CustomEvent") -> Return<CustomEvent>)
	& ((className: "CustomEventReceiver") -> Return<CustomEventReceiver>)
	& ((className: "CylinderMesh") -> Return<CylinderMesh>)
	& ((className: "DynamicMesh") -> Return<DynamicMesh>)
	& ((className: "FileMesh") -> Return<FileMesh>)
	& ((className: "SpecialMesh") -> Return<SpecialMesh>)
	& ((
		className: "DataStoreIncrementOptions"
	) -> Return<DataStoreIncrementOptions>)
	& ((className: "DataStoreOptions") -> Return<DataStoreOptions>)
	& ((className: "DataStoreSetOptions") -> Return<DataStoreSetOptions>)
	& ((className: "DebuggerWatch") -> Return<DebuggerWatch>)
	& ((className: "Dialog") -> Return<Dialog>)
	& ((className: "DialogChoice") -> Return<DialogChoice>)
	& ((className: "Dragger") -> Return<Dragger>)
	& ((
		className: "ExperienceInviteOptions"
	) -> Return<ExperienceInviteOptions>)
	& ((className: "Explosion") -> Return<Explosion>)
	& ((className: "Decal") -> Return<Decal>)
	& ((className: "Texture") -> Return<Texture>)
	& ((className: "Hole") -> Return<Hole>)
	& ((className: "MotorFeature") -> Return<MotorFeature>)
	& ((className: "Fire") -> Return<Fire>)
	& ((className: "CSGDictionaryService") -> Return<CSGDictionaryService>)
	& ((
		className: "NonReplicatedCSGDictionaryService"
	) -> Return<NonReplicatedCSGDictionaryService>)
	& ((className: "ForceField") -> Return<ForceField>)
	& ((className: "FunctionalTest") -> Return<FunctionalTest>)
	& ((className: "GetTextBoundsParams") -> Return<GetTextBoundsParams>)
	& ((className: "Frame") -> Return<Frame>)
	& ((className: "ImageButton") -> Return<ImageButton>)
	& ((className: "TextButton") -> Return<TextButton>)
	& ((className: "ImageLabel") -> Return<ImageLabel>)
	& ((className: "TextLabel") -> Return<TextLabel>)
	& ((className: "TextBox") -> Return<TextBox>)
	& ((className: "VideoFrame") -> Return<VideoFrame>)
	& ((className: "ViewportFrame") -> Return<ViewportFrame>)
	& ((className: "BillboardGui") -> Return<BillboardGui>)
	& ((className: "ScreenGui") -> Return<ScreenGui>)
	& ((className: "GuiMain") -> Return<GuiMain>)
	& ((className: "AdGui") -> Return<AdGui>)
	& ((className: "SurfaceGui") -> Return<SurfaceGui>)
	& ((className: "FloorWire") -> Return<FloorWire>)
	& ((className: "SelectionBox") -> Return<SelectionBox>)
	& ((className: "BoxHandleAdornment") -> Return<BoxHandleAdornment>)
	& ((className: "ConeHandleAdornment") -> Return<ConeHandleAdornment>)
	& ((
		className: "CylinderHandleAdornment"
	) -> Return<CylinderHandleAdornment>)
	& ((className: "ImageHandleAdornment") -> Return<ImageHandleAdornment>)
	& ((className: "LineHandleAdornment") -> Return<LineHandleAdornment>)
	& ((className: "SphereHandleAdornment") -> Return<SphereHandleAdornment>)
	& ((
		className: "WireframeHandleAdornment"
	) -> Return<WireframeHandleAdornment>)
	& ((className: "ParabolaAdornment") -> Return<ParabolaAdornment>)
	& ((className: "SelectionSphere") -> Return<SelectionSphere>)
	& ((className: "ArcHandles") -> Return<ArcHandles>)
	& ((className: "Handles") -> Return<Handles>)
	& ((className: "SurfaceSelection") -> Return<SurfaceSelection>)
	& ((className: "SelectionPartLasso") -> Return<SelectionPartLasso>)
	& ((className: "SelectionPointLasso") -> Return<SelectionPointLasso>)
	& ((
		className: "HeightmapImporterService"
	) -> Return<HeightmapImporterService>)
	& ((
		className: "HiddenSurfaceRemovalAsset"
	) -> Return<HiddenSurfaceRemovalAsset>)
	& ((className: "Humanoid") -> Return<Humanoid>)
	& ((className: "RotateP") -> Return<RotateP>)
	& ((className: "RotateV") -> Return<RotateV>)
	& ((className: "Glue") -> Return<Glue>)
	& ((className: "ManualGlue") -> Return<ManualGlue>)
	& ((className: "ManualWeld") -> Return<ManualWeld>)
	& ((className: "Motor") -> Return<Motor>)
	& ((className: "Motor6D") -> Return<Motor6D>)
	& ((className: "Rotate") -> Return<Rotate>)
	& ((className: "Snap") -> Return<Snap>)
	& ((className: "VelocityMotor") -> Return<VelocityMotor>)
	& ((className: "Weld") -> Return<Weld>)
	& ((className: "Keyframe") -> Return<Keyframe>)
	& ((className: "KeyframeMarker") -> Return<KeyframeMarker>)
	& ((className: "PointLight") -> Return<PointLight>)
	& ((className: "SpotLight") -> Return<SpotLight>)
	& ((className: "SurfaceLight") -> Return<SurfaceLight>)
	& ((className: "Script") -> Return<Script>)
	& ((className: "LocalScript") -> Return<LocalScript>)
	& ((className: "ModuleScript") -> Return<ModuleScript>)
	& ((className: "MarkerCurve") -> Return<MarkerCurve>)
	& ((className: "MemoryStoreService") -> Return<MemoryStoreService>)
	& ((className: "Message") -> Return<Message>)
	& ((className: "Hint") -> Return<Hint>)
	& ((className: "CornerWedgePart") -> Return<CornerWedgePart>)
	& ((className: "Part") -> Return<Part>)
	& ((className: "FlagStand") -> Return<FlagStand>)
	& ((className: "Seat") -> Return<Seat>)
	& ((className: "SkateboardPlatform") -> Return<SkateboardPlatform>)
	& ((className: "SpawnLocation") -> Return<SpawnLocation>)
	& ((className: "WedgePart") -> Return<WedgePart>)
	& ((className: "PartOperation") -> Return<PartOperation>)
	& ((className: "IntersectOperation") -> Return<IntersectOperation>)
	& ((className: "NegateOperation") -> Return<NegateOperation>)
	& ((className: "UnionOperation") -> Return<UnionOperation>)
	& ((className: "TrussPart") -> Return<TrussPart>)
	& ((className: "VehicleSeat") -> Return<VehicleSeat>)
	& ((className: "Model") -> Return<Model>)
	& ((className: "HopperBin") -> Return<HopperBin>)
	& ((className: "Tool") -> Return<Tool>)
	& ((className: "Flag") -> Return<Flag>)
	& ((className: "WorldModel") -> Return<WorldModel>)
	& ((className: "PartOperationAsset") -> Return<PartOperationAsset>)
	& ((className: "PathfindingLink") -> Return<PathfindingLink>)
	& ((className: "PathfindingModifier") -> Return<PathfindingModifier>)
	& ((className: "Player") -> Return<Player>)
	& ((className: "PluginAction") -> Return<PluginAction>)
	& ((className: "PluginCapabilities") -> Return<PluginCapabilities>)
	& ((className: "NumberPose") -> Return<NumberPose>)
	& ((className: "Pose") -> Return<Pose>)
	& ((className: "ReflectionMetadata") -> Return<ReflectionMetadata>)
	& ((
		className: "ReflectionMetadataCallbacks"
	) -> Return<ReflectionMetadataCallbacks>)
	& ((
		className: "ReflectionMetadataClasses"
	) -> Return<ReflectionMetadataClasses>)
	& ((
		className: "ReflectionMetadataEnums"
	) -> Return<ReflectionMetadataEnums>)
	& ((
		className: "ReflectionMetadataEvents"
	) -> Return<ReflectionMetadataEvents>)
	& ((
		className: "ReflectionMetadataFunctions"
	) -> Return<ReflectionMetadataFunctions>)
	& ((
		className: "ReflectionMetadataClass"
	) -> Return<ReflectionMetadataClass>)
	& ((className: "ReflectionMetadataEnum") -> Return<ReflectionMetadataEnum>)
	& ((
		className: "ReflectionMetadataEnumItem"
	) -> Return<ReflectionMetadataEnumItem>)
	& ((
		className: "ReflectionMetadataMember"
	) -> Return<ReflectionMetadataMember>)
	& ((
		className: "ReflectionMetadataProperties"
	) -> Return<ReflectionMetadataProperties>)
	& ((
		className: "ReflectionMetadataYieldFunctions"
	) -> Return<ReflectionMetadataYieldFunctions>)
	& ((className: "RemoteEvent") -> Return<RemoteEvent>)
	& ((className: "RemoteFunction") -> Return<RemoteFunction>)
	& ((className: "RenderingTest") -> Return<RenderingTest>)
	& ((className: "BuoyancySensor") -> Return<BuoyancySensor>)
	& ((className: "ControllerPartSensor") -> Return<ControllerPartSensor>)
	& ((className: "Sky") -> Return<Sky>)
	& ((className: "Smoke") -> Return<Smoke>)
	& ((className: "Sound") -> Return<Sound>)
	& ((className: "Sparkles") -> Return<Sparkles>)
	& ((
		className: "StandalonePluginScripts"
	) -> Return<StandalonePluginScripts>)
	& ((className: "StarterGear") -> Return<StarterGear>)
	& ((className: "StudioCallout") -> Return<StudioCallout>)
	& ((className: "StudioObjectBase") -> Return<StudioObjectBase>)
	& ((className: "StudioWidget") -> Return<StudioWidget>)
	& ((className: "StyleDerive") -> Return<StyleDerive>)
	& ((className: "StyleLink") -> Return<StyleLink>)
	& ((className: "SurfaceAppearance") -> Return<SurfaceAppearance>)
	& ((className: "Team") -> Return<Team>)
	& ((className: "TeleportOptions") -> Return<TeleportOptions>)
	& ((className: "TerrainDetail") -> Return<TerrainDetail>)
	& ((className: "TerrainRegion") -> Return<TerrainRegion>)
	& ((className: "TestService") -> Return<TestService>)
	& ((className: "TextChannel") -> Return<TextChannel>)
	& ((className: "TextChatCommand") -> Return<TextChatCommand>)
	& ((
		className: "TextChatMessageProperties"
	) -> Return<TextChatMessageProperties>)
	& ((className: "TrackerStreamAnimation") -> Return<TrackerStreamAnimation>)
	& ((className: "BinaryStringValue") -> Return<BinaryStringValue>)
	& ((className: "BoolValue") -> Return<BoolValue>)
	& ((className: "BrickColorValue") -> Return<BrickColorValue>)
	& ((className: "CFrameValue") -> Return<CFrameValue>)
	& ((className: "Color3Value") -> Return<Color3Value>)
	& ((className: "DoubleConstrainedValue") -> Return<DoubleConstrainedValue>)
	& ((className: "IntConstrainedValue") -> Return<IntConstrainedValue>)
	& ((className: "IntValue") -> Return<IntValue>)
	& ((className: "NumberValue") -> Return<NumberValue>)
	& ((className: "ObjectValue") -> Return<ObjectValue>)
	& ((className: "RayValue") -> Return<RayValue>)
	& ((className: "StringValue") -> Return<StringValue>)
	& ((className: "Vector3Value") -> Return<Vector3Value>)
	& ((className: "Wire") -> Return<Wire>)

local function propsApplier(obj)
	return function(props: { [string]: any })
		local parent

		for k, v in pairs(props) do
			if type(k) == "string" then
				if k == "Parent" then
					parent = v
				else
					obj[k] = v
				end
			elseif type(k) == "number" and type(v) == "userdata" then
				v.Parent = obj
			end
		end

		obj.Parent = parent

		return obj
	end
end

local New = function(className)
	return propsApplier(Instance.new(className))
end :: New

local Hydrate = function(target)
	return propsApplier(target)
end :: <T>(T) -> (props: { [string]: any }) -> T

return { New = New, Hydrate = Hydrate }
