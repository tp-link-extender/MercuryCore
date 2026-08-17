import config from "./config"

export type ModerationDiscordWebhookPayload = {
	username: string
	action: string
	reason: string
	webhookUrl?: string
}

export async function sendModerationDiscordWebhook({
	username,
	action,
	reason,
	webhookUrl = config.Logging.DiscordModerationWebhook,
}: ModerationDiscordWebhookPayload) {
	if (!webhookUrl || webhookUrl.includes("123456789012345678/abcdefghijklmnopqrstuvwxyz"))
		return

	try {
		const response = await fetch(webhookUrl, {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				content: `${username} - ${action} - ${reason}`,
			}),
		})

		if (!response.ok)
			console.error(
				`Failed to send moderation Discord webhook: ${response.status} ${response.statusText}`
			)
	} catch (error) {
		console.error("Failed to send moderation Discord webhook:", error)
	}
}
