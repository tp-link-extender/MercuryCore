<svg
	width="369"
	height="428"
	viewBox="0 0 369 428"
	fill="none"
	xmlns="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	id="Lock">
	<path
		d="M0 100.5L-5.17708e-06 110L19 110L19 100.5L0 100.5ZM9.50001 86.5L19 86.5L19 86.5L9.50001 86.5ZM149.893 86.5L159.393 86.5V86.5H149.893ZM140.393 134.5C140.393 139.747 144.646 144 149.893 144C155.139 144 159.393 139.747 159.393 134.5L140.393 134.5ZM79.6963 9.5L79.6963 0L79.6963 9.5ZM19 100.5L19 86.5L7.6294e-06 86.5L0 100.5L19 100.5ZM140.393 86.5L140.393 134.5L159.393 134.5L159.393 86.5L140.393 86.5ZM79.6963 19C112.41 19 140.393 48.3746 140.393 86.5H159.393C159.393 39.5736 124.519 7.83711e-06 79.6963 0L79.6963 19ZM19 86.5C19 48.3746 46.9827 19 79.6963 19L79.6963 0C34.8733 -7.83711e-06 1.58343e-05 39.5736 7.62939e-06 86.5L19 86.5Z"
		fill="white" />
</svg>
<svg
	width="369"
	height="428"
	viewBox="0 0 369 428"
	fill="none"
	xmlns="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	id="Bar">
	<path
		fill-rule="evenodd"
		clip-rule="evenodd"
		d="M19.5 10C19.5 4.75329 15.2467 0.5 10 0.5C4.7533 0.5 0.5 4.7533 0.5 10L0.500003 70.0564C3.27205 68.9033 6.31191 68.2669 9.50005 68.2669C13.0762 68.2669 16.4657 69.0677 19.5 70.5001L19.5 10Z"
		fill="white" />
</svg>
<svg
	width="369"
	height="428"
	viewBox="0 0 369 428"
	fill="none"
	xmlns="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink">
	<g transform="translate(0 170)" width="256" height="256" id="Logo">
		<path
			d="M15.511 170V51H38.801L81.981 121.38L66.851 121.21L110.711 51H133.151V170H108.161V129.71C108.161 119.397 108.388 110.103 108.841 101.83C109.408 93.5567 110.314 85.3967 111.561 77.35L114.451 85.34L79.601 139.23H68.211L34.211 85.68L36.931 77.35C38.291 84.9433 39.1977 92.7633 39.651 100.81C40.2177 108.857 40.501 118.49 40.501 129.71V170H15.511Z"
			fill="white"
			id="M"
			transform="translate(54 17)" />
		<path
			d="M184.139 23.755C186.652 19.0869 184.918 13.2287 180.075 11.0716C154.479 -0.328495 125.752 -3.04937 98.3235 3.48802C67.7719 10.7698 40.9639 29.0301 23.0012 54.7937C5.03851 80.5574 -2.82495 112.026 0.907294 143.211C4.63954 174.396 19.707 203.12 43.2421 223.917C66.7773 244.714 97.1373 256.133 128.544 255.999C159.952 255.866 190.213 244.19 213.571 223.193C236.928 202.197 251.751 173.345 255.218 142.13C258.331 114.106 252.096 85.932 237.632 61.9332C234.896 57.3921 228.869 56.3918 224.545 59.461C220.222 62.5302 219.246 68.5045 221.923 73.0814C233.692 93.2078 238.728 116.67 236.135 140.01C233.188 166.544 220.589 191.067 200.735 208.914C180.881 226.761 155.159 236.686 128.463 236.799C101.767 236.913 75.9607 227.207 55.9558 209.53C35.951 191.852 23.1437 167.436 19.9712 140.929C16.7988 114.422 23.4828 87.6738 38.7511 65.7747C54.0194 43.8756 76.8062 28.3544 102.775 22.1648C125.619 16.7201 149.523 18.8308 170.944 28.0338C175.816 30.1266 181.625 28.4231 184.139 23.755Z"
			fill="white"
			id="Outer" />
		<ellipse
			filter="url(#dotfilter)"
			cx="31"
			cy="31"
			rx="13.5"
			ry="13.5"
			id="Light"
			transform="translate(175 10)" />
	</g>
	<defs>
		<filter
			id="dotfilter"
			x="0"
			y="0"
			width="62.5"
			height="62.5"
			filterUnits="userSpaceOnUse"
			color-interpolation-filters="sRGB">
			<feGaussianBlur stdDeviation="9" />
			<feComposite operator="out" />
			<feBlend in="SourceGraphic" result="shape" />
		</filter>
	</defs>
</svg>

<style lang="stylus">
	// This file has taught me so damn much about SVG in like 10 minutes

	svg
		position absolute

	// Lots of magic numbers here
	@keyframes unlock
		0%
			transform translate(-153px, 60px) scale(-1, 1)
		5%
			transform translate(-153px, 60px) scale(-1, 1)
		10%
			transform translate(-153px, 70px) scale(-1, 1)
		33%
			transform translate(-153px, 20px) scale(-1, 1)
		66%
			transform translate(196px, 20px) scale(1, 1)
		100%
			transform translate(196px, 60px) scale(1, 1)

	@keyframes bar
		0%
			transform translate(-158px, 118px) scale(-1.03, 1)
		5%
			transform translate(-158px, 118px) scale(-1.03, 1)
		10%
			transform translate(-158px, 88px) scale(-1.03, 0.8)
		0%
			transform translate(-158px, 118px) scale(-1.03, 1)
		33%
			transform translate(-158px, 118px) scale(-1.03, 1)
		66%
			transform translate(201px, 118px) scale(1.03, 1)
		100%
			transform translate(201px, 103px) scale(1.03, 0.9)

	@keyframes light
		0%
			fill #ff0000
		20%
			fill #ff0000
		30%
			fill #00ff00
		100%
			fill #00ff00

	#Bar
		transform translate(-158px, 118px) scale(-1.03, 1)
		animation bar 1.8s forwards
		animation-delay 0.8s
	#Lock
		transform translate(-153px, 60px) scale(-1, 1)
		animation unlock 1.8s forwards
		animation-delay 0.8s

	#Light
		fill #ff0000
		animation light 1.8s forwards
		animation-delay 0.8s
</style>
