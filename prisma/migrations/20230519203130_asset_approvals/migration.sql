-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('Pending', 'Approved', 'Rejected');

-- AlterTable
ALTER TABLE "Asset" ADD COLUMN     "approved" "ApprovalStatus" NOT NULL DEFAULT 'Pending',
ADD COLUMN     "moderatorUsername" TEXT;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_moderatorUsername_fkey" FOREIGN KEY ("moderatorUsername") REFERENCES "user"("username") ON DELETE SET NULL ON UPDATE CASCADE;
