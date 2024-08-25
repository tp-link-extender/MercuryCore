<script lang="ts">
	import { page } from "$app/stores"

	export let totalPages: number

	function getNewUrl(page: number) {
		const url = new URL($page.url) // clone?
		url.searchParams.set("page", page.toString())
		return url.pathname + url.search
	}
	const pageQ = $page.url.searchParams.get("page") || "1"
	const currentPage = Number.isNaN(+pageQ) ? 1 : +pageQ
	const prevPage = currentPage - 1
	const nextPage = currentPage + 1

	type Page = number | null

	let pages: Page[] = []
	pages.push(1)
	if (currentPage > 2) pages.push(0)
	if (currentPage !== 1 && currentPage !== totalPages) pages.push(currentPage)
	if (currentPage + 1 < totalPages) pages.push(0)
	if (totalPages > 1) pages.push(totalPages)
</script>

<nav class="flex flex-col items-center gap-4" aria-label="pagination">
	<div class="flex items-center gap-2">
		<a
			href={getNewUrl(prevPage)}
			class="btn btn-secondary {prevPage >= 1
				? ''
				: 'opacity-50 pointer-events-none'}">
			<fa fa-arrow-left />
		</a>
		{#each pages as page}
			{#if page}
				<a
					href={getNewUrl(page)}
					class="btn btn-tertiary {page === currentPage
						? 'opacity-50 pointer-events-none'
						: ''}">
					{page}
				</a>
			{:else}
				<span>...</span>
			{/if}
		{/each}
		<a
			href={getNewUrl(nextPage)}
			class="btn btn-secondary {nextPage <= totalPages
				? ''
				: 'opacity-50 pointer-events-none'}">
			<fa fa-arrow-right />
		</a>
	</div>
</nav>
