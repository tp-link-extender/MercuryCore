-- DropIndex
DROP INDEX "Token_userUsername_key";

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "displayname" DROP NOT NULL,
ALTER COLUMN "password" DROP NOT NULL;
