import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

export const load = () => ({
	status: query(surql`stuff:ping.render`) as unknown as string,
})
