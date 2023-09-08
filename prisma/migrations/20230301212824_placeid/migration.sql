/*
  Warnings:

  - The primary key for the `Place` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Place` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `placeId` on the `GameSessions` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "GameSessions" DROP CONSTRAINT "GameSessions_placeId_fkey";

-- AlterTable
ALTER TABLE "GameSessions" DROP COLUMN "placeId",
ADD COLUMN     "placeId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Place" DROP CONSTRAINT "Place_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "Place_pkey" PRIMARY KEY ("id");

-- CreateIndex
CREATE UNIQUE INDEX "Place_id_key" ON "Place"("id");

-- AddForeignKey
ALTER TABLE "GameSessions" ADD CONSTRAINT "GameSessions_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES "Place"("id") ON DELETE CASCADE ON UPDATE CASCADE;
