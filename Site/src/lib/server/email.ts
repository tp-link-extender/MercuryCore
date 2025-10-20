import { createTransport } from "nodemailer"
import type Mail from "nodemailer/lib/mailer"
import { SMTPServer } from "smtp-server"
import { SMTP_PORT } from "$env/static/private"
import config from "./config"

const port = +SMTP_PORT || 4442

console.log("Starting SMTP server...")
let server: SMTPServer
try {
	server = new SMTPServer({
		authOptional: true,
	})
} catch (error) {
	console.error("Error creating SMTP server:", error)
	throw error
}

server.listen(port, () =>
	console.log(`SMTP server is listening on port ${port}`)
)
server.on("error", err => console.error("SMTP Server Error:", err))
server.on("close", () => console.log("SMTP server has closed"))

let transport: Mail
try {
	transport = createTransport({
		host: "localhost",
		port,
		secure: false,
		ignoreTLS: true,
		tls: {
			rejectUnauthorized: false,
		},
		// connectionTimeout: 5000,
		// dnsTimeout: 5000,
		// socketTimeout: 5000,
		// greetingTimeout: 5000,
	})
} catch (error) {
	console.error("Error creating SMTP transport:", error)
	throw error
}
transport.on("error", err => console.error("SMTP Transport Error:", err))
transport.on("idle", () => console.log("SMTP Transport is idle"))
transport.on("token", () => console.log("SMTP Transport token event"))

console.log("Verifying SMTP transport...")
try {
	await transport.verify()
} catch (error) {
	throw new Error(`SMTP transport verification failed: ${error}`)
}
console.log("SMTP transport verified successfully.")

transport.use("stream", (mail, callback) => {
	console.log("Preparing to send email:")
	console.log(`From: ${mail.data.from}`)
	console.log(`To: ${mail.data.to}`)
	console.log(`Subject: ${mail.data.subject}`)
	callback()
})

export async function sendEmail(to: string, subject: string, text: string) {
	console.log(`Queuing email to ${to} with subject "${subject}"`)
	const result = await transport.sendMail({
		from: `${config.Name} <noreply@${config.Domain}>`,
		to,
		subject,
		text,
	})
	if (result.accepted.length > 0)
		console.log(`Email to ${to} queued successfully`)
	else console.error(`Failed to queue email to ${to}`)
	console.log(result)
}
