-- CreateEnum
CREATE TYPE "ModerationActionType" AS ENUM ('Reminder', 'Warning', 'Ban', 'Termination');

-- CreateTable
CREATE TABLE "ModerationAction" (
    "id" TEXT NOT NULL,
    "moderatorId" TEXT NOT NULL,
    "moderateeId" TEXT NOT NULL,
    "time" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" TEXT NOT NULL,
    "materials" TEXT,
    "type" "ModerationActionType" NOT NULL,
    "daysLength" INTEGER,
    "active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "ModerationAction_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ModerationAction_id_key" ON "ModerationAction"("id");

-- AddForeignKey
ALTER TABLE "ModerationAction" ADD CONSTRAINT "ModerationAction_moderatorId_fkey" FOREIGN KEY ("moderatorId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ModerationAction" ADD CONSTRAINT "ModerationAction_moderateeId_fkey" FOREIGN KEY ("moderateeId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
