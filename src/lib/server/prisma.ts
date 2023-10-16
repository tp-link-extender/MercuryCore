// A collection of functions useful for Prisma, as well
// as only needing to initialise PrismaClient once.

import surql from "$lib/surrealtag"
import { mquery } from "$lib/server/surreal"

const failed = "The query was not executed due to a failed transaction"
/**
 * Transfers currency from one user to another, and creates a transaction in the database.
 * @param sender An object containing the id or number of the user sending the currency.
 * @param receiver An object containing the id or number of the user receiving the currency.
 * @param amountSent The amount of currency to send.
 * @param notelink An object containing a note for the transaction, as well as a link to what the transaction was for if possible.
 */
export async function transaction(
	sender: { id?: string; number?: number },
	receiver: { id?: string; number?: number },
	amountSent: number,
	{ note, link }: { note?: String; link?: String },
) {
	const qResult = await mquery<
		| string[]
		| {
				amountSent: number
				taxRate: number
				note: string
				link: string
				time: string
		  }[]
	>(
		surql`
			BEGIN TRANSACTION; # lmfao

			LET $taxRate = stuff:economy.taxRate OR 30;

			LET $sender = (SELECT
				id,
				currency,
				number
			FROM user WHERE number = $senderNumber OR id = $senderId)[0];
			IF !$sender {
				THROW "Sender not found"
			};

			LET $receiver = (SELECT
				id,
				currency,
				number
			FROM user WHERE number = $receiverNumber OR id = $receiverId)[0];
			IF !$receiver {
				THROW "Receiver not found"
			};

			LET $senderAdmin = $sender.number == 1;
			LET $receiverAdmin = $receiver.number == 1;

			IF $amountSent > 0 {
				IF !$senderAdmin AND $sender.currency < $amountSent {
					THROW string::concat("Insufficient funds: You need ", $amountSent - $sender.currency, " more to buy this")
				};

				LET $finalAmount = math::round($amountSent * (1 - $taxRate / 100));

				UPDATE $sender SET currency -=
					IF $senderAdmin THEN
						0
					ELSE
						$amountSent
					END;

				UPDATE $receiver SET currency +=
					IF $receiverAdmin THEN
						0
					ELSE
						$finalAmount
					END;
			};

			RELATE $sender->transaction->$receiver CONTENT {
				amountSent: $amountSent,
				taxRate: $taxRate,
				note: $note,
				link: $link,
				time: time::now(),
			};

			COMMIT TRANSACTION`,
		{
			...(sender?.number
				? { senderNumber: sender.number }
				: { senderId: `user:${sender.id}` }),
			...(receiver?.number
				? { receiverNumber: receiver.number }
				: { receiverId: `user:${receiver.id}` }),
			amountSent,
			note,
			link,
		},
	)

	for (const result of qResult) {
		if (result == failed)
			for (const result2 of qResult)
				if (typeof result2 == "string" && result2 != failed)
					throw new Error(
						result2.match(/An error occurred: (.*)/)?.[1],
					)
	}
}
