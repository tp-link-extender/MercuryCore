# Overwrites are needed to ensure that the schema is correct when changing in dev mode/on deployment

DEFINE NAMESPACE OVERWRITE main;
DEFINE DATABASE OVERWRITE main STRICT;

DEFINE TABLE OVERWRITE asset SCHEMAFULL TYPE NORMAL;
	# privileged assets are 8 digits, user-uploaded assets are 9 (max is 2^31-1 = 2147483647 (usually), we need numeric ids for reasons... eugh)
	DEFINE FIELD OVERWRITE id ON asset TYPE int;
	DEFINE FIELD OVERWRITE created ON asset TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE description ON asset TYPE array<object> DEFAULT ALWAYS [];
		DEFINE FIELD OVERWRITE description.*.text ON asset TYPE string;
		DEFINE FIELD OVERWRITE description.*.updated ON asset TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE forSale ON asset TYPE bool DEFAULT true;
	DEFINE FIELD OVERWRITE name ON asset TYPE string;
	DEFINE FIELD OVERWRITE price ON asset TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE type ON asset TYPE int;
	DEFINE FIELD OVERWRITE updated ON asset TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE visibility ON asset TYPE string DEFAULT "Pending";

DEFINE TABLE OVERWRITE auditLog SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE action ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE created ON auditLog TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE note ON auditLog TYPE string;
	DEFINE FIELD OVERWRITE user ON auditLog TYPE record<user>;

DEFINE TABLE OVERWRITE banner SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON banner TYPE string;
	DEFINE FIELD OVERWRITE active ON banner TYPE bool DEFAULT ALWAYS true;
	DEFINE FIELD OVERWRITE bgColour ON banner TYPE string;
	DEFINE FIELD OVERWRITE body ON banner TYPE string;
	DEFINE FIELD OVERWRITE created ON banner TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE creator ON banner TYPE record<user>;
	DEFINE FIELD OVERWRITE deleted ON banner TYPE bool;
	DEFINE FIELD OVERWRITE textLight ON banner TYPE bool;

DEFINE TABLE OVERWRITE comment SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON comment TYPE string;
	DEFINE FIELD OVERWRITE author ON comment COMPUTED
		(SELECT status, username FROM $this<-createdComment<-user)[0];
	DEFINE FIELD OVERWRITE content ON comment TYPE array<object> DEFAULT ALWAYS [];
		DEFINE FIELD OVERWRITE content.*.text ON comment TYPE string;
		DEFINE FIELD OVERWRITE content.*.updated ON comment TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE created ON comment TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE dislikes ON comment COMPUTED
		($user IN $this<-dislikes<-user.id);
	DEFINE FIELD OVERWRITE likes ON comment COMPUTED
		($user IN $this<-likes<-user.id);
	DEFINE FIELD OVERWRITE pinned ON comment TYPE bool DEFAULT ALWAYS false;
	DEFINE FIELD OVERWRITE score ON comment COMPUTED
		count(<-likes) - count(<-dislikes);
	DEFINE FIELD OVERWRITE type ON comment TYPE array;
		# ["status"] -> status post
		# ["status", "{status id}"] -> status post comment
		# ["forum", "{category id}"] -> forum post
		# ["forum", "{category id}", "{post id}"] -> forum post comment
		# ["asset", "{asset id}"] -> asset comment
		# ["asset", "{asset id}", "{comment id}"] -> asset comment comment
	DEFINE FIELD OVERWRITE visibility ON comment TYPE string DEFAULT "Visible";

DEFINE TABLE OVERWRITE commentLink SCHEMAFULL TYPE RELATION FROM comment TO comment ENFORCED;
	DEFINE FIELD OVERWRITE id ON commentLink TYPE string;

DEFINE TABLE OVERWRITE createdComment SCHEMAFULL TYPE RELATION FROM user TO comment ENFORCED;
	DEFINE FIELD OVERWRITE id ON createdComment TYPE string;

DEFINE TABLE OVERWRITE dislikes SCHEMAFULL TYPE RELATION FROM user TO asset | comment | place ENFORCED;
	DEFINE FIELD OVERWRITE id ON dislikes TYPE string;
	DEFINE FIELD OVERWRITE created ON dislikes TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE follows SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE id ON follows TYPE string;
	DEFINE FIELD OVERWRITE created ON follows TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE forumCategory SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON forumCategory TYPE string;
	DEFINE FIELD OVERWRITE created ON forumCategory TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE description ON forumCategory TYPE string;
	DEFINE FIELD OVERWRITE name ON forumCategory TYPE string;

DEFINE TABLE OVERWRITE friends SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE id ON friends TYPE string;
	DEFINE FIELD OVERWRITE created ON friends TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE group SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON group TYPE string;
	DEFINE FIELD OVERWRITE created ON group TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE name ON group TYPE string;

DEFINE TABLE OVERWRITE hasSession SCHEMAFULL TYPE RELATION FROM user TO session ENFORCED;
	DEFINE FIELD OVERWRITE id ON hasSession TYPE string;

DEFINE TABLE OVERWRITE imageAsset SCHEMAFULL TYPE RELATION FROM asset TO asset ENFORCED;
	DEFINE FIELD OVERWRITE id ON imageAsset TYPE string;

DEFINE TABLE OVERWRITE likes SCHEMAFULL TYPE RELATION FROM user TO asset | comment | place ENFORCED;
	DEFINE FIELD OVERWRITE id ON likes TYPE string;
	DEFINE FIELD OVERWRITE created ON likes TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE member SCHEMAFULL TYPE RELATION FROM user TO group ENFORCED;
	DEFINE FIELD OVERWRITE id ON member TYPE string;
	DEFINE FIELD OVERWRITE created ON member TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE moderation SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE id ON moderation TYPE string;
	DEFINE FIELD OVERWRITE active ON moderation TYPE bool;
	DEFINE FIELD OVERWRITE note ON moderation TYPE string;
	DEFINE FIELD OVERWRITE time ON moderation TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE timeEnds ON moderation TYPE datetime;
	DEFINE FIELD OVERWRITE type ON moderation TYPE string;

DEFINE TABLE OVERWRITE notification SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE id ON notification TYPE string;
	DEFINE FIELD OVERWRITE created ON notification TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE note ON notification TYPE string;
	DEFINE FIELD OVERWRITE read ON notification TYPE bool;
	DEFINE FIELD OVERWRITE relativeId ON notification TYPE string;
	DEFINE FIELD OVERWRITE type ON notification TYPE string;

DEFINE TABLE OVERWRITE ownsAsset SCHEMAFULL TYPE RELATION FROM user TO asset ENFORCED;
	DEFINE FIELD OVERWRITE id ON ownsAsset TYPE string;
	DEFINE FIELD OVERWRITE created ON ownsAsset TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE ownsGroup SCHEMAFULL TYPE RELATION FROM user TO group ENFORCED;
	DEFINE FIELD OVERWRITE id ON ownsGroup TYPE string;

DEFINE TABLE OVERWRITE ownsPlace SCHEMAFULL TYPE RELATION FROM user TO place ENFORCED;
	DEFINE FIELD OVERWRITE id ON ownsPlace TYPE string;

DEFINE TABLE OVERWRITE place SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON place TYPE int;
	DEFINE FIELD OVERWRITE created ON place TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE dedicated ON place TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE deleted ON place TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE description ON place TYPE array<object> DEFAULT ALWAYS [];
		DEFINE FIELD OVERWRITE description.*.text ON place TYPE string;
		DEFINE FIELD OVERWRITE description.*.updated ON place TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE maxPlayers ON place TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE name ON place TYPE string DEFAULT "";
	DEFINE FIELD OVERWRITE privateServer ON place TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE privateTicket ON place TYPE string DEFAULT rand::id();
	DEFINE FIELD OVERWRITE serverAddress ON place TYPE string DEFAULT "";
	DEFINE FIELD OVERWRITE serverPing ON place TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE serverPort ON place TYPE int;
	DEFINE FIELD OVERWRITE serverTicket ON place TYPE string DEFAULT rand::id();
	DEFINE FIELD OVERWRITE updated ON place TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE playing SCHEMAFULL TYPE RELATION FROM user TO place ENFORCED;
	DEFINE FIELD OVERWRITE id ON playing TYPE string;
	DEFINE FIELD OVERWRITE ping ON playing TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE valid ON playing TYPE bool DEFAULT true;

DEFINE TABLE OVERWRITE recentlyWorn SCHEMAFULL TYPE RELATION FROM user TO asset ENFORCED;
	DEFINE FIELD OVERWRITE id ON recentlyWorn TYPE string;
	DEFINE FIELD OVERWRITE time ON recentlyWorn TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE recoveryCode SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON recoveryCode TYPE string;
	DEFINE FIELD OVERWRITE code ON recoveryCode TYPE string DEFAULT rand::string(6);
	DEFINE FIELD OVERWRITE created ON recoveryCode TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE expires ON recoveryCode TYPE datetime DEFAULT ALWAYS time::now() + 1d;
	DEFINE FIELD OVERWRITE used ON recoveryCode TYPE bool DEFAULT false;
	DEFINE FIELD OVERWRITE user ON recoveryCode TYPE record<user>;

DEFINE TABLE OVERWRITE regKey SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON regKey TYPE string;
	DEFINE FIELD OVERWRITE created ON regKey TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE creator ON regKey TYPE record<user>;
	DEFINE FIELD OVERWRITE expiry ON regKey TYPE option<datetime>; # null -> NULL, undefined -> NONE
	DEFINE FIELD OVERWRITE usesLeft ON regKey TYPE int;

DEFINE TABLE OVERWRITE render SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON render TYPE string;
	DEFINE FIELD OVERWRITE created ON render TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE completed ON render TYPE option<datetime>; # hmm...
	DEFINE FIELD OVERWRITE relativeId ON render TYPE string | int;
	DEFINE FIELD OVERWRITE status ON render TYPE string DEFAULT "Pending";
	DEFINE FIELD OVERWRITE type ON render TYPE string;

DEFINE TABLE OVERWRITE report SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE id ON report TYPE string;
	DEFINE FIELD OVERWRITE category ON report TYPE string;
	DEFINE FIELD OVERWRITE note ON report TYPE string;
	DEFINE FIELD OVERWRITE time ON report TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE url ON report TYPE string;

DEFINE TABLE OVERWRITE request SCHEMAFULL TYPE RELATION FROM user TO user ENFORCED;
	DEFINE FIELD OVERWRITE id ON request TYPE string;
	DEFINE FIELD OVERWRITE created ON request TYPE datetime DEFAULT ALWAYS time::now();

DEFINE TABLE OVERWRITE session SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON session TYPE string;
	DEFINE FIELD OVERWRITE created ON session TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE expires ON session TYPE datetime DEFAULT ALWAYS time::now() + 30d;

# the awesomest table in Mercury Core
# What's in it? Nobody knooooowssssssss
DEFINE TABLE OVERWRITE stuff SCHEMALESS;

DEFINE TABLE OVERWRITE user SCHEMAFULL TYPE NORMAL;
	DEFINE FIELD OVERWRITE id ON user TYPE string;
	DEFINE FIELD OVERWRITE admin ON user TYPE bool DEFAULT count(SELECT 1 FROM user) == 0; # Only the first account should be admin
	DEFINE FIELD OVERWRITE bodyColours ON user TYPE object;
		DEFINE FIELD OVERWRITE bodyColours.Head ON user TYPE int;
		DEFINE FIELD OVERWRITE bodyColours.LeftArm ON user TYPE int;
		DEFINE FIELD OVERWRITE bodyColours.LeftLeg ON user TYPE int;
		DEFINE FIELD OVERWRITE bodyColours.RightArm ON user TYPE int;
		DEFINE FIELD OVERWRITE bodyColours.RightLeg ON user TYPE int;
		DEFINE FIELD OVERWRITE bodyColours.Torso ON user TYPE int;
	DEFINE FIELD OVERWRITE created ON user TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE css ON user TYPE string DEFAULT ALWAYS "";
	DEFINE FIELD OVERWRITE description ON user TYPE array<object> DEFAULT ALWAYS [];
		DEFINE FIELD OVERWRITE description.*.text ON user TYPE string;
		DEFINE FIELD OVERWRITE description.*.updated ON user TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE email ON user TYPE string
		ASSERT string::is_email($value) OR $value == "";
	DEFINE FIELD OVERWRITE hashedPassword ON user TYPE string;
	DEFINE FIELD OVERWRITE lastOnline ON user TYPE datetime DEFAULT ALWAYS time::now();
	DEFINE FIELD OVERWRITE permissionLevel ON user TYPE int;
	DEFINE FIELD OVERWRITE status ON user COMPUTED
		IF ->playing[WHERE valid AND ping > time::now() - 35s] {
			"Playing"
		} ELSE IF lastOnline > time::now() - 35s {
			"Online"
		} ELSE {
			"Offline"
		}; # parens no longer needed
	DEFINE FIELD OVERWRITE theme ON user TYPE int DEFAULT 0;
	DEFINE FIELD OVERWRITE username ON user TYPE string;
DEFINE INDEX IF NOT EXISTS usernameI ON user COLUMNS username UNIQUE;
# DEFINE INDEX IF NOT EXISTS emailI ON user COLUMNS email UNIQUE; # doesn't work with empty strings

DEFINE TABLE OVERWRITE used SCHEMAFULL TYPE RELATION FROM user TO regKey ENFORCED;
	DEFINE FIELD OVERWRITE id ON used TYPE string;

DEFINE FUNCTION OVERWRITE fn::assetId() {
	RETURN rand::int(100_000_000, 999_999_999);
};

DEFINE FUNCTION OVERWRITE fn::auditLog($action: string, $note: string, $user: record<user>) {
	CREATE auditLog CONTENT {
		action: $action,
		note: $note,
		user: $user,
	};
};

DEFINE FUNCTION OVERWRITE fn::clampPages($count: number, $pages: number) {
	RETURN math::max([math::ceil(<float> $count / 50), 1]);
};

DEFINE FUNCTION OVERWRITE fn::currentContent($thing: array) {
	RETURN (SELECT text, updated FROM $thing
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
			(SELECT 
				fn::getComments($this.id, $depth + 1, $user) AS comments,
				pinned,
				score
			FROM $comment<-commentLink<-comment
			ORDER BY pinned DESC, score DESC).comments
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
					FROM ONLY type::record("forumCategory", type[1])),
				post: IF type[2] {
					(SELECT fn::currentContent($this.content) AS currentContent
						FROM ONLY type::record("comment", type[2])).currentContent
				},
			}
		} ELSE IF type[0] == "asset" {
			{
				asset: (SELECT VALUE name
					FROM ONLY type::record("asset", type[1])),
			}
		}) AS info
	FROM $comment;
};

DEFINE FUNCTION OVERWRITE fn::notify($sender: record, $receiver: record, $type: string, $note: string, $relativeId: string) {
	RETURN RELATE $sender->notification->$receiver CONTENT {
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

DEFINE FUNCTION OVERWRITE fn::filterInventory($thing: object, $user: record<user>) {
	RETURN $user IN $thing<-ownsAsset<-user
		AND $thing.type IN [2, 8, 11, 12, 13, 18]
};

DEFINE FUNCTION OVERWRITE fn::filterGames($thing: object) {
	RETURN !$thing.privateServer AND !$thing.deleted
};

# remember to get ya parameters in the right order here
DEFINE FUNCTION OVERWRITE fn::search($query: string, $match: string) {
	RETURN string::similarity::fuzzy($query, $match) > 0;
};
