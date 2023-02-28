extends OptionButton
# Managing locales.


const LOCALES_NAMES = {
	"en": "english",
	"fr": "français",
}


func _ready():
	grab_focus()
	
	var i = 0
	for locale_name in LOCALES_NAMES:
		
		add_item(LOCALES_NAMES[locale_name], i)
		set_item_metadata(i, locale_name)
		
		if locale_name in TranslationServer.get_locale():
			select(i)
		
		i += 1


func _on_language_button_item_selected(index):
	TranslationServer.set_locale(get_item_metadata(index))
