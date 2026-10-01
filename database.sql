CREATE TABLE IF NOT EXISTS trucker_job (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    freight_name VARCHAR(255) NOT NULL,
    status VARCHAR(255) NOT NULL,
    payment INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO trucker_job (player_id, freight_name, status, payment) VALUES
(1, 'Wood', 'completed', 500),
(2, 'Electronics', 'in_progress', 700);