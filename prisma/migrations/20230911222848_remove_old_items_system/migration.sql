/*
  Warnings:

  - You are about to drop the column `itemId` on the `TextContent` table. All the data in the column will be lost.
  - You are about to drop the `Item` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_owns` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_wears` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Item" DROP CONSTRAINT "Item_creatorName_fkey";

-- DropForeignKey
ALTER TABLE "TextContent" DROP CONSTRAINT "TextContent_itemId_fkey";

-- DropForeignKey
ALTER TABLE "_owns" DROP CONSTRAINT "_owns_A_fkey";

-- DropForeignKey
ALTER TABLE "_owns" DROP CONSTRAINT "_owns_B_fkey";

-- DropForeignKey
ALTER TABLE "_wears" DROP CONSTRAINT "_wears_A_fkey";

-- DropForeignKey
ALTER TABLE "_wears" DROP CONSTRAINT "_wears_B_fkey";

-- AlterTable
ALTER TABLE "TextContent" DROP COLUMN "itemId";

-- DropTable
DROP TABLE "Item";

-- DropTable
DROP TABLE "_owns";

-- DropTable
DROP TABLE "_wears";
