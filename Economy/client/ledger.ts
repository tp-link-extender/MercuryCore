export const RandNumericId = (): number => Math.floor(Math.random() * 9e8) + 1e8

const idchars = "0123456789abcdefghijklmnopqrstuvwxyz"

export const RandStringId = (): string => {
	let result = ""
	for (let i = 0; i < 20; i++)
		result += idchars[Math.floor(Math.random() * idchars.length)]
	return result
}

export class TransferID {
	constructor(
		public timestamp: bigint,
		public id: string
	) {}

	String(): string {
		return `${this.timestamp}-${this.id}`
	}

	Serialise(): Buffer {
		const bs = Buffer.alloc(8 + this.id.length)
		bs.writeBigUInt64BE(this.timestamp, 0)
		bs.write(this.id, 8)
		return bs
	}
}
