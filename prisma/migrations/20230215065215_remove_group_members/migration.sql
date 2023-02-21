/*
  Warnings:

  - You are about to drop the `_member` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_member" DROP CONSTRAINT "_member_A_fkey";

-- DropForeignKey
ALTER TABLE "_member" DROP CONSTRAINT "_member_B_fkey";

-- DropTable
DROP TABLE "_member";
