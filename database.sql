CREATE DATABASE editors_marketplace;
USE editors_marketplace;


CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    banner_icon VARCHAR(255),
    social_media JSON,
    saved_products JSON,
    liked_products JSON,
    search_history JSON,
    cart JSON,
    order_info TEXT,
    editing_preferences JSON, -- stores survey info (editing style, tools used)
    is_seller BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_info TEXT,
    showcase_video VARCHAR(255),
    price DECIMAL(10, 2),
    product_type ENUM('project_file', 'resource_pack', 'course', 'tutorial'),
    discount_percentage INT,
    discount_expiry DATETIME,
    discount_code VARCHAR(50),
    product_images JSON,
    file_link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE videos (
    video_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    video_url VARCHAR(255),
    quality VARCHAR(10),
    speed FLOAT,
    volume INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE wishlist (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    comment_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    privileges TEXT,
    deleted BOOLEAN DEFAULT FALSE,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE tags (
    tag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(50) UNIQUE
);

CREATE TABLE product_tags (
    product_id INT,
    tag_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id),
    PRIMARY KEY (product_id, tag_id)
);
CREATE TABLE product_analytics (
    product_id INT,
    views INT DEFAULT 0,
    downloads INT DEFAULT 0,
    purchases INT DEFAULT 0,
    last_viewed TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE follows (
    follower_id INT,
    followed_id INT,
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followed_id) REFERENCES users(user_id),
    PRIMARY KEY (follower_id, followed_id)
);
CREATE TABLE user_survey (
    user_id INT PRIMARY KEY,
    editing_tools JSON,        -- e.g. ["After Effects", "Vegas Pro"]
    product_interest JSON,     -- e.g. ["resource_pack", "project_file"]
    editing_style VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE downloads (
    download_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    download_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    subject VARCHAR(255),
    description TEXT,
    status ENUM('open', 'in_progress', 'resolved') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE referrals (
    referrer_id INT,
    referred_id INT,
    reward_earned BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (referrer_id) REFERENCES users(user_id),
    FOREIGN KEY (referred_id) REFERENCES users(user_id),
    PRIMARY KEY (referrer_id, referred_id)
);
