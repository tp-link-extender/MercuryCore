import { json } from "@sveltejs/kit"

export const GET = () =>
	json({
		DFFlagUseKeyframeHumanoidAnimations: "True",
		FFlagUseKeyframeHumanoidAnimations: "True",
		FFlagRenderNewMaterials: "True",
		FFlagRenderAnisotropy: "True",
		FFlagEnableNPCServerAnimation: "True",
		FFlagFireStoppedAnimSignal: "True",
		FFlagPhysics60HZ: "True",
		FFlagFRMUse60FPSLockstepTable: "True",
		FFlagFRMAdjustForMultiCore: "True",
		FFlagFRMRecomputeDistanceFrameDelay: "True",
		DFFlagHeartBeatCanRunTwiceFor30Hz: "True",
		FFlagFixFirstPersonToolLag: "True",
		FFlagUseNewCameraZoomPath: "True",
		FFlagUseNewCameraOcclusionZoom: "True",
		FFlagRenderSoftParticles: "True",
		FFlagRenderClearLightGridOnBind: "True",
		FFlagRenderFastClusterMergeBuffers: "True",
		FFlagRenderLightGridEnabled: "True",
		FFlagRenderLightGridSIMD: "True",
		FFlagRenderLightGridShadowsSmooth: "True",
		FFlagSSAOEnable: "True",

		FFlagUserHttpAPIVisible: "True",
		FFlagModuleScriptsVisible: "True",
		FFlagSurfaceGuiVisible: "True",
		FFlagCreateServerScriptServiceInStudio: "True",
		FFlagCreateServerStorageInStudio: "True",
		FFlagCreateReplicatedStorageInStudio: "True",

		FFlagStudioInitializeViewOnPaint: "True",
		FFlagStudioZoomExtentsExplorerFixEnabled: "True",
		FFlagStudioPropertiesRespectCollisionToggle: "True",
		FFlagStudioScriptBlockAutocomplete: "True",
		FFlagStudioRightClickFixesEnabled: "True",

		FFlagQtFindInExplorer: "True",
		FFlagQtRightClickContextMenu: "True",
		FFlagQtTooltipObjectDescriptions: "True",

		FFlagRibbonBarEnabled: "True",
		FFlagAllowBrowsableAppearInExplorer: "True",
		FFlagBetterGuiObjectInsertDefaults: "True",

		FFlagTrimExtraSlashesAfterRobloxDomain: "False",
		FFlagStudioIntellesenseEnabled: "False",
		FFlagStudioShowToolboxByDefault: "False",
	})
