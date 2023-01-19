/*
  Warnings:

  - You are about to drop the column `usedInvite` on the `user` table. All the data in the column will be lost.
  - Added the required column `regkeyKey` to the `user` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "user" DROP COLUMN "usedInvite",
ADD COLUMN     "regkeyKey" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "Regkey" (
    "key" TEXT NOT NULL,
    "usesLeft" INTEGER NOT NULL DEFAULT 1
);

-- CreateIndex
CREATE UNIQUE INDEX "Regkey_key_key" ON "Regkey"("key");

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_regkeyKey_fkey" FOREIGN KEY ("regkeyKey") REFERENCES "Regkey"("key") ON DELETE RESTRICT ON UPDATE CASCADE;
