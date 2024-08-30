import { redirect } from "@sveltejs/kit"

/**
 * Helper function to parse the query and page from a URL object.
 * @param url The URL object to parse the query and page from
 * @returns An object containing the query and page, as well as a function to check if the current page exceeds the total number of pages.
 * @example
 * const { qp, checkPages } = pageQuery(url)
 * const [things, pages] = await equery<[Thing[], number]>(thingQuery, qp)
 * checkPages(pages)
 */
export default (url: URL) => {
	const pageQ = url.searchParams.get("p") || "1"
	const page = Number.isNaN(+pageQ) ? 1 : Math.round(+pageQ)
	if (page < 1) {
		url.searchParams.set("p", "1")
		redirect(303, url)
	}

	const query = url.searchParams.get("q")?.trim() || ""

	function checkPages(pages: number) {
		if (page <= pages) return
		url.searchParams.set("p", pages.toString())
		redirect(303, url)
	}

	return { pq: { page, query }, checkPages }
}
