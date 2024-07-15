# formatting seems.. fine? for now

DEFINE TABLE auditLog SCHEMAFULL;
	DEFINE FIELD action ON auditLog TYPE string;
	DEFINE FIELD note ON auditLog TYPE string;
	DEFINE FIELD time ON auditLog TYPE datetime;
	DEFINE FIELD user ON auditLog TYPE record;

DEFINE TABLE banner SCHEMAFULL;
	DEFINE FIELD active ON banner TYPE bool;
	DEFINE FIELD bgColour ON banner TYPE string;
	DEFINE FIELD body ON banner TYPE string;
	DEFINE FIELD creator ON banner TYPE record;
	DEFINE FIELD deleted ON banner TYPE bool;
	DEFINE FIELD textLight ON banner TYPE bool;

DEFINE TABLE forumCategory SCHEMAFULL;
	DEFINE FIELD created ON forumCategory TYPE datetime;
	DEFINE FIELD description ON forumCategory TYPE string;
	DEFINE FIELD name ON forumCategory TYPE string;

DEFINE TABLE forumPost SCHEMAFULL;
	DEFINE FIELD content ON forumPost FLEXIBLE TYPE array;
	DEFINE FIELD pinned ON forumPost TYPE bool;
	DEFINE FIELD posted ON forumPost TYPE datetime;
	DEFINE FIELD title ON forumPost TYPE string;
	DEFINE FIELD visibility ON forumPost TYPE string;

DEFINE TABLE forumReply SCHEMAFULL;
	DEFINE FIELD content ON forumReply FLEXIBLE TYPE array;
	DEFINE FIELD pinned ON forumReply TYPE bool;
	DEFINE FIELD posted ON forumReply TYPE datetime;
	DEFINE FIELD visibility ON forumReply TYPE string;

DEFINE TABLE render SCHEMAFULL;
	DEFINE FIELD created ON render TYPE datetime;
	DEFINE FIELD relativeId ON render TYPE any; # todo: uh
	DEFINE FIELD status ON render TYPE string;
	DEFINE FIELD type ON render TYPE string;

DEFINE TABLE session SCHEMAFULL;
	DEFINE FIELD expiresAt ON session TYPE number;

DEFINE TABLE statusPost SCHEMAFULL;
	DEFINE FIELD content ON statusPost FLEXIBLE TYPE array;
	DEFINE FIELD posted ON statusPost TYPE datetime;
	DEFINE FIELD visibility ON statusPost TYPE string;

DEFINE TABLE stuff SCHEMALESS;

DEFINE TABLE user SCHEMAFULL;
	DEFINE FIELD bio ON user FLEXIBLE TYPE array;
	DEFINE FIELD bodyColours ON user FLEXIBLE TYPE object;
	DEFINE FIELD created ON user TYPE string;
	DEFINE FIELD css ON user TYPE string;
	DEFINE FIELD currencyCollected ON user TYPE datetime;
	DEFINE FIELD email ON user TYPE string
		ASSERT string::is::email($value) OR $value == ""; # admin account uh yeah
	DEFINE FIELD hashedPassword ON user TYPE string;
	DEFINE FIELD lastOnline ON user TYPE datetime;
	DEFINE FIELD permissionLevel ON user TYPE number;
	DEFINE FIELD status ON user TYPE any; # future ig
	DEFINE FIELD username ON user TYPE string;
DEFINE INDEX usernameI ON user COLUMNS username UNIQUE;
DEFINE INDEX emailI ON user COLUMNS email UNIQUE;

DEFINE FUNCTION fn::auditLog($action: string, $note: string, $user: record) {
	CREATE auditLog CONTENT {
		action: $action,
		note: $note,
		user: $user,
		time: time::now()
	}
};

DEFINE FUNCTION fn::id() {
	RETURN function((UPDATE ONLY stuff:increment SET ids += 1).ids) {
		return arguments[0].toString(36) // jar var script in muh dayta bayse
	}
};

DEFINE EVENT bannerCreateLog ON TABLE banner WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat('Create banner "', $after.body, '"'), $after.creator);
DEFINE EVENT bannerDeleteLog ON TABLE banner WHEN $event = "UPDATE" AND !$before.deleted AND $after.deleted THEN
	fn::auditLog("Administration", string::concat('Delete banner "', $after.body, '"'), $after.creator);
DEFINE EVENT regKeyCreateLog ON TABLE regKey WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat("Create invite key ", meta::id($after.id)), $after.creator);
DEFINE EVENT regKeyDisableLog ON TABLE regKey WHEN $event = "UPDATE" AND $after.usesLeft = 0 THEN
	fn::auditLog("Administration", string::concat("Disable invite key ", meta::id($after.id)), $after.disabledBy);
