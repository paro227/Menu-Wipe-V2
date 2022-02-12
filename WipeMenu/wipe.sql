CREATE TABLE `wipe` (
  `steamid` varchar(100) NOT NULL,
  `raison` varchar(500) NOT NULL,
  `user` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE `wipe`
  ADD PRIMARY KEY (`steamid`);
