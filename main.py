import discord
from discord import app_commands, ui
from discord.ext import commands
import os
from rich import print
from dotenv import load_dotenv

load_dotenv()

token = os.getenv("token")

bot = commands.Bot(command_prefix="/", intents=discord.Intents.all())

async def confirmed(interaction):
    print(f"[green]Sending user {interaction.user.id} application instructions[green]")
    desc = ":white_check_mark: Registration instructions have been sent to your DMS!"
    embedV = discord.Embed(color=0x472a96, description=desc)
    embedV.set_author(name="Mercury 2 - Register", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
    embedV.add_field(name="I don't see any message!", value="Make sure that you have enabled DMs from this server. If you have and you still have not recieved a message, please contact an adminstrator.")
    await interaction.response.send_message(embed=embedV, ephemeral = True)

async def application(interaction):
    user = await interaction.user.create_dm()
    desc = "This process will guide you in applying for a key to Mercury 2. If your application is successful, you should instantly get your key in your DMs. To begin, click the button that says _Get Started_."
    embedV = discord.Embed(color=0x472a96, description=desc)
    embedV.set_author(name="Mercury 2 - Register", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
    embedV.title = "Mercury 2 Registration"
    embedV.add_field(name="How long does it take for my application to be reviewed?", value="We aim for your application to be reviewed within the same day or tommorrow.", inline=False)
    embedV.add_field(name="How can I check the progress of my application?", value="You can check the progress of your application by running the */info* command.", inline=False)
    embedV.add_field(name="I no longer wish to apply for a key", value="You can unsubmit your application by running the */unsubmit* command.", inline=False)
    embedV.set_footer(text="Mercury Discord - https://discord.gg/5dQWXJn6pW", icon_url="https://banland.xyz/icon192.png")
    if isinstance(interaction.channel, discord.DMChannel):
        await interaction.response.send_message(embed=embedV, view=applyBtns())
    else:
        await user.send(embed=embedV, view=applyBtns())

async def sendApplicationToAdmin(interaction):
    embedV = discord.Embed(color=0x472a96)
    embedV.set_author(name="Mercury 2 - Applications", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
    embedV.title = f"New Applicant - @{interaction.user}"
    embedV.add_field(name="User ID", value=str(interaction.user.id))
    embedV.add_field(name="1. Why would you like to join Mercury 2", value="{user response}", inline=False)
    embedV.add_field(name="2. Where did you hear about Mercury 2?", value="{user response}", inline=False)
    embedV.add_field(name="3. Any questions/suggestions?", value="{user response}", inline=False)
    embedV.add_field(name="Status", value="No decision yet")
    channel = bot.get_channel(1211323371367698492)
    message = await channel.send(embed=embedV, allowed_mentions=None)
    await message.edit(view=adminBtns(message_id = message.id))


async def reviewedApp(interaction, user, decision, reason=None):
    if decision == "denied":
        desc = f"Hello, @{interaction.user}! Unfortunately, your application was **not successful**. The reason for this has been provided below."
        embedV = discord.Embed(color=0xd9363e, description=desc)
        embedV.set_author(name="Mercury 2 - Applications", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
        embedV.title = "Application unsuccessful"
        embedV.add_field(name="Reason for rejection", value=f"`{str(reason)}`", inline=False)
        embedV.add_field(name="What can I do now?", value="You may re-apply for an invite a week from now. You may re-apply as many times as you wish until your application is successful.", inline=False)
        embedV.set_footer(text="Thank you for applying!", icon_url="https://banland.xyz/icon192.png")
        print(f"[green]Application denied by {interaction.user}[/green]")
    else:
        desc = f"Hello, @{interaction.user}! Congratulations! Your application was **successful**! Your invite key has been provided below."
        embedV = discord.Embed(color=0x4acc39, description=desc)
        embedV.set_author(name="Mercury 2 - Applications", url="https://banland.xyz", icon_url="https://banland.xyz/icon192.png")
        embedV.title = "Application successful"
        embedV.add_field(name="Invite key", value="{key}", inline=False)
        embedV.add_field(name="What can I do now?", value="You can now create an account on https://banland.xyz. Additionally, you have been given the prestigious role of QA tester and now you can contribute to the future of Mercury 2!", inline=False)
        embedV.set_footer(text="Thank you for applying!", icon_url="https://banland.xyz/icon192.png")
        print(f"[green]Application approved by {interaction.user}[/green]")
    
    await user.send(embed=embedV)

class keyApplication(ui.Modal, title="Application"):
    q1 = ui.TextInput(label="Why would you like to join Mercury 2?", style=discord.TextStyle.paragraph, required=True, min_length="10")
    q2 = ui.TextInput(label="Where did you hear about Mercury 2?", style=discord.TextStyle.short, required=True, min_length="5")
    q3 = ui.TextInput(label="Any questions/suggestions?", style=discord.TextStyle.short, required=False)

class deniedReason(ui.Modal):
    def __init__(self, user, appMsg, embedMsg, btnView):
        self.user = user
        self.appMsg = appMsg
        self.embedMsg = embedMsg
        self.btnView = btnView
        super().__init__(title="Reason for denial")

    q1 = ui.TextInput(label="Reason for denial:", style=discord.TextStyle.paragraph, required=True, min_length="2")

    async def on_submit(self, interaction: discord.Interaction):
        embedV = self.embedMsg.to_dict()
        embedV["fields"][-1]["value"] = f"Denied by {interaction.user}"
        embedV["color"] = 0xd9363e 
        embedV = discord.Embed.from_dict(embedV)
        await self.appMsg.edit(embed=embedV, view=self.btnView)
        await interaction.response.send_message(f"Your response was {self.q1}.", ephemeral=True)
        await reviewedApp(interaction, self.user, "denied", reason=self.q1)

class applyBtns(discord.ui.View):
    def __init__(self):
        super().__init__(timeout = None)
        self.cooldown = commands.CooldownMapping.from_cooldown(1, 180, commands.BucketType.member)

    @discord.ui.button(label="Get Started", style=discord.ButtonStyle.success, custom_id="getStarted")
    async def getStarted(self, interaction: discord.Interaction, Button: discord.ui.Button):
        interaction.message.author = interaction.user
        bucket = self.cooldown.get_bucket(interaction.message)
        retry = bucket.update_rate_limit()
        if retry:
            return await interaction.response.send_message(f"Please wait {round(retry, 1//60)} minute(s) before trying again.")
        await interaction.response.send_modal(keyApplication())
        await sendApplicationToAdmin(interaction)
        
class adminBtns(discord.ui.View):
    def __init__(self, message_id):
        super().__init__(timeout = None)
        self.message_id = message_id

    @discord.ui.button(label="Accept", style=discord.ButtonStyle.success, custom_id="acceptApp")
    async def acceptApp(self, interaction: discord.Interaction, Button: discord.ui.Button):
        for i in self.children:
            i.disabled = True

        embedV = interaction.message.embeds[0].to_dict()
        user = bot.get_user(int(embedV["fields"][0]["value"]))
        embedV["fields"][-1]["value"] = f"Accepted by {interaction.user}"
        embedV["color"] = 0x4acc39
        embedV = discord.Embed.from_dict(embedV)
        msg = await bot.get_channel(interaction.channel_id).fetch_message(self.message_id)
        await msg.edit(embed=embedV, view=self)
        await interaction.followup.send(f"Application accepted!", ephemeral=True)
        await reviewedApp(interaction, user, "approved")

    @discord.ui.button(label="Deny", style=discord.ButtonStyle.danger, custom_id="denyApp")
    async def denyApp(self, interaction: discord.Interaction, Button: discord.ui.Button):
        for i in self.children:
            i.disabled = True

        embedV = interaction.message.embeds[0].to_dict()
        msg = await bot.get_channel(interaction.channel_id).fetch_message(self.message_id)
        userID = bot.get_user(int(embedV["fields"][0]["value"]))
        await interaction.response.send_modal(deniedReason(user=userID, appMsg=msg, embedMsg=interaction.message.embeds[0], btnView=self))
        
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