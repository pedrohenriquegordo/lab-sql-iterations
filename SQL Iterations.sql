use sakila;

#1
SELECT B.store_id, ROUND(SUM(A.amount),2) as total_business
FROM payment A
JOIN customer B ON A.customer_id = B.customer_id
GROUP BY store_id;

#2
DELIMITER $$
CREATE PROCEDURE total_business_by_store()
BEGIN
	SELECT B.store_id, ROUND(SUM(A.amount),2) as total_business
	FROM payment A
	JOIN customer B ON A.customer_id = B.customer_id
	GROUP BY store_id;
END $$
DELIMITER ;

CALL total_business_by_store();

#3
DROP PROCEDURE total_sales_by_store;
DELIMITER $$
CREATE PROCEDURE total_sales_by_store(IN store_n INT)
BEGIN
	SELECT ROUND(SUM(A.amount),2) as total_sales
	FROM payment A
	JOIN customer B ON A.customer_id = B.customer_id
	WHERE B.store_id=store_n;
END $$
DELIMITER ;

CALL total_sales_by_store(1);
CALL total_sales_by_store(2);

#4
DROP PROCEDURE total_sales_by_store;
DELIMITER $$
CREATE PROCEDURE total_sales_by_store(IN store_n INT)
BEGIN
	DECLARE total_sales_value FLOAT;
	SELECT ROUND(SUM(A.amount),2) as total_sales
	FROM payment A
	JOIN customer B ON A.customer_id = B.customer_id
	WHERE B.store_id=store_n;
	SET total_sales_value = (SELECT total_sales_by_store());
END $$
DELIMITER ;

#5
DROP PROCEDURE total_sales_by_store_with_flag;
DELIMITER $$
CREATE PROCEDURE total_sales_by_store_with_flag(IN p_store_id INT, OUT p_total_sales FLOAT, OUT p_flag VARCHAR(10))
BEGIN
  SELECT SUM(amount) INTO p_total_sales
  FROM payment
  WHERE store_id = p_store_id;
  
  IF p_total_sales > 30000 THEN
    SET p_flag = 'green_flag';
  ELSE
    SET p_flag = 'red_flag';
  END IF;
END $$
DELIMITER ;








