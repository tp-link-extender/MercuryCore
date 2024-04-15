BEGIN TRANSACTION; # lmfao
LET $taxRate = stuff:economy.taxRate OR 30;

LET $sender = (SELECT id, currency, number FROM user
WHERE number = $senderNumber OR id = $senderId)[0];
IF !$sender {
	THROW "Sender not found"
};

LET $receiver = (SELECT id, currency, number FROM user
WHERE number = $receiverNumber OR id = $receiverId)[0];
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
		IF $senderAdmin THEN 0 ELSE $amountSent END;

	UPDATE $receiver SET currency +=
		IF $receiverAdmin THEN 0 ELSE $finalAmount END;
};

RELATE $sender->transaction->$receiver CONTENT {
	amountSent: $amountSent,
	taxRate: $taxRate,
	note: $note,
	link: $link,
	time: time::now(),
};
COMMIT TRANSACTION;
