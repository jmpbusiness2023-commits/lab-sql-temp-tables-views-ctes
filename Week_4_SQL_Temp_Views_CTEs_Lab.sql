-- Customer Summary Report --

-- Step 1 : View Creation
DROP VIEW IF EXISTS customer_summary;
CREATE VIEW customer_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(*) AS rental_count
FROM
    customer c
INNER JOIN
    rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id;

-- Step 2 : Temporary table creation
CREATE TEMPORARY TABLE total_paid AS
SELECT
    cs.customer_id,
    SUM(p.amount) AS total_paid
FROM
    customer_summary cs
INNER JOIN
    payment p ON cs.customer_id = p.customer_id
GROUP BY
    cs.customer_id;

-- Step 3 : CTE Creation
WITH customer_details AS (
    SELECT
        cs.customer_id,
        cs.full_name,
        cs.email,
        cs.rental_count,
        tp.total_paid
    FROM
        customer_summary cs
    INNER JOIN
        total_paid tp ON cs.customer_id = tp.customer_id
)
-- Final Step : Query Execution average payment per rental (derived column from total_paid and rental_count)
SELECT
    customer_id,
    full_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS avg_payment_per_rental
FROM
    customer_details
ORDER BY
    total_paid DESC;



