LET $render = (SELECT status, created, id FROM render
	WHERE status IN ["Pending", "Rendering"]
		AND type = ${renderType}
		AND relativeId = ${relativeId})[0];
IF $render AND $render.created + 1s < time::now() {
	UPDATE $render.id SET status = "Error"
};
# need the updated one
SELECT status, created, id FROM $render.id;
