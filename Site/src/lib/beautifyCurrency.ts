const zeros = /0+$/

export default function (balance: number) {
	const beforePoint = Math.floor(balance / 1e6).toString()
	const afterPoint = (balance % 1e6)
		.toString()
		.padStart(6, "0")
		.replace(zeros, "")
	const zerosBefore = "0".repeat(Math.max(6 - beforePoint.length, 0))
	const zerosAfter = "0".repeat(Math.max(6 - afterPoint.length, 0))
	return [zerosBefore, beforePoint, afterPoint, zerosAfter]
}
