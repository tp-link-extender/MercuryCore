import discord
from discord import app_commands
from discord.ext import commands
import os
from rich import print
from dotenv import load_dotenv

load_dotenv()

token = os.getenv("token")

bot = commands.Bot(command_prefix="/", intents=discord.Intents.all())

@bot.event
async def on_ready():
    print(f"[green]Bot is active[/green]")
    try:
        cmds = await bot.tree.sync()
        print(f"[green]Synced {len(cmds)} command(s)")
    except Exception as e:
        print(e)

@bot.tree.command(name="register")
async def register(interaction: discord.Interaction):
    user = await interaction.user.create_dm()
    if isinstance(interaction.channel, discord.DMChannel):
        await interaction.response.send_message("Beginning register process.")
    else:
        await interaction.response.send_message("Please check your DMS!")
    await user.send("Hi")

bot.run(token)