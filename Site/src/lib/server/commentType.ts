export default (type: string[], id: string) => {
	const mtype = type[0]
	if (
		(mtype === "status" && type.length === 1) || // status post
		(mtype === "forum" && type.length === 2) || // forum post
		(mtype === "asset" && type.length === 2) // asset comment
	)
		return [...type, id]

	// status post comment
	// forum post comment comment
	// asset comment comment
	return type
}
