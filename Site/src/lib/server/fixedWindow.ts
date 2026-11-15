interface Window {
	count: number
	resets: number
}

const sweepInterval = 60_000

/** A fixed-window counter: at most `max` hits per key in each window of `windowMs`, starting from the key's first hit. Rejected hits are not counted, so they never extend a window. */
export class FixedWindow {
	private readonly windows = new Map<string, Window>()
	private nextSweep = 0

	/** @returns whether the hit is allowed */
	hit(key: string, windowMs: number, max: number, now = Date.now()): boolean {
		this.sweep(now)

		const current = this.windows.get(key)
		if (!current || current.resets <= now) {
			this.windows.set(key, { count: 1, resets: now + windowMs })
			return max >= 1
		}

		if (current.count >= max) return false

		current.count++
		return true
	}

	get size(): number {
		return this.windows.size
	}

	private sweep(now: number): void {
		if (now < this.nextSweep) return
		this.nextSweep = now + sweepInterval

		for (const [key, { resets }] of this.windows)
			if (resets <= now) this.windows.delete(key)
	}
}
