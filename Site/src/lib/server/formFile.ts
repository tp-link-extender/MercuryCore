import { type } from "arktype"

/**
 * A file field on a remote form.
 * SvelteKit deserialises uploads as Blob-backed objects that only pretend to be Files, which arktype's File check doesn't recognise, so accept any Blob and present it as a File.
 */
export const formFile = type("Blob").as<File>()
