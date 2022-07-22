-- CreateTable
CREATE TABLE "User" (
    "username" TEXT NOT NULL,
    "displayname" TEXT NOT NULL,
    "bio" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastOnline" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "currency" INTEGER NOT NULL DEFAULT 0
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");
