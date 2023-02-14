-- CreateEnum
CREATE TYPE "ItemCategory" AS ENUM ('TShirt', 'Shirt', 'Pants', 'HeadShape', 'Hair', 'Face', 'Skirt', 'Dress', 'Hat', 'Headgear', 'Gear', 'Neck', 'Back', 'Shoulder');

-- CreateTable
CREATE TABLE "Item" (
    "name" TEXT NOT NULL,
    "id" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "category" "ItemCategory" NOT NULL,
    "creatorName" TEXT NOT NULL,
    "mesh" TEXT NOT NULL,
    "texture" TEXT NOT NULL,

    CONSTRAINT "Item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_owns" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_wears" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Item_id_key" ON "Item"("id");

-- CreateIndex
CREATE UNIQUE INDEX "_owns_AB_unique" ON "_owns"("A", "B");

-- CreateIndex
CREATE INDEX "_owns_B_index" ON "_owns"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_wears_AB_unique" ON "_wears"("A", "B");

-- CreateIndex
CREATE INDEX "_wears_B_index" ON "_wears"("B");

-- AddForeignKey
ALTER TABLE "Item" ADD CONSTRAINT "Item_creatorName_fkey" FOREIGN KEY ("creatorName") REFERENCES "user"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_owns" ADD CONSTRAINT "_owns_A_fkey" FOREIGN KEY ("A") REFERENCES "Item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_owns" ADD CONSTRAINT "_owns_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_wears" ADD CONSTRAINT "_wears_A_fkey" FOREIGN KEY ("A") REFERENCES "Item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_wears" ADD CONSTRAINT "_wears_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
