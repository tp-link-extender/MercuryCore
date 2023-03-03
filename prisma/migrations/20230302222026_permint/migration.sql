/*
  Warnings:

  - The `permissionLevel` column on the `user` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "user" DROP COLUMN "permissionLevel",
ADD COLUMN     "permissionLevel" INTEGER NOT NULL DEFAULT 1;

-- DropEnum
DROP TYPE "Permission";
