IF $notification.* {
	UPDATE $notification SET read = true WHERE out = $user;
};
