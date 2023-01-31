/*
  Warnings:

  - A unique constraint covering the columns `[id]` on the table `key` will be added. If there are existing duplicate values, this will fail.
  - Made the column `displayname` on table `user` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "key" DROP CONSTRAINT "key_user_id_fkey";

-- AlterTable
ALTER TABLE "user" ALTER COLUMN "displayname" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "key_id_key" ON "key"("id");

-- CreateIndex
CREATE INDEX "key_user_id_idx" ON "key"("user_id");

-- AddForeignKey
ALTER TABLE "key" ADD CONSTRAINT "key_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
