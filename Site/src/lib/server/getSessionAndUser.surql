# TODO: this query is called a lot, see if we can select more optimally than just * for users
(SELECT *, record::id(id) AS id FROM $sess
	WHERE $sess)[0];
(SELECT *, record::id(id) AS id FROM $sess<-hasSession<-user
	WHERE $sess)[0];
