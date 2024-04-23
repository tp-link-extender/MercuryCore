export default (uri: string, success: () => void, fail: () => void) => {
	// handle page running in an iframe (blur must be registered with top level window)
	let target = window as Window
	while (target.parent && target !== target.parent) target = target.parent

	const timeout = setTimeout(() => {
		// been too long, protocol probably wasn't handled
		target.removeEventListener("blur", onBlur)
		fail()
	}, 8000)

	function onBlur() {
		// the page has been navigated away from, meaning the protocol has probably been handled
		clearTimeout(timeout)
		target.removeEventListener("blur", onBlur)
		success()
	}

	target.addEventListener("blur", onBlur)
	window.location.href = uri
}
