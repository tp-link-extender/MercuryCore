import config from "./config"

export interface ModerationDiscordWebhookPayload {
	action: string
	moderatorUsername?: string
	reason: string
	username: string
	webhookUrl?: string
}

export async function sendModerationDiscordWebhook({
	username,
	action,
	reason,
	moderatorUsername = "System",
	webhookUrl = config.Logging.DiscordModerationWebhook,
}: ModerationDiscordWebhookPayload) {
	if (
		!webhookUrl ||
		webhookUrl.includes("123456789012345678/abcdefghijklmnopqrstuvwxyz")
	)
		return

	try {
		const response = await fetch(webhookUrl, {
			body: JSON.stringify({
				embeds: [
					{
						color: 0xf59e0b,
						description: `**${username}** was moderated by **${moderatorUsername}**.`,
						fields: [
							{
								inline: true,
								name: "User Moderated",
								value: username,
							},
							{ inline: true, name: "Action", value: action },
							{ inline: false, name: "Reason", value: reason },
							{
								inline: true,
								name: "Moderator",
								value: moderatorUsername,
							},
						],
						timestamp: new Date().toISOString(),
						title: "Moderation action",
					},
				],
			}),
			headers: {
				"Content-Type": "application/json",
			},
			method: "POST",
		})

		if (!response.ok)
			console.error(
				`Failed to send moderation Discord webhook: ${response.status} ${response.statusText}`
			)
	} catch (error) {
		console.error("Failed to send moderation Discord webhook:", error)
	}
}
