import { error } from "@sveltejs/kit"
import { membershipType } from "$lib/permissionLevels"
import config from "$lib/server/config"
import idToPort, { proxyOffset } from "$lib/server/idToPort"
import { SignData } from "$lib/server/sign"
import { db, findWhere, Record } from "$lib/server/surreal"
import joinQuery from "../join.surql"

type Config = {
	CharacterAppearance: string
	MachineAddress: string
	MembershipType: string
	PingUrl: string
	PlaceId: number
	ServerPort: number
	UniverseId: number
	UserId: number
	UserName: string
}

const makeConfig = (c: Config) => ({
	...c,
	ClientPort: 0,
	PingInterval: 120,
	SeleniumTestMode: false,
	SuperSafeChat: true,
	ClientTicket:
		"5/20/2016 1:42:15 PM;NrIIE25IsF2FrEN4ndNMVfz5zeYW5jp1uql+gmz5lShAWUKHE+n3CGaK6V9goXbzw2R/SOy/hQ9OT/y72b7Yoty8z4RVXlDEewn0rOado2wGs2kqzQqjtwMWiwBJi0HZ2HAS8xlX2Tpp1GhEdONem7SVFcqzHsUufPqKySxBBTI=;WUraepy1LfhrnjYgRbn9rQKckP+1AXpMEHAIuFvee6Al8HB+ss7w57REuUhqkIKRgNlKfobF6drSyeHPg/XZfH34/BqkPgQ9vykootvdJKHlPeran+qvGQ2icUqG3EE+/ZUZ3hAHZ5Kc3vsMpx6axbXSJV+mDElM8ej3X9mP/Fo=",
	GameId: "00000000-0000-0000-0000-000000000000",
	MeasurementUrl: "",
	WaitingForCharacterGuid: "16be1dd8-5462-4ca5-a997-0725d997708b",
	BaseUrl: config.Domain,
	ChatStyle: "Classic",
	VendorId: 0,
	ScreenShotInfo: "",
	VideoInfo:
		'<?xml version="1.0"?><entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007"><media:group><media:title type="plain"><![CDATA[ROBLOX Place]]></media:title><media:description type="plain"><![CDATA[ For more games visit http://www.roblox.com]]></media:description><media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Games</media:category><media:keywords>ROBLOX, video, free game, online virtual world</media:keywords></media:group></entry>',
	CreatorId: 0,
	CreatorTypeEnum: "User",
	AccountAge: 0,
	CookieStoreFirstTimePlayKey: "rbx_evt_ftp",
	CookieStoreFiveMinutePlayKey: "rbx_evt_fmp",
	CookieStoreEnabled: true,
	IsRobloxPlace: false,
	GenerateTeleportJoin: false,
	IsUnknownOrUnder13: true,
	SessionId:
		"084fe2bc-2a6e-423c-bc2a-0ed876f7c274|00000000-0000-0000-0000-000000000000|0|204.236.226.210|8|2016-05-20T18:42:15.3704607Z|0|null|null",
	DataCenterId: 0,
	BrowserTrackerId: 0,
	UsePortraitMode: false,
	FollowUserId: 0,
})

type ServerAddress = {
	serverAddress: string
	serverPort: number
}

type Session = {
	place: {
		id: number
		ownerUser: {
			username: string
		}
		dedicated: boolean
	} & ServerAddress
	user: {
		permissionLevel: number
		username: string
	}
}

const serverDedicated = (dedicated: boolean) =>
	config.Gameservers.Hosting === "Both"
		? dedicated
		: config.Gameservers.Hosting === "Dedicated"

function serverInfo(place: Session["place"]): ServerAddress {
	if (!serverDedicated(place.dedicated)) return place

	const url = new URL(config.Orbiter.PublicURL)
	return {
		serverAddress: url.hostname, // no scheme, the address doesn't usually have a path anyway
		serverPort: idToPort(place.id) + proxyOffset, // select the proxy port rather than the port of the server itself
	}
}

export async function GET({ url }) {
	const clientTicket = url.searchParams.get("ticket")
	const privateServer = url.searchParams.get("privateServer") as string

	if (!clientTicket) {
		const joinconfig = makeConfig({
			CharacterAppearance: "",
			MachineAddress: "localhost",
			MembershipType: membershipType(0),
			PingUrl: "",
			PlaceId: 0,
			ServerPort: 53640,
			UniverseId: 0,
			UserId: 0,
			UserName: "Player1",
		})

		return new Response(await SignData(JSON.stringify(joinconfig)))
	}

	const foundPrivatePlace = await findWhere(
		"place",
		"privateTicket = $privateServer",
		{ privateServer }
	)
	if (privateServer && !foundPrivatePlace)
		error(400, "Invalid Private Server")

	const playing = Record("playing", clientTicket)
	// also invalidates the session
	const [gameSession] = await db.query<Session[]>(joinQuery, { playing })
	if (!gameSession) error(400, "Invalid Game Session")

	const { place, user } = gameSession
	const { serverAddress, serverPort } = serverInfo(place)

	// const creatorUsername = place.ownerUser?.username;
	const charApp = `http://${config.DomainInsecure}/asset/characterfetch/${user.username}`
	const pingUrl = `http://${config.DomainInsecure}/game/clientpresence?ticket=${clientTicket}`

	const joinconfig = makeConfig({
		CharacterAppearance: charApp,
		MachineAddress: serverAddress,
		MembershipType: membershipType(user.permissionLevel),
		PingUrl: pingUrl,
		PlaceId: place.id,
		ServerPort: serverPort,
		UniverseId: place.id, // todo: tho not rly used 4 much atm
		UserId: Math.floor(Math.random() * 1e9), // todo: tho not rly used 4 much atm
		UserName: user.username,
	})

	return new Response(await SignData(JSON.stringify(joinconfig)))
}
