import type { RequestHandler } from "./$types"
import { json } from "@sveltejs/kit"

export const GET: RequestHandler = async () => {
	return json({
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
		FFlagStudioShowToolboxByDefault: "False"
	})
}
