# You could start with five or six queries, or ~just one~

SELECT
	username,
	number,
	permissionLevel,
	status,
	(SELECT text, updated FROM $parent.bio ORDER BY updated DESC)[0] AS bio,
	(SELECT
		*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content
	FROM ->posted->statusPost LIMIT 40) AS posts,

	(SELECT
		meta::id(id) AS id,
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

	$user INSIDE <->friends<->user AS friends,
	$user INSIDE <-follows<-user AS following,
	$user INSIDE ->follows->user AS follower,
	$user INSIDE ->request->user AS incomingRequest,
	$user INSIDE <-request<-user AS outgoingRequest,

	(SELECT name, count(<-member) AS memberCount
	FROM ->member->group) AS groups,
	(SELECT name, count(<-member) AS memberCount
	FROM ->owns->group) AS groupsOwned
FROM user WHERE number = $number;
