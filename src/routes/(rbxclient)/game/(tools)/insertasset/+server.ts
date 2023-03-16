import { redirect } from "@sveltejs/kit"

export async function GET({ url }) { 

    throw redirect(302, "https://www.roblox.com" + url.pathname + url.search)

};

