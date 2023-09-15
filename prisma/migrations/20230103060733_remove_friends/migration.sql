/*
  Warnings:

  - You are about to drop the `_followers` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_following` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_friends` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_incomingRequests` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_outgoingRequests` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_followers" DROP CONSTRAINT "_followers_A_fkey";

-- DropForeignKey
ALTER TABLE "_followers" DROP CONSTRAINT "_followers_B_fkey";

-- DropForeignKey
ALTER TABLE "_following" DROP CONSTRAINT "_following_A_fkey";

-- DropForeignKey
ALTER TABLE "_following" DROP CONSTRAINT "_following_B_fkey";

-- DropForeignKey
ALTER TABLE "_friends" DROP CONSTRAINT "_friends_A_fkey";

-- DropForeignKey
ALTER TABLE "_friends" DROP CONSTRAINT "_friends_B_fkey";

-- DropForeignKey
ALTER TABLE "_incomingRequests" DROP CONSTRAINT "_incomingRequests_A_fkey";

-- DropForeignKey
ALTER TABLE "_incomingRequests" DROP CONSTRAINT "_incomingRequests_B_fkey";

-- DropForeignKey
ALTER TABLE "_outgoingRequests" DROP CONSTRAINT "_outgoingRequests_A_fkey";

-- DropForeignKey
ALTER TABLE "_outgoingRequests" DROP CONSTRAINT "_outgoingRequests_B_fkey";

-- DropTable
DROP TABLE "_followers";

-- DropTable
DROP TABLE "_following";

-- DropTable
DROP TABLE "_friends";

-- DropTable
DROP TABLE "_incomingRequests";

-- DropTable
DROP TABLE "_outgoingRequests";
