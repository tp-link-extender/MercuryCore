-- CreateTable
CREATE TABLE "_incomingRequests" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_outgoingRequests" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_followers" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_following" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_incomingRequests_AB_unique" ON "_incomingRequests"("A", "B");

-- CreateIndex
CREATE INDEX "_incomingRequests_B_index" ON "_incomingRequests"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_outgoingRequests_AB_unique" ON "_outgoingRequests"("A", "B");

-- CreateIndex
CREATE INDEX "_outgoingRequests_B_index" ON "_outgoingRequests"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_followers_AB_unique" ON "_followers"("A", "B");

-- CreateIndex
CREATE INDEX "_followers_B_index" ON "_followers"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_following_AB_unique" ON "_following"("A", "B");

-- CreateIndex
CREATE INDEX "_following_B_index" ON "_following"("B");

-- AddForeignKey
ALTER TABLE "Place" ADD CONSTRAINT "Place_ownerUsername_fkey" FOREIGN KEY ("ownerUsername") REFERENCES "user"("username") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_incomingRequests" ADD CONSTRAINT "_incomingRequests_A_fkey" FOREIGN KEY ("A") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_incomingRequests" ADD CONSTRAINT "_incomingRequests_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_outgoingRequests" ADD CONSTRAINT "_outgoingRequests_A_fkey" FOREIGN KEY ("A") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_outgoingRequests" ADD CONSTRAINT "_outgoingRequests_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_followers" ADD CONSTRAINT "_followers_A_fkey" FOREIGN KEY ("A") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_followers" ADD CONSTRAINT "_followers_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_following" ADD CONSTRAINT "_following_A_fkey" FOREIGN KEY ("A") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_following" ADD CONSTRAINT "_following_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
