/*
  Warnings:

  - You are about to drop the `Announcements` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `AuditLog` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Announcements" DROP CONSTRAINT "Announcements_creatorId_fkey";

-- DropForeignKey
ALTER TABLE "AuditLog" DROP CONSTRAINT "AuditLog_userId_fkey";

-- DropTable
DROP TABLE "Announcements";

-- DropTable
DROP TABLE "AuditLog";

-- DropEnum
DROP TYPE "AuditActionType";
