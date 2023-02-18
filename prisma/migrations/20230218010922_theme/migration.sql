-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_authorUsername_fkey";

-- AlterTable
ALTER TABLE "Post" ALTER COLUMN "authorUsername" DROP NOT NULL;

-- AlterTable
ALTER TABLE "user" ADD COLUMN     "theme" TEXT;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorUsername_fkey" FOREIGN KEY ("authorUsername") REFERENCES "user"("username") ON DELETE SET NULL ON UPDATE CASCADE;
