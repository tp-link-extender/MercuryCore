import {
	ConnectionStatus,
	ConnectionUnavailable,
	type Emitter,
	type Engine,
	type EngineEvents,
	type RpcRequest,
	type RpcResponse,
	decodeCbor,
	encodeCbor,
	retrieveRemoteVersion,
} from "surrealdb.js"
import { z } from "zod"

// myootabilitee
let id = 0
function getIncrementalId() {
	id = (id + 1) % Number.MAX_SAFE_INTEGER
	return id.toString()
}

export const realUrl = new URL("http://localhost:8000")
const namespace = "main"
const database = "main"

// not using the default one because it doesn't configure the namespace and database correctly sometimes
export default class implements Engine {
	ready: Promise<void> | undefined = undefined
	status: ConnectionStatus = ConnectionStatus.Disconnected
	readonly emitter: Emitter<EngineEvents>
	connection: {
		url?: URL
		namespace?: string
		database?: string
		token?: string
		variables: { [k: string]: unknown }
	} = { variables: {} }

	constructor(emitter: Emitter<EngineEvents>) {
		this.emitter = emitter
	}

	private setStatus<T extends ConnectionStatus>(
		status: T,
		...args: EngineEvents[T]
	) {
		this.status = status
		this.emitter.emit(status, args)
	}

	version(url: URL, timeout: number): Promise<string> {
		return retrieveRemoteVersion(url, timeout)
	}

	connect(url: URL) {
		this.setStatus(ConnectionStatus.Connecting)
		this.connection.url = url
		this.setStatus(ConnectionStatus.Connected)
		this.ready = new Promise<void>(r => r())
		return this.ready
	}

	disconnect(): Promise<void> {
		this.connection = { variables: {} }
		this.ready = undefined
		this.setStatus(ConnectionStatus.Disconnected)
		return new Promise<void>(r => r())
	}

	async rpc<
		Method extends string,
		Params extends unknown[] | undefined,
		Result,
	>(request: RpcRequest<Method, Params>): Promise<RpcResponse<Result>> {
		while (true) {
			await this.ready
			if (!this.connection.url) throw new ConnectionUnavailable()

			if (request.method === "use") return { result: true as Result }

			if (request.method === "let") {
				const [key, value] = z
					.tuple([z.string(), z.unknown()])
					.parse(request.params)
				this.connection.variables[key] = value
				return { result: true as Result }
			}

			if (request.method === "unset") {
				const [key] = z.tuple([z.string()]).parse(request.params)
				delete this.connection.variables[key]
				return { result: true as Result }
			}

			if (request.method === "query")
				request.params = [
					request.params?.[0],
					{
						...this.connection.variables,
						...(request.params?.[1] ?? {}),
					},
				] as Params

			const id = getIncrementalId()
			const raw = await fetch(this.connection.url.toString(), {
				method: "POST",
				headers: {
					"Content-Type": "application/cbor",
					Accept: "application/cbor",
					"Surreal-NS": namespace,
					"Surreal-DB": database,
					...(this.connection.token
						? { Authorization: `Bearer ${this.connection.token}` }
						: {}),
				},
				body: encodeCbor({ id, ...request }),
			})
			if (raw.status !== 200) {
				console.log("reconnecting")
				this.connect(realUrl)
				continue
			}

			const response: RpcResponse = decodeCbor(await raw.arrayBuffer())
			if ("result" in response)
				switch (request.method) {
					case "signin":
					case "signup":
						this.connection.token = response.result as string
						break
					case "authenticate":
						this.connection.token = request.params?.[0] as string
						break
					case "invalidate":
						delete this.connection.token
						break
					default:
				}

			this.emitter.emit(`rpc-${id}`, [response])
			return response as RpcResponse<Result>
		}
	}

	// get online!
	get connected() {
		return !!this.connection.url
	}
}
