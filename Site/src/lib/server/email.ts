import { createTransport } from "nodemailer"
import { SMTPServer } from "smtp-server"
import { SMTP_PORT } from "$env/static/private"
import config from "./config"

const port = +SMTP_PORT || 4442

const server = new SMTPServer({
	authOptional: true,
})

server.listen(port, () =>
	console.log(`SMTP server is listening on port ${port}`)
)
server.on("error", err => console.error("SMTP Server Error:", err))
server.on("close", () => console.log("SMTP server has closed"))

const transport = createTransport({
	host: "localhost",
	port,
	secure: false,
	tls: {
		rejectUnauthorized: false,
	},
})
transport.on("error", err => console.error("SMTP Transport Error:", err))
transport.on("idle", () => console.log("SMTP Transport is idle"))
transport.on("token", () => console.log("SMTP Transport token event"))

console.log("Verifying SMTP transport...")
await transport.verify()
console.log("SMTP transport verified successfully.")

export async function sendEmail(to: string, subject: string, text: string) {
	console.log(`Queuing email to ${to} with subject "${subject}"`)
	const result = await transport.sendMail({
		from: `${config.Name} <noreply@${config.Domain}>`,
		to,
		subject,
		text,
	})
	console.log(`Email to ${to} sent successfully`)
	console.log(result)
}
