<script lang="ts">
	import ArrowLeft from "./icons/arrow-left.svelte"
	import ArrowRightFromBracket from "./icons/arrow-right-from-bracket.svelte"
	import ArrowUp from "./icons/arrow-up.svelte"
	import ArrowsRotate from "./icons/arrows-rotate.svelte"
	import Bell from "./icons/bell.svelte"
	import BookOpenCover from "./icons/book-open-cover.svelte"
	import BoxOpenFull from "./icons/box-open-full.svelte"
	import Cancel from "./icons/cancel.svelte"
	import CheckCircle from "./icons/check-circle.svelte"
	import Check from "./icons/check.svelte"
	import CircleEllipsis from "./icons/circle-ellipsis.svelte"
	import DiamondHalfStroke from "./icons/diamond-half-stroke.svelte"
	import EllipsisH from "./icons/ellipsis-h.svelte"
	import Flag from "./icons/flag.svelte"
	import Gavel from "./icons/gavel.svelte"
	import Gears from "./icons/gears.svelte"
	import Hammer from "./icons/hammer.svelte"
	import Heart from "./icons/heart.svelte"
	import HouseChimney from "./icons/house-chimney.svelte"
	import Message from "./icons/message.svelte"
	import Messages from "./icons/messages.svelte"
	import Microphone from "./icons/microphone.svelte"
	import MoneyBillTransfer from "./icons/money-bill-transfer.svelte"
	import MountainSun from "./icons/mountain-sun.svelte"
	import PaperPlaneTop from "./icons/paper-plane-top.svelte"
	import Pencil from "./icons/pencil.svelte"
	import PeopleGroup from "./icons/people-group.svelte"
	import Plus from "./icons/plus.svelte"
	import RightToBracket from "./icons/right-to-bracket.svelte"
	import ScaleBalanced from "./icons/scale-balanced.svelte"
	import Search from "./icons/search.svelte"
	import ShieldAlt from "./icons/shield-alt.svelte"
	import ThumbsDown from "./icons/thumbs-down.svelte"
	import ThumbsUp from "./icons/thumbs-up.svelte"
	import Thumbtack from "./icons/thumbtack.svelte"
	import Trash from "./icons/trash.svelte"
	import UserGroup from "./icons/user-group.svelte"
	import UserPen from "./icons/user-pen.svelte"
	import User from "./icons/user.svelte"
	import XmarkLarge from "./icons/xmark-large.svelte"

	const icons = Object.freeze({
		"arrow-left": ArrowLeft,
		"arrow-right-from-bracket": ArrowRightFromBracket,
		"arrow-up": ArrowUp,
		"arrows-rotate": ArrowsRotate,
		bell: Bell,
		"book-open-cover": BookOpenCover,
		"box-open-full": BoxOpenFull,
		cancel: Cancel,
		"check-circle": CheckCircle,
		check: Check,
		"circle-ellipsis": CircleEllipsis,
		"diamond-half-stroke": DiamondHalfStroke,
		"ellipsis-h": EllipsisH,
		flag: Flag,
		gavel: Gavel,
		gears: Gears,
		hammer: Hammer,
		heart: Heart,
		"house-chimney": HouseChimney,
		message: Message,
		messages: Messages,
		microphone: Microphone,
		"money-bill-transfer": MoneyBillTransfer,
		"mountain-sun": MountainSun,
		"paper-plane-top": PaperPlaneTop,
		pencil: Pencil,
		"people-group": PeopleGroup,
		plus: Plus,
		"right-to-bracket": RightToBracket,
		"scale-balanced": ScaleBalanced,
		search: Search,
		"shield-alt": ShieldAlt,
		"thumbs-down": ThumbsDown,
		"thumbs-up": ThumbsUp,
		thumbtack: Thumbtack,
		trash: Trash,
		"user-group": UserGroup,
		"user-pen": UserPen,
		user: User,
		"xmark-large": XmarkLarge
	})

	export let icon: keyof typeof icons
</script>

<span {...$$restProps}>
	<svelte:component this={icons[icon]} />
</span>

<style>
	:global(svg) {
		/* hax */
		height: 1rem;
	}
</style>
