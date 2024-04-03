<script lang="ts">
	import ProfileForm from "./Profile.svelte"
	import AccountInfo from "./Account.svelte"
	import PasswordForm from "./Password.svelte"
	import StylingForm from "./Styling.svelte"

	export let data
	const { user } = data

	let tabData = TabData(
		data.url,
		["Profile", "Account", "Security", "Styling"],
		["fa fa-id-card", "fa fa-user", "far fa-lock", "fa fa-paint-brush"]
	)
</script>

<Head title="Settings" />

<div class="ctnr max-w-220 light-text">
	<div class="pb-4">
		<h1>User settings</h1>
		<a href="/user/{user.number}" class="no-underline">
			<fa fa-caret-left />
			View profile
		</a>
	</div>

	<TabNav bind:tabData />
	<Tab {tabData}>
		<h2 class="text-xl">User Profile</h2>
		<p class="grey-text pb-6">Change your bio, site theme and more.</p>
		<ProfileForm {data} />
	</Tab>

	<Tab {tabData}>
		<h2 class="text-xl">User Information</h2>
		<p class="grey-text pb-6">
			Information about your account, you can change certain aspects of it
			here.
		</p>
		<AccountInfo {data} />
	</Tab>

	<Tab {tabData}>
		<h2 class="text-xl pb-4">Change Password</h2>
		<PasswordForm {data} />
	</Tab>

	<Tab {tabData}>
		<h2 class="text-xl pb-4">Styling</h2>
		<StylingForm {data} />
	</Tab>
</div>
