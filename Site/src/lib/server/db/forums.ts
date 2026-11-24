import type { Scored } from "#lib/like2.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import type { RecordId } from "#lib/server/surreal.ts"
import categoriesQuery from "./forums/categories.surql"
import categoryQuery from "./forums/category.surql"
import categoryIdQuery from "./forums/categoryId.surql"
import categoryNameQuery from "./forums/categoryName.surql"
import createCategoryQuery from "./forums/createCategory.surql"

/** A post shown as a preview, such as the latest one in a category. */
export interface PreviewPost {
	author: BasicUser
	currentContent: string
	id: string
}

export interface ForumPost extends PreviewPost, Scored {
	created: Date
	pinned: boolean
	visibility: string
}

export interface ForumCategory {
	description: string
	latestPost: PreviewPost | null
	name: string
	postCount: number
}

export interface CategoryPosts {
	name: string
	posts: ForumPost[]
}

/** Lists every forum category, with its latest post and how many posts it has. */
export async function categoriesOf(): Promise<ForumCategory[]> {
	const [categories] = await dbQuery<ForumCategory[][]>(categoriesQuery)
	return categories
}

/**
 * Finds a category's name, matched without case, and a page of its posts.
 * @param viewer The user looking at the page, whose likes the posts show.
 * @returns The category, or undefined if there is none, and how many pages of posts there are.
 */
export async function categoryPage(
	name: string,
	page: number,
	viewer: RecordId<"user">
): Promise<{ category: CategoryPosts | undefined; pages: number }> {
	const [category, pages] = await dbQuery<
		[CategoryPosts | undefined, number]
	>(categoryQuery, { category: name, page, user: viewer })
	return { category, pages }
}

/**
 * Finds the id of a category, matched without case.
 * @returns The id, or undefined if there is no such category.
 */
export async function categoryIdOf(name: string): Promise<string | undefined> {
	const [[category]] = await dbQuery<{ id: string }[][]>(categoryIdQuery, {
		category: name,
	})
	return category?.id
}

/**
 * Finds a category's name as it was written, matched without case.
 * @returns The name, or undefined if there is no such category.
 */
export async function categoryNameOf(
	name: string
): Promise<string | undefined> {
	const [[category]] = await dbQuery<{ name: string }[][]>(
		categoryNameQuery,
		{
			categoryParam: name,
		}
	)
	return category?.name
}

export async function createCategory(
	name: string,
	description: string
): Promise<void> {
	await dbQuery(createCategoryQuery, { description, name })
}
