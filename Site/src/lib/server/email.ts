import { createTransport } from "nodemailer"
import type Mail from "nodemailer/lib/mailer"
import { building } from "$app/environment"
import config from "./config"

let transport = null as unknown as Mail
if (!building)
	try {
		transport = createTransport({
			auth: {
				pass: process.env.EMAIL_PASSWORD,
				user: config.Email.Username,
			},
			host: config.Email.Host,
			port: config.Email.Port,
			secure: config.Email.Secure,
		})
		transport.on("error", err =>
			console.error("SMTP Transport Error:", err)
		)
		transport.on("idle", () => console.log("SMTP Transport is idle"))
		transport.on("token", () => console.log("SMTP Transport token event"))

		console.log("Verifying SMTP transport...")
		await transport.verify()
		console.log("SMTP transport verified successfully.")

		transport.use("stream", (mail, callback) => {
			console.log("Preparing to send email:")
			console.log(`From: ${mail.data.from}`)
			console.log(`To: ${mail.data.to}`)
			console.log(`Subject: ${mail.data.subject}`)
			callback()
		})
	} catch (error) {
		console.error("Error creating SMTP transport:", error)
		throw error
	}

export async function sendEmail(to: string, subject: string, text: string) {
	console.log(`Queuing email to ${to}`)
	const result = await transport.sendMail({
		from: `${config.Name} <noreply@${config.Domain}>`,
		subject,
		text,
		to,
	})
	if (result.accepted?.length)
		console.log(`Email to ${to} queued successfully`)
	else console.error(`Failed to queue email to ${to}`)
}
