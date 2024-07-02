DEFINE TABLE stuff SCHEMALESS;

DEFINE TABLE user SCHEMALESS;
DEFINE INDEX usernameI ON TABLE user COLUMNS username UNIQUE;
DEFINE INDEX emailI ON TABLE user COLUMNS email UNIQUE;

DEFINE FUNCTION fn::id() {
	RETURN function((UPDATE ONLY stuff:increment SET ids += 1).ids) {
		return arguments[0].toString(36) // jar var script in muh dayta bayse
	}
};
