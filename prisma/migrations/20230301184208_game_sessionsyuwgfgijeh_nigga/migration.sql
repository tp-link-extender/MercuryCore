-- CreateTable
CREATE TABLE "GameSessions" (
    "placeId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "ticket" TEXT NOT NULL,
    "ping" INTEGER NOT NULL DEFAULT 0,
    "valid" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "GameSessions_pkey" PRIMARY KEY ("ticket")
);

-- CreateIndex
CREATE UNIQUE INDEX "GameSessions_ticket_key" ON "GameSessions"("ticket");

-- AddForeignKey
ALTER TABLE "GameSessions" ADD CONSTRAINT "GameSessions_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES "Place"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameSessions" ADD CONSTRAINT "GameSessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
