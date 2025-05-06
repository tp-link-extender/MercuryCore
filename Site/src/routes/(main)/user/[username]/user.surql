# You could start with five or six queries, or ~just one~

SELECT
	username,
	number,
	permissionLevel,
	status,
	(SELECT text, updated FROM $parent.bio ORDER BY updated)[$] AS bio,
	(SELECT
		*,
		record::id(id) AS id,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content
	FROM ->created->statusPost LIMIT 40) AS posts,

	(SELECT
		record::id(id) AS id,
		name,
		count(
			SELECT 1 FROM <-playing WHERE valid AND ping > time::now() - 35s
		) AS playerCount,

		count(<-likes) AS likeCount,
		count(<-dislikes) AS dislikeCount
	FROM ->owns->place) AS places,

	count(<->friends) AS friendCount,
	count(<-follows) AS followerCount,
	count(->follows) AS followingCount,

	$user IN <->friends<->user AS friends,
	$user IN <-follows<-user AS following,
	$user IN ->follows->user AS follower,
	$user IN ->request->user AS incomingRequest,
	$user IN <-request<-user AS outgoingRequest,

	(SELECT name, count(<-member) AS memberCount
	FROM ->member->group) AS groups,
	(SELECT name, count(<-member) AS memberCount
	FROM ->owns->group) AS groupsOwned
FROM user WHERE username = $username;
