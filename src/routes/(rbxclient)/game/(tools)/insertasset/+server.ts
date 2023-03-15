
export const GET = async ({setHeaders}) => {

    setHeaders({
        "Location":"http://www.roblox.com" + location.pathname + location.search
    })
    
    return new Response("OK")
};

