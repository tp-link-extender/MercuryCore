<script lang="ts">
	import ProfileForm from "./Profile.svelte"
	import AccountInfo from "./Account.svelte"
	import PasswordForm from "./Password.svelte"

	export let data

	let tabData = TabData(data.url, ["Profile", "Account", "Security"])
</script>

<Head title="Settings" />

<div class="ctnr max-w-220 light-text">
	<h1 class="py-6">Settings</h1>
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
</div>
