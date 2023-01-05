/*
  Warnings:

  - You are about to drop the column `Status` on the `user` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "user" DROP COLUMN "Status",
ADD COLUMN     "status" TEXT;
