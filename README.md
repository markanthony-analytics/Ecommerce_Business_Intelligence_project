## The Situation
Umax-eshop has been operational for eight months, and the CEO is expected to deliver corporate performance metrics to the board of directors. As the hired ecommerce data Analyst, I will be in charge of developing relevant indicators to demonstrate the company's prospective growth.
As a part of the start-up team, I will support the CEO, Head of Marketing, and Website Manager in steering the business.
## Project Objective
My primary responsibilities include analysing and optimizing marketing channels, measuring and testing website conversion performance, and analysing data to determine the impact of new product launches.
## Project Execution
I'm going to use MYSQL to analyse landing page performance and conversion, as well as product-level sales. The SQL solution codes have been attacked to this repository as 
[sql_query_solution.sql](https://github.com/markanthony-analytics/Ecommerce_Business_Intelligence_project/blob/main/sql_query_solution.sql) .
Below is the Entity Relationship (ER) Diagram Model of Umax-eshop ecommerce database


![image](https://user-images.githubusercontent.com/102745680/211790796-f2064a57-6b11-4016-80ee-801618f4e52e.png)

 
## Understanding the Business Concept: TRAFFIC SOURCE ANALYSIS
This is all about understanding where your customers are coming from and which channels are bringing in the highest volume of traffic.
The common case use of the traffic source analysis are:
-	Identifying opportunities to reduce waste or increase high-converting traffic
-	Using user behaviour patterns from many traffic sources to inform creative and message strategy
I will be working with six related tables, which contain ecommerce data about:
-	Website Activity
-	Products
-	Orders and Refunds
But to properly understand website traffic and conversion rate, the key tables I will be using are website sessions table, pageviews and order tables. 
## Paid Marketing Campaigns: UTM TRACKING PARAMETERS
When companies run paid marketing campaigns, they frequently worry about performance and track everything: how much they spend, how effectively traffic converts to revenue, and so on.
Paid traffic is frequently tagged with tracking (UTM) parameters, which are appended to URLs and enable campaigner to attribute website activity to specific traffic sources and campaigns.
This is what UTM parameters look like: www.abcwebsite.com?utm_source trafficSource &utm_campaign campaignName
In this project, the website_sessions table has this attributes;



![image](https://user-images.githubusercontent.com/102745680/211791495-c2b4eb4e-4d14-4c15-a074-4b29490c32ab.png)

 
## TRAFIC SOURCE ANALYSIS
To identify paid website sessions, we use the utm parameters stored in the database. I can correlate the session data to the order data to determine how much revenue the paid campaigns are generating.


![image](https://user-images.githubusercontent.com/102745680/216010222-59c5e070-d78f-4dc0-a9cb-c8a3af3b1147.png)

![image](https://user-images.githubusercontent.com/102745680/211791576-75eb4934-c1c4-4c26-8b79-7110aafe119a.png)

 
To identify where the majority of website sessions are originating from at a particular time, it is necessary to obtain a breakdown of website traffic by UTM source, campaign, and referring domain.



![image](https://user-images.githubusercontent.com/102745680/216010908-9e020bae-8361-491a-b44c-a8401c5bf6cb.png)

![image](https://user-images.githubusercontent.com/102745680/211791633-8733e245-de96-434b-93cf-12ba1e8daa9c.png)

 
To understand the device-level performance of this campaign at a specific time frame, the conversion rates from session to order by device type must be determined.


![image](https://user-images.githubusercontent.com/102745680/216011588-b511980f-1d13-4373-9430-351b21e5444b.png)

![image](https://user-images.githubusercontent.com/102745680/211791691-ffd946e6-c601-49d8-8c30-303eeeb8c1bb.png)

 
The above device-level analysis of conversion rates shows that desktop was performing well. It is then suggested that the gsearch nonbrand campaigns be bid on desktop.
To dig deeper, we may extract weekly trends for both desktop and mobile, allowing us to examine the impact on session volume.


![image](https://user-images.githubusercontent.com/102745680/216012014-adccb254-ca5a-478f-bb1f-7ef8e841a69c.png)

 ![image](https://user-images.githubusercontent.com/102745680/211791737-d88ff3b4-23f3-450c-9122-4a41026a5aa6.png)

## Analysing Website Performance
Understanding which pages are visited the most by your users allows you to focus your efforts on enhancing your business.
The common use case are identifying the most frequently visited pages on your website by customers, identifying the pages on your website that are most frequently accessed by customers and Understanding how your most-viewed pages and most-frequently entered pages function in relation to your business objectives
I'll use a temporary table to determine the top entry pages by limiting to the first page a user sees during a given session.




![image](https://user-images.githubusercontent.com/102745680/211791816-138e02e3-35c0-4341-9866-f63485bb616a.png)

 
Now it is possible to get the most-viewed website pages ranked by session volume



![image](https://user-images.githubusercontent.com/102745680/211791864-cc626e78-16a9-4ed6-83cb-e0c84291fb25.png)

 
The homepage, products page, and Mr. Fuzzy page appear to receive the majority of website traffic.
To confirm where the users are hitting the website, it is possible pull all entry pages and rank them on entry volume. To achieve this, I have to create temporary table called firstpageview


![image](https://user-images.githubusercontent.com/102745680/216012940-0b6f1da2-75d1-42de-a455-f2498ba42bc6.png)

![image](https://user-images.githubusercontent.com/102745680/211791946-83d2f06d-7afd-4df7-8990-6bacd3708f92.png)

 
According to the analysis, it appears that all traffic comes in through the homepage!
It is rather evident where the Website Manager should concentrate any improvements.
## PRODUCT SALES ANALYSIS
I'll look at the order data and tie in the exact product(s) driving sales to evaluate sales performance at the product level.
I'll want to know how much of the order volume is from each product, as well as the total revenue and margin earned.


![image](https://user-images.githubusercontent.com/102745680/216013882-72be416d-f558-4e08-b973-6db96380bbbe.png)

![image](https://user-images.githubusercontent.com/102745680/211792010-3d665243-8178-4e13-b300-c7b961c681b9.png)

 
'The Original Mr. Fuzzy' is obviously doing very well in the advertising campaign.
On January 6, 2013, a new product was released. In order to understand the impact of this launch, I would like to obtain monthly order volume, overall conversion rates, revenue per session, and a breakdown of sales by product for the period beginning on April 1, 2013.



![image](https://user-images.githubusercontent.com/102745680/216014780-f061d7bf-0c03-4b5e-af8f-6cd804a65a8b.png)

![image](https://user-images.githubusercontent.com/102745680/211792076-4f6336c0-ea6c-48d5-b3c1-e202fb577546.png)

 
This confirms that the conversion rate and revenue per session are improving over time after the lunch of the second product.
Now I'd like to show how the campaign's specified channel has performed in terms of the overall volume of orders. The objective is to view orders coming from Gsearch, nonbrand, Bseach nonbrand, brand search overall, organic search, and direct type-in.



![image](https://user-images.githubusercontent.com/102745680/216015523-6db0efed-971a-4417-8adf-ad63fd42e768.png)

![image](https://user-images.githubusercontent.com/102745680/211792179-9f26937d-1ee0-4366-9020-a0094ee03a41.png)

 
According to the analysis above, the Gsearch utm source's nonband utm campaign has the highest order.
Let's look at the entire session-to-order conversion rate trends for those same channels to see when major improvements or optimization were made.
 
From the ongoing analysis, the brand utm campaign has the overall conversion rate. 
Let's show the entire session and order volume trended yearly during the life of the business.
 
### Here are the final project findings and recommendations:
1.	According to the device-level analysis of conversion rates, desktop was performing well. It is then proposed that nonbrand gsearch campaigns be bid on desktop.
2.	According to the website performance analysis, the homepage, products page, and Mr. Fuzzy page appear to receive the majority of website traffic. It is rather obvious where the Website Manager should focus any improvements.
3.	The product sales analysis revealed that 'The Original Mr. Fuzzy' is doing extremely well in the advertising campaign. It is consequently recommended that this product be given more attention in terms of upgrades in order to drive more sales. 


