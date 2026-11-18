import type { RenderType } from "./requestRender.ts"

/**
 * Builds a `waitForChange` matcher for the file a render writes. Clothing, model and the other asset renders write the bare asset id to `data/thumbnails`, while avatars write `<id>-head.png` and `<id>-body.png` to `data/avatars`. Matching has to be exact, or an id that is a prefix of another (such as user 12 and user 123) would match the wrong render's file.
 */
export function renderFileMatcher(
	renderType: RenderType,
	relativeId: string | number
): (filename: string | null) => boolean {
	const id = relativeId.toString()
	if (renderType === "Avatar")
		return filename =>
			filename === `${id}-head.png` || filename === `${id}-body.png`
	return filename => filename === id
}
