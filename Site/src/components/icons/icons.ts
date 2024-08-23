import ArrowLeft from "./arrow-left.svelte"
import ArrowRightFromBracket from "./arrow-right-from-bracket.svelte"
import ArrowUp from "./arrow-up.svelte"
import ArrowsRotate from "./arrows-rotate.svelte"
import Bell from "./bell.svelte"
import BookOpenCover from "./book-open-cover.svelte"
import BoxOpenFull from "./box-open-full.svelte"
import Cancel from "./cancel.svelte"
import CheckCircle from "./check-circle.svelte"
import Check from "./check.svelte"
import CircleEllipsis from "./circle-ellipsis.svelte"
import DiamondHalfStroke from "./diamond-half-stroke.svelte"
import EllipsisH from "./ellipsis-h.svelte"
import Flag from "./flag.svelte"
import Gavel from "./gavel.svelte"
import Gears from "./gears.svelte"
import Hammer from "./hammer.svelte"
import Heart from "./heart.svelte"
import HouseChimney from "./house-chimney.svelte"
import Message from "./message.svelte"
import Messages from "./messages.svelte"
import Microphone from "./microphone.svelte"
import MoneyBillTransfer from "./money-bill-transfer.svelte"
import MountainSun from "./mountain-sun.svelte"
import PaperPlaneTop from "./paper-plane-top.svelte"
import Pencil from "./pencil.svelte"
import PeopleGroup from "./people-group.svelte"
import Plus from "./plus.svelte"
import RightToBracket from "./right-to-bracket.svelte"
import ScaleBalanced from "./scale-balanced.svelte"
import Search from "./search.svelte"
import ShieldAlt from "./shield-alt.svelte"
import ThumbsDown from "./thumbs-down.svelte"
import ThumbsUp from "./thumbs-up.svelte"
import Thumbtack from "./thumbtack.svelte"
import Trash from "./trash.svelte"
import UserGroup from "./user-group.svelte"
import UserPen from "./user-pen.svelte"
import User from "./user.svelte"
import XmarkLarge from "./xmark-large.svelte"

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
	"xmark-large": XmarkLarge,
})

export type IconName = keyof typeof icons
export default icons
