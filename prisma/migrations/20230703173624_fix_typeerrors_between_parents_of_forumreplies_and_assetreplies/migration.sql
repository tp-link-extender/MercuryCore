/*
  Warnings:

  - You are about to drop the column `parentAssetId` on the `AssetComment` table. All the data in the column will be lost.
  - You are about to drop the column `parentPostId` on the `ForumReply` table. All the data in the column will be lost.
  - Added the required column `topParentId` to the `AssetComment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `topParentId` to the `ForumReply` table without a default value. This is not possible if the table is not empty.

  - Deez nuts
*/
-- DropForeignKey
ALTER TABLE "AssetComment" DROP CONSTRAINT "AssetComment_parentAssetId_fkey";

-- DropForeignKey
ALTER TABLE "ForumReply" DROP CONSTRAINT "ForumReply_parentPostId_fkey";

-- AlterTable
ALTER TABLE "AssetComment"
RENAME COLUMN "parentAssetId" TO "topParentId";

-- AlterTable
ALTER TABLE "ForumReply"
RENAME COLUMN "parentPostId" TO "topParentId";

-- AddForeignKey
ALTER TABLE "ForumReply" ADD CONSTRAINT "ForumReply_topParentId_fkey" FOREIGN KEY ("topParentId") REFERENCES "ForumPost"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetComment" ADD CONSTRAINT "AssetComment_topParentId_fkey" FOREIGN KEY ("topParentId") REFERENCES "Asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
