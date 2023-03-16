import { redirect } from "@sveltejs/kit"

export async function GET({ url }) { 

    // throw redirect(302, "https://sets.pizzaboxer.xyz" + url.pathname + url.search)
    return new Response("test")
};

