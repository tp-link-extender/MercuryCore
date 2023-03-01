/*
  Warnings:

  - The primary key for the `Place` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - A unique constraint covering the columns `[id]` on the table `Place` will be added. If there are existing duplicate values, this will fail.
  - The required column `id` was added to the `Place` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.
  - Added the required column `maxPlayers` to the `Place` table without a default value. This is not possible if the table is not empty.
  - Added the required column `serverIP` to the `Place` table without a default value. This is not possible if the table is not empty.
  - Added the required column `serverPort` to the `Place` table without a default value. This is not possible if the table is not empty.
  - Added the required column `serverTicket` to the `Place` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Place" DROP CONSTRAINT "Place_pkey",
ADD COLUMN     "id" TEXT NOT NULL,
ADD COLUMN     "maxPlayers" INTEGER NOT NULL,
ADD COLUMN     "serverIP" TEXT NOT NULL,
ADD COLUMN     "serverPing" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "serverPort" TEXT NOT NULL,
ADD COLUMN     "serverTicket" TEXT NOT NULL,
ADD CONSTRAINT "Place_pkey" PRIMARY KEY ("id");
ALTER TABLE public.key
ADD COLUMN expires BIGINT;

-- CreateIndex
CREATE UNIQUE INDEX "Place_id_key" ON "Place"("id");
