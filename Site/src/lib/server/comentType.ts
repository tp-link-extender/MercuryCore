export default (type: string[], id: string) => {
	switch (type[0]) {
		case "status":
			if (type.length === 1) return ["status", id] // status comment
			return type // status comment comment
		case "forum":
			if (type.length === 2) return [...type, id] // forum comment
			return type // forum comment comment
		case "asset":
			return type // asset comment
	}
	return []
}
