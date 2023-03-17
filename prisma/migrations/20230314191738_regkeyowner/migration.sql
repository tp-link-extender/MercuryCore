-- AlterTable
ALTER TABLE "Regkey" ADD COLUMN     "creatorId" TEXT;

-- AddForeignKey
ALTER TABLE "Regkey" ADD CONSTRAINT "Regkey_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;
