-- CreateTable
CREATE TABLE "Place" (
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "ownerUsername" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Place_pkey" PRIMARY KEY ("name","ownerUsername")
);

-- AddForeignKey
ALTER TABLE "Place" ADD CONSTRAINT "Place_ownerUsername_fkey" FOREIGN KEY ("ownerUsername") REFERENCES "User"("username") ON DELETE RESTRICT ON UPDATE CASCADE;
