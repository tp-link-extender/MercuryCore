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
        desc = ":white_check_mark: Registration instructions have been sent to your DMS!"
        embedV = discord.Embed(color=0x472a96, description=desc)
        embedV.set_author(name="Mercury 2 - Register", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
        embedV.add_field(name="I don't see any message!", value="Make sure that you have enabled DMs from this server. If you have and you still have not recieved a message, please contact an adminstrator.")
        await interaction.response.send_message(embed=embedV)
    await user.send("Hi")

bot.run(token)