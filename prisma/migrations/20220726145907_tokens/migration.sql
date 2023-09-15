-- CreateTable
CREATE TABLE "Token" (
    "Token" TEXT NOT NULL,
    "userUsername" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Token_userUsername_key" ON "Token"("userUsername");

-- AddForeignKey
ALTER TABLE "Token" ADD CONSTRAINT "Token_userUsername_fkey" FOREIGN KEY ("userUsername") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;
