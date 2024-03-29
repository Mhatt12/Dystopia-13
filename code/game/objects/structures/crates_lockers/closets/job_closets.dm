/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/gmcloset/New()
	..()
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/head/pin/flower(src)
	new /obj/item/clothing/head/pin/flower/pink(src)
	new /obj/item/clothing/head/pin/flower/yellow(src)
	new /obj/item/clothing/head/pin/flower/blue(src)
	new /obj/item/clothing/head/pin/pink(src)
	new /obj/item/clothing/head/pin/magnetic(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/under/rank/bartender(src)
	new /obj/item/clothing/under/rank/bartender/skirt(src)
	new /obj/item/clothing/under/dress/dress_saloon(src)
	new /obj/item/clothing/accessory/wcoat(src)
	new /obj/item/clothing/accessory/wcoat(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/laceup(src)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "chef's closet"
	desc = "It's a storage unit for foodservice garments."
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/chefcloset/New()
	..()
	new /obj/item/clothing/under/sundress(src)
	new /obj/item/clothing/under/waiter(src)
	new /obj/item/clothing/under/waiter(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/weapon/storage/box/mousetraps(src)
	new /obj/item/weapon/storage/box/mousetraps(src)
	new /obj/item/clothing/under/rank/chef(src)
	new /obj/item/clothing/head/chefhat(src)
	new /obj/item/weapon/storage/bag/food(src)
	new /obj/item/weapon/storage/bag/food(src)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/jcloset/New()
	..()
	new /obj/item/clothing/under/rank/janitor(src)
	new /obj/item/clothing/under/dress/maid/janitor(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/weapon/cartridge/janitor(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/soft/purple(src)
	new /obj/item/clothing/head/beret/purple(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/weapon/caution(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/weapon/storage/bag/trash(src)
	new /obj/item/weapon/storage/belt/janitor(src)
	new /obj/item/clothing/shoes/galoshes(src)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/lawcloset/New()
	..()
	new /obj/item/clothing/under/lawyer/female(src)
	new /obj/item/clothing/under/lawyer/female(src)
	new /obj/item/clothing/under/lawyer/black(src)
	new /obj/item/clothing/under/lawyer/black(src)
	new /obj/item/clothing/under/lawyer/black/skirt(src)
	new /obj/item/clothing/under/lawyer/black/skirt(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/lawyer/red/skirt(src)
	new /obj/item/clothing/under/lawyer/red/skirt(src)
	new /obj/item/clothing/suit/storage/toggle/internalaffairs(src)
	new /obj/item/clothing/suit/storage/toggle/internalaffairs(src)
	new /obj/item/clothing/under/lawyer/bluesuit(src)
	new /obj/item/clothing/under/lawyer/bluesuit(src)
	new /obj/item/clothing/under/lawyer/bluesuit/skirt(src)
	new /obj/item/clothing/under/lawyer/bluesuit/skirt(src)
	new /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket(src)
	new /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket(src)
	new /obj/item/clothing/under/lawyer/purpsuit(src)
	new /obj/item/clothing/under/lawyer/purpsuit(src)
	new /obj/item/clothing/under/lawyer/purpsuit/skirt(src)
	new /obj/item/clothing/under/lawyer/purpsuit/skirt(src)
	new /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket(src)
	new /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	new /obj/item/clothing/glasses/sunglasses/big(src)
	new /obj/item/clothing/under/lawyer/blue(src)
	new /obj/item/clothing/under/lawyer/blue(src)
	new /obj/item/clothing/under/lawyer/blue/skirt(src)
	new /obj/item/clothing/under/lawyer/blue/skirt(src)
	new /obj/item/device/tape/random(src)
	new /obj/item/device/tape/random(src)