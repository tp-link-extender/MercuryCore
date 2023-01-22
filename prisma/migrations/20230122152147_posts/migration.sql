-- CreateTable
CREATE TABLE "Post" (
    "id" TEXT NOT NULL,
    "authorUsername" TEXT NOT NULL,
    "posted" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "content" TEXT NOT NULL,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Post_id_key" ON "Post"("id");

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_authorUsername_fkey" FOREIGN KEY ("authorUsername") REFERENCES "user"("username") ON DELETE RESTRICT ON UPDATE CASCADE;
