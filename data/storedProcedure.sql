DELIMITER //

CREATE PROCEDURE InsertProducts(IN json_data JSON)
BEGIN
    -- Variable Declarations
    DECLARE product_id INT;
    DECLARE type_id INT;
    DECLARE distribution_id INT;
    DECLARE product_name VARCHAR(255);
    DECLARE product_description TEXT;
    DECLARE product_category VARCHAR(255);
    DECLARE product_image VARCHAR(255);
    DECLARE product_status VARCHAR(50);
    DECLARE product_tags VARCHAR(255);
    DECLARE restriction_type VARCHAR(50);
    DECLARE restriction_sub_type VARCHAR(50);
    DECLARE restriction_value INT;
    DECLARE type_name VARCHAR(255);
    DECLARE type_price DECIMAL(10, 2);
    DECLARE type_currency VARCHAR(10);
    DECLARE type_status VARCHAR(50);
    DECLARE distribution_name VARCHAR(255);
    DECLARE distribution_amount DECIMAL(10, 2);
    DECLARE done INT DEFAULT 0;
    DECLARE product_index INT DEFAULT 0;
    DECLARE type_index INT DEFAULT 0;
    DECLARE type_amount_id INT;

    -- Cursor Declarations
    DECLARE cur1 CURSOR FOR 
        SELECT 
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.name')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.description')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.category')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.image')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.status')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.tags'))
        FROM JSON_TABLE(json_data, "$.products[*]" COLUMNS (
            value JSON PATH "$"
        )) AS jt1;

    DECLARE cur2 CURSOR FOR 
        SELECT 
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.type')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.subType')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.value'))
        FROM JSON_TABLE(JSON_EXTRACT(json_data, CONCAT('$.products[', product_index, '].restrictions')), "$[*]" COLUMNS (
            value JSON PATH "$"
        )) AS jt2;

    DECLARE cur3 CURSOR FOR 
        SELECT 
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.name')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.price')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.currency')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.status'))
        FROM JSON_TABLE(JSON_EXTRACT(json_data, CONCAT('$.products[', product_index, '].types')), "$[*]" COLUMNS (
            value JSON PATH "$"
        )) AS jt3;

    DECLARE cur4 CURSOR FOR 
        SELECT 
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.name')),
            JSON_UNQUOTE(JSON_EXTRACT(value, '$.amount'))
        FROM JSON_TABLE(JSON_EXTRACT(json_data, CONCAT('$.products[', product_index, '].types[', type_index, '].distributions')), "$[*]" COLUMNS (
            value JSON PATH "$"
        )) AS jt4;

    -- Condition Handlers
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Begin Block
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO product_name, product_description, product_category, product_image, product_status, product_tags;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert into Products table
        INSERT INTO Products (name, description, category, image, status, tags, created_by)
        VALUES (product_name, product_description, product_category, product_image, product_status, product_tags, 'admin');

        SET product_id = LAST_INSERT_ID();

        -- Insert restrictions
        OPEN cur2;
        read_loop2: LOOP
            FETCH cur2 INTO restriction_type, restriction_sub_type, restriction_value;
            IF done THEN
                LEAVE read_loop2;
            END IF;

            INSERT INTO ProductRestrictions (product_id, type, sub_type, value)
            VALUES (product_id, restriction_type, restriction_sub_type, restriction_value);
        END LOOP read_loop2;
        CLOSE cur2;

        -- Insert types
        OPEN cur3;
        read_loop3: LOOP
            FETCH cur3 INTO type_name, type_price, type_currency, type_status;
            IF done THEN
                LEAVE read_loop3;
            END IF;

            INSERT INTO ProductTypes (name, status)
            VALUES (type_name, type_status);

            SET type_id = LAST_INSERT_ID();

            INSERT INTO ProductTypeAmounts (product_id, type_id, price, currency, status)
            VALUES (product_id, type_id, type_price, type_currency, type_status);

            SET type_amount_id = LAST_INSERT_ID();

            -- Insert distributions
            OPEN cur4;
            read_loop4: LOOP
                FETCH cur4 INTO distribution_name, distribution_amount;
                IF done THEN
                    LEAVE read_loop4;
                END IF;

                INSERT INTO ProductTypeDistributions (name, status)
                VALUES (distribution_name, 'active');

                SET distribution_id = LAST_INSERT_ID();

                INSERT INTO ProductTypeDistributionAmounts (product_type_amount_id, product_type_distribution_id, amount)
                VALUES (type_amount_id, distribution_id, distribution_amount);
            END LOOP read_loop4;
            CLOSE cur4;
        END LOOP read_loop3;
        CLOSE cur3;

        SET product_index = product_index + 1;
    END LOOP read_loop;
    CLOSE cur1;
END //

DELIMITER ;
