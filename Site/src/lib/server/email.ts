import { createTransport } from "nodemailer"
import type Mail from "nodemailer/lib/mailer"
import { building } from "$app/env"
import config from "./config"

let transport: Promise<Mail> | null = null

// Created on first use, not at import time: pages import the modules that send email (through remote functions), and a failed SMTP connection shouldn't break rendering them
const getTransport = () => {
	if (transport) return transport
	if (building)
		throw new Error("SMTP transport is not available while building")

	transport = (async () => {
		const t = createTransport({
			auth: {
				pass: process.env.EMAIL_PASSWORD,
				user: config.Email.Username,
			},
			host: config.Email.Host,
			port: config.Email.Port,
			secure: config.Email.Secure,
		})
		t.on("error", err => console.error("SMTP Transport Error:", err))
		t.on("idle", () => console.log("SMTP Transport is idle"))
		t.on("token", () => console.log("SMTP Transport token event"))

		console.log("Verifying SMTP transport...")
		await t.verify()
		console.log("SMTP transport verified successfully.")

		t.use("stream", (mail, callback) => {
			console.log("Preparing to send email:")
			console.log("From:", mail.data.from)
			console.log(`Subject: ${mail.data.subject}`)
			callback()
		})

		return t
	})()

	// A failed connection shouldn't be cached, so the next attempt starts over
	transport.catch(() => {
		transport = null
	})

	return transport
}

// Recipient addresses are never logged, so the logs don't reveal who has an account or asked to recover one
export async function sendEmail(to: string, subject: string, text: string) {
	const t = await getTransport()
	console.log(`Queuing email "${subject}"`)
	const result = await t.sendMail({
		from: `${config.Name} <noreply@${config.Domain}>`,
		subject,
		text,
		to,
	})
	if (result.accepted?.length)
		console.log(`Email "${subject}" queued successfully`)
	else console.error(`Failed to queue email "${subject}"`)
}
