# Overwrites are needed to ensure that the schema is correct when changing in dev mode/on deployment

DEFINE TABLE OVERWRITE asset SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON asset TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE description ON asset FLEXIBLE TYPE array DEFAULT ALWAYS [];
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

DEFINE TABLE OVERWRITE auditLog SCHEMAFULL;
	DEFINE FIELD OVERWRITE action ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE created ON auditLog TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE note ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE user ON auditLog TYPE record<user>;

DEFINE TABLE OVERWRITE banner SCHEMAFULL;
	DEFINE FIELD OVERWRITE active ON banner TYPE bool;
	DEFINE FIELD OVERWRITE bgColour ON banner TYPE string;
	DEFINE FIELD OVERWRITE body ON banner TYPE string;
	DEFINE FIELD OVERWRITE creator ON banner TYPE record<user>;
	DEFINE FIELD OVERWRITE deleted ON banner TYPE bool;
	DEFINE FIELD OVERWRITE textLight ON banner TYPE bool;

DEFINE TABLE OVERWRITE comment SCHEMAFULL;
	DEFINE FIELD OVERWRITE author ON comment VALUE <future> {
		(SELECT status, username FROM <-createdComment<-user)[0]
	};
	DEFINE FIELD OVERWRITE content ON comment FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE created ON comment TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE dislikes ON comment VALUE <future> {
		($user IN <-dislikes<-user.id) 
	};
	DEFINE FIELD OVERWRITE likes ON comment VALUE <future> {
		($user IN <-likes<-user.id) 
	};
	DEFINE FIELD OVERWRITE pinned ON comment TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE score ON comment VALUE <future> {
		count(<-likes) - count(<-dislikes)
	};
	DEFINE FIELD OVERWRITE type ON comment FLEXIBLE TYPE array;
		# ["status"] -> status
		# ["status", "{status id}"] -> status reply
		# ["forum", "{category id}"] -> forum post
		# ["forum", "{category id}", "{post id}"] -> forum post
		# ["asset", "{asset id}"] -> asset/catalog
	DEFINE FIELD OVERWRITE visibility ON comment TYPE string DEFAULT "Visible";

DEFINE TABLE OVERWRITE commentLink SCHEMAFULL TYPE RELATION FROM comment TO comment ENFORCED;

DEFINE TABLE OVERWRITE dislikes SCHEMAFULL TYPE RELATION FROM user TO asset | comment | place ENFORCED;
	DEFINE FIELD OVERWRITE created ON dislikes TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE follows SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE created ON follows TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE forumCategory SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON forumCategory TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE description ON forumCategory TYPE string;
	DEFINE FIELD OVERWRITE name ON forumCategory TYPE string;

DEFINE TABLE OVERWRITE friends SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE created ON friends TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE group SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON group TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE name ON group TYPE string;

DEFINE TABLE OVERWRITE hasSession SCHEMAFULL TYPE RELATION FROM user TO session ENFORCED;

DEFINE TABLE OVERWRITE likes SCHEMAFULL TYPE RELATION FROM user TO asset | comment | place ENFORCED;
	DEFINE FIELD OVERWRITE created ON likes TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE moderation SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE active ON moderation TYPE bool;
	DEFINE FIELD OVERWRITE note ON moderation TYPE string;
	DEFINE FIELD OVERWRITE time ON moderation TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE timeEnds ON moderation TYPE datetime;
	DEFINE FIELD OVERWRITE type ON moderation TYPE string;

DEFINE TABLE OVERWRITE notification SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE created ON notification TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE note ON notification TYPE string;
	DEFINE FIELD OVERWRITE read ON notification TYPE bool;
	DEFINE FIELD OVERWRITE relativeId ON notification TYPE any;
	DEFINE FIELD OVERWRITE type ON notification TYPE string;

DEFINE TABLE OVERWRITE ownsAsset SCHEMAFULL TYPE RELATION FROM user TO asset ENFORCED;
	DEFINE FIELD OVERWRITE created ON ownsAsset TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE ownsGroup SCHEMAFULL TYPE RELATION FROM user TO group;

DEFINE TABLE OVERWRITE ownsPlace SCHEMAFULL TYPE RELATION FROM user TO place ENFORCED;

DEFINE TABLE OVERWRITE place SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON place TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE deleted ON place TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE description ON place FLEXIBLE TYPE array;
	DEFINE FIELD OVERWRITE maxPlayers ON place TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE name ON place TYPE string DEFAULT "";
	DEFINE FIELD OVERWRITE privateServer ON place TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE privateTicket ON place TYPE string DEFAULT rand::guid();
	DEFINE FIELD OVERWRITE serverAddress ON place TYPE string DEFAULT "";
	DEFINE FIELD OVERWRITE serverPing ON place TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE serverPort ON place TYPE int;
	DEFINE FIELD OVERWRITE serverTicket ON place TYPE string DEFAULT rand::guid();
	DEFINE FIELD OVERWRITE updated ON place TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE createdComment SCHEMAFULL TYPE RELATION FROM user TO comment;

DEFINE TABLE OVERWRITE regKey SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON regKey TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE creator ON regKey TYPE record<user>;
	DEFINE FIELD OVERWRITE expiry ON regKey TYPE option<datetime>; # null -> NULL, undefined -> NONE
	DEFINE FIELD OVERWRITE usesLeft ON regKey TYPE int;

DEFINE TABLE OVERWRITE render SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON render TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE completed ON render TYPE option<datetime>; # hmm...
	DEFINE FIELD OVERWRITE relativeId ON render TYPE any; # todo: uh
	DEFINE FIELD OVERWRITE status ON render TYPE string DEFAULT "Pending";
	DEFINE FIELD OVERWRITE type ON render TYPE string;

DEFINE TABLE OVERWRITE report SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE category ON report TYPE string;
	DEFINE FIELD OVERWRITE note ON report TYPE string;
	DEFINE FIELD OVERWRITE time ON report TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE url ON report TYPE string;

DEFINE TABLE OVERWRITE request SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE created ON request TYPE datetime DEFAULT time::now();

DEFINE TABLE OVERWRITE session SCHEMAFULL;
	DEFINE FIELD OVERWRITE created ON session TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE expiresAt ON session TYPE datetime;

DEFINE TABLE OVERWRITE stuff SCHEMALESS;

DEFINE TABLE OVERWRITE user SCHEMAFULL;
	DEFINE FIELD OVERWRITE bodyColours ON user FLEXIBLE TYPE object;
	DEFINE FIELD OVERWRITE created ON user TYPE datetime DEFAULT time::now();
	DEFINE FIELD OVERWRITE css ON user TYPE string DEFAULT ALWAYS "";
	DEFINE FIELD OVERWRITE description ON user FLEXIBLE TYPE array DEFAULT ALWAYS [];
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

DEFINE TABLE OVERWRITE used SCHEMAFULL TYPE RELATION FROM user TO regKey ENFORCED;

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

DEFINE FUNCTION OVERWRITE fn::currentContent($thing: record) {
	RETURN (SELECT text, updated FROM $thing.content
	ORDER BY updated)[$].text
};

DEFINE FUNCTION OVERWRITE fn::getComments($comment: record<comment>, $depth: number, $user: record<user>) {
    IF $depth > 9 {
        RETURN [];
    };

	RETURN SELECT
		record::id(id) AS id,
		author,
		SELECT text, updated FROM $parent.content
		ORDER BY updated DESC AS content,
		array::flatten(
			SELECT VALUE fn::getComments($this.id, $depth + 1, $user)
			FROM $comment<-commentLink<-comment
		) AS comments,
		created,
		dislikes,
		likes,
		SELECT VALUE record::id(id)
		FROM $comment->commentLink->comment AS parentId,
		pinned,
		score,
		type,
		visibility,
		(IF type[0] == "forum" {
			{
				category: (SELECT VALUE name
					FROM ONLY type::thing("forumCategory", type[1])),
				post: IF type[2] {
					(SELECT fn::currentContent(id) AS currentContent
						FROM ONLY type::thing("comment", type[2])).currentContent
				},
			}
		} ELSE IF type[0] == "asset" {

		}) AS info
	FROM $comment;
};

DEFINE FUNCTION OVERWRITE fn::notify($user: record, $user2: record, $type: string, $note: string, $relativeId: any) {
	RETURN RELATE $user->notification->$user2 CONTENT {
		note: $note,
		read: false,
		relativeId: $relativeId,
		type: $type,
	};
};

# Events are mad awesome but they result in bugs that are FUCKING IMPOSSIBLE TO TRACK DOWN
# IF SOMETHING INSANE IS HAPPENING TO THE DATABASE THE CAUSE IS PROBABLY HERE
DEFINE EVENT OVERWRITE bannerCreateLog ON TABLE banner
WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat('Create banner "', $after.body, '"'), $after.creator);
DEFINE EVENT OVERWRITE bannerDeleteLog ON TABLE banner
WHEN $event = "UPDATE" AND !$before.deleted AND $after.deleted THEN
	fn::auditLog("Administration", string::concat('Delete banner "', $after.body, '"'), $after.creator);
DEFINE EVENT OVERWRITE regKeyCreateLog ON TABLE regKey
WHEN $event = "CREATE" THEN
	fn::auditLog("Administration", string::concat("Create registration key ", record::id($after.id)), $after.creator);

# separation of concerns, maaaan

DEFINE FUNCTION OVERWRITE fn::filterInventory($thing: object) {
	RETURN $user IN $thing<-ownsAsset<-user
		AND $thing.type IN [2, 8, 11, 12, 17, 18, 19]
};

DEFINE FUNCTION OVERWRITE fn::filterGames($thing: object) {
	RETURN !$thing.privateServer AND !$thing.deleted
};
