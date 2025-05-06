# Overwrites are needed to ensure that the schema is correct when changing in dev mode/on deployment

DEFINE TABLE OVERWRITE asset SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON asset TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE description ON asset FLEXIBLE TYPE array DEFAULT [];
	DEFINE FIELD OVERWRITE name ON asset TYPE string;
	DEFINE FIELD OVERWRITE price ON asset TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE type ON asset TYPE int;
	DEFINE FIELD OVERWRITE updated ON asset TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE visibility ON asset TYPE string DEFAULT "Pending";

DEFINE TABLE OVERWRITE assetCache SCHEMAFULL;
	DEFINE FIELD OVERWRITE assetModified ON assetCache TYPE string;
	DEFINE FIELD OVERWRITE created ON assetCache TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE description ON assetCache TYPE string DEFAULT ALWAYS "No description available.";
	DEFINE FIELD OVERWRITE name ON assetCache TYPE string DEFAULT ALWAYS "Unnamed asset";
	DEFINE FIELD OVERWRITE type ON assetCache TYPE int;

DEFINE TABLE OVERWRITE assetComment SCHEMAFULL;
	DEFINE FIELD OVERWRITE content ON assetComment FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE pinned ON assetComment TYPE bool;
	DEFINE FIELD OVERWRITE posted ON assetComment TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE visibility ON assetComment TYPE string;

DEFINE TABLE OVERWRITE auditLog SCHEMAFULL;
	DEFINE FIELD OVERWRITE action ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE note ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE time ON auditLog TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE user ON auditLog TYPE record<user>;

DEFINE TABLE OVERWRITE banner SCHEMAFULL;
	DEFINE FIELD OVERWRITE active ON banner TYPE bool;
	DEFINE FIELD OVERWRITE bgColour ON banner TYPE string;
	DEFINE FIELD OVERWRITE body ON banner TYPE string;
	DEFINE FIELD OVERWRITE creator ON banner TYPE record<user>;
	DEFINE FIELD OVERWRITE deleted ON banner TYPE bool;
	DEFINE FIELD OVERWRITE textLight ON banner TYPE bool;

DEFINE TABLE OVERWRITE forumCategory SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON forumCategory TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE description ON forumCategory TYPE string;
	DEFINE FIELD OVERWRITE name ON forumCategory TYPE string;

DEFINE TABLE OVERWRITE forumPost SCHEMAFULL;
	DEFINE FIELD OVERWRITE content ON forumPost FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE pinned ON forumPost TYPE bool;
	DEFINE FIELD OVERWRITE posted ON forumPost TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE title ON forumPost TYPE string;
	DEFINE FIELD OVERWRITE visibility ON forumPost TYPE string;

DEFINE TABLE OVERWRITE forumReply SCHEMAFULL;
	DEFINE FIELD OVERWRITE content ON forumReply FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE pinned ON forumReply TYPE bool;
	DEFINE FIELD OVERWRITE posted ON forumReply TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE visibility ON forumReply TYPE string;

DEFINE TABLE OVERWRITE group SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON group TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE name ON group TYPE string;

DEFINE TABLE OVERWRITE moderation SCHEMAFULL;
	DEFINE FIELD OVERWRITE active ON moderation TYPE bool;
	DEFINE FIELD OVERWRITE note ON moderation TYPE string;
	DEFINE FIELD OVERWRITE time ON moderation TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE timeEnds ON moderation TYPE datetime;
	DEFINE FIELD OVERWRITE type ON moderation TYPE string;

DEFINE TABLE OVERWRITE notification SCHEMAFULL;
	DEFINE FIELD OVERWRITE note ON notification TYPE string;
	DEFINE FIELD OVERWRITE read ON notification TYPE bool;
	DEFINE FIELD OVERWRITE relativeId ON notification TYPE any;
	DEFINE FIELD OVERWRITE time ON notification TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE type ON notification TYPE string;

DEFINE TABLE OVERWRITE owns SCHEMAFULL;
	DEFINE FIELD OVERWRITE time ON owns TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE place SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON place TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE deleted ON place TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE description ON place FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE maxPlayers ON place TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE name ON place TYPE string DEFAULT "";
	DEFINE FIELD OVERWRITE privateServer ON place TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE privateTicket ON place TYPE string DEFAULT rand::guid();
	DEFINE FIELD OVERWRITE serverIP ON place TYPE string DEFAULT "";
	DEFINE FIELD OVERWRITE serverPing ON place TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE serverPort ON place TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE serverTicket ON place TYPE string DEFAULT rand::guid();
	DEFINE FIELD OVERWRITE updated ON place TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE regKey SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON regKey TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE creator ON regKey TYPE record<user>;
	DEFINE FIELD OVERWRITE expiry ON regKey TYPE datetime;
	DEFINE FIELD OVERWRITE usesLeft ON regKey TYPE int;

DEFINE TABLE OVERWRITE render SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON render TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE completed ON render TYPE option<datetime>; # hmm...
	DEFINE FIELD OVERWRITE relativeId ON render TYPE any; # todo: uh
	DEFINE FIELD OVERWRITE status ON render TYPE string DEFAULT "Pending";
	DEFINE FIELD OVERWRITE type ON render TYPE string;

DEFINE TABLE OVERWRITE report SCHEMAFULL;
	DEFINE FIELD OVERWRITE category ON report TYPE string;
	DEFINE FIELD OVERWRITE note ON report TYPE string;
	DEFINE FIELD OVERWRITE time ON report TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE url ON report TYPE string;

DEFINE TABLE OVERWRITE session SCHEMAFULL;
	DEFINE FIELD OVERWRITE expiresAt ON session TYPE datetime;

DEFINE TABLE OVERWRITE statusPost SCHEMAFULL;
	DEFINE FIELD OVERWRITE content ON statusPost FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE posted ON statusPost TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE visibility ON statusPost TYPE string DEFAULT "Visible";

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
	DEFINE FIELD OVERWRITE bio ON user FLEXIBLE TYPE array DEFAULT [];
	DEFINE FIELD OVERWRITE bodyColours ON user FLEXIBLE TYPE object;
	DEFINE FIELD OVERWRITE created ON user TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE css ON user TYPE string DEFAULT "";
	DEFINE FIELD OVERWRITE email ON user TYPE string
		ASSERT string::is::email($value) OR $value == ""; # admin account uh yeah
	DEFINE FIELD OVERWRITE hashedPassword ON user TYPE string;
	DEFINE FIELD OVERWRITE lastOnline ON user TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE permissionLevel ON user TYPE int;
	DEFINE FIELD OVERWRITE status ON user VALUE <future> {
		(IF ->playing[WHERE valid AND ping > time::now() - 35s] {
			"Playing"
		} ELSE IF lastOnline > time::now() - 35s {
			"Online"
		} ELSE {
			"Offline"
		}) # dk y parens r needed
	};
	DEFINE FIELD OVERWRITE theme ON user TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE username ON user TYPE string;
DEFINE INDEX IF NOT EXISTS usernameI ON user COLUMNS username UNIQUE;
DEFINE INDEX IF NOT EXISTS emailI ON user COLUMNS email UNIQUE;

DEFINE FUNCTION OVERWRITE fn::auditLog($action: string, $note: string, $user: record) {
	CREATE auditLog CONTENT {
		action: $action,
		note: $note,
		user: $user,
	}
};

DEFINE FUNCTION OVERWRITE fn::clampPages($count: number, $pages: number) {
	RETURN math::max([math::ceil(<float> $count / 50), 1]);
};

DEFINE FUNCTION OVERWRITE fn::notify($user: record, $user2: record, $type: string, $note: string, $relativeId: any) {
	RETURN RELATE $user->notification->$user2 CONTENT {
		note: $note,
		read: false,
		relativeId: $relativeId,
		type: $type,
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

DEFINE EVENT OVERWRITE bannerCreateLog ON TABLE banner
WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat('Create banner "', $after.body, '"'), $after.creator);
DEFINE EVENT OVERWRITE bannerDeleteLog ON TABLE banner
WHEN $event = "UPDATE" AND !$before.deleted AND $after.deleted THEN
	fn::auditLog("Administration", string::concat('Delete banner "', $after.body, '"'), $after.creator);
DEFINE EVENT OVERWRITE regKeyCreateLog ON TABLE regKey
WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat("Create registration key ", record::id($after.id)), $after.creator);
DEFINE EVENT OVERWRITE regKeyDisableLog ON TABLE regKey
WHEN $event = "UPDATE" AND $after.usesLeft = 0 THEN
	fn::auditLog("Administration", string::concat("Disable registration key ", record::id($after.id)), $after.disabledBy);

# separation of concerns, maaaan

DEFINE FUNCTION OVERWRITE fn::filterInventory($thing: object) {
	RETURN $user IN $thing<-owns<-user
		AND $thing.type IN [2, 8, 11, 12, 17, 18, 19]
};

DEFINE FUNCTION OVERWRITE fn::filterGames($thing: object) {
	RETURN !$thing.privateServer AND !$thing.deleted
};
