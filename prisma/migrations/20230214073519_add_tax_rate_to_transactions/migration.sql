/*
  Warnings:

  - You are about to drop the column `amount` on the `Transaction` table. All the data in the column will be lost.
  - Added the required column `amountSent` to the `Transaction` table without a default value. This is not possible if the table is not empty.
  - Added the required column `taxRate` to the `Transaction` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "amount",
ADD COLUMN     "amountSent" INTEGER NOT NULL,
ADD COLUMN     "taxRate" DOUBLE PRECISION NOT NULL;
