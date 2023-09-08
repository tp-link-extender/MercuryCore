/*
  Warnings:

  - You are about to drop the column `daysLength` on the `ModerationAction` table. All the data in the column will be lost.
  - You are about to drop the column `materials` on the `ModerationAction` table. All the data in the column will be lost.
  - Added the required column `timeEnds` to the `ModerationAction` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
ALTER TYPE "ModerationActionType" ADD VALUE 'AccountDeleted';

-- AlterTable
ALTER TABLE "ModerationAction" DROP COLUMN "daysLength",
DROP COLUMN "materials",
ADD COLUMN     "timeEnds" TIMESTAMP(3) NOT NULL;
