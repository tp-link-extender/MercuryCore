-- DropForeignKey
ALTER TABLE "GameSessions" DROP CONSTRAINT "GameSessions_placeId_fkey";

-- DropForeignKey
ALTER TABLE "GameSessions" DROP CONSTRAINT "GameSessions_userId_fkey";

-- AddForeignKey
ALTER TABLE "GameSessions" ADD CONSTRAINT "GameSessions_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES "Place"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameSessions" ADD CONSTRAINT "GameSessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
