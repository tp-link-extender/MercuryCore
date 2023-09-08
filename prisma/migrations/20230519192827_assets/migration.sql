-- AlterTable
ALTER TABLE "TextContent" ADD COLUMN     "assetId" INTEGER;

-- CreateTable
CREATE TABLE "Asset" (
    "id" SERIAL NOT NULL,
    "creatorUsername" TEXT,
    "creatorGroupname" TEXT,
    "name" TEXT NOT NULL,
    "type" INTEGER NOT NULL,
    "price" INTEGER NOT NULL,
    "imageAssetId" INTEGER,

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_owned" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Asset_id_key" ON "Asset"("id");

-- CreateIndex
CREATE UNIQUE INDEX "_owned_AB_unique" ON "_owned"("A", "B");

-- CreateIndex
CREATE INDEX "_owned_B_index" ON "_owned"("B");

-- AddForeignKey
ALTER TABLE "TextContent" ADD CONSTRAINT "TextContent_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "Asset"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_creatorUsername_fkey" FOREIGN KEY ("creatorUsername") REFERENCES "user"("username") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_creatorGroupname_fkey" FOREIGN KEY ("creatorGroupname") REFERENCES "Group"("name") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_imageAssetId_fkey" FOREIGN KEY ("imageAssetId") REFERENCES "Asset"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_owned" ADD CONSTRAINT "_owned_A_fkey" FOREIGN KEY ("A") REFERENCES "Asset"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_owned" ADD CONSTRAINT "_owned_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
