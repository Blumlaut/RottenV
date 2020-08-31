SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

SET AUTOCOMMIT = 0;

START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;

/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;

CREATE TABLE `players` (
  `ids` int(10) UNSIGNED NOT NULL,
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `steamid` varchar(300) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `license` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `discord` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `x` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `y` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `z` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `hunger` float NOT NULL DEFAULT '100',
  `thirst` float NOT NULL DEFAULT '100',
  `inv` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `health` bigint(20) NOT NULL DEFAULT '200',
  `playerkillsthislife` bigint(20) DEFAULT '0',
  `zombiekillsthislife` bigint(20) NOT NULL DEFAULT '0',
  `playerkills` bigint(20) NOT NULL DEFAULT '0',
  `zombiekills` bigint(20) NOT NULL DEFAULT '0',
  `humanity` bigint(20) NOT NULL DEFAULT '500',
  `infected` varchar(8) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'false',
  `money` bigint(20) NOT NULL DEFAULT '0',
  `locker_money` int(11) NOT NULL DEFAULT '0',
  `wheelspins` int(11) DEFAULT '0',
  `playtime` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0:0',
  `currentQuest` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `finishedQuests` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `customskin` char(65) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

CREATE TABLE `safes` (
  `id` int(11) NOT NULL,
  `inv` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `creationTime` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `owner` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `passcode` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT '0000',
  `x` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `y` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `z` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `r` text CHARACTER SET latin1 COLLATE latin1_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPACT;

ALTER TABLE `players`
  ADD PRIMARY KEY (`ids`),
  ADD UNIQUE KEY `ids` (`ids`),
  ADD KEY `steamid` (`steamid`),
  ADD KEY `discord` (`discord`);

ALTER TABLE `safes`
  ADD UNIQUE KEY `id` (`id`);

ALTER TABLE `players`
  MODIFY `ids` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=744895;

ALTER TABLE `safes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1222;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

