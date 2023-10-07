/*
  Warnings:

  - You are about to drop the column `creatorGroupname` on the `Asset` table. All the data in the column will be lost.
  - You are about to drop the column `ownerGroupname` on the `Place` table. All the data in the column will be lost.
  - You are about to drop the column `regkeyKey` on the `user` table. All the data in the column will be lost.
  - You are about to drop the `ForumCategory` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ForumPost` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ForumReply` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `GameSessions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Group` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ModerationAction` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Regkey` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Report` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `TextContent` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Transaction` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Asset" DROP CONSTRAINT "Asset_creatorGroupname_fkey";

-- DropForeignKey
ALTER TABLE "ForumPost" DROP CONSTRAINT "ForumPost_authorId_fkey";

-- DropForeignKey
ALTER TABLE "ForumPost" DROP CONSTRAINT "ForumPost_forumCategoryName_fkey";

-- DropForeignKey
ALTER TABLE "ForumReply" DROP CONSTRAINT "ForumReply_authorId_fkey";

-- DropForeignKey
ALTER TABLE "ForumReply" DROP CONSTRAINT "ForumReply_parentReplyId_fkey";

-- DropForeignKey
ALTER TABLE "ForumReply" DROP CONSTRAINT "ForumReply_topParentId_fkey";

-- DropForeignKey
ALTER TABLE "GameSessions" DROP CONSTRAINT "GameSessions_placeId_fkey";

-- DropForeignKey
ALTER TABLE "GameSessions" DROP CONSTRAINT "GameSessions_userId_fkey";

-- DropForeignKey
ALTER TABLE "Group" DROP CONSTRAINT "Group_ownerUsername_fkey";

-- DropForeignKey
ALTER TABLE "ModerationAction" DROP CONSTRAINT "ModerationAction_moderateeId_fkey";

-- DropForeignKey
ALTER TABLE "ModerationAction" DROP CONSTRAINT "ModerationAction_moderatorId_fkey";

-- DropForeignKey
ALTER TABLE "Place" DROP CONSTRAINT "Place_ownerGroupname_fkey";

-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_authorGroupname_fkey";

-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_authorUsername_fkey";

-- DropForeignKey
ALTER TABLE "Regkey" DROP CONSTRAINT "Regkey_creatorId_fkey";

-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_reporteeId_fkey";

-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_reporterId_fkey";

-- DropForeignKey
ALTER TABLE "TextContent" DROP CONSTRAINT "TextContent_assetCommentId_fkey";

-- DropForeignKey
ALTER TABLE "TextContent" DROP CONSTRAINT "TextContent_assetId_fkey";

-- DropForeignKey
ALTER TABLE "TextContent" DROP CONSTRAINT "TextContent_forumPostId_fkey";

-- DropForeignKey
ALTER TABLE "TextContent" DROP CONSTRAINT "TextContent_forumReplyId_fkey";

-- DropForeignKey
ALTER TABLE "TextContent" DROP CONSTRAINT "TextContent_placeId_fkey";

-- DropForeignKey
ALTER TABLE "TextContent" DROP CONSTRAINT "TextContent_userId_fkey";

-- DropForeignKey
ALTER TABLE "Transaction" DROP CONSTRAINT "Transaction_receiverName_fkey";

-- DropForeignKey
ALTER TABLE "Transaction" DROP CONSTRAINT "Transaction_senderName_fkey";

-- DropForeignKey
ALTER TABLE "user" DROP CONSTRAINT "user_regkeyKey_fkey";

-- AlterTable
ALTER TABLE "Asset" DROP COLUMN "creatorGroupname";

-- AlterTable
ALTER TABLE "Place" DROP COLUMN "ownerGroupname";

-- AlterTable
ALTER TABLE "user" DROP COLUMN "regkeyKey";

-- DropTable
DROP TABLE "ForumCategory";

-- DropTable
DROP TABLE "ForumPost";

-- DropTable
DROP TABLE "ForumReply";

-- DropTable
DROP TABLE "GameSessions";

-- DropTable
DROP TABLE "Group";

-- DropTable
DROP TABLE "ModerationAction";

-- DropTable
DROP TABLE "Post";

-- DropTable
DROP TABLE "Regkey";

-- DropTable
DROP TABLE "Report";

-- DropTable
DROP TABLE "TextContent";

-- DropTable
DROP TABLE "Transaction";

-- DropEnum
DROP TYPE "ItemCategory";

-- DropEnum
DROP TYPE "ModerationActionType";

-- DropEnum
DROP TYPE "ReportCategory";
