import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

export const load = () => ({
	categories: query<{
		description: string
		name: string
		postCount: number
		latestPost: {
			author: {
				number: number
				username: string
			}
			id: string
			posted: string
			title: string
		}
	}>(surql`
		SELECT
			name,
			description,
			(SELECT
				meta::id(id) AS id,
				title,
				posted,
				(SELECT
					number,
					username
				FROM <-posted<-user)[0] AS author
			FROM <-in<-forumPost
			ORDER BY posted DESC)[0] AS latestPost,
			count(<-in) AS postCount
		FROM forumCategory`),
})
