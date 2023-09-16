export default (statement: TemplateStringsArray, ...substitutions: string[]) =>
	statement.raw.reduce((query, part, index) => {
		// Add the current part of the statement to the query
		query += part

		// If there is a substitution at this index, add it
		if (index < substitutions.length) query += substitutions[index]

		return query
	}, "")
