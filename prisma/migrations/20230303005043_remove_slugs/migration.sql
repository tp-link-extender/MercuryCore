/*
  Warnings:

  - You are about to drop the column `slug` on the `Place` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "Place_name_key";

-- DropIndex
DROP INDEX "Place_slug_key";

-- AlterTable
ALTER TABLE "Place" DROP COLUMN "slug";
