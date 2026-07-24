const zeros = /0+$/

const million = 1_000_000n

export default (balance: bigint) => {
	const beforePoint = (balance / million).toString()
	const afterPoint = (balance % million)
		.toString()
		.padStart(6, "0")
		.replace(zeros, "")

	// yes it's spelled 'zeros', as in plural of 'zero'. 'zeros' is a plural noun, 'zeroes' is an intransitive verb. Source: me, that's just what I prefer
	const zerosBefore = "0".repeat(Math.max(6 - beforePoint.length, 0))
	const zerosAfter = "0".repeat(Math.max(6 - afterPoint.length, 0))

	return [zerosBefore, beforePoint, afterPoint, zerosAfter]
}
