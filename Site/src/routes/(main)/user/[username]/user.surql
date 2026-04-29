# You could start with five or six queries, or ~just one~

SELECT
	username,
	number,
	permissionLevel,
	status,
	fn::currentContent($this.description) AS description,
	(SELECT
		*,
		record::id(id) AS id,
		fn::currentContent($this.content) AS content
	FROM $parent->createdComment->comment LIMIT 40) AS comments,

	(SELECT
		record::id(id) AS id,
		name,
		count(
			SELECT 1 FROM $parent<-playing WHERE valid AND ping > time::now() - 35s
		) AS playerCount,

		count(<-likes) AS likeCount,
		count(<-dislikes) AS dislikeCount
	FROM $parent->ownsPlace->place) AS places,

	count(<->friends) AS friendCount,
	count(<-follows) AS followerCount,
	count(->follows) AS followingCount,

	$user IN <->friends<->user AS friends,
	$user IN <-follows<-user AS following,
	$user IN ->follows->user AS follower,
	$user IN ->request->user AS incomingRequest,
	$user IN <-request<-user AS outgoingRequest,

	(SELECT 
		record::id(id) AS id,
		name,
		count(<-member) AS memberCount
	FROM $parent->member->group) AS groups,
	(SELECT 
		record::id(id) AS id,
		name,
		count(<-member) AS memberCount
	FROM $parent->ownsGroup->group) AS groupsOwned
FROM user WHERE username = $username;
