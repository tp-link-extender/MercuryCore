import config from "./config"

export type ModerationDiscordWebhookPayload = {
	username: string
	action: string
	reason: string
	moderatorUsername?: string
	webhookUrl?: string
}

export async function sendModerationDiscordWebhook({
	username,
	action,
	reason,
	moderatorUsername = "System",
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
				embeds: [
					{
						color: 0xf59e0b,
						title: "Moderation action",
						description: `**${username}** was moderated by **${moderatorUsername}**.`,
						fields: [
							{ name: "User Moderated", value: username, inline: true },
							{ name: "Action", value: action, inline: true },
							{ name: "Reason", value: reason, inline: false },
							{ name: "Moderator", value: moderatorUsername, inline: true },
						],
						timestamp: new Date().toISOString(),
					},
				],
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
