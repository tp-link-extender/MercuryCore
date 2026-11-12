interface StrID {
	id: string
}
export interface UserData extends BasicUser, StrID {}
interface StrIDName extends StrID {
	name: string
}
export type GroupData = StrIDName
export type SourceData = StrIDName

export interface OwnerData {
	groups: { [id: string]: GroupData }
	sources: { [id: string]: SourceData }
	users: { [id: string]: UserData }
}
