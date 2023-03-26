// The service worker script, adding some offline functionality to Mercury.
// This is the same service worker script found at https://kit.svelte.dev/docs/service-workers.
/// <reference types="@sveltejs/kit" />
import { build, files, prerendered, version } from "$service-worker"

// Create a unique cache name for this deployment
const CACHE = `cache-${version}`

const ASSETS = [
	...build, // the app itself
	...files, // everything in `static`
	...prerendered, // pages that have been prerendered (empty in dev)
]

self.addEventListener("install", event =>
	// Create a new cache and add all files to it

	event.waitUntil(async () => await (await caches.open(CACHE)).addAll(ASSETS))
)

self.addEventListener("activate", event =>
	// Remove previous cached data from disk

	event.waitUntil(async () => {
		for (const key of await caches.keys())
			if (key != CACHE) await caches.delete(key)
	})
)

self.addEventListener("fetch", event => {
	// ignore POST requests etc
	if (event.request.method != "GET") return

	// cannot be an anonymous function for some reason
	async function respond() {
		const url = new URL(event.request.url)
		const cache = await caches.open(CACHE)

		// `build`/`files` can always be served from the cache
		// buggy atm so disabled
		// if (ASSETS.includes(url.pathname)) return cache.match(event.request)

		// for everything else, try the network first, but
		// fall back to the cache if we're offline
		try {
			const response = await fetch(event.request)

			if (response.status == 200)
				cache.put(event.request, response.clone())

			return response
		} catch {
			return cache.match(event.request)
		}
	}

	event.respondWith(respond())
})
