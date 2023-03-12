-- CreateTable
CREATE TABLE "Announcements" (
    "id" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "bgColour" TEXT NOT NULL,
    "textLight" BOOLEAN NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "creatorId" TEXT NOT NULL,

    CONSTRAINT "Announcements_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Announcements_id_key" ON "Announcements"("id");

-- AddForeignKey
ALTER TABLE "Announcements" ADD CONSTRAINT "Announcements_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
