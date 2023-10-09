<script lang="ts">
	import ProfileForm from "./Profile.svelte"
	import AccountInfo from "./Account.svelte"
	import PasswordForm from "./Password.svelte"

	export let data

	let tabData = TabData(data.url, ["Profile", "Account", "Security"])
</script>

<Head title="Settings" />

<div class="container mt-6 light-text">
	<h1 class="pb-4">Settings</h1>
	<TabNav bind:tabData />
	<Tab {tabData}>
		<h2 class="fs-4">User Profile</h2>
		<p class="mb-0 grey-text mb-6">Change your bio, site theme and more.</p>
		<ProfileForm {data} />
	</Tab>

	<Tab {tabData}>
		<h2 class="fs-4">User Information</h2>
		<p class="mb-0 grey-text mb-6">
			Information about your account, you can change certain aspects of it
			here.
		</p>
		<AccountInfo {data} />
	</Tab>

	<Tab {tabData}>
		<h2 class="fs-4">Change Password</h2>
		<PasswordForm {data} />
	</Tab>
</div>
