/obj/item/device/scanner/price
	name = "export scanner"
	desc = "A device used to check objects against Commercial database."
	icon = 'icons/obj/reader.dmi'
	icon_state = "reader0"
	item_state = "radio"
	flags = NOBLUDGEON
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 1
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	charge_per_use = 3
	rarity_value = 25

/obj/item/device/scanner/price/is_valid_scan_target(atom/movable/target)
	return istype(target)

/obj/item/device/scanner/price/scan(atom/movable/target, mob/user)
	scan_title = "Price estimations"

	if(!scan_data)
		scan_data = price_scan_results(target)
	else
		scan_data += "<br>[price_scan_results(target)]"
	flick("reader1", src)
	show_results(user)

/obj/item/device/scanner/price/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	return ..()

/proc/price_scan_results(atom/movable/target)
	var/list/data = list()
	var/price = SStrade.get_price(target) * SStrade.get_export_price_multiplier(target)
	var/station_name
	var/offer_name
	var/offer_price
	var/offer_amount
	data += "<span class='notice'>Scanned [target], value: <b>[price ? price : "0"]</b> credits[target.contents.len ? " (contents included)" : ""]."
	if(!price)
		for(var/datum/trade_station/TS in SStrade.discovered_stations)
			for(var/path in TS.special_offers)
				if(istype(target, path))
					station_name = TS.name
					var/list/offer_content = TS.special_offers[path]
					offer_name = offer_content["name"]
					offer_price = offer_content["price"]
					offer_amount = offer_content["amount"]
					data += "<span class='notice'>\> Special offer available at <b>[station_name]</b>.</span>"
					data += "<span class='notice'>\>\> [offer_name], <b>[round(offer_price / offer_amount, 1)]</b> credits each, [offer_amount ? offer_amount : "0"] requested</span>"
	data = jointext(data, "<br>")
	return data
