
export async function GET({ url, setHeaders }) { 

    setHeaders({
         "Location":"http://www.roblox.com" + url.pathname + url.search
    })

    return new Response("ok")
};

