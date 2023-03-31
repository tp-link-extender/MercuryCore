/*
  Warnings:

  - You are about to drop the column `primary` on the `key` table. All the data in the column will be lost.
  - Added the required column `primary_key` to the `key` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "key" RENAME "primary" TO primary_key;
