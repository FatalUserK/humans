dofile("data/scripts/lib/mod_settings.lua")

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	--print( tostring(new_value) )
end

local currentLang = GameTextGetTranslatedOrNot("$current_language")

local GUI_button = "GUI Button"
local GUI_button_desc = "Shows [NE] button at the top of the screen."
local Difficulty_name = "Difficulty Selection"
local Difficulty_desc = "Select the custom enemy difficulty"
local Difficulty_desc_easy = "Easier Mode"
local Difficulty_desc_normal = "Normal Mode"
local Enemy_progress_lang_name = "Enemy Progess Language Selection"
local Enemy_progress_lang_desc = "Select the language for enemies in the progress"
local Enemy_progress_lang_fin = "Finnish"
local Enemy_progress_lang_eng = "English"
local New_enemies_scenes_name = "New Enemies Scenes"
local New_enemies_scenes_desc = "Toggles Custom Scenes on and off."
local New_enemies_twitch_name = "New Enemies Twitch Events"
local New_enemies_twitch_desc = "Toggles Custom Events on and off."
local Biome_verlet_removal_name = "Biome Verlets Lag Reducer"
local Biome_verlet_removal_desc = "This setting removes hanging vines in the jungle which in vanilla cause a lot of lag."
-- local Chunk_optimizer_name = "Chunk Loading Optimizer"
-- local Chunk_optimizer_desc = "Higher FPS, Slightly bigger file size."
local Offscreen_attacks_name = "Offscreen attack disabler"
local Offscreen_attacks_desc = "This setting deletes enemy projectiles, if they are shot from offscreen."
local Custom_poly_name = "Polymorph Into Custom Enemies"
local Custom_poly_desc = "Toggles Custom Polymorphing on and off."
local Custom_poly_player_name = "Only Player Can Polymorph Into Custom Enemies"
local Custom_poly_player_desc = "Who polymorphs into custom creatures? Everyone or just the player?"
local Feast_name = "Specific Feast Skin Selection"
local Feast_desc = "Specify a fixed special event date, for enemies to have respective aesthetics!"
local Feast_desc_normal = "Normal Dates"
local Feast_desc_christmas = "Always Christmas"
local Feast_desc_pride = "Always Pride Month"
local Feast_desc_new_year = "Always New Year"
local Feast_desc_easter = "Always Easter"
local Feast_desc_halloween = "Always Halloween"
local Feast_desc_carnival = "Always Carnival"
local Feast_desc_april_fools = "Always April Fools"
local Feast_desc_thanksgiving = "Always Thankgiving"
local Feast_desc_saint_patricks = "Always Saint Patricks"
local Feast_desc_birthday = "Always Birthday"
local Feast_desc_valentines = "Always Valentines"
local Feast_desc_lunar_new_year = "Always Lunar New Year"
local Feast_desc_mariachi = "Always Mariachi"
local Feast_desc_4th_of_july = "Always 4th Of July"
local Feast_desc_may_the_fourth = "Always May The Fourth"
local Feast_desc_diwali = "Always Diwali"

--Russian Translations
if currentLang == "русский" then

	GUI_button = "Кнопка GUI"
	GUI_button_desc = "Показывает кнопку [NE] в верхней части экрана."
	Difficulty_name = "Выбор сложности"
	Difficulty_desc = "Выберите пользовательскую сложность врагов"
	Difficulty_desc_easy = "Легкий режим"
	Difficulty_desc_normal = "Обычный режим"
	Enemy_progress_lang_name = "Выбор языка прогресса врагов"
	Enemy_progress_lang_desc = "Выберите язык для врагов в прогрессе"
	Enemy_progress_lang_fin = "Финский"
	Enemy_progress_lang_eng = "Английский"
	New_enemies_scenes_name = "Новые сцены врагов"
	New_enemies_scenes_desc = "Включает и выключает пользовательские сцены."
	New_enemies_twitch_name = "Новые события Twitch"
	New_enemies_twitch_desc = "Включает и выключает пользовательские события."
	Biome_verlet_removal_name = "Уменьшение лагов в биомах"
	Biome_verlet_removal_desc = "Эта настройка удаляет висящие лианы в джунглях, которые в оригинале вызывают много лагов."
	Offscreen_attacks_name = "Отключение атак вне экрана"
	Offscreen_attacks_desc = "Эта настройка удаляет снаряды врагов, если они выпущены вне экрана."
	-- Chunk_optimizer_name = "Оптимизатор загрузки чанков"
	-- Chunk_optimizer_desc = "Эта настройка делает игру более плавной, за счёт увеличения размера файла сохранения."
	Custom_poly_name = "Полиморф в пользовательских врагов"
	Custom_poly_desc = "Включает и выключает пользовательский полиморф."
	Custom_poly_player_name = "Только игрок может полиморфироваться в пользовательских врагов"
	Custom_poly_player_desc = "Кто полиморфируется в пользовательских существ? Все или только игрок?"
	Feast_name = "Выбор Тематического Праздника"
	Feast_desc = "Укажите фиксированную дату особого события, чтобы враги получили соответствующий облик!"
	Feast_desc_normal = "Обычные даты"
	Feast_desc_christmas = "Всегда Рождество"
	Feast_desc_pride = "Всегда Месяц Прайда"
	Feast_desc_new_year = "Всегда Новый Год"
	Feast_desc_easter = "Всегда Пасха"
	Feast_desc_halloween = "Всегда Хэллоуин"
	Feast_desc_carnival = "Всегда Карнавал"
	Feast_desc_april_fools = "Всегда 1 Апреля"
	Feast_desc_thanksgiving = "Всегда День Благодарения"
	Feast_desc_saint_patricks = "Всегда День Святого Патрика"
	Feast_desc_birthday = "Всегда День Рождения"
	Feast_desc_valentines = "Всегда День Святого Валентина"
	Feast_desc_lunar_new_year = "Всегда Китайский Новый Год"
	Feast_desc_mariachi = "Всегда Мариачи"
	Feast_desc_4th_of_july = "Всегда 4 Июля"
	Feast_desc_may_the_fourth = "Всегда Да Будет Сила (4 Мая)"
	Feast_desc_diwali = "Всегда Дивали"


--Japanese Translation
elseif currentLang == "日本語" then

	GUI_button = "GUIボタン"
	GUI_button_desc = "画面上部の[NE]ボタンから、このMODの設定画面にアクセスできるようになります。"
	Difficulty_name = "難易度選択"
	Difficulty_desc = "敵キャラの強さを設定できます"
	Difficulty_desc_easy = "ふつう"
	Difficulty_desc_normal = "つよい"
	Enemy_progress_lang_name = "敵キャラ名の言語"
	Enemy_progress_lang_desc = "進捗画面で表示される敵キャラ名の言語を設定できます。"
	Enemy_progress_lang_fin = "フィンランド語"
	Enemy_progress_lang_eng = "英語"
	New_enemies_scenes_name = "追加地形"
	New_enemies_scenes_desc = "本MODで追加される地形を生成するかどうか設定できます。"
	New_enemies_twitch_name = "Twitch連携"
	New_enemies_twitch_desc = "Twitch連携モードにイベントを追加します"
	Biome_verlet_removal_name = "軽量化モード"
	Biome_verlet_removal_desc = "オンにすると、ジャングルなどで出現する背景のツタを削除し、ラグを削減します。"
	-- Chunk_optimizer_name = "チャンク読み込み最適化"
	-- Chunk_optimizer_desc = "この設定は、セーブファイルが大きくなる代わりにゲームをよりスムーズにします。"
	Offscreen_attacks_name = "画面外攻撃の無効化"
	Offscreen_attacks_desc = "画面外で発射された敵の放射物を削除します。"
	Custom_poly_name = "追加モンスターの多形体"
	Custom_poly_desc = "多形性型で追加モンスターに変身できるかどうか設定できます。"
	Custom_poly_player_name = "プレイヤーのみがカスタム敵に変身"
	Custom_poly_player_desc = "カスタムクリーチャーに変身するのは誰ですか？全員か、それともプレイヤーだけか？"
	Feast_name = "特定イベントスキンの選択"
	Feast_desc = "特別なイベントの日付を固定して、敵に対応した見た目を設定しよう！"
	Feast_desc_normal = "通常の日付"
	Feast_desc_christmas = "常にクリスマス"
	Feast_desc_pride = "常にプライド月間"
	Feast_desc_new_year = "常にお正月"
	Feast_desc_easter = "常にイースター"
	Feast_desc_halloween = "常にハロウィン"
	Feast_desc_carnival = "常にカーニバル"
	Feast_desc_april_fools = "常にエイプリルフール"
	Feast_desc_thanksgiving = "常に感謝祭"
	Feast_desc_saint_patricks = "常にセント・パトリックス・デー"
	Feast_desc_birthday = "常に誕生日"
	Feast_desc_valentines = "常にバレンタインデー"
	Feast_desc_lunar_new_year = "常に旧正月"
	Feast_desc_mariachi = "常にマリアッチ"
	Feast_desc_4th_of_july = "常に独立記念日（7月4日）"
	Feast_desc_may_the_fourth = "常にスター・ウォーズの日（5月4日）"
	Feast_desc_diwali = "常にディワリ"

end

local mod_id = "new_enemies"
mod_settings_version = 1
mod_settings = 
{
  {
    id = "show_button",
    ui_name = GUI_button,
    ui_description = GUI_button_desc,
    value_default = true,
    scope = MOD_SETTING_SCOPE_RUNTIME,
  },
  
	{
		id = "difficulty_level",
		ui_name = Difficulty_name,
		ui_description = Difficulty_desc,
		value_default = "normal",
		values = {
			{"easy", Difficulty_desc_easy},
			{"normal",Difficulty_desc_normal},
		},
		scope = MOD_SETTING_SCOPE_RUNTIME, 
	},
	
	{
	  id = "global_enemy_multiplier",
	  ui_name = "Global New Enemy Ratio",
	  ui_description = "Spawn ratio of new enemies to other enemies globally",
	  value_default = 100,
	  value_min = 0,
	  value_max = 200,
	  value_display_multiplier = 1,
	  value_display_formatting = " $0 is to 100 ratio",
	  scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	
	{
		id = "progress_language",
		ui_name = Enemy_progress_lang_name,
		ui_description = Enemy_progress_lang_desc,
		value_default = "finnish",
		values = {
			{"finnish", Enemy_progress_lang_fin},
			{"english", Enemy_progress_lang_eng},
		},
		scope = MOD_SETTING_SCOPE_RUNTIME, 
	},
	
  {
    id = "scenes_enabled",
    ui_name = New_enemies_scenes_name,
    ui_description = New_enemies_scenes_desc,
    value_default = true,
    scope = MOD_SETTING_SCOPE_RUNTIME,
  },
  -- {
    -- id = "twitch_events_enabled",
    -- ui_name = New_enemies_twitch_name,
    -- ui_description = New_enemies_twitch_desc,
    -- value_default = false,
    -- scope = MOD_SETTING_SCOPE_RUNTIME,
  -- },
  {
    id = "jungle_lag_reducer_enabled",
    ui_name = Biome_verlet_removal_name,
    ui_description = Biome_verlet_removal_desc,
    value_default = true,
    scope = MOD_SETTING_SCOPE_RUNTIME,
  },
  -- {
    -- id = "chunk_optimizer_enabled",
    -- ui_name = Chunk_optimizer_name,
    -- ui_description = Chunk_optimizer_desc,
    -- value_default = true,
    -- scope = MOD_SETTING_SCOPE_RUNTIME,
  -- },
  {
    id = "disable_offscreen_attacks_enabled",
    ui_name = Offscreen_attacks_name,
    ui_description = Offscreen_attacks_desc,
    value_default = false,
    scope = MOD_SETTING_SCOPE_NEW_GAME,
  },
	{
		id = "feast_specifier",
		ui_name = Feast_name,
		ui_description = Feast_desc,
		value_default = "normal",
		values = {
			{"normal",Feast_desc_normal},
			{"christmas",Feast_desc_christmas},
			{"pride",Feast_desc_pride},
			{"new_year",Feast_desc_new_year},
			{"easter",Feast_desc_easter},
			{"halloween",Feast_desc_halloween},
			{"carnival",Feast_desc_carnival},
			{"april_fools",Feast_desc_april_fools},
			{"thanksgiving",Feast_desc_thanksgiving},
			{"stpatricks",Feast_desc_saint_patricks},
			{"birthday",Feast_desc_birthday},
			{"valentines",Feast_desc_valentines},
			{"lunar_new_year",Feast_desc_lunar_new_year},
			{"mariachi",Feast_desc_mariachi},
			{"july_4th",Feast_desc_4th_of_july},
			{"may_4th",Feast_desc_may_the_fourth},
			{"diwali",Feast_desc_diwali}
		},
		scope = MOD_SETTING_SCOPE_RUNTIME, 
	},
  {
    id = "poly_expansion_enabled",
    ui_name = Custom_poly_name,
    ui_description = Custom_poly_desc,
    value_default = true,
    scope = MOD_SETTING_SCOPE_NEW_GAME,
	change_fn = function(mod_id, gui, in_main_menu, setting, old_value, new_value)
	  for i, v in ipairs(mod_settings) do
		if v.id == "poly_only_player_enabled" then
		  v.hidden = (not new_value) == true
		end
	  end
	end
  },
  {
    id = "poly_only_player_enabled",
    ui_name = Custom_poly_player_name,
    ui_description = Custom_poly_player_desc,
    value_default = true,
    scope = MOD_SETTING_SCOPE_RUNTIME,
  },
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end