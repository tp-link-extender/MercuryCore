<template lang="pug">
	main
		slot

	footer
		p
			a(href="/") Mercury
			| 2022-{new Date().getFullYear()}

		a.footer(href="/about") About
		| |
		a.footer(href="/terms") Terms of Service
		| |
		a.footer(href="/privacy") Privacy Policy
		| |
		a.footer(href="/statistics") Statistics
</template>

<style lang="sass">
	@use "./vars.sass"

	main
		z-index: 1

	:root
		background-color: vars.$background
		color: vars.$light-text
		font-family: SFUIBold

	footer
		text-align: center

	a
		color: vars.$grey-text
		text-decoration: none
		transition: all 1s ease-in-out
		margin: 0 3px
		&:hover
			color: vars.$accent3
</style>
