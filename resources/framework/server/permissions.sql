-- Tabela para armazenar permissões dos jogadores
CREATE TABLE IF NOT EXISTS `player_permissions` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `player_name` varchar(100) NOT NULL,
    `group_name` varchar(50) NOT NULL DEFAULT 'user',
    `added_by` varchar(50) DEFAULT NULL,
    `added_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_login` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS `idx_identifier` ON `player_permissions` (`identifier`);
CREATE INDEX IF NOT EXISTS `idx_group` ON `player_permissions` (`group_name`);

CREATE TABLE IF NOT EXISTS `bans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(100) NOT NULL,
    `player_name` VARCHAR(100) NOT NULL,
    `banned_by` VARCHAR(100) NOT NULL,
    `reason` VARCHAR(255) NOT NULL,
    `ban_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `expire_date` TIMESTAMP NULL DEFAULT NULL
);
CREATE INDEX IF NOT EXISTS `idx_ban_identifier` ON `bans` (`identifier`); 