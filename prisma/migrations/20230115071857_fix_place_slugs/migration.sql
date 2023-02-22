/*
  Warnings:

  - A unique constraint covering the columns `[slug]` on the table `Place` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Place_slug_key" ON "Place"("slug");
