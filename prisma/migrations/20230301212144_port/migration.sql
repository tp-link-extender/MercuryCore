/*
  Warnings:

  - Changed the type of `serverPort` on the `Place` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "Place" DROP COLUMN "serverPort",
ADD COLUMN     "serverPort" INTEGER NOT NULL;
