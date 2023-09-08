/*
  Warnings:

  - The values [ForumReply] on the enum `NotificationType` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "NotificationType_new" AS ENUM ('AssetApproved', 'FriendRequest', 'Follower', 'ForumPostReply', 'ForumReplyReply', 'ForumMention', 'ForumPost', 'ItemPurchase', 'Message', 'NewFriend');
ALTER TABLE "Notification" ALTER COLUMN "type" TYPE "NotificationType_new" USING ("type"::text::"NotificationType_new");
ALTER TYPE "NotificationType" RENAME TO "NotificationType_old";
ALTER TYPE "NotificationType_new" RENAME TO "NotificationType";
DROP TYPE "NotificationType_old";
COMMIT;
