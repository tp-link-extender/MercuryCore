import discord
from discord import ui
import datetime
import dateutil.parser
from discord.ext import commands
import os
import aiohttp
import json
from rich import print
from dotenv import load_dotenv

load_dotenv()

envserverid = os.getenv("SERVERID")
envadminid = os.getenv("ADMINID")
envtoken = os.getenv("TOKEN")

if envserverid == None or envadminid == None or envtoken == None:
    raise Exception("Please provide a SERVERID, ADMINID, and TOKEN in the .env file.")

serverid = int(envserverid)
adminid = int(envadminid)

bot = commands.Bot(command_prefix="/", intents=discord.Intents.all())


async def problemMessage(interaction: discord.Interaction):
    return await interaction.response.send_message(
        "Sorry, but there was a problem running this command. Please notify @task.mgr with details."
    )


async def confirmedFetch(interaction):
    print(f"[green]Sending user {interaction.user.id} application info[green]")
    desc = ":white_check_mark: Application info has been sent to your DMS!"
    embedV = discord.Embed(color=0x472A96, description=desc)
    embedV.set_author(
        name="Mercury 2 - Info",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.add_field(
        name="I don't see any message!",
        value="Make sure that you have enabled DMs from this server. If you have and you still have not recieved a message, please contact an adminstrator.",
    )
    await interaction.response.send_message(embed=embedV, ephemeral=True)


async def confirmedDelete(interaction):
    print(f"[green]Sending user {interaction.user.id} application deletion[green]")
    desc = ":white_check_mark: Application unsubmit info has been sent to your DMS!"
    embedV = discord.Embed(color=0x472A96, description=desc)
    embedV.set_author(
        name="Mercury 2 - Unsubmit",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.add_field(
        name="I don't see any message!",
        value="Make sure that you have enabled DMs from this server. If you have and you still have not recieved a message, please contact an adminstrator.",
    )
    await interaction.response.send_message(embed=embedV, ephemeral=True)


async def confirmed(interaction):
    print(f"[green]Sending user {interaction.user.id} application instructions[green]")
    desc = ":white_check_mark: Registration instructions have been sent to your DMS!"
    embedV = discord.Embed(color=0x472A96, description=desc)
    embedV.set_author(
        name="Mercury 2 - Register",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.add_field(
        name="I don't see any message!",
        value="Make sure that you have enabled DMs from this server. If you have and you still have not recieved a message, please contact an adminstrator.",
    )
    await interaction.response.send_message(embed=embedV, ephemeral=True)


async def application(interaction):
    user = await interaction.user.create_dm()
    desc = "This process will guide you in applying for a key to Mercury 2. If your application is successful, you should instantly get your key in your DMs. To begin, click the button that says _Get Started_."
    embedV = discord.Embed(color=0x472A96, description=desc)
    embedV.set_author(
        name="Mercury 2 - Register",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.title = "Mercury 2 Registration"
    embedV.add_field(
        name="How long does it take for my application to be reviewed?",
        value="We aim for your application to be reviewed within the same day or tommorrow.",
        inline=False,
    )
    embedV.add_field(
        name="How can I check the progress of my application?",
        value="You can check the progress of your application by running the */info* command.",
        inline=False,
    )
    embedV.add_field(
        name="I no longer wish to apply for a key",
        value="You can unsubmit your application by running the */unsubmit* command.",
        inline=False,
    )
    embedV.set_footer(
        text="Mercury Discord - https://discord.gg/5dQWXJn6pW",
        icon_url="https://banland.xyz/icon192.png",
    )
    if isinstance(interaction.channel, discord.DMChannel):
        await interaction.response.send_message(embed=embedV, view=applyBtns())
    else:
        await user.send(embed=embedV, view=applyBtns())


async def sendApplicationToAdmin(interaction, q1, q2, q3):

    if len(str(q3)) <= 5:
        q3 = "N/A"

    embedV = discord.Embed(color=0x472A96)
    embedV.set_author(
        name="Mercury 2 - Applications",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.title = f"New Applicant - @{interaction.user}"
    embedV.add_field(name="User ID", value=str(interaction.user.id))
    embedV.add_field(
        name="1. Why would you like to join Mercury 2",
        value=f"`{str(q1)}`",
        inline=False,
    )
    embedV.add_field(
        name="2. Where did you hear about Mercury 2?",
        value=f"`{str(q2)}`",
        inline=False,
    )
    embedV.add_field(
        name="3. Any questions/suggestions?", value=f"`{str(q3)}`", inline=False
    )
    embedV.add_field(name="Status", value="No decision yet")
    channel = bot.get_channel(int(adminid))
    message = await channel.send(embed=embedV, allowed_mentions=None)
    await message.edit(view=adminBtns(message_id=message.id))


async def notifyAdminsUnsubmit(interaction):
    embedV = discord.Embed(color=0x472A96)
    embedV.set_author(
        name="Mercury 2 - Applications",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.title = f"Application Unsubmitted - @{interaction.user}"
    embedV.add_field(name="User ID", value=str(interaction.user.id))
    channel = bot.get_channel(int(adminid))
    await channel.send(embed=embedV, allowed_mentions=None)


async def sendApplication(url, data):
    async with aiohttp.ClientSession() as session:
        headers = {"Content-Type": "application/json"}
        json_data = json.dumps(data)
        async with session.post(url, data=json_data, headers=headers) as resp:
            if resp.status == 200:
                print("[green]Successfully sent application to server![/green]")
                return "created"

            resp_data = await resp.text()
            data = json.loads(resp_data)

            if data["message"] == "This user can't apply again":
                print("[green]User has already sent an application[/green]")
                return "pending"

            if data["message"] == "This user has already been accepted":
                print("[green]User has already been accepted[/green]")
                return "accepted"

            if data["message"] == "This user is banned":
                print("[green]User is banned from sending applications[/green]")
                return data["reason"]


async def updateApplication(url, jsonData, userID):
    async with aiohttp.ClientSession() as session:
        headers = {"Content-Type": "application/json"}
        json_data = json.dumps(jsonData)

        method = jsonData["status"]

        async with session.post(url, data=json_data, headers=headers) as resp:
            resptext = await resp.text()
            if resp.status == 200:
                print(
                    f"[green]Successfully updated application #{userID} on server![/green]"
                )
                if method == "Accepted":
                    return resptext
                else:
                    return "updated"
            else:
                resptext = await resp.text()
                print(resp.status, resptext)
                return resp.status


async def getApplication(url, userID) -> tuple[str, str, list[str], str, str] | None:
    async with aiohttp.ClientSession() as session, session.get(url) as resp:
        resp_data = await resp.text()
        contentlength = resp.headers.get("Content-Length")
        if contentlength and int(contentlength) > 0 and resp.status == 200:
            data = json.loads(resp_data)
            print(
                f"[green]Successfully fetched application #{userID} from server![/green]"
            )
            return (
                data["status"],
                data["reason"],
                data["response"],
                data["created"],
                data["reviewed"],
            )
        else:
            return None


async def fetchApplication(url, userID, interaction):
    user = await interaction.user.create_dm()

    app = await getApplication(url, interaction.user.id)

    if app == None:
        return await interaction.response.send_message(
            "Sorry, but you do not have any previous/pending applications. You can create one by running */register*.",
            ephemeral=True,
        )

    status, reason, response, created, reviewed = app

    if len(response[2]) <= 20:
        response[2] = "N/A"

    print(f"[green]Successfully fetched application #{userID} from server![/green]")
    embedV = discord.Embed(color=0x472A96)
    embedV.set_author(
        name="Mercury 2 - Info",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.title = "Your Application"
    embedV.add_field(
        name="Date submitted",
        value=f"<t:{int(dateutil.parser.isoparse(created).timestamp())}>",
    )
    if status != "Pending":
        embedV.add_field(
            name="Date reviewed",
            value=f"<t:{int(dateutil.parser.isoparse(reviewed).timestamp())}>",
        )
    embedV.add_field(name="Status", value=f"**{status}**", inline=False)
    embedV.add_field(
        name="Why would you like to join Mercury 2?",
        value=f"`{response[0]}`",
        inline=False,
    )
    embedV.add_field(
        name="Where did you hear about Mercury 2?",
        value=f"`{response[1]}`",
        inline=False,
    )
    embedV.add_field(
        name="Any questions/suggestions?", value=f"`{response[2]}`", inline=False
    )
    if status == "Denied" or status == "Banned":
        embedV.add_field(
            name="Reason for denial/ban", value=f"`{reason}`", inline=False
        )
    if status == "Denied":
        date = dateutil.parser.isoparse(reviewed) + datetime.timedelta(days=3)
        embedV.add_field(
            name="Next application unlocked on", value=f"<t:{int(date.timestamp())}>"
        )
    if isinstance(interaction.channel, discord.DMChannel):
        await interaction.response.send_message(embed=embedV)
    else:
        await user.send(embed=embedV)


async def deleteApplication(userID, interaction):
    user = await interaction.user.create_dm()
    desc = "We're sorry you have to unsubmit your application. Before you confirm your unsubmit you must understand that **you will have to wait three days before sending another application**. If you do not want to unsubmit your application, just ignore this message."
    embedV = discord.Embed(color=0x472A96, description=desc)
    embedV.set_author(
        name="Mercury 2 - Unsubmit",
        url="https://banland.xyz",
        icon_url="https://banland.xyz/icon192.png",
    )
    embedV.title = "Unsubmit Application"
    if isinstance(interaction.channel, discord.DMChannel):
        await interaction.response.send_message(
            embed=embedV, view=deleteBtns(userId=userID)
        )
    else:
        await user.send(embed=embedV, view=deleteBtns(userId=userID))


async def reviewedApp(interaction, user, userID, decision, reason=None):
    if decision == "denied":
        print(f"[green]Updating application #{userID}[/green]")
        data = {"status": "Denied", "reason": f"{str(reason)}"}
        await updateApplication(
            f"https://banland.xyz/api/discord/updateApplication/{userID}?apiKey={os.getenv('APIKEY')}",
            data,
            userID,
        )
        desc = f"Unfortunately, your application was **not successful**. The reason for this has been provided below."
        embedV = discord.Embed(color=0xD9363E, description=desc)
        embedV.set_author(
            name="Mercury 2 - Applications",
            url="https://banland.xyz",
            icon_url="https://banland.xyz/icon192.png",
        )
        embedV.title = ":x: Application unsuccessful"
        embedV.add_field(
            name="Reason for rejection", value=f"`{str(reason)}`", inline=False
        )
        embedV.add_field(
            name="What can I do now?",
            value="You may re-apply for an invite 3 days from now. You may re-apply as many times as you wish until your application is successful.",
            inline=False,
        )
        embedV.set_footer(
            text="Thank you for applying!", icon_url="https://banland.xyz/icon192.png"
        )
        print(f"[green]Application #{userID} denied by {interaction.user}[/green]")
    elif decision == "approved":
        print(f"[green]Updating application #{userID}[/green]")

        data = {"status": "Accepted"}

        guild = await bot.fetch_guild(int(serverid))

        try:
            member = await guild.fetch_member(userID)
        except:
            member = False

        if not member:
            data = {
                "status": "Denied",
                "reason": "You are not currently in the Mercury 2 Discord server. If this is a mistake, please contact @task.mgr immediately.",
            }
            desc = f"Unfortunately, your application was **not successful**. The reason for this has been provided below."
            embedV = discord.Embed(color=0xD9363E, description=desc)
            embedV.set_author(
                name="Mercury 2 - Applications",
                url="https://banland.xyz",
                icon_url="https://banland.xyz/icon192.png",
            )
            embedV.title = ":x: Application unsuccessful"
            embedV.add_field(
                name="Reason for rejection",
                value=f"`You are not currently in the Mercury 2 Discord server. If this is a mistake, please contact @task.mgr immediately.`",
                inline=False,
            )
            embedV.add_field(
                name="What can I do now?",
                value="Please make sure you are in the Mercury 2 Discord server. You may then re-apply for an invite 3 days from now. You may re-apply as many times as you wish until your application is successful.",
                inline=False,
            )
            embedV.set_footer(
                text="Thank you for applying!",
                icon_url="https://banland.xyz/icon192.png",
            )
            print(
                f"[green]Application #{userID} denied by {interaction.user} due to member not in server[/green]"
            )
            await interaction.followup.send(
                "User was not found in server - autorejected user."
            )

        key = await updateApplication(
            f"https://banland.xyz/api/discord/updateApplication/{userID}?apiKey={os.getenv('APIKEY')}",
            data,
            userID,
        )

        role = discord.utils.get(guild.roles, name="Verified")
        await member.add_roles(role)

        desc = f"Congratulations! Your application was **successful**! Your invite key has been provided below."
        embedV = discord.Embed(color=0x4ACC39, description=desc)
        embedV.set_author(
            name="Mercury 2 - Applications",
            url="https://banland.xyz",
            icon_url="https://banland.xyz/icon192.png",
        )
        embedV.title = ":white_check_mark: Application successful"
        embedV.add_field(name="Invite key", value=f"`{key}`", inline=False)
        embedV.add_field(
            name="What can I do now?",
            value="You can now create an account on https://banland.xyz. Additionally, you have full access to the Mercury Discord server and have been given the prestigious role of QA tester and now you can contribute to the future of Mercury 2!",
            inline=False,
        )
        embedV.set_footer(
            text="Thank you for applying!", icon_url="https://banland.xyz/icon192.png"
        )
        print(f"[green]Application #{userID} approved by {interaction.user}[/green]")
    else:
        print(f"[green]Updating application #{userID}[/green]")
        data = {"status": "Banned", "reason": f"{str(reason)}"}
        await updateApplication(
            f"https://banland.xyz/api/discord/updateApplication/{userID}?apiKey={os.getenv('APIKEY')}",
            data,
            userID,
        )
        desc = f"Unfortunately, your account has been **banned** from applying in the future. The reason for this has been provided below."
        embedV = discord.Embed(color=0xD9363E, description=desc)
        embedV.set_author(
            name="Mercury 2 - Applications",
            url="https://banland.xyz",
            icon_url="https://banland.xyz/icon192.png",
        )
        embedV.title = ":x: Account banned from future applications"
        embedV.add_field(name="Reason for ban", value=f"`{str(reason)}`", inline=False)
        embedV.add_field(
            name="What can I do now?",
            value="You are unable to apply for future applications. This decision can be appealed by messaging @task.mgr.",
            inline=False,
        )
        embedV.set_footer(
            text="Thank you for applying!", icon_url="https://banland.xyz/icon192.png"
        )
        print(f"[green]{userID} banned by {interaction.user}[/green]")

    await user.send(embed=embedV)


async def fetchAllApplications(url, userID):
    async with aiohttp.ClientSession() as session, session.get(url) as resp:
        resp_data = await resp.text()
        if resp.status == 200:
            data = json.loads(resp_data)
            print(
                f"[green]{userID} successfully fetched {len(data)} application(s) from server![/green]"
            )
            print(data)
            return data
        else:
            print(resp.status)
            return []


class keyApplication(ui.Modal):
    def __init__(self, userId):
        self.userId = userId
        self.cooldown = commands.CooldownMapping.from_cooldown(
            1, 120, commands.BucketType.member
        )
        super().__init__(title="Application")

    q1 = ui.TextInput(
        label="Why would you like to join Mercury 2?",
        style=discord.TextStyle.paragraph,
        required=True,
        min_length=100,
    )
    q2 = ui.TextInput(
        label="Where did you hear about Mercury 2?",
        style=discord.TextStyle.short,
        required=True,
        min_length=5,
    )
    q3 = ui.TextInput(
        label="Any questions/suggestions?",
        style=discord.TextStyle.short,
        required=False,
    )

    async def on_submit(self, interaction: discord.Interaction):
        interaction.message.author = interaction.user
        bucket = self.cooldown.get_bucket(interaction.message)
        retry = bucket.update_rate_limit()
        if retry:
            return await interaction.response.send_message(
                f"Please wait {round(retry, 1)} second(s) before trying again."
            )

        print(f"[green]Application #{self.userId} is sending to server for creation")
        appResp = await sendApplication(
            f"https://banland.xyz/api/discord/createApplication/{self.userId}?apiKey={os.getenv('APIKEY')}",
            [str(self.q1), str(self.q2), str(self.q3)],
        )
        if appResp == "created":

            if len(str(self.q3)) <= 5:
                self.q3 = "N/A"

            desc = "Thank you for sending an application! It will be reviewed and you should recieve a decision on this application within 1-2 days or later. You can view the status of this application at any time by using */info*. You may also unsubmit this application at any time by using */unsubmit*."
            embedV = discord.Embed(color=0x4ACC39, description=desc)
            embedV.set_author(
                name="Mercury 2 - Applications",
                url="https://banland.xyz",
                icon_url="https://banland.xyz/icon192.png",
            )
            embedV.title = ":white_check_mark: Application sent"
            embedV.add_field(
                name="Why would you like to join Mercury 2?",
                value=f"`{str(self.q1)}`",
                inline=False,
            )
            embedV.add_field(
                name="Where did you hear about Mercury 2?",
                value=f"`{str(self.q2)}`",
                inline=False,
            )
            embedV.add_field(
                name="Any questions/suggestions?",
                value=f"`{str(self.q3)}`",
                inline=False,
            )
            embedV.set_footer(
                text="Thank you for applying!",
                icon_url="https://banland.xyz/icon192.png",
            )
            await sendApplicationToAdmin(interaction, self.q1, self.q2, self.q3)
        elif appResp == "pending":
            desc = "The application you have just completed has not been sent as your previous application is still pending. You can run */info* to view more information about your pending application or run */unsubmit* to unsubmit your previous application."
            embedV = discord.Embed(color=0xD9363E, description=desc)
            embedV.set_author(
                name="Mercury 2 - Applications",
                url="https://banland.xyz",
                icon_url="https://banland.xyz/icon192.png",
            )
            embedV.title = ":x: Previous application is still pending"
        elif appResp == "accepted":
            desc = "The application you have just completed has not been sent as you have already been accepted into Mercury 2."
            embedV = discord.Embed(color=0xD9363E, description=desc)
            embedV.set_author(
                name="Mercury 2 - Applications",
                url="https://banland.xyz",
                icon_url="https://banland.xyz/icon192.png",
            )
            embedV.title = ":question: You have already been accepted"
        else:
            desc = f"Unfortunately, your account has been **banned** from applying in the future. The reason for this has been provided below."
            embedV = discord.Embed(color=0xD9363E, description=desc)
            embedV.set_author(
                name="Mercury 2 - Applications",
                url="https://banland.xyz",
                icon_url="https://banland.xyz/icon192.png",
            )
            embedV.title = ":x: Account banned from future applications"
            embedV.add_field(
                name="Reason for ban", value=f"`{str(appResp)}`", inline=False
            )
            embedV.add_field(
                name="What can I do now?",
                value="You are unable to apply for future applications. This decision can be appealed by messaging @task.mgr.",
                inline=False,
            )

        await interaction.response.send_message(embed=embedV)


class deniedReason(ui.Modal):
    def __init__(self, userId, appMsg, embedMsg, btnView):
        self.userId = userId
        self.appMsg = appMsg
        self.embedMsg = embedMsg
        self.btnView = btnView
        super().__init__(title="Reason for denial")

    q1 = ui.TextInput(
        label="Reason for denial",
        style=discord.TextStyle.paragraph,
        required=True,
        min_length="2",
    )

    async def on_submit(self, interaction: discord.Interaction):
        embedV = self.embedMsg.to_dict()
        embedV["fields"][-1]["value"] = f"Denied by {interaction.user}"
        user = bot.get_user(self.userId)
        embedV["color"] = 0xD9363E
        embedV = discord.Embed.from_dict(embedV)
        embedV.add_field(name="Reason for denial", value=f"`{self.q1}`", inline=False)
        await self.appMsg.edit(embed=embedV, view=self.btnView)
        await interaction.response.send_message(
            f"Your reason for denial was `{self.q1}`.", ephemeral=True
        )
        await reviewedApp(interaction, user, self.userId, "denied", reason=self.q1)


class bannedReason(ui.Modal):
    def __init__(self, userId, appMsg, embedMsg, btnView):
        self.userId = userId
        self.appMsg = appMsg
        self.embedMsg = embedMsg
        self.btnView = btnView
        super().__init__(title="Reason for ban")

    q1 = ui.TextInput(
        label="Reason for ban",
        style=discord.TextStyle.paragraph,
        required=True,
        min_length=2,
    )

    async def on_submit(self, interaction: discord.Interaction):
        embedV = self.embedMsg.to_dict()
        embedV["fields"][-1]["value"] = f"Banned by {interaction.user}"
        user = bot.get_user(self.userId)
        embedV["color"] = 0xD9363E
        embedV = discord.Embed.from_dict(embedV)
        embedV.add_field(name="Reason for ban", value=f"`{self.q1}`", inline=False)
        await self.appMsg.edit(embed=embedV, view=self.btnView)
        await interaction.response.send_message(
            f"Your reason for banning was `{self.q1}`.", ephemeral=True
        )
        await reviewedApp(interaction, user, self.userId, "banned", reason=self.q1)


class applyBtns(discord.ui.View):
    def __init__(self):
        super().__init__(timeout=None)

    @discord.ui.button(
        label="Get Started", style=discord.ButtonStyle.success, custom_id="getStarted"
    )
    async def getStarted(self, interaction: discord.Interaction, _):
        for i in self.children:
            i.disabled = True

        msg = await bot.get_channel(interaction.channel_id).fetch_message(
            interaction.message.id
        )
        await msg.edit(view=self)

        member = bot.get_guild(int(serverid)).get_member(interaction.user.id)
        if not member:
            return await interaction.response.send_message(
                "Sorry, but you must be a member of the [Mercury 2 Discord server](https://discord.gg/5dQWXJn6pW) to use this bot."
            )
        await interaction.response.send_modal(
            keyApplication(userId=interaction.user.id)
        )


class deleteBtns(discord.ui.View):
    def __init__(self, userId):
        self.userId = userId
        self.cooldown = commands.CooldownMapping.from_cooldown(
            1, 300, commands.BucketType.member
        )
        super().__init__(timeout=None)

    @discord.ui.button(
        label="Confirm Unsubmit",
        style=discord.ButtonStyle.danger,
        custom_id="deleteApp",
    )
    async def deleteApp(self, interaction: discord.Interaction, _):
        user = await interaction.user.create_dm()

        interaction.message.author = interaction.user
        bucket = self.cooldown.get_bucket(interaction.message)
        retry = bucket.update_rate_limit()
        if retry:
            return await interaction.response.send_message(
                f"Please try again in {round(retry, 1//60)} minute(s)."
            )

        for i in self.children:
            i.disabled = True

        msg = await bot.get_channel(interaction.channel_id).fetch_message(
            interaction.message.id
        )
        await msg.edit(view=self)

        data = {"status": "Denied", "reason": "User unsubmitted application"}

        await interaction.response.send_message(
            f"Application is unsubmitting! If this was a mistake, please contact @task.mgr with details."
        )

        try:
            update = await updateApplication(
                f"https://banland.xyz/api/discord/updateApplication/{self.userId}?apiKey={os.getenv('APIKEY')}",
                data,
                self.userId,
            )
        except:
            for i in self.children:
                i.disabled = False

            await msg.edit(view=self)

            await user.send(
                f"Sorry, but your application was not unsubmitted. Please contact @task.mgr with this code: 451"
            )

        if update == "updated":
            print(f"[green]Application #{self.userId} has been unsubmitted[/green]")
            await notifyAdminsUnsubmit(interaction)
            await user.send(
                "Your application has been unsubmitted. If this was a mistake, please contact @task.mgr with details."
            )
        else:
            for i in self.children:
                i.disabled = False

            await msg.edit(view=self)
            await user.send(
                f"Sorry, but your application was not unsubmitted. Please contact @task.mgr with this code: {update}"
            )


class adminBtns(discord.ui.View):
    def __init__(self, message_id):
        super().__init__(timeout=None)
        self.message_id = message_id

    @discord.ui.button(
        label="Accept", style=discord.ButtonStyle.success, custom_id="acceptApp"
    )
    async def acceptApp(self, interaction: discord.Interaction, _):
        for i in self.children:
            i.disabled = True

        embedV = interaction.message.embeds[0].to_dict()
        userId = int(embedV["fields"][0]["value"])
        user = bot.get_user(userId)
        embedV["fields"][-1]["value"] = f"Accepted by {interaction.user}"
        embedV["color"] = 0x4ACC39
        embedV = discord.Embed.from_dict(embedV)
        msg = await bot.get_channel(interaction.channel_id).fetch_message(
            self.message_id
        )
        await msg.edit(embed=embedV, view=self)
        await interaction.response.send_message(
            f"Application accepted!", ephemeral=True
        )
        await reviewedApp(interaction, user, userId, "approved")

    @discord.ui.button(
        label="Deny", style=discord.ButtonStyle.danger, custom_id="denyApp"
    )
    async def denyApp(self, interaction: discord.Interaction, _):
        for i in self.children:
            i.disabled = True

        embedV = interaction.message.embeds[0].to_dict()
        msg = await bot.get_channel(interaction.channel_id).fetch_message(
            self.message_id
        )
        userID = int(embedV["fields"][0]["value"])
        await interaction.response.send_modal(
            deniedReason(
                userId=userID,
                appMsg=msg,
                embedMsg=interaction.message.embeds[0],
                btnView=self,
            )
        )

    @discord.ui.button(
        label="Ban", style=discord.ButtonStyle.danger, custom_id="banApp"
    )
    async def banApp(self, interaction: discord.Interaction, _):
        for i in self.children:
            i.disabled = True

        embedV = interaction.message.embeds[0].to_dict()
        msg = await bot.get_channel(interaction.channel_id).fetch_message(
            self.message_id
        )
        userID = int(embedV["fields"][0]["value"])
        await interaction.response.send_modal(
            bannedReason(
                userId=userID,
                appMsg=msg,
                embedMsg=interaction.message.embeds[0],
                btnView=self,
            )
        )


@bot.event
async def on_ready():
    print(f"[green]Bot is active[/green]")
    try:
        cmds = await bot.tree.sync()
        print(f"[green]Synced {len(cmds)} command(s)")
    except Exception as e:
        print(e)


@bot.tree.command(name="register", description="Creates an application")
async def register(interaction: discord.Interaction):
    member = bot.get_guild(int(serverid)).get_member(interaction.user.id)
    if not member:
        return await interaction.response.send_message(
            "Sorry, but you must be a member of the [Mercury 2 Discord server](https://discord.gg/5dQWXJn6pW) to use this bot."
        )

    try:
        app = await getApplication(
            f"https://banland.xyz/api/discord/getApplication/{interaction.user.id}?apiKey={os.getenv('APIKEY')}",
            interaction.user.id,
        )

        if app:
            status, _, _, _, reviewed = app

            if status == "Banned":
                return await interaction.response.send_message(
                    "You cannot submit an application at this moment. Please run */info* for more details."
                )
            if status == "Denied":
                date = dateutil.parser.isoparse(reviewed) + datetime.timedelta(days=3)
                timestamp = int(date.timestamp())
                return await interaction.response.send_message(
                    f"You cannot submit an application at this moment. You may retry on <t:{timestamp}>"
                )
    except Exception as e:
        print(e)
        return await problemMessage(interaction)

    if isinstance(interaction.channel, discord.DMChannel):
        await application(interaction)
    else:
        await confirmed(interaction)
        await application(interaction)


@bot.tree.command(name="info", description="Returns information about your application")
async def info(interaction: discord.Interaction):
    member = bot.get_guild(int(serverid)).get_member(interaction.user.id)
    if not member:
        return await interaction.response.send_message(
            "Sorry, but you must be a member of the [Mercury 2 Discord server](https://discord.gg/5dQWXJn6pW) to use this bot."
        )

    if isinstance(interaction.channel, discord.DMChannel):
        await fetchApplication(
            f"https://banland.xyz/api/discord/getApplication/{interaction.user.id}?apiKey={os.getenv('APIKEY')}",
            interaction.user.id,
            interaction,
        )
    else:
        await confirmedFetch(interaction)
        await fetchApplication(
            f"https://banland.xyz/api/discord/getApplication/{interaction.user.id}?apiKey={os.getenv('APIKEY')}",
            interaction.user.id,
            interaction,
        )


@bot.tree.command(name="unsubmit", description="Unsubmits your current application")
async def unsubmit(interaction: discord.Interaction):
    member = bot.get_guild(int(serverid)).get_member(interaction.user.id)
    if not member:
        return await interaction.response.send_message(
            "Sorry, but you must be a member of the [Mercury 2 Discord server](https://discord.gg/5dQWXJn6pW) to use this bot."
        )

    try:
        app = await getApplication(
            f"https://banland.xyz/api/discord/getApplication/{interaction.user.id}?apiKey={os.getenv('APIKEY')}",
            interaction.user.id,
        )

        if app == None or app[0] == "Pending":
            return await interaction.response.send_message(
                "You do not have a current pending application at the moment."
            )
    except:
        return await problemMessage(interaction)

    if isinstance(interaction.channel, discord.DMChannel):
        await deleteApplication(interaction.user.id, interaction)
    else:
        await confirmedDelete(interaction)
        await deleteApplication(interaction.user.id, interaction)


@bot.tree.command(name="fetch", description="Fetches all pending applications")
async def fetch(interaction: discord.Interaction):

    guild = await bot.fetch_guild(serverid)

    mod = discord.utils.get(guild.roles, name="Owners")

    if (
        not isinstance(interaction.user, discord.Member)
        or mod not in interaction.user.roles
    ):
        return await problemMessage(interaction)

    try:
        applications = await fetchAllApplications(
            f"https://banland.xyz/api/discord/getApplication?apiKey={os.getenv('APIKEY')}",
            interaction.user.id,
        )
    except:
        return await problemMessage(interaction)

    if len(applications) == 0:
        return await interaction.response.send_message(
            "There are no pending applications at the moment."
        )

    for i in range(len(applications)):
        try:
            user = await guild.fetch_member(int(applications[i]["discordId"]))
        except:
            user = "N/A - Left Server"

        if len(str(applications[i]["response"][2])) <= 20:
            applications[i]["response"][2] = "N/A"

        print(applications[i]["discordId"])

        embedV = discord.Embed(color=0x472A96)
        embedV.set_author(
            name="Mercury 2 - Applications",
            url="https://banland.xyz",
            icon_url="https://banland.xyz/icon192.png",
        )
        embedV.title = f"New Applicant - @{user}"
        embedV.add_field(name="User ID", value=str(applications[i]["discordId"]))
        embedV.add_field(
            name="1. Why would you like to join Mercury 2",
            value=f"`{str(applications[i]['response'][0])}`",
            inline=False,
        )
        embedV.add_field(
            name="2. Where did you hear about Mercury 2?",
            value=f"`{str(applications[i]['response'][1])}`",
            inline=False,
        )
        embedV.add_field(
            name="3. Any questions/suggestions?",
            value=f"`{str(applications[i]['response'][2])}`",
            inline=False,
        )
        embedV.add_field(name="Status", value="No decision yet")
        channel = bot.get_channel(int(adminid))
        message = await channel.send(embed=embedV, allowed_mentions=None)
        await message.edit(view=adminBtns(message_id=message.id))

    await interaction.response.send_message(
        f"Fetched {len(applications)} applications!"
    )


bot.run(envtoken)
