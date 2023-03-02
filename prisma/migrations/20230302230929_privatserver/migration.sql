/*
  Warnings:

  - The required column `privateTicket` was added to the `Place` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.

*/
-- AlterTable
ALTER TABLE "Place" ADD COLUMN     "privateServer" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "privateTicket" TEXT NOT NULL;
