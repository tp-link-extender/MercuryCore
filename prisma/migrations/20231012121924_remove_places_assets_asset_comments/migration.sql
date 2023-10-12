/*
  Warnings:

  - You are about to drop the `Asset` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `AssetComment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Place` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_owned` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Asset" DROP CONSTRAINT "Asset_creatorUsername_fkey";

-- DropForeignKey
ALTER TABLE "Asset" DROP CONSTRAINT "Asset_imageAssetId_fkey";

-- DropForeignKey
ALTER TABLE "Asset" DROP CONSTRAINT "Asset_moderatorUsername_fkey";

-- DropForeignKey
ALTER TABLE "AssetComment" DROP CONSTRAINT "AssetComment_authorId_fkey";

-- DropForeignKey
ALTER TABLE "AssetComment" DROP CONSTRAINT "AssetComment_parentReplyId_fkey";

-- DropForeignKey
ALTER TABLE "AssetComment" DROP CONSTRAINT "AssetComment_topParentId_fkey";

-- DropForeignKey
ALTER TABLE "Place" DROP CONSTRAINT "Place_ownerUsername_fkey";

-- DropForeignKey
ALTER TABLE "_owned" DROP CONSTRAINT "_owned_A_fkey";

-- DropForeignKey
ALTER TABLE "_owned" DROP CONSTRAINT "_owned_B_fkey";

-- DropTable
DROP TABLE "Asset";

-- DropTable
DROP TABLE "AssetComment";

-- DropTable
DROP TABLE "Place";

-- DropTable
DROP TABLE "_owned";

-- DropEnum
DROP TYPE "ApprovalStatus";
