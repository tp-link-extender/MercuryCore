-- DropForeignKey
ALTER TABLE "Place" DROP CONSTRAINT "Place_ownerUsername_fkey";

-- AlterTable
ALTER TABLE "Place" ADD COLUMN     "ownerGroupname" TEXT,
ALTER COLUMN "ownerUsername" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "authorGroupname" TEXT;

-- CreateTable
CREATE TABLE "Group" (
    "name" TEXT NOT NULL,
    "ownerUsername" TEXT NOT NULL,

    CONSTRAINT "Group_pkey" PRIMARY KEY ("name")
);

-- CreateTable
CREATE TABLE "_member" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Group_name_key" ON "Group"("name");

-- CreateIndex
CREATE UNIQUE INDEX "_member_AB_unique" ON "_member"("A", "B");

-- CreateIndex
CREATE INDEX "_member_B_index" ON "_member"("B");

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorGroupname_fkey" FOREIGN KEY ("authorGroupname") REFERENCES "Group"("name") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Group" ADD CONSTRAINT "Group_ownerUsername_fkey" FOREIGN KEY ("ownerUsername") REFERENCES "user"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Place" ADD CONSTRAINT "Place_ownerUsername_fkey" FOREIGN KEY ("ownerUsername") REFERENCES "user"("username") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Place" ADD CONSTRAINT "Place_ownerGroupname_fkey" FOREIGN KEY ("ownerGroupname") REFERENCES "Group"("name") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_member" ADD CONSTRAINT "_member_A_fkey" FOREIGN KEY ("A") REFERENCES "Group"("name") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_member" ADD CONSTRAINT "_member_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
