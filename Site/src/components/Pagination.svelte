<script lang="ts">
	import { untrack } from "svelte"
	import { page } from "$app/state"

	const { totalPages }: { totalPages: number } = $props()

	function getNewUrl(p: number) {
		const url = new URL(page.url) // clone?
		url.searchParams.set("p", p.toString())
		return url.pathname + url.search
	}
	const pageQ = page.url.searchParams.get("p") || "1"
	const currentPage = Number.isNaN(+pageQ) ? 1 : +pageQ
	const prevPage = currentPage - 1
	const nextPage = currentPage + 1

	type Page = number | null

	let pages: Page[] = $state([])
	function updPages() {
		pages = []
		untrack(() => {
			pages.push(1)
			if (currentPage > 2) pages.push(0)
			if (currentPage !== 1 && currentPage !== totalPages)
				pages.push(currentPage)
			if (currentPage + 1 < totalPages) pages.push(0)
			if (totalPages > 1) pages.push(totalPages)
		})
	}
	updPages()
	$effect(updPages)

	const disabled = "opacity-50 pointer-events-none"
</script>

<nav class="flex justify-center gap-2 pt-6" aria-label="pagination">
	<a
		href={getNewUrl(prevPage)}
		class="btn btn-secondary {prevPage >= 1 ? '' : disabled}"
		aria-label="Forward">
		<fa fa-arrow-left></fa>
	</a>
	{#each pages as page}
		{#if page}
			<a
				href={getNewUrl(page)}
				class="btn btn-tertiary {page === currentPage ? disabled : ''}">
				{page}
			</a>
		{:else}
			<span>...</span>
		{/if}
	{/each}
	<a
		href={getNewUrl(nextPage)}
		class="btn btn-secondary {nextPage <= totalPages ? '' : disabled}"
		aria-label="Back">
		<fa fa-arrow-right></fa>
	</a>
</nav>
