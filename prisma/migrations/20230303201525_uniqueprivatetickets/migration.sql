/*
  Warnings:

  - A unique constraint covering the columns `[privateTicket]` on the table `Place` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Place_privateTicket_key" ON "Place"("privateTicket");
