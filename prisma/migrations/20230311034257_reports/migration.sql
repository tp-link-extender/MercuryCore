-- CreateEnum
CREATE TYPE "ReportCategory" AS ENUM ('AccountTheft', 'Dating', 'Exploiting', 'Harassment', 'InappropriateContent', 'PersonalInformation', 'Scamming', 'Spam', 'Swearing', 'Threats', 'Under13');

-- CreateTable
CREATE TABLE "Report" (
    "id" TEXT NOT NULL,
    "reporterId" TEXT NOT NULL,
    "reporteeId" TEXT NOT NULL,
    "time" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "category" "ReportCategory" NOT NULL,
    "inGame" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Report_id_key" ON "Report"("id");

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "user"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reporteeId_fkey" FOREIGN KEY ("reporteeId") REFERENCES "user"("username") ON DELETE RESTRICT ON UPDATE CASCADE;
