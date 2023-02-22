-- custom migration

CREATE TABLE public.key (
  id TEXT PRIMARY KEY,
  user_id INTEGER REFERENCES public.user(id) NOT NULL,
  "primary" BOOLEAN NOT NULL,
  hashed_password TEXT
);

INSERT INTO public.key (id, user_id, "primary", hashed_password)
SELECT provider_id, id, TRUE, hashed_password
FROM public.user;

ALTER TABLE public.user
DROP COLUMN provider_id,
DROP COLUMN hashed_password;

ALTER TABLE public.session
RENAME COLUMN expires TO active_expires;
