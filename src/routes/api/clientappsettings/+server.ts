import type { RequestHandler } from "./$types"
import { json } from "@sveltejs/kit"

export const GET: RequestHandler = async () => {
	return json({
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
		FFlagSSAOEnable: "True"
	})
}
