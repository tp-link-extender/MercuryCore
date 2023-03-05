import type { RequestHandler } from './$types';
import { error } from '@sveltejs/kit';

export const GET: RequestHandler = async ({url}) => {
    const userId = url.searchParams.get("userID")

    if(!userId || !/^\d+$/.test(userId)) throw error(400, "Invalid Request")

    let charApp = `https://banland.xyz/Asset/BodyColors.ashx?id=${userId}`

    return new Response(charApp);
};