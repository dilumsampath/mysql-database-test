-- Create Products table
CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(255),
    image VARCHAR(255),
    status VARCHAR(50),
    created_by VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ProductRestrictions table
CREATE TABLE ProductRestrictions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    type VARCHAR(50),
    sub_type VARCHAR(50),
    value INT,
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE
);

-- Create ProductTypes table
CREATE TABLE ProductTypes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    status VARCHAR(50)
);

-- Create ProductTypeAmounts table
CREATE TABLE ProductTypeAmounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    type_id INT,
    price DECIMAL(10, 2),
    currency VARCHAR(10),
    status VARCHAR(50),
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES ProductTypes(id) ON DELETE CASCADE
);

-- Create ProductTypeDistributions table
CREATE TABLE ProductTypeDistributions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    status VARCHAR(50)
);

-- Create ProductTypeDistributionAmounts table
CREATE TABLE ProductTypeDistributionAmounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_type_amount_id INT,
    product_type_distribution_id INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (product_type_amount_id) REFERENCES ProductTypeAmounts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_type_distribution_id) REFERENCES ProductTypeDistributions(id) ON DELETE CASCADE
);

-- Create Tags table (if needed)
CREATE TABLE Tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tag VARCHAR(255) UNIQUE
);

-- Create ProductTags table to handle many-to-many relationship
CREATE TABLE ProductTags (
    product_id INT,
    tag_id INT,
    PRIMARY KEY (product_id, tag_id),
    FOREIGN KEY (product_id) REFERENCES Products(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(id) ON DELETE CASCADE
);
