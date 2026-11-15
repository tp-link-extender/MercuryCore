# Logged here rather than in an event, so the log names the admin making the change instead of the banner's creator
LET $body = SELECT VALUE body FROM ONLY $banner WHERE !deleted;
IF $body != NONE {
	UPDATE $banner MERGE $changes;
	fn::auditLog("Administration", string::concat($action, ' banner "', $body, '"', $detail), $user);
};
RETURN $body != NONE;
