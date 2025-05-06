<script lang="ts">
	import Head from "$components/Head.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import Account from "./Account.svelte"
	import Profile from "./Profile.svelte"
	import Security from "./Security.svelte"
	import Styling from "./Styling.svelte"

	const { data } = $props()

	const { user } = data

	let tabData = $state(
		TabData(
			data.url,
			["Profile", "Account", "Security", "Styling"],
			["fa-id-card", "fa-user", "fa-lock", "fa-paint-brush"]
		)
	)
</script>

<Head name={data.siteName} title="Settings" />

<div class="ctnr max-w-220 light-text">
	<div class="pb-4">
		<h1>User settings</h1>
		<a href="/user/{user.username}" class="no-underline">
			<fa fa-caret-left></fa>
			View profile
		</a>
	</div>

	<TabNav bind:tabData />
	<Tab bind:tabData>
		<h2 class="text-xl">User Profile</h2>
		<p class="grey-text pb-6">Change your description, site theme and more.</p>
		<Profile {data} />
	</Tab>

	<Tab bind:tabData>
		<h2 class="text-xl">User Information</h2>
		<p class="grey-text pb-6">Information about your account.</p>
		<Account {data} />
	</Tab>

	<Tab bind:tabData>
		<h2 class="text-xl">Account Security</h2>
		<p class="grey-text pb-6">
			Ensure your account is secure by changing your password and other
			security settings.
		</p>
		<Security {data} />
	</Tab>

	<Tab bind:tabData>
		<h2 class="text-xl pb-4">Styling</h2>
		<Styling {data} />
	</Tab>
</div>
