/*
  Warnings:

  - A unique constraint covering the columns `[name]` on the table `Place` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "Place_slug_key";

-- CreateIndex
CREATE UNIQUE INDEX "Place_name_key" ON "Place"("name");
