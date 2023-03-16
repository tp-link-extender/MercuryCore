import { redirect } from "@sveltejs/kit"

export async function GET({ url }) { 

    redirect(302, "http://www.roblox.com" + url.pathname + url.search)

    return new Response("ok")
};

