/*
  Warnings:

  - Made the column `parentPostId` on table `ForumReply` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "ForumReply" DROP CONSTRAINT "ForumReply_parentPostId_fkey";

-- AlterTable
ALTER TABLE "ForumReply" ALTER COLUMN "parentPostId" SET NOT NULL;

-- AddForeignKey
ALTER TABLE "ForumReply" ADD CONSTRAINT "ForumReply_parentPostId_fkey" FOREIGN KEY ("parentPostId") REFERENCES "ForumPost"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
