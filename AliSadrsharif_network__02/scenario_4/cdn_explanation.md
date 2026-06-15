# CDN (Content Delivery Network) - Explanation

## What is a CDN and what does it do?
A **CDN (Content Delivery Network)** is a network of distributed servers (called **Edge Servers**) placed in many locations around the world. Its goal is to deliver web content (especially **static assets** like images, CSS, JavaScript, videos) faster and more reliably to users.
Typical flow:
1. A user requests a file from a website.
2. The CDN routes the request to the **nearest Edge Server** (based on network proximity and performance).
3. If the content is already **cached** at that Edge Server, the CDN returns it immediately.
4. If it’s not cached, the Edge Server fetches the content from the **Origin Server**, stores it in cache, and then serves it to the user.

Key benefits:
 - Lower loading time and **reduced latency**
 - Less load on the **Origin Server**
 - Better scalability during traffic spikes
 - Improved availability and sometimes better protection against attacks

## How does a CDN reduce latency?
**Latency** is the time it takes for data to travel and for the response to be returned.
CDNs reduce latency by:
 - **Serving from a closer location:** Edge servers are geographically nearer to users than the origin.
 - **Using caching:** When content is cached at the edge, the CDN can respond without reaching the origin.
 - **Optimizing network paths:** CDNs route traffic through faster/more efficient routes.
 - **Handling load efficiently:** Requests can be served by multiple edge servers rather than overloading a single origin.

Result:
 If the requested content is a **cache HIT**, the response is much faster than fetching from the origin every time.

## Difference between Edge Server and Origin Server

### Origin Server
 - The **main server** where the website/app content is originally stored.
 - It is the source of truth (the original files or data).
 - It often does more work if CDNs are not used or if cache misses occur frequently.

### Edge Server
 - A CDN server located near users (many locations worldwide).
 - It stores **cached copies** of content.
 - It serves users directly when possible; on cache miss, it fetches from the origin.

Summary:
 - **Origin = original content source**
 - **Edge = nearby delivery + caching layer**

## Show that a CDN uses headers (using curl)
CDNs often add response HTTP headers that reveal caching behavior and which server handled the request. You can inspect these headers using `curl -I`.

Example (daneshkar / Arvan CDN):
 Run:
 ```bash
 curl -I https://daneshkar.net
 ```

Results headrs for daneshkar:

 HTTP/2 200 
 date: Mon, 18 May 2026 07:49:16 GMT
 content-type: text/html; charset=utf-8
 content-length: 608725
 vary: Accept-Encoding
 cache-control: s-maxage=600, stale-while-revalidate
 etag: "50z0gr0g17cmc5"
 referrer-policy: strict-origin-when-cross-origin
 vary: Accept-Encoding
 vary: RSC, Next-Router-State-Tree, Next-Router-Prefetch, Accept-Encoding
 x-content-type-options: nosniff
 x-frame-options: SAMEORIGIN
 x-nextjs-cache: STALE
 x-powered-by: Next.js
 content-security-policy: upgrade-insecure-requests
 x-xss-protection: 1; mode=block
 alt-svc: h3=":443"; ma=86400
 *server: ArvanCloud*
 server-timing: total;dur=220
 *x-cache: BYPASS*
 x-request-id: 02c9046b60aadb74a2c797ed48cf893a
 x-sid: 2066
 accept-ranges: bytes
