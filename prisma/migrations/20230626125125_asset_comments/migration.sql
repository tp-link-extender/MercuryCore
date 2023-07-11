-- AlterTable
ALTER TABLE "TextContent" ADD COLUMN     "assetCommentId" TEXT;

-- CreateTable
CREATE TABLE "AssetComment" (
    "id" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "posted" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "parentAssetId" INTEGER NOT NULL,
    "parentReplyId" TEXT,

    CONSTRAINT "AssetComment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "AssetComment_id_key" ON "AssetComment"("id");

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_assetCommentId_fkey" FOREIGN KEY ("assetCommentId") REFERENCES "AssetComment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetComment" ADD CONSTRAINT "AssetComment_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetComment" ADD CONSTRAINT "AssetComment_parentAssetId_fkey" FOREIGN KEY ("parentAssetId") REFERENCES "Asset"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssetComment" ADD CONSTRAINT "AssetComment_parentReplyId_fkey" FOREIGN KEY ("parentReplyId") REFERENCES "AssetComment"("id") ON DELETE SET NULL ON UPDATE CASCADE;
