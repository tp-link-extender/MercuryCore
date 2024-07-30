import type { BrickColour } from "$lib/brickColours" // actually works!?!

export type Config = {
	/**
	 * The name of your revival. Make sure it's something stupid.
	 *
	 * [**No good names. Absolutely none.**](https://youtube.com/watch?v=88KGJ-eh7FU&t=145)
	 */
	Name: string
	/**
	 * Your revival's domain name.
	 */
	Domain: string
	/**
	 * The URL of your database server.
	 */
	DatabaseURL: string
	/**
	 * The URL of your RCC proxy server. Requires a URL scheme.
	 */
	RCCServiceProxyURL: string
	/**
	 * The symbol for your revival's currency. Placed before the amount.
	 */
	CurrencySymbol: string

	/**
	 * The default body colours for avatar creation, given to each new user on registration.
	 *
	 * Each colour is a BrickColor ID.
	 */
	DefaultBodyColors: {
		/**
		 * The default head colour.
		 */
		Head: BrickColour
		/**
		 * The default left arm colour.
		 */
		LeftArm: BrickColour
		/**
		 * The default left leg colour.
		 */
		LeftLeg: BrickColour
		/**
		 * The default right arm colour.
		 */
		RightArm: BrickColour
		/**
		 * The default right leg colour.
		 */
		RightLeg: BrickColour
		/**
		 * The default torso colour.
		 */
		Torso: BrickColour
	}

	/**
	 * Configuration for logging done by Mercury Core.
	 */
	Logging: {
		/**
		 * Whether to log all incoming requests to dynamic pages.
		 */
		Requests: boolean
		/**
		 * Whether to format errors in a more readable way. This does not provide a full stack trace.
		 */
		FormattedErrors: boolean
		/**
		 * Whether to log the time of each request.
		 */
		Time: boolean
	}
}
