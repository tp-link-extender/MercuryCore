import discord
from discord import app_commands
from discord.ext import commands
import os
from rich import print
from dotenv import load_dotenv

load_dotenv()

token = os.getenv("token")

bot = commands.Bot(command_prefix="/", intents=discord.Intents.all())

class btns(discord.ui.View):
    def __init__(self):
        super().__init__(timeout = None)
        self.cooldown = commands.CooldownMapping.from_cooldown(1, 300, commands.BucketType.member)

    @discord.ui.button(label="Get Started", style=discord.ButtonStyle.success, custom_id="getStarted")
    async def getStarted(self, interaction: discord.Interaction, Button: discord.ui.Button):
        channel = bot.get_channel(1211323371367698492)
        interaction.message.author = interaction.user
        bucket = self.cooldown.get_bucket(interaction.message)
        retry = bucket.update_rate_limit()
        if retry:
            return await interaction.response.send_message(f"Please wait {round(retry, 1//60)} seconds before trying again.", ephemeral=True)
        await interaction.response.send_message("Testing!", ephemeral=True)
        await channel.send(f"Test message - {interaction.user} has registered")

async def confirmed(interaction):
    print(f"[green]Sending user {interaction.user} application instructions[green]")
    desc = ":white_check_mark: Registration instructions have been sent to your DMS!"
    embedV = discord.Embed(color=0x472a96, description=desc)
    embedV.set_author(name="Mercury 2 - Register", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
    embedV.add_field(name="I don't see any message!", value="Make sure that you have enabled DMs from this server. If you have and you still have not recieved a message, please contact an adminstrator.")
    await interaction.response.send_message(embed=embedV)

async def application(interaction):
    user = await interaction.user.create_dm()
    desc = "This process will guide you in applying for a key to Mercury 2. If your application is successful, you should instantly get your key in your DMs. To begin, click the button that says _Get Started_."
    embedV = discord.Embed(color=0x472a96, description=desc)
    embedV.set_author(name="Mercury 2 - Register", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
    embedV.title = "Mercury 2 Registration"
    embedV.add_field(name="How long does it take for my application to be reviewed?", value="We aim for your application to be reviewed within the same day or tommorrow.", inline=False)
    embedV.add_field(name="How can I check the progress of my application?", value="You can check the progress of your application by running the */info* command.", inline=False)
    embedV.add_field(name="I no longer wish to apply for a key", value="You can unsubmit your application by running the */unsubmit* command.", inline=False)
    if isinstance(interaction.channel, discord.DMChannel):
        await interaction.response.send_message(embed=embedV, view=btns())
    else:
        await user.send(embed=embedV, view=btns())

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
    if isinstance(interaction.channel, discord.DMChannel):
        await application(interaction)
    else:
        await confirmed(interaction)
        await application(interaction)

bot.run(token)