/*
  Warnings:

  - A unique constraint covering the columns `[serverTicket]` on the table `Place` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "Place_serverTicket_key" ON "Place"("serverTicket");
