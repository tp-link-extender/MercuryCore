SELECT record::id(id) AS id, name, price, type FROM asset WHERE id IN $ids;
