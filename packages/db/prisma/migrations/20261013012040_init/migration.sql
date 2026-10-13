-- CreateTable
CREATE TABLE `User` (
    `id` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `passwordHash` VARCHAR(191) NOT NULL,
    `balance` DOUBLE NOT NULL DEFAULT 0,
    `lockedBalance` DOUBLE NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Order` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `side` VARCHAR(191) NOT NULL,
    `type` VARCHAR(191) NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'open',
    `price` DOUBLE NULL,
    `quantity` DOUBLE NOT NULL,
    `originalQuantity` DOUBLE NOT NULL DEFAULT 0,
    `leverage` DOUBLE NOT NULL DEFAULT 1,
    `lockedMargin` DOUBLE NOT NULL DEFAULT 0,
    `reduceOnly` BOOLEAN NOT NULL DEFAULT false,
    `source` VARCHAR(191) NOT NULL DEFAULT 'user',
    `reason` VARCHAR(191) NULL,
    `acceptedAt` DATETIME(3) NULL,
    `engineSeq` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `Order_userId_createdAt_idx`(`userId`, `createdAt`),
    INDEX `Order_status_market_idx`(`status`, `market`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Fill` (
    `id` VARCHAR(191) NOT NULL,
    `tradeId` VARCHAR(191) NULL,
    `buyOrderId` VARCHAR(191) NOT NULL,
    `sellOrderId` VARCHAR(191) NOT NULL,
    `buyerId` VARCHAR(191) NOT NULL,
    `sellerId` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `price` DOUBLE NOT NULL,
    `quantity` DOUBLE NOT NULL,
    `buyerFee` DOUBLE NOT NULL DEFAULT 0,
    `sellerFee` DOUBLE NOT NULL DEFAULT 0,
    `takerSide` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Fill_tradeId_key`(`tradeId`),
    INDEX `Fill_buyerId_createdAt_idx`(`buyerId`, `createdAt`),
    INDEX `Fill_sellerId_createdAt_idx`(`sellerId`, `createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Position` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `side` VARCHAR(191) NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'open',
    `quantity` DOUBLE NOT NULL,
    `entryPrice` DOUBLE NOT NULL,
    `leverage` DOUBLE NOT NULL,
    `margin` DOUBLE NOT NULL,
    `pnl` DOUBLE NOT NULL DEFAULT 0,
    `riskScore` DOUBLE NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `Position_userId_status_idx`(`userId`, `status`),
    INDEX `Position_status_market_idx`(`status`, `market`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `InsuranceFund` (
    `id` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `balance` DOUBLE NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `InsuranceFund_market_key`(`market`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `FundingRate` (
    `id` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `rate` DOUBLE NOT NULL,
    `period` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `FundingRate_createdAt_idx`(`createdAt`),
    UNIQUE INDEX `FundingRate_market_period_key`(`market`, `period`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `FundingPayment` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `amount` DOUBLE NOT NULL,
    `side` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `FundingPayment_userId_createdAt_idx`(`userId`, `createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `FeeAccount` (
    `id` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `balance` DOUBLE NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `FeeAccount_market_key`(`market`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PositionHistory` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `market` VARCHAR(191) NOT NULL,
    `side` VARCHAR(191) NOT NULL,
    `quantity` DOUBLE NOT NULL,
    `entryPrice` DOUBLE NOT NULL,
    `exitPrice` DOUBLE NULL,
    `leverage` DOUBLE NOT NULL,
    `margin` DOUBLE NOT NULL,
    `pnl` DOUBLE NOT NULL,
    `reason` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `PositionHistory_userId_createdAt_idx`(`userId`, `createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ProcessedEvent` (
    `id` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
