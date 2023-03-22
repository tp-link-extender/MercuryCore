/*
  Warnings:

  - You are about to drop the column `content` on the `ForumPost` table. All the data in the column will be lost.
  - You are about to drop the column `content` on the `ForumReply` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `Place` table. All the data in the column will be lost.
  - You are about to drop the column `bio` on the `user` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ForumPost" DROP COLUMN "content";

-- AlterTable
ALTER TABLE "ForumReply" DROP COLUMN "content";

-- AlterTable
ALTER TABLE "Place" DROP COLUMN "description";

-- AlterTable
ALTER TABLE "user" DROP COLUMN "bio";

-- CreateTable
CREATE TABLE "TextContent" (
    "id" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "forumPostId" TEXT,
    "forumReplyId" TEXT,
    "userId" TEXT,
    "placeId" INTEGER,
    "itemId" TEXT,

    CONSTRAINT "TextContent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "TextContent_id_key" ON "TextContent"("id");

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_forumPostId_fkey" FOREIGN KEY ("forumPostId") REFERENCES "ForumPost"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_forumReplyId_fkey" FOREIGN KEY ("forumReplyId") REFERENCES "ForumReply"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES "Place"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "Item"("id") ON DELETE SET NULL ON UPDATE CASCADE;
