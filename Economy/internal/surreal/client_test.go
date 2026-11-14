package surreal

import "testing"

func TestAuth(t *testing.T) {
	root := Auth("main", "main", "root", "p")
	if root.Namespace != "" || root.Database != "" {
		t.Fatalf("root should sign in at root level, got %+v", root)
	}
	site := Auth("main", "main", "site", "p")
	if site.Namespace != "main" || site.Database != "main" {
		t.Fatalf("database users need a namespace and database, got %+v", site)
	}
}

func TestPassword(t *testing.T) {
	t.Setenv("DATABASE_PASSWORD", "site-pass")
	t.Setenv("DATABASE_ROOT_PASSWORD", "root-pass")
	if got := Password("site", "flag"); got != "flag" {
		t.Fatalf("an explicit password should win, got %q", got)
	}
	if got := Password("site", ""); got != "site-pass" {
		t.Fatalf("got %q, want DATABASE_PASSWORD", got)
	}
	if got := Password("root", ""); got != "root-pass" {
		t.Fatalf("got %q, want DATABASE_ROOT_PASSWORD", got)
	}
}

func TestDefaultUser(t *testing.T) {
	t.Setenv("DATABASE_USER", "")
	if got := DefaultUser(); got != "site" {
		t.Fatalf("got %q, want site", got)
	}
	t.Setenv("DATABASE_USER", "web")
	if got := DefaultUser(); got != "web" {
		t.Fatalf("got %q, want web", got)
	}
}
