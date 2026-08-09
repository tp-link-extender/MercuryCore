type StrID = {
	id: string
}
export interface UserData extends BasicUser, StrID {}
interface StrIDName extends StrID {
	name: string
}
export type GroupData = StrIDName
export type SourceData = StrIDName

export type OwnerData = {
	users: { [id: string]: UserData }
	groups: { [id: string]: GroupData }
	sources: { [id: string]: SourceData }
}
