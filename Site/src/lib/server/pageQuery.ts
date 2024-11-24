import { redirect } from "@sveltejs/kit"

/**
 * Helper function to parse the page number from a URL object.
 * @param url The URL object to parse thepage from
 * @returns An object containing the page, as well as a function to check if the current page exceeds the total number of pages.
 * @example
 * const { page, checkPages } = pageQuery(url)
 * const [things, pages] = await db.query<[Thing[], number]>(thingQuery, qp)
 * checkPages(pages)
 */
export default (url: URL) => {
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) {
		url.searchParams.set("p", "1")
		redirect(303, url)
	}

	function checkPages(pages: number) {
		if (page <= pages) return
		url.searchParams.set("p", pages.toString())
		redirect(303, url)
	}

	return { page, checkPages }
}
