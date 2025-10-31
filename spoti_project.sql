create database spoti;
 use spoti;
 CREATE TABLE spotify_users (
 user_id INT PRIMARY KEY,
 gender VARCHAR(10),
 age INT,
 country VARCHAR(5),
 subscription_type VARCHAR(20),
 listening_time INT,
 songs_played_per_day INT,
 skip_rate FLOAT,
 device_type VARCHAR(20),
 ads_listened_per_week INT,
 offline_listening INT,
 is_churned INT,
 FOREIGN KEY (subscription_type) REFERENCES subscription_cost(subscription_type)
);
CREATE TABLE subscription_cost (
 subscription_type VARCHAR(20) PRIMARY KEY,
 monthly_cost DECIMAL(5,2)
);

INSERT INTO subscription_cost VALUES
('Free', 0),
('Student', 4.99),
('Family', 14.99),
('Premium', 9.99);

select * from spotify_churn_dataset;

-- Top 5 countries with most churned users. 

SELECT 
    country, 
    COUNT(*) AS churned_users
FROM spotify_churn_dataset
WHERE is_churned = 1
GROUP BY country
ORDER BY churned_users DESC
LIMIT 5;

-- Find users above age 40 with Premium subscription. 

SELECT 
    user_id,
    age,
    country
FROM spotify_churn_dataset
WHERE age > 40 
  AND subscription_type = 'Premium';
  
   
   -- Find churn rate by subscription type.
  
  SELECT 
    subscription_type,
    ROUND(
        (SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 
        2
    ) AS churn_rate_percentage
FROM spotify_churn_dataset
GROUP BY subscription_type
ORDER BY churn_rate_percentage DESC;

-- Find top 5 users with highest skip rate.

SELECT 
    user_id,
    skip_rate,
    country,
    subscription_type
FROM spotify_churn_dataset
ORDER BY skip_rate DESC
LIMIT 5;

-- Find users who play more songs than the average daily songs. 

SELECT 
    user_id,
    songs_played_per_day,
    country,
    subscription_type
FROM spotify_churn_dataset
WHERE songs_played_per_day > (
    SELECT AVG(songs_played_per_day) 
    FROM spotify_churn_dataset
);

-- Find average listening time per subscription cost

SELECT 
    sc.subscription_type,
    sc.monthly_cost,
    ROUND(AVG(su.listening_time), 2) AS avg_listening_time
FROM spotify_churn_dataset su
JOIN subscription_cost sc
    ON su.subscription_type = sc.subscription_type
GROUP BY sc.subscription_type, sc.monthly_cost
ORDER BY avg_listening_time DESC;

