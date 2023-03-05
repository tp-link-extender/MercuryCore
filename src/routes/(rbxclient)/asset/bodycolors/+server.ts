import { error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { prisma } from "$lib/server/prisma"

export const GET: RequestHandler = async ({url}) => {
    const ID = url.searchParams.get("id") 
    if(!ID || !/^\d+$/.test(ID)) throw error(400, "Invalid Request")

    const userInfo = await prisma.user.findUnique({
        where: {number: parseInt(ID)},
        select: {bodyColours: true}
    })

    if(!userInfo) throw error(404, "User Not Found")

    const userBodyColours = userInfo.bodyColours

    return new Response();
};