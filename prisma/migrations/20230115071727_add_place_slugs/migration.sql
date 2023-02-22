/*
  Warnings:

  - The primary key for the `Place` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - Added the required column `slug` to the `Place` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Place" DROP CONSTRAINT "Place_pkey",
ADD COLUMN     "slug" TEXT NOT NULL,
ADD CONSTRAINT "Place_pkey" PRIMARY KEY ("slug");
