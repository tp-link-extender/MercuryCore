# formatting seems.. fine? for now

DEFINE TABLE OVERWRITE auditLog SCHEMAFULL;
	DEFINE FIELD OVERWRITE action ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE note ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE time ON auditLog TYPE datetime;
	DEFINE FIELD OVERWRITE user ON auditLog TYPE record;

DEFINE TABLE OVERWRITE banner SCHEMAFULL;
	DEFINE FIELD OVERWRITE active ON banner TYPE bool;
	DEFINE FIELD OVERWRITE bgColour ON banner TYPE string;
	DEFINE FIELD OVERWRITE body ON banner TYPE string;
	DEFINE FIELD OVERWRITE creator ON banner TYPE record;
	DEFINE FIELD OVERWRITE deleted ON banner TYPE bool;
	DEFINE FIELD OVERWRITE textLight ON banner TYPE bool;

DEFINE TABLE OVERWRITE forumCategory SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON forumCategory TYPE datetime;
	DEFINE FIELD OVERWRITE description ON forumCategory TYPE string;
	DEFINE FIELD OVERWRITE name ON forumCategory TYPE string;

DEFINE TABLE OVERWRITE forumPost SCHEMAFULL;
	DEFINE FIELD OVERWRITE content ON forumPost FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE pinned ON forumPost TYPE bool;
	DEFINE FIELD OVERWRITE posted ON forumPost TYPE datetime;
	DEFINE FIELD OVERWRITE title ON forumPost TYPE string;
	DEFINE FIELD OVERWRITE visibility ON forumPost TYPE string;

DEFINE TABLE OVERWRITE forumReply SCHEMAFULL;
	DEFINE FIELD OVERWRITE content ON forumReply FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE pinned ON forumReply TYPE bool;
	DEFINE FIELD OVERWRITE posted ON forumReply TYPE datetime;
	DEFINE FIELD OVERWRITE visibility ON forumReply TYPE string;

DEFINE TABLE OVERWRITE render SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON render TYPE datetime;
	DEFINE FIELD OVERWRITE relativeId ON render TYPE any; # todo: uh
	DEFINE FIELD OVERWRITE status ON render TYPE string;
	DEFINE FIELD OVERWRITE type ON render TYPE string;

DEFINE TABLE OVERWRITE session SCHEMAFULL;
	DEFINE FIELD OVERWRITE expiresAt ON session TYPE number;

DEFINE TABLE OVERWRITE statusPost SCHEMAFULL;
	DEFINE FIELD OVERWRITE content ON statusPost FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE posted ON statusPost TYPE datetime;
	DEFINE FIELD OVERWRITE visibility ON statusPost TYPE string;

DEFINE TABLE OVERWRITE stuff SCHEMALESS;
IF stuff:increment == NULL {
	CREATE stuff:increment CONTENT {
		asset: 0,
		ping: {
			render: 0,
		}
	}
};

DEFINE TABLE OVERWRITE user SCHEMAFULL;
	DEFINE FIELD OVERWRITE bio ON user FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE bodyColours ON user FLEXIBLE TYPE object;
	DEFINE FIELD OVERWRITE created ON user TYPE string;
	DEFINE FIELD OVERWRITE css ON user TYPE string;
	DEFINE FIELD OVERWRITE email ON user TYPE string
		ASSERT string::is::email($value) OR $value == ""; # admin account uh yeah
	DEFINE FIELD OVERWRITE hashedPassword ON user TYPE string;
	DEFINE FIELD OVERWRITE lastOnline ON user TYPE datetime;
	DEFINE FIELD OVERWRITE permissionLevel ON user TYPE number;
	DEFINE FIELD OVERWRITE status ON user TYPE any; # future ig
	DEFINE FIELD OVERWRITE theme ON user TYPE number;
	DEFINE FIELD OVERWRITE username ON user TYPE string;
DEFINE INDEX IF NOT EXISTS usernameI ON user COLUMNS username UNIQUE;
DEFINE INDEX IF NOT EXISTS emailI ON user COLUMNS email UNIQUE;

DEFINE FUNCTION OVERWRITE fn::auditLog($action: string, $note: string, $user: record) {
	CREATE auditLog CONTENT {
		action: $action,
		note: $note,
		user: $user,
		time: time::now()
	}
};

DEFINE FUNCTION OVERWRITE fn::clampPages($count: number, $pages: number) {
	RETURN math::max([math::ceil(<float> $count / 50), 1]);
};

DEFINE FUNCTION OVERWRITE fn::notify($user: record, $user2: record, $type: string, $note: string, $relativeId: any) {
	RETURN RELATE $user->notification->$user2 CONTENT {
		type: $type,
		time: time::now(),
		note: $note,
		relativeId: $relativeId,
		read: false,
	};
};

# not very dry
DEFINE FUNCTION OVERWRITE fn::getReplies($reply: record, $depth: number, $user: record) {
    IF $depth > 9 {
        RETURN [];
    };
    
    RETURN SELECT
		*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		record::id(id) AS id,
		NONE AS parentReplyId,
		(SELECT status, username FROM <-created<-user)[0] AS author,

		count(<-likes) - count(<-dislikes) AS score,
		$user IN <-likes<-user.id AS likes,
		$user IN <-dislikes<-user.id AS dislikes,

        fn::getReplies(id, $depth + 1, $user) AS replies
    FROM $reply<-replyToReply<-forumReply;
};

DEFINE FUNCTION OVERWRITE fn::getComments($comment: record, $depth: number, $user: record) {
    IF $depth > 9 {
        RETURN [];
    };
    
    RETURN SELECT
		*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		record::id(id) AS id,
		NONE AS parentReplyId,
		(SELECT status, username FROM <-created<-user)[0] AS author,

		count(<-likes) - count(<-dislikes) AS score,
		$user IN <-likes<-user.id AS likes,
		$user IN <-dislikes<-user.id AS dislikes,

        fn::getComments(id, $depth + 1, $user) AS replies
    FROM $comment<-replyToComment<-assetComment
	ORDER BY score DESC; 
};

DEFINE EVENT OVERWRITE bannerCreateLog ON TABLE banner WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat('Create banner "', $after.body, '"'), $after.creator);
DEFINE EVENT OVERWRITE bannerDeleteLog ON TABLE banner WHEN $event = "UPDATE" AND !$before.deleted AND $after.deleted THEN
	fn::auditLog("Administration", string::concat('Delete banner "', $after.body, '"'), $after.creator);
DEFINE EVENT OVERWRITE regKeyCreateLog ON TABLE regKey WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat("Create registration key ", record::id($after.id)), $after.creator);
DEFINE EVENT OVERWRITE regKeyDisableLog ON TABLE regKey WHEN $event = "UPDATE" AND $after.usesLeft = 0 THEN
	fn::auditLog("Administration", string::concat("Disable registration key ", record::id($after.id)), $after.disabledBy);

# separation of concerns, maaaan

DEFINE FUNCTION OVERWRITE fn::filterInventory($thing: object) {
	RETURN $user IN $thing<-owns<-user
		AND $thing.type IN [2, 8, 11, 12, 17, 18, 19]
};

DEFINE FUNCTION OVERWRITE fn::filterGames($thing: object) {
	RETURN !$thing.privateServer AND !$thing.deleted
};
