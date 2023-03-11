-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_reporteeId_fkey";

-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_reporterId_fkey";

-- AlterTable
ALTER TABLE "Report" ALTER COLUMN "note" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reporteeId_fkey" FOREIGN KEY ("reporteeId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
