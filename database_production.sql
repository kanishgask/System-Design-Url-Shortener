-- ==============================
-- SCALABLE URL SHORTENER DATABASE
-- Production-Level SQL Script
-- ==============================

-- 1️⃣ MAIN TABLE
CREATE TABLE IF NOT EXISTS urls (
    id BIGSERIAL PRIMARY KEY,
    original_url TEXT NOT NULL,
    short_code VARCHAR(10) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    click_count BIGINT DEFAULT 0,
    expiry_date TIMESTAMP NULL
);

-- Prevent duplicate original URLs
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_original_url 
ON urls(original_url);

-- 2️⃣ PERFORMANCE INDEXING

-- Fast redirect lookup
CREATE INDEX IF NOT EXISTS idx_short_code 
ON urls(short_code);

-- Analytics query optimization
CREATE INDEX IF NOT EXISTS idx_created_at 
ON urls(created_at);

-- Expiry cleanup optimization
CREATE INDEX IF NOT EXISTS idx_expiry_date 
ON urls(expiry_date);


-- 3️⃣ CLICK LOG TABLE (For Analytics)
CREATE TABLE IF NOT EXISTS click_logs (
    id BIGSERIAL PRIMARY KEY,
    short_code VARCHAR(10),
    clicked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 4️⃣ STORED PROCEDURE: INSERT URL
CREATE OR REPLACE FUNCTION insert_url(
    p_original_url TEXT,
    p_short_code VARCHAR,
    p_expiry TIMESTAMP DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO urls(original_url, short_code, expiry_date)
    VALUES(p_original_url, p_short_code, p_expiry)
    ON CONFLICT (original_url) DO NOTHING;
END;
$$ LANGUAGE plpgsql;


-- 5️⃣ STORED PROCEDURE: GET ORIGINAL URL
CREATE OR REPLACE FUNCTION get_original_url(
    p_short_code VARCHAR
)
RETURNS TEXT AS $$
DECLARE
    result TEXT;
BEGIN
    SELECT original_url INTO result
    FROM urls
    WHERE short_code = p_short_code
    AND (expiry_date IS NULL OR expiry_date > NOW());
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;


-- 6️⃣ STORED PROCEDURE: INCREMENT CLICK COUNT
CREATE OR REPLACE FUNCTION increment_click(
    p_short_code VARCHAR
)
RETURNS VOID AS $$
BEGIN
    UPDATE urls
    SET click_count = click_count + 1
    WHERE short_code = p_short_code;
END;
$$ LANGUAGE plpgsql;


-- 7️⃣ TRIGGER FUNCTION TO LOG EVERY CLICK
CREATE OR REPLACE FUNCTION log_click()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO click_logs(short_code)
    VALUES (NEW.short_code);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- 8️⃣ TRIGGER CREATION
DROP TRIGGER IF EXISTS click_trigger ON urls;

CREATE TRIGGER click_trigger
AFTER UPDATE OF click_count ON urls
FOR EACH ROW
WHEN (NEW.click_count > OLD.click_count)
EXECUTE FUNCTION log_click();


-- 9️⃣ ANALYTICS QUERY: TOP 10 MOST CLICKED
-- (Use manually when needed)
-- SELECT short_code, click_count
-- FROM urls
-- ORDER BY click_count DESC
-- LIMIT 10;


-- 🔟 EXPIRED LINK CLEANUP QUERY
-- (Run via cron job / scheduler)
-- DELETE FROM urls
-- WHERE expiry_date IS NOT NULL
-- AND expiry_date < NOW();


-- ==============================
-- END OF PRODUCTION DATABASE SETUP
-- ==============================
