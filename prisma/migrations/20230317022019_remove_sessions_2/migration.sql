/*
  Warnings:

  - The values [Reminder] on the enum `ModerationActionType` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "ModerationActionType_new" AS ENUM ('Warning', 'Ban', 'Termination', 'AccountDeleted');
ALTER TABLE "ModerationAction" ALTER COLUMN "type" TYPE "ModerationActionType_new" USING ("type"::text::"ModerationActionType_new");
ALTER TYPE "ModerationActionType" RENAME TO "ModerationActionType_old";
ALTER TYPE "ModerationActionType_new" RENAME TO "ModerationActionType";
DROP TYPE "ModerationActionType_old";
COMMIT;
