import discord
from discord import app_commands
import json
from rich import print

with open("bot.json", "r") as f:
    config = json.load(f)

client = discord.Client(intents=discord.Intents.all())

@client.event
async def on_ready():
    print(f"[green]Bot is active[/green]")
    try:
        cmds = await client.tree.sync()
        print(f"[green]Synced {len(cmds)} command(s)")
    except Exception as e:
        print(e)

@client.tree.command(name="register")
async def register(interaction: discord.Interaction):
    await interaction.response.send_message(f"Hello")

client.run(config["token"])