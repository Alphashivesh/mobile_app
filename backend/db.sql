DROP DATABASE IF EXISTS app_db;

CREATE DATABASE IF NOT EXISTS app_db;

USE app_db;

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    image_url VARCHAR(255) NOT NULL
);

INSERT INTO categories (name, image_url) VALUES
('Travel & Stay', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758222439/stay_dphvh5.avif'),
('Banquets & Venues', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758222442/venue_lsyc7f.jpg'),
('Retail stores & Shops', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758222440/shop_qz4dds.jpg'),
('Salons & Grooming', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758224308/saloon_dxfqty.png'),
('Fitness & Gyms', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227506/gym_igjeaf.jpg'),
('Jewelry & Accessories', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227507/jewel_czf2w0.jpg'),
('Fashion Boutiques', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227506/dress_x9my2b.png'),
('Gifts Shop', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227506/gift_gkeiyq.jpg'),
('Memories', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227506/memory_xjcueq.jpg'),
('Craft & Culture', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227506/craft_vauncw.jpg'),
('Smart Services', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227506/smart_skqdnv.jpg'),
('Casual Fun Games', 'https://res.cloudinary.com/dyhsntoii/image/upload/v1758227506/fun_byrepv.png');

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE travel_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    country VARCHAR(100),
    state VARCHAR(100),
    destination_city VARCHAR(255),
    check_in_date DATE,
    check_out_date DATE,
    num_travelers INT,
    num_rooms INT,
    num_children INT,
    traveler_type VARCHAR(100),
    accommodation_type VARCHAR(100),
    budget DECIMAL(10, 2),
    currency VARCHAR(10),
    offer_within_hours INT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE banquet_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_type VARCHAR(100),
    country VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    event_dates TEXT,
    num_adults INT,
    catering_preference VARCHAR(50),
    cuisines TEXT,
    budget DECIMAL(10, 2),
    currency VARCHAR(10),
    offer_within_hours INT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE retail_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_category VARCHAR(255),
    item_description TEXT,
    quantity INT,
    brand_preference VARCHAR(255),
    item_condition VARCHAR(50),
    delivery_location VARCHAR(255),
    budget DECIMAL(10, 2),
    currency VARCHAR(10),
    offer_within_hours INT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE saloon_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    service_type VARCHAR(255),
    preferred_date DATE,
    preferred_time VARCHAR(50),
    customer_gender VARCHAR(50),
    stylist_preference VARCHAR(100), 
    budget DECIMAL(10, 2),         
    special_requests TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE gym_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    activity_type VARCHAR(255),
    duration_months INT,
    customer_gender VARCHAR(50),
    intensity_level VARCHAR(100),
    focus_area VARCHAR(255),
    workout_goal TEXT,
    equipment_used TEXT,
    nutrition_link VARCHAR(255),
    location VARCHAR(255),
    special_requests TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE jewelry_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_type VARCHAR(255),
    material VARCHAR(255),
    gemstone VARCHAR(255),
    size_details VARCHAR(255),
    customization_details TEXT,
    design_reference_url VARCHAR(500),
    occasion VARCHAR(255),
    budget DECIMAL(10, 2),
    currency VARCHAR(10),
    delivery_deadline DATE,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fashion_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    clothing_type VARCHAR(255),
    size VARCHAR(50),
    color_preference VARCHAR(100),
    fabric_type VARCHAR(100),
    pattern_or_style VARCHAR(100),
    brand_preference VARCHAR(100),
    gender VARCHAR(20),
    occasion VARCHAR(255),
    occasion_type VARCHAR(100),
    budget DECIMAL(10,2),
    currency VARCHAR(10),
    preferred_date DATE,
    additional_notes TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE gifts_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    occasion VARCHAR(255),
    recipient_gender VARCHAR(50),
    recipient_age_group VARCHAR(50),
    recipient_relation VARCHAR(100),
    gift_category VARCHAR(255),
    gift_type VARCHAR(100),
    price_range VARCHAR(100),
    currency VARCHAR(10),
    personalization_details TEXT,
    preferred_brands VARCHAR(255),
    preferred_date DATE,
    urgency_level ENUM('Low','Medium','High') DEFAULT 'Medium',
    additional_notes TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE memories_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_type VARCHAR(255),
    service_type VARCHAR(100),
    event_date DATE,
    location VARCHAR(255),
    theme_or_mood VARCHAR(255),
    guest_count INT,
    budget DECIMAL(10,2),
    currency VARCHAR(10),
    preferred_photographer VARCHAR(255),
    media_types VARCHAR(255),
    special_requests TEXT,
    additional_notes TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE craft_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    craft_type VARCHAR(255),
    description TEXT,
    material_type VARCHAR(100),
    color_preferences VARCHAR(100),
    size_or_dimensions VARCHAR(100),
    quantity INT,
    budget DECIMAL(10,2),
    currency VARCHAR(10),
    personalization_details TEXT,
    preferred_date DATE,
    additional_notes TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE smart_services_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    service_category VARCHAR(255),
    description TEXT,
    preferred_date DATE,
    time_slot VARCHAR(100),
    budget DECIMAL(10,2),
    currency VARCHAR(10),
    additional_notes TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE games_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    game_type VARCHAR(255),
    num_players INT,
    age_group VARCHAR(50),
    location_type VARCHAR(100),
    location_details VARCHAR(255),
    event_date DATE,
    event_time VARCHAR(50),
    budget DECIMAL(10,2),
    currency VARCHAR(10),
    equipment_needed TEXT,
    additional_notes TEXT,
    submission_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
