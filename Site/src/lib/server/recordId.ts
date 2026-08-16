export function toRawId(value: unknown): string {
	if (value == null) return ""
	if (typeof value === "string") {
		const trimmed = value.trim()
		if (trimmed.includes(":")) return trimmed.split(":").at(-1) ?? trimmed
		return trimmed
	}
	if (typeof value === "number" || typeof value === "bigint") return String(value)
	if (typeof value === "object") {
		const maybeRecordId = value as { id?: unknown; tb?: unknown }
		if (typeof maybeRecordId.id !== "undefined") return toRawId(maybeRecordId.id)
		if (typeof maybeRecordId.tb !== "undefined") return toRawId(maybeRecordId.tb)
	}
	return String(value)
}
