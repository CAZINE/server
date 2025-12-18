-- Tabela para armazenar as gangues
CREATE TABLE IF NOT EXISTS gangs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    data LONGTEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela opcional para convites pendentes (se quiser persistir convites)
CREATE TABLE IF NOT EXISTS gang_invites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    gang_name VARCHAR(50) NOT NULL,
    player_id INT NOT NULL,
    invited_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP DEFAULT (CURRENT_TIMESTAMP + INTERVAL 24 HOUR),
    FOREIGN KEY (gang_name) REFERENCES gangs(name) ON DELETE CASCADE
);

-- Índices para melhor performance
CREATE INDEX idx_gangs_name ON gangs(name);
CREATE INDEX idx_invites_player ON gang_invites(player_id);
CREATE INDEX idx_invites_gang ON gang_invites(gang_name); 