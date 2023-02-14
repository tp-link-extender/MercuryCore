/*
  Warnings:

  - The `permissionLevel` column on the `user` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- CreateEnum
CREATE TYPE "Permission" AS ENUM ('User', 'Verified', 'Moderator', 'ItemManager', 'Administrator');

-- AlterTable
ALTER TABLE "user" DROP COLUMN "permissionLevel",
ADD COLUMN     "permissionLevel" "Permission" NOT NULL DEFAULT 'User';
