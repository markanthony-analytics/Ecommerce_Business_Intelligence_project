/*
1. To show the  overall session and order volume
trended by quarterly and yearly  for the life of the business.
*/ 

SELECT 
	YEAR(website_sessions.created_at) AS yr,
	QUARTER(website_sessions.created_at) AS qtr, 
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions, 
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions 
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
GROUP BY 1,2
ORDER BY 1,2
;


/*
2. Next, let’s showcase all of the efficiency improvements. I would love to show quarterly figures 
for session-to-order conversion rate, revenue per order, and revenue per session. 

*/

SELECT 
	YEAR(website_sessions.created_at) AS yr,
	QUARTER(website_sessions.created_at) AS qtr, 
	COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate, 
    SUM(price_usd)/COUNT(DISTINCT orders.order_id) AS revenue_per_order, 
    SUM(price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions 
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
GROUP BY 1,2
ORDER BY 1,2
;

/*
3. TO determine how much revenue the paid campaigns are generating
*/

SELECT 
    utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
    COUNT(DISTINCT orders.order_id) AS Orders
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
GROUP BY utm_source;

/*
4. To obtain a breakdown of website traffic by UTM source, campaign, and referring domain
*/

SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id) AS Sessions
FROM
    website_sessions
WHERE
    created_at < '2012-04-12'
GROUP BY utm_source , utm_campaign , http_referer
ORDER BY Sessions DESC; 

/*
5.To understand the device-level performance of this campaign at a specific time frame.
*/

SELECT 
    website_sessions.device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
    COUNT(orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS 'Conversion Rate'
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-05-11'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY website_sessions.device_type;

/*
6.To dig deeper, we may extract weekly trends for both desktop and mobile, in order to examine the impact on session volume.
*/


SELECT
	YEAR(website_sessions.created_at) AS year, 
    MONTH(website_sessions.created_at) AS month, 
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions, 
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions, 
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders
FROM website_sessions
	LEFT JOIN orders 
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,2
ORDER BY desktop_sessions desc, desktop_orders desc;

/*
7.To confirm where the users are hitting the website, it is possible pull all entry pages and rank them on entry volume. 
To achieve this, I have to create temporary table called firstpageview
*/

CREATE TEMPORARY TABLE firstpageview
SELECT website_session_id,
MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;
SELECT 
    website_pageviews.pageview_url AS Landing_page,
    COUNT(firstpageview.website_session_id) AS Session_Hitting_Landing_page
FROM
    firstpageview
        LEFT JOIN
    website_pageviews ON website_pageviews.website_pageview_id = firstpageview.min_pageview_id
GROUP BY website_pageviews.pageview_url
ORDER BY Session_Hitting_Landing_page DESC

/*
8.TO know how much of the order volume is from each product, as well as the total revenue and margin earned.
*/

SELECT 
    products.product_name,
    COUNT(orders.order_id) AS Orders,
    ROUND(SUM(orders.price_usd * orders.items_purchased)) AS Revenue,
    ROUND(SUM(orders.price_usd - orders.cogs_usd)) AS Margin,
    AVG(orders.price_usd) AS Averagre_Order_Value
FROM
    orders
        INNER JOIN
    products ON products.product_id = orders.primary_product_id
GROUP BY 1
ORDER BY 3 DESC;

/*
9. In order to understand the impact of this launch, I would like to obtain monthly order volume, 
overall conversion rates, revenue per session, and a breakdown of sales by product for the period beginning on April 1, 2013.
*/

SELECT 
    YEAR(website_sessions.created_at) AS Yr,
    MONTH(website_sessions.created_at) AS Month,
    COUNT(DISTINCT orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS Conv_rate,
    SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,
    COUNT(DISTINCT CASE
            WHEN primary_product_id = 1 THEN order_id
            ELSE NULL
        END) AS product_one_orders,
    COUNT(DISTINCT CASE
            WHEN primary_product_id = 2 THEN order_id
            ELSE NULL
        END) AS product_two_orders
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2013-04-05'
        AND website_sessions.created_at > '2012-04-01'
GROUP BY 1 , 2

/*
10. To show how the campaign's specified channel has performed in terms of the overall volume of orders
*/

WITH CTE AS (SELECT
YEAR(sess.created_at) AS Yr, QUARTER(sess.created_at) AS Qtr,
COUNT(DISTINCT CASE WHEN channel_type='Gsearch_nonbrand' THEN order_id ELSE NULL END) AS Gsearch_nonbarnd_orders,
COUNT(DISTINCT CASE WHEN channel_type='Bsearch_nonbrand' THEN order_id ELSE NULL END) AS Bsearch_nonbarnd_orders,
COUNT(DISTINCT CASE WHEN channel_type='Brand_search_overall' THEN order_id ELSE NULL END) AS Brand_overall_orders,
COUNT(DISTINCT CASE WHEN channel_type='Organic' THEN order_id ELSE NULL END) AS Organic_orders,
COUNT(DISTINCT CASE WHEN channel_type='Direct_type_in' THEN order_id ELSE NULL END) AS Direct_type_in_orders
FROM (SELECT website_session_id, created_at,
CASE
WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN 'Gsearch_nonbrand'
WHEN utm_source = 'Bsearch' AND utm_campaign = 'nonbrand' THEN 'Bsearch_nonbrand'
WHEN utm_campaign = 'brand' THEN 'Brand_search_overall'
WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'Organic'
WHEN http_referer IS NULL THEN 'Direct_type_in'
ELSE 'check_logic'
END AS 'channel_type' FROM website_sessions
) AS sess
LEFT JOIN orders ON sess.website_session_id = orders.website_session_id
GROUP BY 1,2)
SELECT SUM(Gsearch_nonbarnd_orders) AS Gsearch_nonbarnd_orders, SUM(Bsearch_nonbarnd_orders) AS Bsearch_nonbarnd_orders, 
SUM(Brand_overall_orders) AS Brand_overall_orders, SUM( Organic_orders) AS Organic_orders,
SUM(Direct_type_in_orders) AS Direct_type_in_orders
FROM CTE;

/*
11. To look at the entire session-to-order conversion rate trends for those same channels to see when major improvements or optimization were made.
*/

WITH CTE AS (SELECT
YEAR(sess.created_at) AS Yr,
QUARTER(sess.created_at) AS Qtr,
COUNT(DISTINCT CASE WHEN channel_type='Gsearch_nonbrand' THEN order_id ELSE NULL END)
/ COUNT(DISTINCT CASE WHEN channel_type='Gsearch_nonbrand' THEN sess.website_session_id ELSE NULL END) AS Gsearch_nonbarnd_conv_rt,
COUNT(DISTINCT CASE WHEN channel_type='Bsearch_nonbrand' THEN order_id ELSE NULL END)
/COUNT(DISTINCT CASE WHEN channel_type='Bsearch_nonbrand' THEN sess.website_session_id ELSE NULL END) AS Bsearch_nonbarnd_conv_rt,
COUNT(DISTINCT CASE WHEN channel_type='Brand_search_overall' THEN order_id ELSE NULL END)
/COUNT(DISTINCT CASE WHEN channel_type='Brand_search_overall' THEN sess.website_session_id ELSE NULL END) AS Brand_overall_conv_rt,
COUNT(DISTINCT CASE WHEN channel_type='Organic' THEN order_id ELSE NULL END)
/COUNT(DISTINCT CASE WHEN channel_type='Organic' THEN sess.website_session_id ELSE NULL END) AS Organic_conv_rt,
COUNT(DISTINCT CASE WHEN channel_type='Direct_type_in' THEN order_id ELSE NULL END)
/COUNT(DISTINCT CASE WHEN channel_type='Direct_type_in' THEN sess.website_session_id ELSE NULL END) AS Direct_type_in_conv_rt
FROM
(
SELECT
website_session_id,
created_at,
CASE
WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN 'Gsearch_nonbrand'
WHEN utm_source = 'Bsearch' AND utm_campaign = 'nonbrand' THEN 'Bsearch_nonbrand'
WHEN utm_campaign = 'brand' THEN 'Brand_search_overall'
WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'Organic'
WHEN http_referer IS NULL THEN 'Direct_type_in'
ELSE 'check_logic'
END AS 'channel_type'
FROM website_sessions
) AS sess
LEFT JOIN orders
ON sess.website_session_id = orders.website_session_id
GROUP BY 1,2) 
select sum(Gsearch_nonbarnd_conv_rt) AS Gsearch_nonbarnd_conv_rt, sum(Bsearch_nonbarnd_conv_rt) AS Bsearch_nonbarnd_conv_rt,
sum(Brand_overall_conv_rt) AS Brand_overall_conv_rt,sum(Organic_conv_rt) AS Organic_conv_rt, 
sum(Direct_type_in_conv_rt) AS Direct_type_in_conv_rt
from CTE;

/*
12. To show the entire session and order volume trended yearly during the life of the business
*/

SELECT 
    YEAR(website_sessions.created_at) AS Year,
    COUNT(DISTINCT website_sessions.website_session_id) AS Sessions,
    COUNT(DISTINCT order_id) AS Orders
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
GROUP BY 1
ORDER BY Orders DESC
