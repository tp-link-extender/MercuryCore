/*
  Warnings:

  - You are about to drop the column `expires` on the `session` table. All the data in the column will be lost.
  - You are about to drop the column `hashed_password` on the `user` table. All the data in the column will be lost.
  - You are about to drop the column `provider_id` on the `user` table. All the data in the column will be lost.
  - Added the required column `active_expires` to the `session` table without a default value. This is not possible if the table is not empty.
  - Made the column `displayname` on table `user` required. This step will fail if there are existing NULL values in that column.

*/
-- DropIndex
DROP INDEX "user_provider_id_key";

-- AlterTable
ALTER TABLE "session" DROP COLUMN "expires",
ADD COLUMN     "active_expires" BIGINT NOT NULL;

-- AlterTable
ALTER TABLE "user" DROP COLUMN "hashed_password",
DROP COLUMN "provider_id",
ALTER COLUMN "displayname" SET NOT NULL;

-- CreateTable
CREATE TABLE "key" (
    "id" TEXT NOT NULL,
    "hashed_password" TEXT,
    "user_id" INTEGER NOT NULL,
    "primary" BOOLEAN NOT NULL,

    CONSTRAINT "key_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "key_id_key" ON "key"("id");

-- CreateIndex
CREATE INDEX "key_user_id_idx" ON "key"("user_id");

-- AddForeignKey
ALTER TABLE "key" ADD CONSTRAINT "key_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
