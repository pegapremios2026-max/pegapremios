-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/12/2025 às 18:29
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `pegapremio`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `affiliate_groups`
--

CREATE TABLE `affiliate_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `commission_rate` decimal(5,2) NOT NULL COMMENT 'Porcentagem de comiss├úo (ex: 10.00 = 10%)',
  `revenue_share_rate` decimal(5,2) DEFAULT 0.00 COMMENT 'Porcentagem de revenue share',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `affiliate_groups`
--

INSERT INTO `affiliate_groups` (`id`, `name`, `description`, `commission_rate`, `revenue_share_rate`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Bronze', 'Grupo inicial de afiliados', 5.00, 0.00, 1, '2025-11-15 00:00:52', '2025-11-15 00:00:52'),
(2, 'Prata', 'Grupo intermedi├írio com melhor comiss├úo', 10.00, 2.00, 1, '2025-11-15 00:00:52', '2025-11-15 00:00:52'),
(3, 'Ouro', 'Grupo premium com m├íxima comiss├úo', 15.00, 5.00, 1, '2025-11-15 00:00:52', '2025-11-15 00:00:52');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `commissions`
--

CREATE TABLE `commissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `affiliate_id` int(10) UNSIGNED NOT NULL COMMENT 'Afiliado que recebe',
  `referred_user_id` int(10) UNSIGNED NOT NULL COMMENT 'Usu├írio indicado',
  `deposit_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Dep├│sito que gerou comiss├úo',
  `order_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Pedido/jogo que gerou comiss├úo',
  `amount` decimal(10,2) NOT NULL,
  `commission_rate` decimal(5,2) NOT NULL,
  `type` enum('deposit','game_loss','revenue_share','cpa','revshare','hybrid') DEFAULT 'deposit',
  `status` enum('pending','paid','revoked') DEFAULT 'paid',
  `paid_at` datetime DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `revoked_by` int(10) UNSIGNED DEFAULT NULL,
  `revoke_reason` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `deposits`
--

CREATE TABLE `deposits` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `gateway_id` int(10) UNSIGNED NOT NULL,
  `transactionId` varchar(100) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `bonus` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('pending','completed','failed','cancelled') DEFAULT 'pending',
  `document` varchar(255) DEFAULT NULL,
  `webhooks` text DEFAULT NULL,
  `payloads` text DEFAULT NULL,
  `pix` text DEFAULT NULL,
  `externalId` varchar(255) DEFAULT NULL COMMENT 'ID do pedido no gateway',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `game_configs`
--

CREATE TABLE `game_configs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `bg_top` varchar(255) DEFAULT NULL COMMENT 'Background top image',
  `bomb` varchar(255) DEFAULT NULL COMMENT 'Bomb image',
  `mold` varchar(255) DEFAULT NULL COMMENT 'Mold/frame image',
  `min_bombs` int(11) DEFAULT 3 COMMENT 'Minimum number of bombs',
  `max_bombs` int(11) DEFAULT 5 COMMENT 'Maximum number of bombs',
  `min_prizes` int(11) DEFAULT 8 COMMENT 'Minimum number of prizes',
  `max_prizes` int(11) DEFAULT 10 COMMENT 'Maximum number of prizes',
  `collected_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'Total collected amount',
  `paid_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'Total paid amount',
  `target_rtp` decimal(5,2) DEFAULT 25.00 COMMENT 'Target RTP percentage',
  `fixed_rtp` decimal(5,2) NOT NULL DEFAULT 30.00,
  `use_fixed_rtp` tinyint(1) NOT NULL DEFAULT 1,
  `bets` text DEFAULT NULL COMMENT 'Available bets JSON',
  `person_img` varchar(255) DEFAULT NULL COMMENT 'Person/character image',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `game_configs`
--

INSERT INTO `game_configs` (`id`, `bg_top`, `bomb`, `mold`, `min_bombs`, `max_bombs`, `min_prizes`, `max_prizes`, `collected_amount`, `paid_amount`, `target_rtp`, `fixed_rtp`, `use_fixed_rtp`, `bets`, `person_img`, `created_at`, `updated_at`) VALUES
(1, '/assets/border12.png', '/assets/bomb1.png', '/assets/moldurared.png', 3, 5, 8, 10, 0.00, 0.00, 10.00, 10.00, 1, NULL, '/assets/papainelupdate.png', '2025-11-15 19:39:37', '2025-12-05 20:12:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_11_15_215728_rename_balance_to_main_balance_in_users_table', 2),
(5, '2025_11_15_222859_add_missing_fields_to_users_table', 3),
(7, '2025_11_15_223155_update_prizes_table_to_match_original', 4),
(8, '2025_11_16_001353_add_remaining_columns_to_orders_table', 5),
(9, '2025_11_16_010000_rename_user_referral_fields_to_match_original', 6),
(10, '2025_11_16_020000_fix_prizes_table_structure', 6),
(11, '2025_11_16_030000_fix_deposits_table_structure', 6),
(12, '2025_11_16_040000_fix_payment_gateways_table_structure', 6),
(13, '2025_11_16_050000_fix_withdrawals_table_structure', 6),
(14, '2025_11_16_add_influencer_fields_to_users_table', 7),
(15, '2025_12_05_055040_add_api_fields_to_withdrawals_table', 8),
(16, '2025_12_05_073341_make_withdrawal_account_id_nullable_on_withdrawals', 9),
(17, '2025_12_05_161915_add_fixed_rtp_to_game_configs_table', 10);

-- --------------------------------------------------------

--
-- Estrutura para tabela `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `prize_id` int(10) UNSIGNED DEFAULT NULL,
  `rtp_before` decimal(10,2) NOT NULL DEFAULT 0.00,
  `rtp_after` decimal(10,2) NOT NULL DEFAULT 0.00,
  `amount` decimal(10,2) NOT NULL COMMENT 'Valor apostado',
  `status` enum('pending','win','loss') DEFAULT 'pending',
  `bet_amount` decimal(10,2) NOT NULL,
  `win_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `balance_before` decimal(10,2) NOT NULL,
  `balance_after` decimal(10,2) NOT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `device` text DEFAULT NULL,
  `origin` varchar(255) NOT NULL DEFAULT 'game',
  `is_demo` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `payment_gateways`
--

CREATE TABLE `payment_gateways` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(50) NOT NULL COMMENT 'C├│digo ├║nico (ex: pixup, pagseguro)',
  `image` varchar(255) DEFAULT NULL,
  `splits` text DEFAULT NULL,
  `endpoint` varchar(255) DEFAULT NULL,
  `needs_document` tinyint(1) NOT NULL DEFAULT 0,
  `route_cash_in` varchar(255) DEFAULT NULL,
  `route_cash_out` varchar(255) DEFAULT NULL,
  `clientId` varchar(255) DEFAULT NULL,
  `secretId` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_visible` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `payment_gateways`
--

INSERT INTO `payment_gateways` (`id`, `name`, `slug`, `image`, `splits`, `endpoint`, `needs_document`, `route_cash_in`, `route_cash_out`, `clientId`, `secretId`, `is_active`, `is_visible`, `created_at`, `updated_at`) VALUES
(1, 'SigiloPay', 'sigilopay', NULL, NULL, 'https://app.sigilopay.com.br/api/v1', 0, '/gateway/pix/receive', '/gateway/pix/send', NULL, NULL, 1, 0, '2025-11-15 00:00:52', '2025-12-05 17:16:53');

-- --------------------------------------------------------

--
-- Estrutura para tabela `prizes`
--

CREATE TABLE `prizes` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `gift_image` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'money',
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `percente` decimal(5,2) NOT NULL DEFAULT 0.00,
  `image` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `bet` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `prizes`
--

INSERT INTO `prizes` (`id`, `admin_id`, `gift_image`, `type`, `amount`, `percente`, `image`, `status`, `bet`, `created_at`, `updated_at`) VALUES
(1, 1, '/assets/prize1.png', 'money', 1.00, 0.00, '/assets/prizes/1real.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(2, 1, '/assets/prize2.png', 'money', 1.00, 0.00, '/assets/prizes/1real.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(3, NULL, '/assets/prize1.png', 'money', 2.00, 0.00, '/assets/prizes/2reais.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(4, NULL, '/assets/prize3.png', 'money', 0.50, 0.00, '/assets/prizes/50centavos.png', 1, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(5, NULL, '/assets/prize4.png', 'money', 0.50, 0.00, '/assets/prizes/50centavos.png', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(6, NULL, '/assets/prize1.png', 'money', 0.10, 0.00, '/assets/prizes/10cents.png', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(7, NULL, '/assets/prize1.png', 'money', 0.25, 0.00, '/assets/prizes/25cents.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(8, NULL, '/assets/prize1.png', 'money', 3.00, 0.00, '/assets/prizes/3reais.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(9, NULL, '/assets/prize1.png', 'money', 5.00, 0.00, '/assets/prizes/5reais.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(10, NULL, '/assets/prize1.png', 'money', 10.00, 0.00, '/assets/prizes/10reais.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(11, NULL, '/assets/prize1.png', 'money', 25.00, 0.00, '/assets/prizes/J9rvJ5mwkwFHWcUvViBLfgRO6nnzkGYcuQoDy2B7.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(12, NULL, '/assets/prize1.png', 'money', 50.00, 0.00, '/assets/prizes/50reais.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(13, NULL, '/assets/prize1.png', 'money', 100.00, 0.00, '/assets/prizes/baekOzmpUqf0Wwfyv7oP7e9j87qSGfRNnFqPi277.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(14, NULL, '/assets/prize1.png', 'money', 200.00, 0.00, '/assets/prizes/200reais.webp', 1, 0.50, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(15, NULL, '/assets/prize2.png', 'money', 0.50, 0.00, '/assets/prizes/50centavos.png', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(16, NULL, '/assets/prize2.png', 'money', 2.00, 0.00, '/assets/prizes/2reais.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(17, NULL, '/assets/prize2.png', 'money', 5.00, 0.00, '/assets/prizes/5reais.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(18, NULL, '/assets/prize2.png', 'money', 10.00, 0.00, '/assets/prizes/10reais.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(19, NULL, '/assets/prize2.png', 'money', 15.00, 0.00, '/assets/prizes/15reais.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(20, NULL, '/assets/prize2.png', 'money', 20.00, 0.00, '/assets/prizes/JlMiM0mjOD1WeqWlemMOUTi8jjGeCVRpO1ChFXhf.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(21, NULL, '/assets/prize2.png', 'money', 50.00, 0.00, '/assets/prizes/50reais.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(22, NULL, '/assets/prize2.png', 'money', 100.00, 0.00, '/assets/prizes/6PdCyFWp2pNakkt4SFTgztIUi7QmWmQJSq5XKjoE.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(23, NULL, '/assets/prize2.png', 'money', 200.00, 0.00, '/assets/prizes/200reais.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(24, NULL, '/assets/prize2.png', 'money', 500.00, 0.00, '/assets/prizes/500conto.webp', 1, 1.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(25, NULL, '/assets/prize4.png', 'money', 1.00, 0.00, '/assets/prizes/1real.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(26, NULL, '/assets/prize4.png', 'money', 2.00, 0.00, '/assets/prizes/2reais.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(27, NULL, '/assets/prize4.png', 'money', 5.00, 0.00, '/assets/prizes/5reais.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(28, NULL, '/assets/prize4.png', 'money', 15.00, 0.00, '/assets/prizes/15reais.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(29, NULL, '/assets/prize4.png', 'money', 20.00, 0.00, '/assets/prizes/GNXoAaFLiy2j9Q5Yqnx8kDPz6829igF7JB9DWfZn.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(30, NULL, '/assets/prize4.png', 'money', 50.00, 0.00, '/assets/prizes/50reais.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(31, NULL, '/assets/prize4.png', 'money', 100.00, 0.00, '/assets/prizes/I2kgiCbxgwV3ZXpFTPYckCTSVrRwV5kuucfeaiu2.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(32, NULL, '/assets/prize4.png', 'money', 200.00, 0.00, '/assets/prizes/200reais.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(33, NULL, '/assets/prize4.png', 'money', 500.00, 0.00, '/assets/prizes/500conto.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(34, NULL, '/assets/prize4.png', 'money', 1000.00, 0.00, '/assets/prizes/1k.webp', 1, 5.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(35, NULL, '/assets/prize3.png', 'money', 1.00, 0.00, '/assets/prizes/1real.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(36, NULL, '/assets/prize3.png', 'money', 2.00, 0.00, '/assets/prizes/2reais.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(37, NULL, '/assets/prize3.png', 'money', 3.00, 0.00, '/assets/prizes/3reais.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(38, NULL, '/assets/prize3.png', 'money', 5.00, 0.00, '/assets/prizes/5reais.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(39, NULL, '/assets/prize3.png', 'money', 10.00, 0.00, '/assets/prizes/10reais.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(40, NULL, '/assets/prize3.png', 'money', 15.00, 0.00, '/assets/prizes/15reais.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(41, NULL, '/assets/prize3.png', 'money', 20.00, 0.00, '/assets/prizes/Mi0Ku9ejhTpvTqfUdH3ONGQomDH4Gdy8UlwzCpOq.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(42, NULL, '/assets/prize3.png', 'money', 50.00, 0.00, '/assets/prizes/50reais.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(43, NULL, '/assets/prize3.png', 'money', 100.00, 0.00, '/assets/prizes/ViPPF1Ela2mvp5yTvHKPVtqGqSvoYh1TAYJPNri0.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(44, NULL, '/assets/prize3.png', 'money', 200.00, 0.00, '/assets/prizes/200reais.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(45, NULL, '/assets/prize3.png', 'money', 500.00, 0.00, '/assets/prizes/500conto.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07'),
(46, NULL, '/assets/prize3.png', 'money', 700.00, 0.00, '/assets/prizes/vdYMY8Lr4NcWjHQ3pVtlxyaeuQRiBvC0C7QgSNmG.webp', 0, 2.00, '2025-10-22 00:10:07', '2025-10-22 00:10:07');

-- --------------------------------------------------------

--
-- Estrutura para tabela `rewards`
--

CREATE TABLE `rewards` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('first_deposit','daily_login','referral_bonus','cashback') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Condi├º├Áes para receber' CHECK (json_valid(`conditions`)),
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `rewards`
--

INSERT INTO `rewards` (`id`, `name`, `description`, `type`, `amount`, `conditions`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'B├┤nus de Primeiro Dep├│sito', 'Ganhe 100% do valor do primeiro dep├│sito', 'first_deposit', 0.00, NULL, 1, '2025-11-15 00:00:52', '2025-11-15 00:00:52'),
(2, 'Cashback Semanal', 'Receba 5% de cashback nas perdas da semana', 'cashback', 0.00, NULL, 1, '2025-11-15 00:00:52', '2025-11-15 00:00:52');

-- --------------------------------------------------------

--
-- Estrutura para tabela `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `system_settings`
--

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `description`, `updated_at`) VALUES
(1, 'site_name', 'PegaPremio', 'Nome do site', '2025-11-15 00:00:52'),
(2, 'min_deposit', '10.00', 'Valor m├¡nimo de dep├│sito', '2025-11-15 00:00:52'),
(3, 'max_deposit', '10000.00', 'Valor m├íximo de dep├│sito', '2025-11-15 00:00:52'),
(4, 'min_withdrawal', '10.00', 'Valor m├¡nimo de saque', '2025-12-05 04:31:34'),
(5, 'max_withdrawal', '50000.00', 'Valor m├íximo de saque', '2025-11-15 00:00:52'),
(6, 'game_enabled', '1', 'Sistema de jogos ativado', '2025-11-15 00:00:52'),
(7, 'affiliate_enabled', '1', 'Sistema de afiliados ativado', '2025-11-15 00:00:52'),
(8, 'logo', '/assets/logo.png', 'Logo do site', '2025-11-15 23:28:33'),
(9, 'favicon', '/assets/favlog.png', 'Favicon do site', '2025-11-15 23:28:33'),
(10, 'email', 'suporte@pegapremio.com', 'Email de suporte', '2025-12-05 14:29:41'),
(11, 'version', '1.0.0', 'VersÒo do sistema', '2025-11-15 16:03:05'),
(12, 'shortcuts_deposits', '[10,20,50,100,250,500]', 'Atalhos de dep¾sito', '2025-12-05 01:40:09'),
(13, 'game_max_prizes', '10', 'Maximum number of prizes to generate in the game', '2025-11-15 16:24:43'),
(14, 'game_min_prizes', '5', 'Minimum number of prizes to generate in the game', '2025-11-15 16:24:43'),
(15, 'game_max_bombs', '3', 'Maximum number of bombs to generate in the game', '2025-11-15 16:24:43'),
(16, 'game_min_bombs', '1', 'Minimum number of bombs to generate in the game', '2025-11-15 16:24:43'),
(17, 'affiliate_default_type', 'revshare', 'Tipo padrÒo de afiliado', '2025-12-05 02:15:55'),
(18, 'affiliate_default_cpa', '5.00', 'CPA padrÒo (R$)', '2025-12-05 02:15:55'),
(19, 'affiliate_default_percent', '10.00', 'RevShare padrÒo (%)', '2025-12-05 02:15:55');

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `provider_id` varchar(255) DEFAULT NULL,
  `cpf` varchar(14) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `role` enum('user','affiliate','admin') DEFAULT 'user',
  `is_demo` tinyint(1) NOT NULL DEFAULT 0,
  `xp` int(11) NOT NULL DEFAULT 0,
  `main_balance` decimal(10,2) DEFAULT 0.00,
  `affiliate_balance` decimal(10,2) DEFAULT 0.00,
  `is_affiliate` tinyint(1) DEFAULT 0,
  `is_influencer` int(11) NOT NULL DEFAULT 0,
  `influencer_rtp_boost` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT 'RTP boost percentage for influencers (e.g., 5.00 for 5%)',
  `invite_code` varchar(20) DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `affiliate_group_id` int(10) UNSIGNED DEFAULT NULL,
  `affiliate_type` varchar(255) NOT NULL DEFAULT 'cpa',
  `cpa_value` decimal(10,2) DEFAULT NULL,
  `baseline` decimal(10,2) DEFAULT NULL,
  `percent` decimal(10,2) NOT NULL DEFAULT 0.00,
  `revshare_percent` decimal(10,2) DEFAULT NULL,
  `custom_affiliate_config` tinyint(1) NOT NULL DEFAULT 0,
  `total_commission` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_withdrawn` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_deposit` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('active','banned','pending') DEFAULT 'active',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `is_banned` tinyint(1) NOT NULL DEFAULT 0,
  `ban_reason` text DEFAULT NULL,
  `registration_ip` varchar(255) DEFAULT NULL,
  `registration_device` varchar(255) DEFAULT NULL,
  `last_activity_at` timestamp NULL DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `token_expires_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `last_login_ip` varchar(255) DEFAULT NULL,
  `last_login_user_agent` text DEFAULT NULL,
  `last_login_device` varchar(255) DEFAULT NULL,
  `last_login_location` varchar(255) DEFAULT NULL,
  `last_password_change_at` timestamp NULL DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `provider`, `provider_id`, `cpf`, `phone`, `birth_date`, `role`, `is_demo`, `xp`, `main_balance`, `affiliate_balance`, `is_affiliate`, `is_influencer`, `influencer_rtp_boost`, `invite_code`, `parent_id`, `affiliate_group_id`, `affiliate_type`, `cpa_value`, `baseline`, `percent`, `revshare_percent`, `custom_affiliate_config`, `total_commission`, `total_withdrawn`, `total_deposit`, `status`, `is_active`, `is_banned`, `ban_reason`, `registration_ip`, `registration_device`, `last_activity_at`, `token`, `token_expires_at`, `last_login_at`, `last_login_ip`, `last_login_user_agent`, `last_login_device`, `last_login_location`, `last_password_change_at`, `created_at`, `updated_at`) VALUES
(1, 'Administrador', 'admin@gmail.com', NULL, '$2y$12$YIi5hyrjsSxzaNFQOXOkL.Qx.lR9SqtNW8kmV3R953DXjXyMfs96W', NULL, NULL, NULL, NULL, NULL, NULL, 'admin', 0, 0, 0.00, 0.00, 1, 1, 70.00, 'ADMIN001', NULL, NULL, 'revshare', 5.00, NULL, 10.00, 10.00, 0, 0.00, 0.00, 0.00, 'active', 1, 0, NULL, NULL, NULL, '2025-12-05 18:31:02', NULL, NULL, '2025-12-05 15:31:02', '2804:1b1:f942:511f:11ff:5932:167:9329', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', NULL, NULL, NULL, '2025-11-15 00:00:52', '2025-12-05 17:12:57');

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_rewards`
--

CREATE TABLE `user_rewards` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `reward_id` int(10) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('pending','claimed','expired') DEFAULT 'pending',
  `claimed_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `withdrawals`
--

CREATE TABLE `withdrawals` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `withdrawal_account_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `pix_key` varchar(255) DEFAULT NULL,
  `document` varchar(255) DEFAULT NULL,
  `pix_type` varchar(255) DEFAULT NULL,
  `wallet_type` enum('balance','affiliate_balance') DEFAULT 'balance',
  `status` enum('pending','processing','completed','rejected') DEFAULT 'pending',
  `external_id` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `api_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`api_response`)),
  `webhooks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`webhooks`)),
  `rejection_reason` text DEFAULT NULL,
  `fail_reason` varchar(255) DEFAULT NULL,
  `processed_at` datetime DEFAULT NULL,
  `processed_by` int(10) UNSIGNED DEFAULT NULL COMMENT 'Admin que processou',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `withdrawal_accounts`
--

CREATE TABLE `withdrawal_accounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `account_type` enum('pix_cpf','pix_email','pix_phone','bank_account') NOT NULL,
  `account_holder` varchar(255) NOT NULL,
  `account_number` varchar(255) NOT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `bank_code` varchar(10) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `affiliate_groups`
--
ALTER TABLE `affiliate_groups`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Índices de tabela `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Índices de tabela `commissions`
--
ALTER TABLE `commissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `deposit_id` (`deposit_id`),
  ADD KEY `revoked_by` (`revoked_by`),
  ADD KEY `idx_affiliate_id` (`affiliate_id`),
  ADD KEY `idx_referred_user_id` (`referred_user_id`);

--
-- Índices de tabela `deposits`
--
ALTER TABLE `deposits`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_no` (`transactionId`),
  ADD KEY `gateway_id` (`gateway_id`),
  ADD KEY `idx_order_no` (`transactionId`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`);

--
-- Índices de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Índices de tabela `game_configs`
--
ALTER TABLE `game_configs`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Índices de tabela `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prize_id` (`prize_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Índices de tabela `payment_gateways`
--
ALTER TABLE `payment_gateways`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`slug`);

--
-- Índices de tabela `prizes`
--
ALTER TABLE `prizes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `rewards`
--
ALTER TABLE `rewards`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Índices de tabela `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `referral_code` (`invite_code`),
  ADD KEY `referred_by` (`parent_id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_referral_code` (`invite_code`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `fk_users_affiliate_group` (`affiliate_group_id`);

--
-- Índices de tabela `user_rewards`
--
ALTER TABLE `user_rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reward_id` (`reward_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Índices de tabela `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `withdrawal_account_id` (`withdrawal_account_id`),
  ADD KEY `processed_by` (`processed_by`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`);

--
-- Índices de tabela `withdrawal_accounts`
--
ALTER TABLE `withdrawal_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `affiliate_groups`
--
ALTER TABLE `affiliate_groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `commissions`
--
ALTER TABLE `commissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `deposits`
--
ALTER TABLE `deposits`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `game_configs`
--
ALTER TABLE `game_configs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `payment_gateways`
--
ALTER TABLE `payment_gateways`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `prizes`
--
ALTER TABLE `prizes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de tabela `rewards`
--
ALTER TABLE `rewards`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de tabela `user_rewards`
--
ALTER TABLE `user_rewards`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `withdrawals`
--
ALTER TABLE `withdrawals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `withdrawal_accounts`
--
ALTER TABLE `withdrawal_accounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `commissions`
--
ALTER TABLE `commissions`
  ADD CONSTRAINT `commissions_ibfk_1` FOREIGN KEY (`affiliate_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `commissions_ibfk_2` FOREIGN KEY (`referred_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `commissions_ibfk_3` FOREIGN KEY (`deposit_id`) REFERENCES `deposits` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `commissions_ibfk_4` FOREIGN KEY (`revoked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `deposits`
--
ALTER TABLE `deposits`
  ADD CONSTRAINT `deposits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `deposits_ibfk_2` FOREIGN KEY (`gateway_id`) REFERENCES `payment_gateways` (`id`);

--
-- Restrições para tabelas `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`prize_id`) REFERENCES `prizes` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_affiliate_group` FOREIGN KEY (`affiliate_group_id`) REFERENCES `affiliate_groups` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `user_rewards`
--
ALTER TABLE `user_rewards`
  ADD CONSTRAINT `user_rewards_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_rewards_ibfk_2` FOREIGN KEY (`reward_id`) REFERENCES `rewards` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `withdrawals`
--
ALTER TABLE `withdrawals`
  ADD CONSTRAINT `withdrawals_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `withdrawals_ibfk_3` FOREIGN KEY (`processed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `withdrawal_accounts`
--
ALTER TABLE `withdrawal_accounts`
  ADD CONSTRAINT `withdrawal_accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
