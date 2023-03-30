-- this was an unbelievable pain in the ass why does it suddenly work now

-- DropForeignKey
ALTER TABLE "_owns" DROP CONSTRAINT "_owns_A_fkey";

-- DropForeignKey
ALTER TABLE "_owns" DROP CONSTRAINT "_owns_B_fkey";

-- DropForeignKey
ALTER TABLE "_wears" DROP CONSTRAINT "_wears_A_fkey";

-- DropForeignKey
ALTER TABLE "_wears" DROP CONSTRAINT "_wears_B_fkey";

-- AddForeignKey
ALTER TABLE "_owns" ADD CONSTRAINT "_owns_A_fkey" FOREIGN KEY ("A") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_owns" ADD CONSTRAINT "_owns_B_fkey" FOREIGN KEY ("B") REFERENCES "Item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_wears" ADD CONSTRAINT "_wears_A_fkey" FOREIGN KEY ("A") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_wears" ADD CONSTRAINT "_wears_B_fkey" FOREIGN KEY ("B") REFERENCES "Item"("id") ON DELETE CASCADE ON UPDATE CASCADE;
