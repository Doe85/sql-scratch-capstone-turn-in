-- 1.1 Quiz Funnel – Table Content
SELECT *
FROM survey
LIMIT 10;



-- 2.1 Quiz Funnel – User journey
SELECT question, COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;



-- 3.2 Quiz Funnel – Step 3
SELECT response, COUNT(response) AS 'Responses'
FROM survey
WHERE question LIKE '3. Which shapes do you like?'
GROUP BY response;



-- 3.3 Quiz Funnel – Step 5
SELECT response, COUNT(response) AS 'Responses'
FROM survey
WHERE question LIKE '5.%'
GROUP BY response;



-- 4.1 Home Try-On Funnel
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;



-- 5.1 Home Try-On Funnel – Joining tables
SELECT
   DISTINCT quiz.user_id,
   home_try_on.user_id IS NOT NULL AS 'Received sample?',
   home_try_on.number_of_pairs,
   purchase.user_id IS NOT NULL AS 'Purchased?'
FROM quiz
LEFT JOIN home_try_on
   ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
   ON purchase.user_id = quiz.user_id
LIMIT 10;



-- 6.1 Actionable Insights – Conversion Rates (Overall)
WITH funnel AS (
SELECT
   DISTINCT quiz.user_id AS 'tested',
   home_try_on.user_id IS NOT NULL AS 'received_sample',
   home_try_on.number_of_pairs,
   purchase.user_id IS NOT NULL AS 'purchased'
FROM quiz
LEFT JOIN home_try_on
   ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
   ON purchase.user_id = quiz.user_id)

SELECT
   COUNT(*) AS 'num_tested',
   SUM(purchased) AS 'num_purchased',
   1.0 * SUM(purchased) / COUNT(tested) AS 'tested_to_conversion'
FROM funnel;



-- 6.2 Actionable Insights – Conversion Rates (By steps)
WITH funnel AS (
SELECT
  DISTINCT quiz.user_id,
  home_try_on.user_id IS NOT NULL AS 'received_sample',
  home_try_on.number_of_pairs,
  purchase.user_id IS NOT NULL AS 'purchased'
FROM quiz
LEFT JOIN home_try_on
  ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
  ON purchase.user_id = quiz.user_id)

SELECT COUNT(*) AS 'num_tested',
  SUM(received_sample) AS 'num_received_sample',
  SUM(Purchased) AS 'num_purchased',
  1.0 * SUM(received_sample) / COUNT(user_id) AS 'tested_to_received_sample',
  1.0 * SUM(purchased) / SUM(received_sample) AS 'sample_to_purchase'
FROM funnel;



-- 6.3 Actionable Insights – Conversion Rates (By type)
WITH funnel AS (
SELECT
   DISTINCT quiz.user_id AS 'tested',
   home_try_on.user_id IS NOT NULL AS 'received_sample',
   home_try_on.number_of_pairs,
   purchase.user_id IS NOT NULL AS 'purchased'
FROM quiz
LEFT JOIN home_try_on
   ON quiz.user_id = home_try_on.user_id
LEFT JOIN purchase
   ON purchase.user_id = quiz.user_id)

SELECT number_of_pairs,
SUM(received_sample) AS 'num_received',
SUM(purchased) AS 'num_purchased',
1.0 * SUM(purchased) / COUNT(received_sample) AS 'Conversions'
FROM funnel
GROUP BY number_of_pairs;



-- 6.4 Extra Insights – Demographic split
WITH style_choice AS (
SELECT
   style,
   COUNT(style) AS 'Choices'
FROM quiz
GROUP BY style)

SELECT
   style,
   Choices AS 'Total Choices',
   1.0 * Choices / 1000 AS 'Split %'
FROM style_choice
GROUP BY style;



-- 6.4 Extra Insights – Popular purchases
SELECT
   product_id,
   style,
   model_name,
   color,
   COUNT(product_id) AS Purchases
FROM purchase
GROUP BY product_id
ORDER BY Purchases DESC;
