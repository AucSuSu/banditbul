const BASE_URL = "https://k10e102.k.ssafy.io/api";

async function Fetch(
    path: string,
    method: string,
    body: object | null = null
): Promise<any> {
    if (body === null) {
        const res = await fetch(BASE_URL + path, {
            method,
            headers: {
                "Content-Type": "application/json",
            },
        });
        return res;
    }
    const res = await fetch(BASE_URL + path, {
        method,
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
    });
    return res;
}

export { Fetch };
