# You could start with five or six queries, or ~just one~

SELECT
	record::id(id) AS id,
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
	FROM $parent->member->group) AS groups
FROM user WHERE username = $username;
