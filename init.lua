--PolyTools
-- dofile_once("mods/new_enemies/files/polytools/polytools_init.lua").init("mods/new_enemies/files/polytools")

--Addition of custom genomes Heavily experimental
function split_string(inputstr, sep)
  sep = sep or "%s"
  local t= {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function replace_value(path, input, output, print_contents)
	local content = ModTextFileGetContent(path)
	content = content:gsub(input, output)
	ModTextFileSetContent(path, content)
	if print_contents == true then
		print(content)
	end
end

local content = ModTextFileGetContent("data/genome_relations.csv")
function add_new_genome(content, genome_name, default_relation_ab, default_relation_ba, self_relation, relations)
  local lines = split_string(content, "\r\n")
  local output = ""
  local genome_order = {}
  for i, line in ipairs(lines) do
    if i == 1 then
      output = output .. line .. "," .. genome_name .. "\r\n"
    else
      local herd = line:match("([%w_-]+),")
      output = output .. line .. ","..(relations[herd] or default_relation_ba).."\r\n"
      table.insert(genome_order, herd)
    end
  end
  
  local line = genome_name
  for i, v in ipairs(genome_order) do
    line = line .. "," .. (relations[v] or default_relation_ab)
  end
  output = output .. line .. "," .. self_relation

  return output
end

-- Example usage: (This sets all genome relations of this genome to 100, unless indicated so, in this case, I want 100 with everything, except the player and -1)
content = add_new_genome(content, "friendly", 100, 100, 100, {
  player = 0,
  ["-1"] = 0
})

content = add_new_genome(content, "yikka", 100, 100, 100, {
  player = 5,
  ["-1"] = 5
})

content = add_new_genome(content, "meaty", 0, 0, 100, {
  player = 0,
  ["-1"] = 0,
  ghost = 100,
  orcs = 40
})

--Please Note: Here I want the genome twin_mage to attack all other genomes except its own, AND I want other genomes to not attack it!
--So Look what I did here. I Illegaly set the horizontal row to be different than the vertical row.
--horizontal row is 0, and vertical row is 100 . This somehow achieves exactly what I want. Makes the twin_mage genome attack other genomes, without the other genomes considering it an enemy
content = add_new_genome(content, "twin_mage", 0, 100, 100, {})
content = add_new_genome(content, "twin_mage_b", 100, 100, 100, {
  player = 0,
  ["-1"] = 0
})

--Love Mage Genomes
content = add_new_genome(content, "charmed_target", 100, 100, 100, {})
content = add_new_genome(content, "love_mage", 0, 100, 100, {
	charmed_target = 100
})

-- content = add_new_genome(content, "friendly_mob", 100, 100, 100, {
  -- player = 0,
  -- helpless = 0,
  -- ["-1"] = 0
-- })

-- content = add_new_genome(content, "player_evil", 0, 0, 100, {})

-- content = add_new_genome(content, "parasite", 0, 100, 100, {})

ModTextFileSetContent("data/genome_relations.csv", content)

setting_cache = setting_cache or {}
local function get_setting(name)
    setting_cache[name] = setting_cache[name] or ModSettingGet(name)
    return setting_cache[name]
end


--Addition of Translations:

--General text translations
local content = ModTextFileGetContent("data/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. [[
gods_destroy,The Gods will destroy you,Боги уничтожат тебя,Os Deuses vão destruir você,Los Dioses te destruirán,Die Götter werden dich zerstören,Les Dieux vont vous détruire,Gli Dei ti distruggeranno,Bogowie cię zniszczą,神々はあなたを滅しようとしています,神々が君を滅ぼそうとしている,신들이 당신을 파괴할 것입니다,,
ground_terror_name,Ground Terror,Земной ужас,Terror Terrestre,Terror Terrestre,Bodenterror,Terreur Terrestre,Terrore Terreno,Terror Ziemi,地面恐怖,地の恐怖,지상의 공포,,
ground_terror_desc,Become The Terror,Стань Ужасом,Torne-se o Terror,Conviértete en el Terror,Werden Sie der Terror,Devenez la Terreur,Diventa il Terrore,Stań się Grozą,恐怖を支配せよ,恐怖になれ,공포가 되어라,,
alcohol_immunity_perk_name,Alcohol Immunity,Иммунитет к алкоголю,Imunidade ao Álcool,Inmunidad al Alcohol,Alkoholvergiftung Immun,Immunité à l'alcool,Immunità all'Alcool,Odporny na Alkohol,アルコール免疫,アルコール耐性,알코올 면역,,
alcohol_immunity_perk_desc,You are Immune to Alcohol,Вы иммунны к алкоголю,Você é Imune ao Álcool,Eres Inmune al Alcohol,Du bist immun gegen Alkohol,Vous êtes immunisé contre l'alcool,Sei immune all'alcol,Odporność na alkohol,酒に強くなった,酒に免疫を持っている,알코올에 면역이 있다,,
lava_immunity_perk_name,Lava Immunity,Иммунитет к лаве,Imunidade à Lava,Inmunidad a la Lava,Lava-Immunität,Immunité à la lave,Immunità alla Lava,Odporny na Lawę,溶岩耐性,溶岩免疫,용암 면역,,
lava_immunity_perk_desc,You are immune to lava,Вы иммунны к лаве,Você é Imune à Lava,Eres Inmune a la Lava,Du bist immun gegen Lava,Vous êtes immunisé contre la lave,Sei immune alla lava,Odporny na lawę,溶岩からダメージを受けることがなくなる,溶岩からダメージを受けない,용암에 면역이 생겼습니다,,
reward_ending_ne,New Enemies Mod Trophy,Трофей мода новых врагов,Troféu Mod de Novos Inimigos,Trofeo Mod de Nuevos Enemigos,Neue Feinde Mod Trophäe,Trophée Mod Nouveaux Ennemis,Trofeo Mod Nuovi Nemici,Trofeum Mod Nowych Wrogów,New Enemies Modのトロフィー,新しい敵モードのトロフィー,새로운 적 모드 트로피,,
reward_ending_ne_nightmare,New Enemies Mod Nightmare Trophy,Трофей «Новые Враги» в режиме кошмара,Troféu Mod de Pesadelo Novos Inimigos,Trofeo Pesadilla de Nuevos Enemigos,Alptraum Mod Trophäe,Trophée Cauchemar Mod Nouveaux Ennemis,Trofeo Incubo Mod Nuovi Nemici,Trofeum Koszmar Mod Nowych Wrogów,New Enemies Modのトロフィー(ナイトメア),新しい敵モードのナイトメアトロフィー,새로운 적 모드 악몽 트로피,,
gold_reward_desert_skull,Gold Reward,Золотая награда,Recompensa de Ouro,Recompensa de Oro,Gold-Belohnung,Récompense d'or,Premio d'Oro,Złota Nagroda,試練の報酬,金報酬,황금 보상,,
gold_nugget_5,Gold Nugget (5),Золотая крупица (5),Pedaço de Ouro (5),Pepita de Oro (5),Goldklumpen (5),Pépite d'or (5),Pepita d'Oro (5),Złoty Bryłek (5),金塊(5),ゴールドナゲット（5）,황금 덩어리 (5) ,,
gold_nugget_5_blood,Bloody Gold Nugget (5),Кровавый золотой самородок (5),Pedaço de Ouro Ensanguentado (5),Pepita de Oro Sangrienta (5),Blutiger Goldklumpen (5),Pépite d'or Sanglante (5),Pepita d'Oro Insanguinata (5),Zakrwawiony Złoty Bryłek (5),ブラッディー金塊 (5),血のゴールドナゲット (5),피 묻은 금 덩어리 (5) ,,
poison_immunity_name,Poison Immunity,Иммунитет к яду,Imunidade ao Veneno,Inmunidad al Veneno,Giftimmunität,Immunité au poison,Immunità al Veleno,Odporny na Trucizny,猛毒免疫,毒耐性,독 면역,,
poison_immunity_desc,You're Immune to Poison,Вы иммунны к яду,Você é Imune ao Veneno,Eres Inmune al Veneno,Du bist immun gegen Gift,Vous êtes immunisé contre le poison,Sei immune al veleno,Odporność na trucizny,毒からダメージを受けることがなくなる,毒によるダメージを受けない,독으로부터 면역,,
bleeding_status_name,Bleeding,Кровотечение,Sangramento,Hemorragia,Blutung,Saignement,Sanguinamento,Krwawienie,出血,出血,출혈,,
bleeding_status_desc,You're Bleeding,Вы истекаете кровью,Você está Sangrando,Estás Sangrando,Du blutest,Vous saignez,Stai Sanguinando,Krwawisz,出血している！,あなたは出血している,당신은 출혈 중입니다!,,
shrinking_status_name,Shrinking,Уменьшение,Encolhimento,Encogimiento,Schrumpfen,Rétrécissement,Riduzione,Zmniejszenie,縮小,縮む,축소,,
shrinking_status_desc,You're Shrinking,Вы уменьшаетесь,Você está Encolhendo,Te estás Encogiendo,Du schrumpfst,Vous rétrécissez,Ti stai Riducendo,Zmniejszasz się,身体が小さくなっていく！,体が小さくなっています！,몸이 작아지고 있습니다,,
time_status_name,Time Travel,Путешествие во времени,Viagem no Tempo,Viaje en el Tiempo,Zeitreise,Voyage dans le temps,Viaggio nel tempo,Podróż w czasie,时间旅行,タイムトラベル,시간 여행,,
time_status_desc,You're being sent back in time!,Вас отправляют назад во времени!,Você está sendo enviado de volta no tempo!,¡Estás siendo enviado al pasado!,Du wirst in die Vergangenheit geschickt!,Vous êtes renvoyé dans le passé!,Stai venendo mandato indietro nel tempo!,Jesteś wysyłany w przeszłość!,你正在被送回过去！,時間が巻き戻っていく！,당신은 과거로 보내지고 있습니다！,,
trip_status_name,Tripping,Галлюцинации,Viajando,Alucinando,Trippen,Trip,Allucinazioni,Odurzenie halucynacjami,迷幻体验,トリップ,환각,,
trip_status_desc,You're tripping out of your mind,Вы находитесь в состоянии галлюцинаций!,Você está alucinando!,¡Estás alucinando!,Du halluzinierst!,Vous êtes en plein délire!,Sei completamente fuori di testa!,Doświadczasz halucynacji!,你快失去理智了,頭がどうにかなりそうだ。,당신은 정신을 잃고 있습니다.,,
webbed_status_name,Webbed,Опутан паутиной,Emaranhado,Enredado,Gespinst,Glué,Ricoperto di ragnatele,Uwikłany w sieć,被蜘蛛网缠住,キャプチャー,거미줄에 묶임,,
webbed_status_desc,You're stuck in a cobweb. Can't move!,Вы запутались в паутине. Вы не можете двигаться!,Você está preso em uma teia. Não pode se mover!,¡Estás atrapado en una telaraña. No puedes moverte!,Du steckst in einem Spinnennetz fest. Kannst dich nicht bewegen!,Vous êtes coincé dans une toile d'araignée. Impossible de bouger!,Sei bloccato in una ragnatela. Non puoi muoverti!,Utknąłeś w pajęczynie. Nie możesz się ruszać!,你被困在蜘蛛网里了，无法移动！,蜘蛛の巣に捕まって動けない！,당신은 거미줄에 갇혔습니다. 움직일 수 없습니다!,,
charmed_custom_status_name,Charmed,Очарование,Encantado,Encantado,Bezaubert,Charmé,Incantato,Oczarowany,魅惑,魅了,매혹,,
charmed_custom_status_desc,You become a friend to most enemies,Вы становитесь другом для большинства врагов,Você se torna amigo da maioria dos inimigos,Te haces amigo de la mayoría de los enemigos,Du wirst Freund der meisten Feinde,Vous devenez ami avec la plupart des ennemis,Diventi amico della maggior parte dei nemici,Stajesz się przyjacielem większości wrogów,你成了大多数敌人的朋友,ほとんどの敵があなたと仲良しになった。,당신은 대부분의 적의 친구가 됩니다.,,
madness_status_name,Madness,Безумие,Loucura,Locura,Wahnsinn,Folie,Follia,Obłęd,疯狂,狂気,광기,,
madness_status_desc,You are being pulled into madness!,Вы впадаете в безумие!,Você está sendo puxado para a loucura!,¡Estás siendo arrastrado a la locura!,Du wirst in den Wahnsinn gezogen!,Vous sombrez dans la folie!,Stai precipitando nella follia!,Zostajesz wciągnięty w obłęd!,你正在陷入疯狂！,狂気に冒されている！,당신은 광기에 빠지고 있습니다！,,
slow_levitation_status_name,Slower Levitation,Замедленное парение,Levitando mais devagar,Levitación más lenta,Langsames Schweben,Lévitation plus lente,Levitazione rallentata,Wolniejsze lewitowanie,减缓的漂浮,浮遊速度ダウン,느린 부유,,
slow_levitation_status_desc,Your levitation slows by half,Ваше левитирование замедляется вдвое,Sua levitação diminui pela metade,Tu levitación se reduce a la mitad,Deine Levitation verlangsamt sich um die Hälfte,Votre lévitation ralentit de moitié,La tua levitazione si rallenta della metà,Twoje lewitowanie spowalnia o połowę,你的漂浮速度减慢了一半,空中浮遊の上昇速度が半分になった。,당신의 부유가 절반으로 느려집니다！,,
stone_entity_status_name,Petrified,Окаменелость,Petrificado,Petrificado,Versteinert,Pétrifié,Pietrificato,Skamieniały,石化,石化,석화,,
stone_entity_status_desc,You have an exterior of stone,Ваша внешность покрыта камнем,Você tem um exterior de pedra,Tienes un exterior de piedra,Du hast eine steinerne Hülle,Vous avez un extérieur en pierre,La tua superficie è di pietra,Twoje ciało pokrywa kamień,你的外表被石头覆盖,全身が石に変えられてしまった。,돌처럼 외관이 바뀌었습니다,,
mana_eater_status_name,Mana Deficiency,Недостаток маны,Deficiência de Mana,Deficiencia de Maná,Mana-Mangel,Déficit de mana,Deficienza di Mana,Niedobór Many,法力不足,マナ不足,마나 부족,,
mana_eater_status_desc,Your mana is being devoured,Ваша мана поглощается,Sua mana está sendo devorada,Tu maná está siendo devorado,Deine Mana wird verschlungen,Votre mana est dévorée,La tua mana viene consumata,Twoja mana jest pochłaniana,你的法力正在被吞噬,マナが失われていく！,마나가 소멸되고 있습니다,,
no_protection_status_name,Protection Disabler,Отключение защиты,Desativador de Proteção,Inhibidor de Protección,Schutzdeaktivierung,Désactivation de protection,Disattivazione Protezione,Wyłączanie Ochrony,抵抗无效化,耐性無効化,보호 비활성화,,
no_protection_status_desc,Your Protection has no effect,Ваша защита не действует,Sua proteção não tem efeito,Tu protección no tiene efecto,Dein Schutz hat keine Wirkung,Votre protection est inefficace,La tua protezione non ha effetto,Twoja ochrona nie działa,你的保护不起作用,耐性系のステータス効果が無効化される。,보호 효과가 없습니다,,
disgust_status_name,Disgust,Отвращение,Nojo,Asco,Ekel,Dégoût,Disgusto,Wstręt,嫌恶感,嫌悪感,혐오감,,
disgust_status_desc,Something smells awful,Что-то ужасно воняет,Algo está com um cheiro horrível,Algo huele horrible,Etwas riecht schrecklich,Quelque chose sent horriblement mauvais,Qualcosa ha un odore terribile,Coś okropnie śmierdzi,有什么东西闻起来很糟糕,ひどい臭いがする。,끔찍한 냄새가 납니다,,
unseen_status_name,Unseen,Незаметный,Não Visto,Invisible,Unsichtbar,Invisible,Invisibile,Niewidzialny,隐形,不可視化,보이지 않는,,
unseen_status_desc,You're Gone!,Вы исчезли!,Você desapareceu!,¡Has desaparecido!,Du bist verschwunden!,Vous avez disparu!,Sei sparito!,Zniknąłeś!,你消失了！,あなたは消えました！,당신은 사라졌습니다！,,
hooks_status_name,Hooks,Крючки,Ganchos,Ganchos,Haken,Crochets,Ami,Haki,钩子,フックの呪い,갈고리,,
hooks_status_desc,All Your Projectiles Are Turned To Hooks!,Все ваши снаряды превращены в крючки!,Todos os seus projéteis viraram ganchos!,¡Todos tus proyectiles se han convertido en ganchos!,Alle deine Projektile werden zu Haken!,Tous vos projectiles se transforment en crochets!,Tutti i tuoi proiettili sono diventati ami!,Wszystkie twoje pociski zmieniły się w haki!,所有的射弹都变成了钩子！,杖からフックボルトが！,모든 발사체가 갈고리가 되었습니다！,,
telebolts_status_name,Telebolts,Телепортирующие стрелы,Telebolts,Proyectiles de Teletransporte,Teleportbolzen,Bolts de téléportation,Telebolts,Pociski Teleportujące,传送箭,テレポートボルトの呪い,텔레포트 볼트,,
telebolts_status_desc,All Your Projectiles Are Turned To Teleport bolts!,Все ваши снаряды превращены в телепортирующие стрелы!,Todos os seus projéteis viraram bolts de teletransporte!,¡Todos tus proyectiles se han convertido en proyectiles de teletransporte!,Alle deine Projektile werden zu Teleportbolzen!,Tous vos projectiles deviennent des bolts de téléportation!,Tutti i tuoi proiettili sono diventati Telebolts!,Wszystkie twoje pociski zamieniły się w teleportujące!,所有射弹都变成了传送箭！,杖からテレポートボルトが！,모든 발사체가 텔레포트 볼트로 변했습니다！,,
longdistancetelebolts_status_name,Long Distance Telebolts,Дальнобойные телепортирующие стрелы,Telebolts de Longa Distância,Proyectiles de Teletransporte de Largo Alcance,Teleportbolzen mit großer Reichweite,Bolts de téléportation longue distance,Telebolts a lunga distanza,Długodystansowe Pociski Teleportujące,远程传送箭,長距離テレポートボルトの呪い,장거리 텔레포트 볼트,,
longdistancetelebolts_status_desc,All Your Projectiles Are Turned To Long Distance Teleport bolts!,Все ваши снаряды превращены в дальнобойные телепортирующие стрелы!,Todos os seus projéteis viraram bolts de teletransporte de longa distância!,¡Todos tus proyectiles se han convertido en proyectiles de teletransporte de largo alcance!,Alle deine Projektile werden zu Teleportbolzen mit großer Reichweite!,Tous vos projectiles deviennent des bolts de téléportation longue distance!,Tutti i tuoi proiettili sono diventati Telebolts a lunga distanza!,Wszystkie twoje pociski zamieniły się w teleportujące dalekiego zasięgu!,所有射弹都变成了远程传送箭！,杖からテレポートボルトが！,모든 발사체가 장거리 텔레포트 볼트로 변했습니다！,,
bloodmist_status_name,Blood Mists,Кровавый туман,Névoa de Sangue,Niebla Sangrienta,Blutnebel,Brouillard de Sangue,Nebbia di Sangue,Krwawa Mgła,血雾,血のミストの呪い,피의 안개,,
bloodmist_status_desc,All Your Projectiles Are Turned To Blood Mists!,Все ваши снаряды превращены в кровавый туман!,Todos os seus projéteis viraram Névoas de Sangue!,¡Todos tus proyectiles se han convertido en niebla sangrienta!,Alle deine Projektile werden zu Blutnebel!,Tous vos projectiles deviennent des brouillards de sang!,Tutti i tuoi proiettili sono diventati Nebbie di Sangue!,Wszystkie twoje pociski zamieniły się w krwawą mgłę!,所有射弹都变成了血雾！,杖から血のミストが！,모든 발사체가 피의 안개로 변했습니다！,,
swapperbolts_status_name,Swapper Bolts,Меняющиеся стрелы,Setas de Troca,Proyectiles Intercambiadores,Wechselbolzen,Boulons d'échange,Bolts di Scambio,Pociski Zamienne,替换箭,スワッパーボルトの呪い,교체 볼트,,
swapperbolts_status_desc,All Your Projectiles Are Turned To Swapper Bolts!,Все ваши снаряды превращены в меняющиеся стрелы!,Todos os seus projéteis viraram Setas de Troca!,¡Todos tus proyectiles se han convertido en proyectiles intercambiadores!,Alle deine Projektile werden zu Wechselbolzen!,Tous vos projectiles deviennent des boulons d'échange!,Tutti i tuoi proiettili sono diventati Bolts di Scambio!,Wszystkie twoje pociski zamieniły się w pociski zamienne!,所有射弹都变成了替换箭！,杖からスワッパーボルトが！,모든 발사체가 교체 볼트로 변했습니다！,,
radioactive_dose_status_name,Radiation Sickness,Лучевая болезнь,Doença por Radiação,Enfermedad por Radiación,Strahlenkrankheit,Maladie des Radiations,Malattia da Radiazione,Choroba Popromienna,放射病,放射線病,방사선병,,
radioactive_dose_status_desc,Suffering from excess radiation.,Вы страдаете от избытка радиации.,Sofrendo de radiação excessiva.,Sufriendo de radiación excesiva.,Du leidest an übermäßiger Strahlung.,Vous souffrez d'une exposition excessive aux radiations.,Soffri di radiazioni eccessive.,Cierpisz na nadmiar promieniowania.,你正遭受过量的辐射。,過剰な放射線を浴びている。,과도한 방사선에 노출되었습니다.,,
radioactive_dose_status2_name,Radiation Sickness (Grade 2),Лучевая болезнь (2-й степень),Doença por Radiação (Grau 2),Enfermedad por Radiación (Grado 2),Strahlenkrankheit (Grad 2),Maladie des Radiations (Grade 2),Malattia da Radiazione (Grado 2),Choroba Popromienna (Stopień 2),放射病（2级）,放射線病（2級）,방사선병 (2단계),,
radioactive_dose_status2_desc,Intoxicated from excess radiation.,Вы отравлены избытком радиации.,Intoxicado por radiação excessiva.,Intoxicado por radiación excesiva.,Vergiftet durch übermäßige Strahlung.,Intoxiqué par un excès de radiations.,Intossicato da radiazioni eccessive.,Zatruty nadmiarem promieniowania.,因过量辐射而中毒。,過剰な放射線を浴びていることによる中毒。,과도한 방사선으로 인한 중독.,,
radioactive_dose_status3_name,Radiation Sickness (Grade 3),Лучевая болезнь (3-й степень),Doença por Radiação (Grau 3),Enfermedad por Radiación (Grado 3),Strahlenkrankheit (Grad 3),Maladie des Radiations (Grade 3),Malattia da Radiazione (Grado 3),Choroba Popromienna (Stopień 3),放射病（3级）,放射線病（3級）,방사선병 (3단계),,
radioactive_dose_status3_desc,Internal bleeding from excess radiation.,Внутреннее кровотечение из-за избытка радиации.,Hemorragia interna por radiação excessiva.,Hemorragia interna por radiación excesiva.,Innere Blutungen durch übermäßige Strahlung.,Hémorragie interne due à un excès de radiations.,Emorragia interna dovuta a radiazioni eccessive.,Krwotok wewnętrzny z powodu nadmiaru promieniowania.,因过量辐射引起内出血。,過剰な放射線を浴びていることによる内出血。,과도한 방사선으로 인한 내출혈.,,
radioactive_dose_status4_name,Radiation Sickness (Grade 4),Лучевая болезнь (4-й степень),Doença de Radiação (Grau 4),Enfermedad por Radiación (Grado 4),Strahlenkrankheit (Stufe 4),Maladie des Radiations (Niveau 4),Malattia da Radiazioni (Livello 4),Choroba Popromienna (Stopień 4),放射病（第4级）,放射線病（グレード4）,방사선 병 (4단계),,
radioactive_dose_status4_desc,Confusion from excess radiation.,Спутанность сознания из-за избытка радиации.,Confusão devido à radiação excessiva.,Confusión por radiación excesiva.,Verwirrung durch übermäßige Strahlung.,Confusion due à une irradiation excessive.,Confusione da radiazione eccessiva.,Zamieszanie spowodowane nadmiernym promieniowaniem.,过量辐射引起的混乱,過剰な放射線を浴びていることによる混乱,과도한 방사선으로 인한 혼란,,
radioactive_dose_status5_name,Radiation Sickness (Grade 5),Лучевая болезнь (5-й степень),Doença de Radiação (Grau 5),Enfermedad por Radiación (Grado 5),Strahlenkrankheit (Stufe 5),Maladie des Radiations (Niveau 5),Malattia da Radiazioni (Livello 5),Choroba Popromienna (Stopień 5),放射病（第5级）,放射線病（グレード5）,방사선 병 (5단계),,
radioactive_dose_status5_desc,Lethal inflammation from excess radiation.,Смертельное воспаление из-за избытка радиации.,Inflamação letal devido à radiação excessiva.,Inflamación letal por radiación excesiva.,Tödliche Entzündung durch übermäßige Strahlung.,Inflammation mortelle due à une irradiation excessive.,Infiammazione letale da radiazione eccessiva.,Śmiertelne zapalenie spowodowane nadmiernym promieniowaniem.,过量辐射导致致命炎症,過剰な放射線を浴びていることによる致命的な炎症,과도한 방사선으로 인한 치명적인 염증,,
new_enemies_toxic_growth,toxic growth,Токсичный рост,Crescimento Tóxico,Crecimiento Tóxico,Toxisches Wachstum,Croissance Toxique,Crescita Tossica,Toksyczny Wzrost,有毒增长,毒の成長,독성 성장,,
new_enemies_liquid_nitrogen,liquid nitrogen,Жидкий азот,Nitrogênio Líquido,Nitrógeno Líquido,Flüssiger Stickstoff,Azote Liquide,Azoto Liquido,Ciekły Azot,液氮,液体窒素,액체 질소,,
new_enemies_acid_weak,weak acid,Слабая кислота,Ácido Fraco,Ácido Débil,Schwache Säure,Acide Faible,Acido Debole,Słaby Kwas,弱酸,弱い酸,약한 산,,
new_enemies_midas_toxic,toxic draught of midas,Токсичное зелье Мидаса,Elixir Tóxico de Midas,Brebaje Tóxico de Midas,Toxischer Midas-Trank,Breuvage Toxique de Midas,Elisir Tossico di Mida,Toksyczny Napój Midasa,有毒的迈达斯药剂,毒のミダス薬,독성 미다스 물약,,
new_enemies_pollen,pollen,Пыльца,Pólen,Polen,Pollen,Pollen,Polline,Pyłek,花粉,花粉,꽃가루,,
new_enemies_sentient_gas,sentient gas,Одухотворённый газ,Gás Sensível,Gas Sensible,Bewusstes Gas,Gaz Conscient,Gas Sensibile,Gaz Świadomy,有灵气体,意識を持つガス,지각 있는 가스,,
new_enemies_meat_lava,magma meat,Мясо из лавы,Carne de Magma,Carne de Magma,Magma-Fleisch,Viande de Magma,Carne di Magma,Mięso Magmy,熔岩肉,溶岩の肉,용암 고기,,
new_enemies_radioactive_goo,toxic goo,Радиоактивная жижа,Gosma Tóxica,Moco Tóxico,Toxischer Schleim,Goo Toxique,Melma Tossica,Toksyczny Śluz,有毒粘液,有毒な粘液,독성 점액,,
new_enemies_tar,tar,Дёготь,Piche,Alcatrão,Teer,Goudron,Catrame,Smoła,焦油,タール,타르,,
ne_gui_new_enemies_in,New Enemies In,Новые враги в,Novos inimigos em,Nuevos enemigos en,Neue Feinde in,Nouveaux ennemis dans,Nuovi nemici in,Nowi wrogowie w,新的敌人,新しい敵,새로운 적들,,
ne_gui_desc,Toggle Enemies On and Off. You need to restart the game to see effects,Включить/выключить врагов. Требуется перезапуск игры для применения изменений.,Alternar inimigos ativados e desativados. Você precisa reiniciar o jogo para ver os efeitos,Alternar enemigos encendidos y apagados. Debes reiniciar el juego para ver los efectos,Feinde ein- und ausschalten. Sie müssen das Spiel neu starten um die Effekte zu sehen,Activer ou désactiver les ennemis. Vous devez redémarrer le jeu pour voir les effets,Attiva o disattiva i nemici. È necessario riavviare il gioco per vedere gli effetti,Przełącz wrogów. Aby zobaczyć efekty musisz zrestartować grę,切换敌人开关。 您需要重新启动游戏以查看效果。,敵の出現の有無を切り替えます。設定はゲームを再起動すると適用されます,적을 켜고 끕니다. 효과를 보려면 게임을 다시 시작해야 합니다.,,
ne_gui_enable_all,Enable all,Включить всех,Ativar todos,Habilitar todos,Alle aktivieren,Activer tout,Attiva tutto,Włącz wszystko,启用所有,すべてを有効にする,모두 활성화,,
ne_gui_all,All,Все,Tudo,Todos,Alle,Tout,Tutti,Wszystko,所有,すべて,모두,,
ne_gui_disable_all,Disable all,Отключить всех,Desativar todos,Desactivar todos,Alle deaktivieren,Désactiver tout,Disattiva tutto,Wyłącz wszystko,禁用所有,すべてを無効にする,모두 비활성화,,
ne_gui_sort_by,Sort By:,Сортировать по:,Classificar por:,Ordenar por:,Sortieren nach:,Trier par:,Ordina per:,Sortuj według:,排序依据:,並べ替え:,정렬 기준:,,
ne_gui_descending,Alphabet Descending,По убыванию алфавита,Alfabeto decrescente,Alfabético descendente,Alphabetisch absteigend,Alphabétique décroissant,Alfabeto discendente,Alfabetycznie malejąco,字母降序,アルファベット降順,알파벳 내림차순,,
ne_gui_ascending,Alphabet Ascending,По возрастанию алфавита,Alfabeto crescente,Alfabético ascendente,Alphabetisch aufsteigend,Alphabétique croissant,Alfabeto ascendente,Alfabetycznie rosnąco,字母升序,アルファベット昇順,알파벳 오름차순,,
ne_gui_sky,Sky,Небо,Céu,Cielo,Himmel,Ciel,Cielo,Niebo,天空,空,하늘,,
ne_gui_bosses,Bosses,Боссы,Chefes,Jefes,Bosse,Chefs,Boss,Bossowie,首领,ボス,보스,,
ne_gui_mini_bosses,Mini Bosses,Мини-боссы,Chefes menores,Mini jefes,Mini-Bosse,Mini-chefs,Mini boss,Mini bossowie,小型首领,ミニボス,미니 보스,,
ne_gui_orb_bosses,Orb Bosses,Боссы орбов,Chefes dos orbes,Jefes de orbes,Orb Bosse,Chefs d'orbes,Boss degli orbi,Bossowie kul,球体首领,オーブのボス,구체 보스,,
ne_gui_secret_bosses,Secret Bosses,Секретные боссы,Chefes secretos,Jefes secretos,Geheime Bosse,Chefs secrets,Boss segreti,Tajemniczy bossowie,秘密首领,隠しボス,비밀 보스,,
ne_gui_special,Special,Особенный,Especial,Especial,Spezial,Spécial,Speciale,Specjalny,特殊,特別,특별한,,
ne_gui_essence_rooms,Essence Room Bosses,Боссы комнат эссенции,Chefes das salas de essência,Jefes de la sala de esencia,Essenzraum Bosse,Chefs des salles d'essence,Boss delle stanze dell'essenza,Bossowie sal esencji,精华室首领,エッセンスルームのボス,정수 방 보스,,
swallowed_status_name,Swallowed,Поглощение,Engolido,Tragado,Verschluckt,Avalé,Inghiottito,Połknięty,飲み込まれた,飲み込まれる,삼켜짐,,
swallowed_status_desc,You're being digested!,Вас переваривают!,Você está sendo digerido!,¡Estás siendo digerido!,Du wirst verdaut!,Vous êtes en train d’être digéré!,Sei digerito!,Jesteś trawiony!,あなたは消化されています！,あなたは消化されている！,당신은 소화되고 있습니다,,
wishing_eye,Wishing Eye,Око желаний,Olho dos Desejos,Ojo de los Deseos,Wunschauge,Œil des souhaits,Occhio dei desideri,Oko życzeń,ウィッシング・アイ,ウィッシングアイ,소원의 눈,,
wishing_eye_desc,Must substitute your own,Необходимо заменить на свой вариант,Deve substituir pelo seu próprio,Debes sustituirlo por el tuyo,Muss durch das eigene ersetzt werden,Doit être remplacé par le vôtre,Deve essere sostituito con il tuo,Należy zastąpić własnym,自分のものに置き換える必要があります,自分のものに置き換えてください,자신의 것으로 교체해야 합니다,,
carrot_nose,Carrot Nose,Морковный нос,Nariz de Cenoura,Nariz de Zanahoria,Karottennase,Nez de carotte,Naso di carota,Marchewkowy nos,キャロット・ノーズ,キャロットノーズ,당근 코,,
carrot_nose_desc,A healthy meal,Полезная еда,Uma refeição saudável,Una comida saludable,Eine gesunde Mahlzeit,Un repas sain,Un pasto sano,Zdrowy posiłek,健康的な食事,ヘルシーな食事,건강한 식사,,
]])
--Progress translations:
local progress_language = ModSettingGet( "new_enemies.progress_language" )

if progress_language == "english" or not progress_language then

local content = ModTextFileGetContent("data/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. [[
acidmonster,Acid Lurker,,,,,,,,,,,,,
alchaos,Alchaos,,,,,,,,,,,,,
alien,Suuka,,,,,,,,,,,,,
alligator_temple,Large Alligator,,,,,,,,,,,,,
alligator_temple_small,Alligator,,,,,,,,,,,,,
angler,Angler Eel,,,,,,,,,,,,,
aquatitan,Aquatitan,,,,,,,,,,,,,
archer,Archer,,,,,,,,,,,,,
axeman,Axeman,,,,,,,,,,,,,
bigfly,Giant Wasp,,,,,,,,,,,,,
bird,Phoenix,,,,,,,,,,,,,
blob_giant,Blob Infestant,,,,,,,,,,,,,
blood_teddy,Caddel,,,,,,,,,,,,,
bloodmage_greater,Greater Blood Mage,,,,,,,,,,,,,
bloodmage_lesser,Lesser Blood Mage,,,,,,,,,,,,,
bloodmonster,Blood Demon,,,,,,,,,,,,,
bloodskull,Blood Skull,,,,,,,,,,,,,
bloom_ceiling,Ceiling Bloom,,,,,,,,,,,,,
bluemancer,Bluemancer,,,,,,,,,,,,,
book,Bewitched Tome,,,,,,,,,,,,,
boss_rock_spirit,Rock Spirit Boss,,,,,,,,,,,,,
bot,Laser Mech,,,,,,,,,,,,,
bouncer,Bounce Bot,,,,,,,,,,,,,
camel,Camel,,,,,,,,,,,,,
cargobot,Cargo Bot,,,,,,,,,,,,,
ceilingflower,Ceiling Slush Flower,,,,,,,,,,,,,
cerebracle,Cerebracle,,,,,,,,,,,,,
chaoticpolyshooter,Chaotic Poly Shooter,,,,,,,,,,,,,
chest_great_mimic,Great Chest Mimic,,,,,,,,,,,,,
cobra,Cobra,,,,,,,,,,,,,
commander,Commander,,,,,,,,,,,,,
conduit,Conduit,,,,,,,,,,,,,
copter,Hiisi Copter,,,,,,,,,,,,,
corrupt_alchemist,Corrupted Alchemist,,,,,,,,,,,,,
crawler,Crawler,,,,,,,,,,,,,
creeper,Creeper,,,,,,,,,,,,,
cryogen,Cryogen,,,,,,,,,,,,,
cyborg,Cyborg,,,,,,,,,,,,,
darkghost2,Dark Gazer,,,,,,,,,,,,,
desert_skull,Desert Skull,,,,,,,,,,,,,
desulitor,Desulitor,,,,,,,,,,,,,
desulitor_fly,Combustive Flies,,,,,,,,,,,,,
draghoul,Hell Moth,,,,,,,,,,,,,
dragon_ice,Dragutt Kiesah,,,,,,,,,,,,,
drake_snake,Draken,,,,,,,,,,,,,
driller,Driller,,,,,,,,,,,,,
dripper,Dripper,,,,,,,,,,,,,
drone_beam,Beam Drone,,,,,,,,,,,,,
drone_face2,Inferno Drone,,,,,,,,,,,,,
drone_trail,Static Drone,,,,,,,,,,,,,
drone2,Swarmer Drone,,,,,,,,,,,,,
earthmage,Earth Mage,,,,,,,,,,,,,
earthskull,Earth Skull,,,,,,,,,,,,,
eldari_big,Giant Eldari,,,,,,,,,,,,,
electricskull,Electric Skull,,,,,,,,,,,,,
electrobot,Electro Bot,,,,,,,,,,,,,
enigma,Enigma,,,,,,,,,,,,,
ent,Ent,,,,,,,,,,,,,
eradicator,Eradicator Droid,,,,,,,,,,,,,
eye,Eyeling's Eye,,,,,,,,,,,,,
eye_bat,Eye Bat,,,,,,,,,,,,,
eye_monster,Cyclops Bat,,,,,,,,,,,,,
eyeling,Eyeling,,,,,,,,,,,,,
face_worm,Orro Worm,,,,,,,,,,,,,
fallen_alchemist,Fallen Alchemist,,,,,,,,,,,,,
fire_crawler,Lava Crawler,,,,,,,,,,,,,
fireflower,Dragon's Breath Flower,,,,,,,,,,,,,
firemage_big,Giant Fire Mage,,,,,,,,,,,,,
wall_of_flesh,Wall Of Flesh,,,,,,,,,,,,,
flesh_monster,Flesh Monster,,,,,,,,,,,,,
flutterpede,Flutterpede,,,,,,,,,,,,,
forgotten_alchemist,Forgotten Alchemist,,,,,,,,,,,,,
frog_bot,Frog Bot,,,,,,,,,,,,,
frog_tiny,Bunny,,,,,,,,,,,,,
fungus_spore,Spore Fungus,,,,,,,,,,,,,
fungus_swamp2,Rotting Fungus,,,,,,,,,,,,,
fury,Fury,,,,,,,,,,,,,
gazer_laser,Laser Gazer,,,,,,,,,,,,,
gazer_necromancer,Necromancer Gazer,,,,,,,,,,,,,
ghostling,Ghostling,,,,,,,,,,,,,
ghust,Ghust,,,,,,,,,,,,,
ghuu,Ghuu,,,,,,,,,,,,,
giant_alt,Giant Summoner,,,,,,,,,,,,,
giant_energy,Energy Orb Giant,,,,,,,,,,,,,
giant_old,Ancient Giant,,,,,,,,,,,,,
giant_squid,Giant Squid,,,,,,,,,,,,,
giantfirebug,Massive Firefly,,,,,,,,,,,,,
gigashooter,Giga Shooter,,,,,,,,,,,,,
god,God,,,,,,,,,,,,,
golem,Stone Golem,,,,,,,,,,,,,
gonha,Gonha,,,,,,,,,,,,,
goomonster,Oozer,,,,,,,,,,,,,
goomonster_giant,Large Oozer,,,,,,,,,,,,,
goomonster_giant_alt,One Hole Oozer,,,,,,,,,,,,,
ground_terror,Ground Terror,,,,,,,,,,,,,
hairling,Hairling,,,,,,,,,,,,,
harpy,Harpy,,,,,,,,,,,,,
hazmat,Hazmat,,,,,,,,,,,,,
head_statue_physics,Frozen Soul,,,,,,,,,,,,,
hell_overseer,Infernal Colossus,,,,,,,,,,,,,
hurpa,Hurpa,,,,,,,,,,,,,
hybrid,Hybrid,,,,,,,,,,,,,
hydra,Hydra,,,,,,,,,,,,,
icemage_big2,Giant Ice Mage,,,,,,,,,,,,,
icemage2,Ice Mage,,,,,,,,,,,,,
icicle,Icicle,,,,,,,,,,,,,
icicle_king,Icicle Master,,,,,,,,,,,,,
igu,Igu,,,,,,,,,,,,,
imp,Imp,,,,,,,,,,,,,
invisiman,Invisiman,,,,,,,,,,,,,
irtokki,Irtokki,,,,,,,,,,,,,
jellyfish,Jellyfish,,,,,,,,,,,,,
jungle_worm,Mutant Worm,,,,,,,,,,,,,
junkbot,Junk Bot,,,,,,,,,,,,,
khulu,Khulu,,,,,,,,,,,,,
knight,Knight,,,,,,,,,,,,,
lake_statue,Lake Statue,,,,,,,,,,,,,
landflower,Slush Flower,,,,,,,,,,,,,
laserbot,Death Laser Bot,,,,,,,,,,,,,
lava_monster,Lava Guardian,,,,,,,,,,,,,
lavashooter,Lava Tentacler,,,,,,,,,,,,,
lempo,Lempo,,,,,,,,,,,,,
lightling,Lightling,,,,,,,,,,,,,
llama,Llama,,,,,,,,,,,,,
locust,Locust,,,,,,,,,,,,,
long_ghost,Long Ghost,,,,,,,,,,,,,
longleg_big,Large Spidey,,,,,,,,,,,,,
lost_soul,Lost Soul,,,,,,,,,,,,,
lost_soul_big,Giant Lost Soul,,,,,,,,,,,,,
lukki_blue,Eerie Lukki,,,,,,,,,,,,,
lukki_ominous,Ominous Lukki,,,,,,,,,,,,,
lukki_red,Lava Lukki,,,,,,,,,,,,,
lukki_swamp2,Rotting Lukki,,,,,,,,,,,,,
lukki_weird,Putrid Lukki,,,,,,,,,,,,,
lukki_white,Darkness Lukki,,,,,,,,,,,,,
lurker2,Lurker,,,,,,,,,,,,,
mammoth,Mammoth,,,,,,,,,,,,,
mammoth_baby,Baby Mammoth,,,,,,,,,,,,,
manus,Manus,,,,,,,,,,,,,
medusa,Medusa,,,,,,,,,,,,,
menace,Menace,,,,,,,,,,,,,
menhir,Hell Menhir,,,,,,,,,,,,,
miner_alcohol,Boozer,,,,,,,,,,,,,
miner_boss,TNT Boss,,,,,,,,,,,,,
mirror_physics,Vollux,,,,,,,,,,,,,
moal,Moal,,,,,,,,,,,,,
monkey,Monkey,,,,,,,,,,,,,
mother_nature,Gaia,,,,,,,,,,,,,
mutant_blob,Mutant Blob,,,,,,,,,,,,,
mutant_blob_ceiling,Ceiling Mutant Blob,,,,,,,,,,,,,
mutant2,Gut Mutant,,,,,,,,,,,,,
mwyah,Mwyah,,,,,,,,,,,,,
mwyah_phase1,Mwyah,,,,,,,,,,,,,
mwyah_phase2,Ascended Mwyah,,,,,,,,,,,,,
naga,Naga,,,,,,,,,,,,,
nautilus,Nautilus,,,,,,,,,,,,,
necromancer_omega,Omegamancer,,,,,,,,,,,,,
nightmare,Nightmare,,,,,,,,,,,,,
nova,Nova,,,,,,,,,,,,,
ooion,Ooion,,,,,,,,,,,,,
peasant,Peasant,,,,,,,,,,,,,
phan,Phan,,,,,,,,,,,,,
phantom_boss,Restless Phantom,,,,,,,,,,,,,
phantom_trapper,Trapper Phantom,,,,,,,,,,,,,
great_green_fish,Piranha,,,,,,,,,,,,,
player_ai_nemesis,Nemesis,,,,,,,,,,,,,
player_ai_clone,Clone,,,,,,,,,,,,,
player_ai_decoy,Ancient Scholar,,,,,,,,,,,,,
polyp_gas,Gasnacle,,,,,,,,,,,,,
polyshooter,Polymorphine Shooter,,,,,,,,,,,,,
potionmaster2,Potion Master,,,,,,,,,,,,,
quin,Quin,,,,,,,,,,,,,
radiobot,Radioactive Drone,,,,,,,,,,,,,
robot,Bazooka Mech,,,,,,,,,,,,,
sawbot,Saw Bot,,,,,,,,,,,,,
scavenger_alcohol,Alcohol Hiisi,,,,,,,,,,,,,
scavenger_civilian,Hiisi Civilian,,,,,,,,,,,,,
scavenger_compressor,Compressor Hiisi,,,,,,,,,,,,,
scavenger_compressor_robot,Robot Compressor,,,,,,,,,,,,,
scavenger_electrocuter2,Electrocuter Hiisi,,,,,,,,,,,,,
scavenger_gas,Gas Grenader Hiisi,,,,,,,,,,,,,
scavenger_gas_robot,Robot Gas Grenader,,,,,,,,,,,,,
scavenger_king,Hiisi King,,,,,,,,,,,,,
scavenger_king_robot,Robot Hiisi King,,,,,,,,,,,,,
scavenger_laser,Laser Hiisi,,,,,,,,,,,,,
scavenger_monster,Parasite,,,,,,,,,,,,,
scavenger_oiler,Oil Grenade Hiisi,,,,,,,,,,,,,
scavenger_plasma,Plasma Hiisi,,,,,,,,,,,,,
scavenger_poison_immunity,Poison Medic Hiisi,,,,,,,,,,,,,
scavenger_radiolava,Radiolava Hiisi,,,,,,,,,,,,,
scavenger_robot,Rocketier,,,,,,,,,,,,,
scavenger_trigger,Trigger Hiisi,,,,,,,,,,,,,
scavenger_turbo,Turbo Hiisi,,,,,,,,,,,,,
scavenger_turbo_robot,Turbo Robot,,,,,,,,,,,,,
scavenger_undercover,Suspicious Hiisi,,,,,,,,,,,,,
seamonster,Sea Monster,,,,,,,,,,,,,
serpentor,Serpentor,,,,,,,,,,,,,
shapeshifter,Shape Shifter,,,,,,,,,,,,,
shark,Shark,,,,,,,,,,,,,
shiva,Shiva,,,,,,,,,,,,,
singularitor,Singularitor,,,,,,,,,,,,,
skeleboss,Skeleton Boss,,,,,,,,,,,,,
skeleton,Skeleton,,,,,,,,,,,,,
skull_abomination,Skull Abomination,,,,,,,,,,,,,
skullmage,Skull Mage,,,,,,,,,,,,,
skullspider,Skull Spider,,,,,,,,,,,,,
skymonster,Sky Monster,,,,,,,,,,,,,
slime_ghoul,Sleaze Ghoul,,,,,,,,,,,,,
slime_roller,Tumbler Sleaze Baby,,,,,,,,,,,,,
slime_turret,Sleaze Pod,,,,,,,,,,,,,
slimeshooter_golden,Midas Sleaze Bag,,,,,,,,,,,,,
slimeshooter_mega,Mother Sleaze Bag,,,,,,,,,,,,,
smoke_bot,Smoke Machine,,,,,,,,,,,,,
sneeker,Sneaker,,,,,,,,,,,,,
snowman,Snowman,,,,,,,,,,,,,
sochaos,Sochaos,,,,,,,,,,,,,
sorceress,Sorceress,,,,,,,,,,,,,
spider,Ancient Spider,,,,,,,,,,,,,
spooky_ghost,Spooky Ghost,,,,,,,,,,,,,
sporeling,Medium Sporeling,,,,,,,,,,,,,
sporeling_large,Large Sporeling,,,,,,,,,,,,,
sporeling_tiny,Tiny Sporeling,,,,,,,,,,,,,
stalker,Stalker,,,,,,,,,,,,,
stalker_ceiling,Ceiling Stalker,,,,,,,,,,,,,
stingray,Stingray,,,,,,,,,,,,,
stone_crab,Stone Crab,,,,,,,,,,,,,
stone_physics,Acid Touch Stone,,,,,,,,,,,,,
summoner,Summoner,,,,,,,,,,,,,
tank_boss,Tank Boss,,,,,,,,,,,,,
tank_fire2,Flame Tank,,,,,,,,,,,,,
tank_propane,April Fools Tank,,,,,,,,,,,,,
tardigrade,Tardigrade,,,,,,,,,,,,,
terminator,Terminator,,,,,,,,,,,,,
thou,Thou,,,,,,,,,,,,,
toxicmage_acid2,Acid Mage,,,,,,,,,,,,,
toxicmage2,Sludge Mage,,,,,,,,,,,,,
train,Underground Train,,,,,,,,,,,,,
twig,Nook,,,,,,,,,,,,,
valkyrie2,Valkyrie,,,,,,,,,,,,,
vine_monster,Vine Monster,,,,,,,,,,,,,
void_mask2,Void Skull,,,,,,,,,,,,,
wanderer,Abu,,,,,,,,,,,,,
wandmaster2,Wand Master,,,,,,,,,,,,,
watermonster,Water Spirit,,,,,,,,,,,,,
welder,Hiisi Welder,,,,,,,,,,,,,
whale,Whale,,,,,,,,,,,,,
windmill,Hiisi Airship,,,,,,,,,,,,,
wizard_earthquake,Earthquake Mage,,,,,,,,,,,,,
wizard_madness,Master Of Madness,,,,,,,,,,,,,
wizard_random,Master Of Multitudes,,,,,,,,,,,,,
wizard_time,Time Mage,,,,,,,,,,,,,
wizard_trip,Trip Mage,,,,,,,,,,,,,
wizard_twin,Master Of Cloning,,,,,,,,,,,,,
worm_eel,Electric Worm,,,,,,,,,,,,,
worm_fungal,Fungal Abomination,,,,,,,,,,,,,
worm_robot,Mecha Worm,,,,,,,,,,,,,
wraith_boss,Wraith Boss,,,,,,,,,,,,,
wraith_speed,Speed Wraith,,,,,,,,,,,,,
wraith_void2,Void Wraith,,,,,,,,,,,,,
zombie_giant,Giant Zombie,,,,,,,,,,,,,
zombie3,Zombie Ghoul,,,,,,,,,,,,,
beanpodupine,Podupine,,,,,,,,,,,,,
scarab,Scarab Beetle,,,,,,,,,,,,,
stork,Avian Overseer,,,,,,,,,,,,,
devourer,Morsa,,,,,,,,,,,,,
fish_angler2,Angler Fish,,,,,,,,,,,,,
zap_eel2,Electric Eel,,,,,,,,,,,,,
minabomination,Alchemist Abomination,,,,,,,,,,,,,
desert_mage,Eldirood,,,,,,,,,,,,,
camel_robot,I160,,,,,,,,,,,,,
doom_bringer,Doom Bringer,,,,,,,,,,,,,
magiconstruct,The Sanctuary,,,,,,,,,,,,,
magiconstruct_statue,Sanctuary Wing,,,,,,,,,,,,,
elephant,Vulcan,,,,,,,,,,,,,
yikka,Yikka,,,,,,,,,,,,,
yikka_host,Idol,,,,,,,,,,,,,
lukki_dark_huge,Sarlacc,,,,,,,,,,,,,
giant_boss,Rock Spirit Colossus,,,,,,,,,,,,,
god_warrior,God Warrior,,,,,,,,,,,,,
worm_skull_old,Ancient Skull Worm,,,,,,,,,,,,,
cthulhu,Abyssum,,,,,,,,,,,,,
wizard_tiny,Master Of Shrinking,,,,,,,,,,,,,
flopper_mother,Emesus,,,,,,,,,,,,,
xopon,Xopon,,,,,,,,,,,,,
oruai,Oruai Sphere,,,,,,,,,,,,,
jungle_flower,Grappling Bloom,,,,,,,,,,,,,
boid,Sparrow Bird,,,,,,,,,,,,,
sand_worm,Colossal Sand Worm,,,,,,,,,,,,,
kiwiki,Kiwiki,,,,,,,,,,,,,
shield_physics,Sentinel,,,,,,,,,,,,,
flopper_mother_giant,Giant Emesus,,,,,,,,,,,,,
flopper_mother_giant_progeny,Giant Emesus Progeny,,,,,,,,,,,,,
crawler_bug,Fire Bug,,,,,,,,,,,,,
platoon,Platoon,,,,,,,,,,,,,
scorpio,Scorpio,,,,,,,,,,,,,
mountain,The Mountain,,,,,,,,,,,,,
peeper,Ephemeris,,,,,,,,,,,,,
mantis,Mantis,,,,,,,,,,,,,
gold_face_physics,God's Finger,,,,,,,,,,,,,
chameleon,Chameleon,,,,,,,,,,,,,
bloodmage_enlightened,Ascended Blood Mage,,,,,,,,,,,,,
elephant_robot,Titan Tusk,,,,,,,,,,,,,
fireworkman,Fire Worker,,,,,,,,,,,,,
beehive,Beehive,,,,,,,,,,,,,
mountain_large,Geocolossus,,,,,,,,,,,,,
spider_crawler,Crawling Spider,,,,,,,,,,,,,
larva_crawler,Silk Worm,,,,,,,,,,,,,
plant_boss,Overgrowth,,,,,,,,,,,,,
drill_giant,Excavator Drill,,,,,,,,,,,,,
drill_giant_segment,Excavator Drill Segment,,,,,,,,,,,,,
mule,Mule,,,,,,,,,,,,,
ear_boss,Enchanted Corridor,,,,,,,,,,,,,
cyclops_slime,Aberrant Abomination,,,,,,,,,,,,,
boss_eel,Dutchman Eel,,,,,,,,,,,,,
boss_fungus,Fungal Colossus,,,,,,,,,,,,,
corpse_lily,Corpse Lily,,,,,,,,,,,,,
hell_door,Chaos Door,,,,,,,,,,,,,
mummy,Mummy,,,,,,,,,,,,,
worm_portal,Portal Worm,,,,,,,,,,,,,
mexxi,Mexxi,,,,,,,,,,,,,
hellion,Hellion,,,,,,,,,,,,,
hellion2,Obsidian Hellion,,,,,,,,,,,,,
mechahub,Desolate Core,,,,,,,,,,,,,
manticore,Manticore,,,,,,,,,,,,,
player_evil,Fiend,,,,,,,,,,,,,
player_evil_name,Fiend,,,,,,,,,,,,,
puffer,Pufferfish,,,,,,,,,,,,,
lukki_saw,Saw Spider,,,,,,,,,,,,,
jungle_deity,Jungle Deity,,,,,,,,,,,,,
tentacle_monster2,Tentaclon,,,,,,,,,,,,,
cancer2,Tumour,,,,,,,,,,,,,
head2,Metastasis,,,,,,,,,,,,,
ground_flesh2,Meat Snapper,,,,,,,,,,,,,
hand2,Meat Hand,,,,,,,,,,,,,
brain2,Brain,,,,,,,,,,,,,
fleshclops2,Fleshclops,,,,,,,,,,,,,
flesh_abomination2,Flesh Abomination,,,,,,,,,,,,,
water_worm2,Pus Parasite,,,,,,,,,,,,,
chainsawer,Chainsaw Hiisi,,,,,,,,,,,,,
chainsawer_hell,Hell Chainsaw Hiisi,,,,,,,,,,,,,
yoyoer_shaman,Yoyo Swampling,,,,,,,,,,,,,
yoyoer,Yoyoer,,,,,,,,,,,,,
ritualists,Ritualists,,,,,,,,,,,,,
huts,Huts,,,,,,,,,,,,,
slimer,Slimer,,,,,,,,,,,,,
technomancer,Technomancer,,,,,,,,,,,,,
necromancer_cultist,Cultist,,,,,,,,,,,,,
necromancer_cultist_clone,Cultist,,,,,,,,,,,,,
worm_saw,Saw Slink,,,,,,,,,,,,,
lemming,Lemming,,,,,,,,,,,,,
vulture,Vulture,,,,,,,,,,,,,
necromancer_ice,Frozen Fury,,,,,,,,,,,,,
]])

elseif progress_language == "finnish" then
local content = ModTextFileGetContent("data/translations/common.csv")
ModTextFileSetContent("data/translations/common.csv", content .. [[
acidmonster,Happo-otus,,,,,,,,,,,,,
alchaos,Muodonmuutosmöykky,,,,,,,,,,,,,
alien,Maagimuurahainen,,,,,,,,,,,,,
alligator_temple,Alligaattori,,,,,,,,,,,,,
alligator_temple_small,Pikkualligaattori,,,,,,,,,,,,,
angler,Lehtikala,,,,,,,,,,,,,
aquatitan,Vellamo,,,,,,,,,,,,,
archer,Jousipyssypoika,,,,,,,,,,,,,
axeman,Kirveshiisi,,,,,,,,,,,,,
bigfly,Suuramppari,,,,,,,,,,,,,
bird,Feeniks,,,,,,,,,,,,,
blob_giant,Suurmöykky,,,,,,,,,,,,,
blood_teddy,Pelle,,,,,,,,,,,,,
bloodmage_greater,Suurvihulainen,,,,,,,,,,,,,
bloodmage_lesser,Vihulainen,,,,,,,,,,,,,
bloodmonster,Veritähti,,,,,,,,,,,,,
bloodskull,Verikkö,,,,,,,,,,,,,
bloom_ceiling,Kattokukka,,,,,,,,,,,,,
bluemancer,Siniotus,,,,,,,,,,,,,
book,Lumottu hautakivi,,,,,,,,,,,,,
boss_rock_spirit,Sinilohkare,,,,,,,,,,,,,
bot,Laserrobotti,,,,,,,,,,,,,
bouncer,Hyppylennokki,,,,,,,,,,,,,
camel,Kameli,,,,,,,,,,,,,
cargobot,Tuhorobotti,,,,,,,,,,,,,
ceilingflower,Sinikattokukka,,,,,,,,,,,,,
cerebracle,Hylkiö,,,,,,,,,,,,,
chaoticpolyshooter,Muodonmuutosmustikka,,,,,,,,,,,,,
chest_great_mimic,Mahtimatkija,,,,,,,,,,,,,
cobra,Kärmes,,,,,,,,,,,,,
commander,Hiisikomentaja,,,,,,,,,,,,,
conduit,Sähköinsinööri,,,,,,,,,,,,,
copter,Hiisikopteri,,,,,,,,,,,,,
corrupt_alchemist,Repaleinen Alkemisti,,,,,,,,,,,,,
crawler,Ötökkä,,,,,,,,,,,,,
creeper,Yökötys,,,,,,,,,,,,,
cryogen,Kylmäkalle,,,,,,,,,,,,,
cyborg,Puolihiisi,,,,,,,,,,,,,
darkghost2,Tihrustaja,,,,,,,,,,,,,
desert_skull,Muinainen Kallo,,,,,,,,,,,,,
desulitor,Raapskärpäsparvi,,,,,,,,,,,,,
desulitor_fly,Raapskärpäset,,,,,,,,,,,,,
draghoul,Tuonelanyökkö,,,,,,,,,,,,,
dragon_ice,Jäälohikäärme,,,,,,,,,,,,,
drake_snake,Yönkorento,,,,,,,,,,,,,
driller,Pora,,,,,,,,,,,,,
dripper,Valuvainen,,,,,,,,,,,,,
drone_beam,Rak,,,,,,,,,,,,,
drone_face2,Infernohäivealus,,,,,,,,,,,,,
drone_trail,Suihkukone,,,,,,,,,,,,,
drone2,Drooni,,,,,,,,,,,,,
earthmage,Tapio,,,,,,,,,,,,,
earthskull,Viherhippunen,,,,,,,,,,,,,
eldari_big,Suureldari,,,,,,,,,,,,,
electricskull,Sähköjuttelija,,,,,,,,,,,,,
electrobot,Yhdistäjä,,,,,,,,,,,,,
enigma,Varoituksen Sana,,,,,,,,,,,,,
ent,Metsämahti,,,,,,,,,,,,,
eradicator,Tunteeton,,,,,,,,,,,,,
eye,Silmä,,,,,,,,,,,,,
eye_bat,Kolikkolepakko,,,,,,,,,,,,,
eye_monster,Räpyttelijä,,,,,,,,,,,,,
eyeling,Silmäjoukko,,,,,,,,,,,,,
face_worm,Ilmemato,,,,,,,,,,,,,
fallen_alchemist,Säihkysilmä,,,,,,,,,,,,,
fire_crawler,Tuliötökkä,,,,,,,,,,,,,
fireflower,Tulikukka,,,,,,,,,,,,,
firemage_big,Suurstendari,,,,,,,,,,,,,
wall_of_flesh,Lihamuuri,,,,,,,,,,,,,
flesh_monster,Lihis,,,,,,,,,,,,,
flutterpede,Sudenkorento,,,,,,,,,,,,,
forgotten_alchemist,Varjoalkemisti,,,,,,,,,,,,,
frog_bot,Metallisammakko,,,,,,,,,,,,,
frog_tiny,Pupu,,,,,,,,,,,,,
fungus_spore,Röyhtäilijä,,,,,,,,,,,,,
fungus_swamp2,Suokas,,,,,,,,,,,,,
fury,Erinys,,,,,,,,,,,,,
gazer_laser,Hohtokatse,,,,,,,,,,,,,
gazer_necromancer,Ruumiskatse,,,,,,,,,,,,,
ghostling,Kaapukallo,,,,,,,,,,,,,
ghust,Kammotus,,,,,,,,,,,,,
ghuu,Muikelo,,,,,,,,,,,,,
giant_alt,Lohkaremuhku,,,,,,,,,,,,,
giant_energy,Syöttäjä,,,,,,,,,,,,,
giant_old,Muhku,,,,,,,,,,,,,
giant_squid,Nahkiainen,,,,,,,,,,,,,
giantfirebug,Megatulikärpänen,,,,,,,,,,,,,
gigashooter,Katsoja,,,,,,,,,,,,,
god,Jumalukko,,,,,,,,,,,,,
golem,Kivigolem,,,,,,,,,,,,,
gonha,Demoninpala,,,,,,,,,,,,,
goomonster,Limaörvelö,,,,,,,,,,,,,
goomonster_giant,Suurlimaörvelö,,,,,,,,,,,,,
goomonster_giant_alt,Yksi Reikä limaörvelö,,,,,,,,,,,,,
ground_terror,Iso Haukku,,,,,,,,,,,,,
hairling,Hapsunuljaska,,,,,,,,,,,,,
harpy,Harpyija,,,,,,,,,,,,,
hazmat,Suojautunut,,,,,,,,,,,,,
head_statue_physics,Lapasten Tarpeessa,,,,,,,,,,,,,
hell_overseer,Mahtilaavarapu,,,,,,,,,,,,,
hurpa,Hurpa,,,,,,,,,,,,,
hybrid,Hämishiisi,,,,,,,,,,,,,
hydra,Monipäinen Käärme,,,,,,,,,,,,,
icemage_big2,Megapakkasukko,,,,,,,,,,,,,
icemage2,Jäätelömestari,,,,,,,,,,,,,
icicle,Jääpuikko,,,,,,,,,,,,,
icicle_king,Jääpuikkomestari,,,,,,,,,,,,,
igu,Kätyri,,,,,,,,,,,,,
imp,Piru,,,,,,,,,,,,,
invisiman,Lasimestari,,,,,,,,,,,,,
irtokki,Irtokki,,,,,,,,,,,,,
jellyfish,Meduusa,,,,,,,,,,,,,
jungle_worm,Lukkimato,,,,,,,,,,,,,
junkbot,Kyhäelmä,,,,,,,,,,,,,
khulu,Niveljalkainen,,,,,,,,,,,,,
knight,Ritari,,,,,,,,,,,,,
lake_statue,Huru-ukko,,,,,,,,,,,,,
landflower,Sinikukka,,,,,,,,,,,,,
laserbot,Kolmijalkalaser,,,,,,,,,,,,,
lava_monster,Laavasoturi,,,,,,,,,,,,,
lavashooter,Laavanuljaska,,,,,,,,,,,,,
lempo,Lempo,,,,,,,,,,,,,
lightling,Lennokas,,,,,,,,,,,,,
llama,Laama,,,,,,,,,,,,,
locust,Kulkusirkka,,,,,,,,,,,,,
long_ghost,Vetelehtijäaave,,,,,,,,,,,,,
longleg_big,Möhköhämis,,,,,,,,,,,,,
lost_soul,Pikkuastia,,,,,,,,,,,,,
lost_soul_big,Astia,,,,,,,,,,,,,
lukki_blue,Sinilukki,,,,,,,,,,,,,
lukki_ominous,Hammaslukki,,,,,,,,,,,,,
lukki_red,Laavalukki,,,,,,,,,,,,,
lukki_swamp2,Mätälukki,,,,,,,,,,,,,
lukki_weird,Jätelukki,,,,,,,,,,,,,
lukki_white,Valkolukki,,,,,,,,,,,,,
lurker2,Myrkkypilvi,,,,,,,,,,,,,
mammoth,Mammutti,,,,,,,,,,,,,
mammoth_baby,Mammutinpoikanen,,,,,,,,,,,,,
manus,Hyppynen,,,,,,,,,,,,,
medusa,Lonkeroinen,,,,,,,,,,,,,
menace,Ketku,,,,,,,,,,,,,
menhir,Purkaus,,,,,,,,,,,,,
miner_alcohol,Juomahiisi,,,,,,,,,,,,,
miner_boss,Ärtsyhiisi,,,,,,,,,,,,,
mirror_physics,Sekoittaja,,,,,,,,,,,,,
moal,Mököttäjä,,,,,,,,,,,,,
monkey,Apina,,,,,,,,,,,,,
mother_nature,Mielikki,,,,,,,,,,,,,
mutant_blob,Alkulima,,,,,,,,,,,,,
mutant_blob_ceiling,Kattoalkulima,,,,,,,,,,,,,
mutant2,Mutantti,,,,,,,,,,,,,
mwyah,Läpivalaistu,,,,,,,,,,,,,
mwyah_phase1,Läpivalaistu,,,,,,,,,,,,,
mwyah_phase2,Ylentynyt Läpivalaistu,,,,,,,,,,,,,
naga,Naga,,,,,,,,,,,,,
nautilus,Kotilonkero,,,,,,,,,,,,,
necromancer_omega,Hylätty Vartija,,,,,,,,,,,,,
nightmare,Lihaleijona,,,,,,,,,,,,,
nova,Nova,,,,,,,,,,,,,
ooion,Painoton,,,,,,,,,,,,,
peasant,Talonpoika,,,,,,,,,,,,,
phan,Kummituslepakko,,,,,,,,,,,,,
phantom_boss,Käsienlevittelijä,,,,,,,,,,,,,
phantom_trapper,Ansastaja,,,,,,,,,,,,,
great_green_fish,Piraija,,,,,,,,,,,,,
player_ai_nemesis,Nemesis,,,,,,,,,,,,,
player_ai_clone,Klooni,,,,,,,,,,,,,
player_ai_decoy,Muinainen Oppinut,,,,,,,,,,,,,
polyp_gas,Kaasusiimajalkainen,,,,,,,,,,,,,
polyshooter,Muodonmuutosmansikka,,,,,,,,,,,,,
potionmaster2,Cocktailmestari,,,,,,,,,,,,,
quin,Uiskentelija,,,,,,,,,,,,,
radiobot,Säteilykeskus,,,,,,,,,,,,,
robot,Koljatti,,,,,,,,,,,,,
sawbot,Saharobotti,,,,,,,,,,,,,
scavenger_alcohol,Illanviettäjähiisi,,,,,,,,,,,,,
scavenger_civilian,Pakokauhuhiisi,,,,,,,,,,,,,
scavenger_compressor,Puksutinhiisi,,,,,,,,,,,,,
scavenger_compressor_robot,Robottipuksutinhiisi,,,,,,,,,,,,,
scavenger_electrocuter2,Tuikkaajahiisi,,,,,,,,,,,,,
scavenger_gas,Posautushiisi,,,,,,,,,,,,,
scavenger_gas_robot,Kaasuhiisi,,,,,,,,,,,,,
scavenger_king,Kuningashiisi,,,,,,,,,,,,,
scavenger_king_robot,Robottikuningashiisi,,,,,,,,,,,,,
scavenger_laser,Laserhiisi,,,,,,,,,,,,,
scavenger_monster,Lonkeroviitta,,,,,,,,,,,,,
scavenger_oiler,Hirvihiisi,,,,,,,,,,,,,
scavenger_plasma,Plasmahiisi,,,,,,,,,,,,,
scavenger_poison_immunity,Lääkintähiisi,,,,,,,,,,,,,
scavenger_radiolava,Laavahiisi,,,,,,,,,,,,,
scavenger_robot,Rakettihiisi,,,,,,,,,,,,,
scavenger_trigger,Kypärähiisi,,,,,,,,,,,,,
scavenger_turbo,Turbohiisi,,,,,,,,,,,,,
scavenger_turbo_robot,Robottiturbohiisi,,,,,,,,,,,,,
scavenger_undercover,Salahiisi,,,,,,,,,,,,,
seamonster,Merihirviö,,,,,,,,,,,,,
serpentor,Kaksoiskärmes,,,,,,,,,,,,,
shapeshifter,Muodonmuuttaja,,,,,,,,,,,,,
shark,Hai,,,,,,,,,,,,,
shiva,Suursuu,,,,,,,,,,,,,
singularitor,Sinkauttaja,,,,,,,,,,,,,
skeleboss,Epäkuollut Luuranko,,,,,,,,,,,,,
skeleton,Luuranko,,,,,,,,,,,,,
skull_abomination,Kallokauhistus,,,,,,,,,,,,,
skullmage,Kallollinen,,,,,,,,,,,,,
skullspider,Suurkallohämis,,,,,,,,,,,,,
skymonster,Ilmojen Pitelijä,,,,,,,,,,,,,
slime_ghoul,Pikku-Cthulhu,,,,,,,,,,,,,
slime_roller,Pyörölima,,,,,,,,,,,,,
slime_turret,Ärtsylonkero,,,,,,,,,,,,,
slimeshooter_golden,Kultanuljaska,,,,,,,,,,,,,
slimeshooter_mega,Äitilima,,,,,,,,,,,,,
smoke_bot,Savukone,,,,,,,,,,,,,
sneeker,Veistos,,,,,,,,,,,,,
snowman,Pakastaja,,,,,,,,,,,,,
sochaos,Sauvojen Mestari,,,,,,,,,,,,,
sorceress,Velhotar,,,,,,,,,,,,,
spider,Seititär,,,,,,,,,,,,,
spooky_ghost,Kauhea Aave,,,,,,,,,,,,,
sporeling,Suurpore,,,,,,,,,,,,,
sporeling_large,Porepaukku,,,,,,,,,,,,,
sporeling_tiny,Pikkuporepaukku,,,,,,,,,,,,,
stalker,Tuijottelija,,,,,,,,,,,,,
stalker_ceiling,Kattotuijottelija,,,,,,,,,,,,,
stingray,Rausku,,,,,,,,,,,,,
stone_crab,Matkijarapu,,,,,,,,,,,,,
stone_physics,Happokivi,,,,,,,,,,,,,
summoner,Laumanjohtaja,,,,,,,,,,,,,
tank_boss,Luksustankki,,,,,,,,,,,,,
tank_fire2,Tulitankki,,,,,,,,,,,,,
tank_propane,Jäynätankki,,,,,,,,,,,,,
tardigrade,Karhukainen,,,,,,,,,,,,,
terminator,Terminaattori,,,,,,,,,,,,,
thou,Jojolohkare,,,,,,,,,,,,,
toxicmage_acid2,Happomestari,,,,,,,,,,,,,
toxicmage2,Myrkkymestari,,,,,,,,,,,,,
train,Juna,,,,,,,,,,,,,
twig,Monistusköynnös,,,,,,,,,,,,,
valkyrie2,Valkyria,,,,,,,,,,,,,
vine_monster,Köynnös,,,,,,,,,,,,,
void_mask2,Kirottu Kallo,,,,,,,,,,,,,
wanderer,Liehutin,,,,,,,,,,,,,
wandmaster2,Sauvojentekijä,,,,,,,,,,,,,
watermonster,Henkiolento,,,,,,,,,,,,,
welder,Hitsaajahiisi,,,,,,,,,,,,,
whale,Valas,,,,,,,,,,,,,
windmill,Laivue,,,,,,,,,,,,,
wizard_earthquake,Maamestari,,,,,,,,,,,,,
wizard_madness,Mahdottomuuksien Mestari,,,,,,,,,,,,,
wizard_random,Moninaismestari,,,,,,,,,,,,,
wizard_time,Aikamestari,,,,,,,,,,,,,
wizard_trip,Sienimestari,,,,,,,,,,,,,
wizard_twin,Alennusmestari,,,,,,,,,,,,,
worm_eel,Sähkömato,,,,,,,,,,,,,
worm_fungal,Sienirihmasto,,,,,,,,,,,,,
worm_robot,Robottimato,,,,,,,,,,,,,
wraith_boss,Epäkuolleiden Mestari,,,,,,,,,,,,,
wraith_speed,Hohtava Epäkuollut,,,,,,,,,,,,,
wraith_void2,Olio Olematon,,,,,,,,,,,,,
zombie_giant,Zombikalma,,,,,,,,,,,,,
zombie3,Kalmakoira,,,,,,,,,,,,,
beanpodupine,Paukkupalkosika,,,,,,,,,,,,,
scarab,Louskutin,,,,,,,,,,,,,
stork,Kenkänokka,,,,,,,,,,,,,
devourer,Morsa,,,,,,,,,,,,,
fish_angler2,Merikrotti,,,,,,,,,,,,,
zap_eel2,Sähköankerias,,,,,,,,,,,,,
minabomination,Ällökemisti,,,,,,,,,,,,,
desert_mage,Eldirood,,,,,,,,,,,,,
camel_robot,I160,,,,,,,,,,,,,
doom_bringer,Tuomion Tuoja,,,,,,,,,,,,,
magiconstruct,Pyhäkkö,,,,,,,,,,,,,
magiconstruct_statue,Pyhäkön Siipi,,,,,,,,,,,,,
elephant,Hönkäle,,,,,,,,,,,,,
yikka,Yikka,,,,,,,,,,,,,
yikka_host,Epäjumala,,,,,,,,,,,,,
lukki_dark_huge,Hirmukita,,,,,,,,,,,,,
giant_boss,Järkäle,,,,,,,,,,,,,
god_warrior,Perkele,,,,,,,,,,,,,
worm_skull_old,Muinainen Kallomato,,,,,,,,,,,,,
cthulhu,Antero Vipunen,,,,,,,,,,,,,
wizard_tiny,Kutistusmestari,,,,,,,,,,,,,
flopper_mother,Emesus,,,,,,,,,,,,,
xopon,Xopon,,,,,,,,,,,,,
oruai,Vahtaaja,,,,,,,,,,,,,
jungle_flower,Villiviini,,,,,,,,,,,,,
boid,Pääskynen,,,,,,,,,,,,,
sand_worm,Uskomato,,,,,,,,,,,,,
kiwiki,Kiwikii,,,,,,,,,,,,,
shield_physics,Tarkkailija,,,,,,,,,,,,,
flopper_mother_giant,Suur Emesus,,,,,,,,,,,,,
flopper_mother_giant_progeny,Suur Emesus Jälkeläinen,,,,,,,,,,,,,
crawler_bug,Kusiainen,,,,,,,,,,,,,
platoon,Komppania,,,,,,,,,,,,,
scorpio,Lepakkorpioni,,,,,,,,,,,,,
mountain,Vuori,,,,,,,,,,,,,
peeper,Vilahdus,,,,,,,,,,,,,
mantis,Sirkka,,,,,,,,,,,,,
gold_face_physics,Jumalan Sormi,,,,,,,,,,,,,
chameleon,Kamelerontti,,,,,,,,,,,,,
bloodmage_enlightened,Arkkivihulainen,,,,,,,,,,,,,
elephant_robot,Moottorinorsu,,,,,,,,,,,,,
fireworkman,Ilotulittaja,,,,,,,,,,,,,
beehive,Mehiläispesä,,,,,,,,,,,,,
mountain_large,Maajätti,,,,,,,,,,,,,
spider_crawler,Ryömiä Hämis,,,,,,,,,,,,,
larva_crawler,Silkkiäistoukka,,,,,,,,,,,,,
plant_boss,Rehevys,,,,,,,,,,,,,
drill_giant,Porakaivinkone,,,,,,,,,,,,,
drill_giant_segment,Excavator Drill Segment,,,,,,,,,,,,,
mule,Muuli,,,,,,,,,,,,,
ear_boss,Syöveri,,,,,,,,,,,,,
cyclops_slime,Jättilimanuljaska,,,,,,,,,,,,,
boss_eel,Hollantilainen Ankerias,,,,,,,,,,,,,
boss_fungus,Sienititaani,,,,,,,,,,,,,
corpse_lily,Ruholilja,,,,,,,,,,,,,
hell_door,Helvetin Portti,,,,,,,,,,,,,
mummy,Muumio,,,,,,,,,,,,,
worm_portal,Extradimensionaalimato,,,,,,,,,,,,,
mexxi,Mexxi,,,,,,,,,,,,,
hellion,Magmasuomuhauki,,,,,,,,,,,,,
hellion2,Jäähtynyt Magmasuomuhauki,,,,,,,,,,,,,
mechahub,Kadotettu Konesydän,,,,,,,,,,,,,
manticore,Painajainen,,,,,,,,,,,,,
player_evil,Peto,,,,,,,,,,,,,
player_evil_name,Peto,,,,,,,,,,,,,
puffer,Pallokala,,,,,,,,,,,,,
yoyoer,Jojohiisi,,,,,,,,,,,,,
lukki_saw,Sirkkelihämähäkki,,,,,,,,,,,,,
jungle_deity,Viidakkojumala,,,,,,,,,,,,,
tentacle_monster2,Lonkerias,,,,,,,,,,,,,
cancer2,Tumour,,,,,,,,,,,,,
head2,Etäpesäke,,,,,,,,,,,,,
ground_flesh2,Lihakita,,,,,,,,,,,,,
hand2,Kuoreton Käsi,,,,,,,,,,,,,
brain2,Aivot,,,,,,,,,,,,,
fleshclops2,Kuoreton Lepakko,,,,,,,,,,,,,
flesh_abomination2,Lihakammotus,,,,,,,,,,,,,
water_worm2,Loinen,,,,,,,,,,,,,
chainsawer,Moottorisahahiisi,,,,,,,,,,,,,
chainsawer_hell,Hornamoottorisahahiisi,,,,,,,,,,,,,
yoyoer_shaman,Jojomärkiäinen,,,,,,,,,,,,,
slimer,Limatykittäjä,,,,,,,,,,,,,
ritualists,Ritualisti,,,,,,,,,,,,,
huts,Mökki,,,,,,,,,,,,,
technomancer,Teknomantikko,,,,,,,,,,,,,
necromancer_cultist,Kultisti,,,,,,,,,,,,,
necromancer_cultist_clone,Kultisti,,,,,,,,,,,,,
worm_saw,Sirkkelirunko,,,,,,,,,,,,,
lemming,Lemmi,,,,,,,,,,,,,
vulture,Korppikotka,,,,,,,,,,,,,
necromancer_ice,Jäinen Raivo,,,,,,,,,,,,,
]])
end

--Magic Numbers Test
-- ModMagicNumbersFileAdd("data/entities/debug_magic_numbers.xml")

--Loading in poly tools
-- dofile_once("mods/new_enemies/files/polytools/polytools_init.lua").init("mods/new_enemies/files/polytools")

--Addition of Custom sounds:
ModRegisterAudioEventMappings("mods/new_enemies/data/sound/GUIDs.txt")
ModRegisterAudioEventMappings("mods/new_enemies/data/sound/more_sounds/GUIDs.txt")

local nxml = dofile_once("mods/new_enemies/files/nxml.lua")

--Addition of Materials
--Also increasing the limit of materials by the amount im adding, to prevent reaching it with other mods enabled and such!

ModMaterialsFileAdd("mods/new_enemies/files/materials/materials.xml")

--Increasing material Limit
ModMagicNumbersFileAdd( "mods/new_enemies/files/increase_material_limit.xml" ) 

-- local content_materials = ModTextFileGetContent("mods/new_enemies/files/materials/materials.xml")
-- local xml_orig = nxml.parse(content_materials)

-- local new_material_count = 0

-- for element in xml_orig:each_child() do
	-- new_material_count = new_material_count + 1
-- end

-- local original_maximum = MagicNumbersGetValue( "CELLFACTORY_CELLDATA_MAX_COUNT" )

-- replace_value("data/magic_numbers.xml", [[%<MagicNumbers]], ([[<MagicNumbers 
  -- CELLFACTORY_CELLDATA_MAX_COUNT="%s"]]):format(original_maximum + new_material_count), true)

--Addition of staining textures to enemy sprites:
-- ModDevGenerateSpriteUVsForDirectory( "data/enemies_gfx/" )

--Addition of Twitch Events
-- if ModSettingGet("new_enemies.twitch_events_enabled") then
	-- ModLuaFileAppend( "data/scripts/streaming_integration/event_list.lua", "data/scripts/twitch_events/twitch_events.lua" )
	-- -- ModLuaFileAppend( "mods/twitch_extended/files/scripts/config/config_list.lua", "data/scripts/twitch_events/config_list.lua" )
-- end
--Addition of Status Effects
ModLuaFileAppend( "data/scripts/status_effects/status_list.lua", "mods/new_enemies/data/scripts/status_effects/ne_status_effects.lua" )

--Addition of lake creatures
-- ModLuaFileAppend( "data/scripts/biomes/lake_deep.lua", "data/scripts/biomes/lake_sharks.lua" )
replace_value("data/scripts/biomes/lake_deep.lua", 
[[function init%(x%, y%, w%, h%)]], 
[[function init(x, y, w, h)
	SetRandomSeed(GameGetFrameNum(), x + y)
	for i=1, 5 do
		EntityLoad("data/entities/spawn_shark_checker.xml", x + Random(0, 512), y + Random(0, 512))
	end]]
)

--Addition of Ritualists, Peasants, Mammoths, Camels and Huts:
-- ModLuaFileAppend( "data/scripts/biomes/mountain/mountain_hall.lua", "data/scripts/biomes/mountain/mountain_hall_enemies.lua" )
replace_value("data/scripts/biomes/mountain/mountain_hall.lua", 
[[function init%( x, y, w, h %)]], 
[[function init( x, y, w, h )
	if not HasFlagPersistent("ned_ritualists") then
		local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
		local prev_world = GlobalsGetValue("new_enemies_ritualists_pw", "0")
		if prev_world ~= current_world_x then
			GlobalsSetValue("new_enemies_ritualists_pw", current_world_x)
			function split(str, delimiter)
				local result = {}
				for match in (str..delimiter):gmatch("(.-)"..delimiter) do
					table.insert(result, match)
				end
				return result
			end
			
			function join(tbl, delimiter)
				return table.concat(tbl, delimiter)
			end

			local spawned_worlds = GlobalsGetValue("new_enemies_ritualists_spawned", "")

			local spawned_worlds_table = split(spawned_worlds, ",")

			function table_contains(tbl, val)
				for _, v in ipairs(tbl) do
					if v == val then
						return true
					end
				end
				return false
			end
			
			local current_world_index = tostring(current_world_x)
			
			local current_world_occupied = table_contains(spawned_worlds_table, tostring(current_world_x))

			if current_world_occupied == false then
				table.insert(spawned_worlds_table, current_world_index)
				if ModIsEnabled("quant.ew") then
					CrossCall("sync_global", "new_enemies_ritualists_spawned", join(spawned_worlds_table, ","))
				end
				GlobalsSetValue("new_enemies_ritualists_spawned", join(spawned_worlds_table, ","))
				
				local multiplier = 0
				if current_world_x ~= 0 then
					local msx, msy = BiomeMapGetSize()
					multiplier = current_world_x * ( msx * 512 )
				end

				EntityLoad("data/entities/buildings/ritualist_a.xml", x - 61,y + 397)
				EntityLoad("data/entities/buildings/ritualist_b.xml", x - 83,y + 399)
				EntityLoad("data/entities/buildings/altar_skull.xml", x -111,y + 399)
				EntityLoad("data/entities/buildings/ritualist_c.xml", x - 138,y + 400)
				EntityLoad("data/entities/buildings/ritualist_d.xml", x - 159,y + 400)
				
				EntityLoad("data/entities/props/physics_torch_stand_intro_old.xml", x - 182,y + 404)
				EntityLoad("data/entities/props/physics_torch_stand_intro_old.xml", x - 32,y + 400)

				LoadBackgroundSprite( "data/vegetation/lush_bush_04.xml", x - 172, y + 409, 40.0, false )
				LoadBackgroundSprite( "data/vegetation/lush_bush_05.xml", x - 47, y + 408, 40.0, false )
			end
		end
	end]]
)

replace_value("data/scripts/biomes/desert.lua", 
[[function init%(x%, y%, w%, h%)]], 
[[function init(x, y, w, h)
	if not ( HasFlagPersistent("ned_camels") and HasFlagPersistent("ned_locusts") and HasFlagPersistent("ned_scorpions") and HasFlagPersistent("ned_vultures") ) then
		local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
		local prev_world = GlobalsGetValue("new_enemies_camels_pw", "0")
		if prev_world ~= current_world_x then
			GlobalsSetValue("new_enemies_camels_pw", current_world_x)

			function split(str, delimiter)
				local result = {}
				for match in (str..delimiter):gmatch("(.-)"..delimiter) do
					table.insert(result, match)
				end
				return result
			end

			function join(tbl, delimiter)
				return table.concat(tbl, delimiter)
			end

			local spawned_worlds = GlobalsGetValue("new_enemies_camels_spawned", "")

			local spawned_worlds_table = split(spawned_worlds, ",")

			function table_contains(tbl, val)
				for _, v in ipairs(tbl) do
					if v == val then
						return true
					end
				end
				return false
			end

			local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
			local current_world_index = tostring(current_world_x)
			
			local current_world_occupied = table_contains(spawned_worlds_table, tostring(current_world_x))
			if current_world_occupied == false then
				table.insert(spawned_worlds_table, current_world_index)
				if ModIsEnabled("quant.ew") then
					CrossCall("sync_global", "new_enemies_camels_spawned", join(spawned_worlds_table, ","))
				end
				GlobalsSetValue("new_enemies_camels_spawned", join(spawned_worlds_table, ","))

				local _, _, day, hour, minute, second = GameGetDateAndTimeLocal()
				SetRandomSeed(day + hour + second, minute + second)
				
				local multiplier = 0
				if current_world_x ~= 0 then
					local msx, msy = BiomeMapGetSize()
					multiplier = current_world_x * ( msx * 512 )
				end

				function loadRandomEntity(entities, xMin, xMax, yMin, yMax, UseY)
					local randomIndex = Random(1, #entities)
					local entity = entities[randomIndex]
					if entity ~= "" then
						if UseY then
							yvalue = math.random(yMin, yMax)
						else
							yvalue = -300
						end
						LoadPixelScene(entity, "", math.random(xMin + multiplier, xMax + multiplier), yvalue, "", true)
					end
				end
				local entries = {}
				if not HasFlagPersistent("ned_camels") then
					table.insert(entries, "data/biome_impl/hill_pixels/camel.png")
				else
					table.insert(entries, "")
				end
				if not HasFlagPersistent("ned_locusts") then
					table.insert(entries, "data/biome_impl/hill_pixels/locust.png")
				else
					table.insert(entries, "")
				end
				if not HasFlagPersistent("ned_scorpions") then
					table.insert(entries, "data/biome_impl/hill_pixels/scorpion.png")
				else
					table.insert(entries, "")
				end
				if not HasFlagPersistent("ned_vultures") then
					table.insert(entries, "data/biome_impl/hill_pixels/vulture.png")
				else
					table.insert(entries, "")
				end
				for i = 1,6 do
					loadRandomEntity(entries, 5460, 7140)
				end
				for i = 1,3 do
					loadRandomEntity(entries, 11430, 13290)
				end
				
				for i = 1,3 do
					loadRandomEntity(entries, 15020, 15916)
				end
			end
		end
	end]]
)

replace_value("data/scripts/biomes/hills.lua", 
[[function init%(x%, y%, w%, h%)]], 
[[function init(x, y, w, h)
	if not ( HasFlagPersistent("ned_boids") and HasFlagPersistent("ned_llama") and HasFlagPersistent("ned_frog_tiny") and HasFlagPersistent("ned_peasants") and HasFlagPersistent("ned_huts") and HasFlagPersistent("ned_mammoths") and HasFlagPersistent("ned_mammoth_baby") ) then
		local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
		local prev_world = GlobalsGetValue("new_enemies_peasants_pw", "0")
		if prev_world ~= current_world_x then
			GlobalsSetValue("new_enemies_peasants_pw", current_world_x)

			function split(str, delimiter)
				local result = {}
				for match in (str..delimiter):gmatch("(.-)"..delimiter) do
					table.insert(result, match)
				end
				return result
			end

			function join(tbl, delimiter)
				return table.concat(tbl, delimiter)
			end

			local spawned_worlds = GlobalsGetValue("new_enemies_peasants_spawned", "")
			local spawned_worlds_table = split(spawned_worlds, ",")

			function table_contains(tbl, val)
				for _, v in ipairs(tbl) do
					if v == val then
						return true
					end
				end
				return false
			end
			local current_world_index = tostring(current_world_x)
			
			local current_world_occupied = table_contains(spawned_worlds_table, tostring(current_world_x))
			local peer_count = 1
			if ModIsEnabled("quant.ew") then
				local peers = EntityGetWithTag("ew_peer")
				if ( peers ~= nil ) and ( #peers > 0 ) then
					peer_count = #peers
				end
			end
			
			function table_count(tbl)
				local count = 0
				for _, v in ipairs(tbl) do
					count = count + 1
				end
				return count
			end
			local tcount = table_count(spawned_worlds_table)
			if ( ( peer_count > 1 ) or not GameHasFlagRun("ew_flag_this_is_host") ) and ( current_world_x == 0 ) then
				current_world_occupied = true
			end
			if not current_world_occupied then
				table.insert(spawned_worlds_table, current_world_index)
				if ModIsEnabled("quant.ew") then
					CrossCall("sync_global", "new_enemies_peasants_spawned", join(spawned_worlds_table, ","))
				end
				GlobalsSetValue("new_enemies_peasants_spawned", join(spawned_worlds_table, ","))

				local _, _, day, hour, minute, second = GameGetDateAndTimeLocal()
				SetRandomSeed(day + hour + second, minute + second)
				
				local multiplier = 0
				if current_world_x ~= 0 then
					local msx, msy = BiomeMapGetSize()
					multiplier = current_world_x * ( msx * 512 )
				end

				function loadRandomEntity(entities, xMin, xMax, yMin, yMax, UseY)
					local randomIndex = Random(1, #entities)
					local entity = entities[randomIndex]
					if entity ~= "" then
					  if UseY then
						yvalue = math.random(yMin, yMax)
					  else
						yvalue = -300
					  end
					  LoadPixelScene(entity, "", math.random(xMin + multiplier, xMax + multiplier), yvalue, "", true)
					end
				end
				
				if not HasFlagPersistent("ned_boids") then
					for i=1, 20 do
					  loadRandomEntity({ "data/biome_impl/hill_pixels/boid.png", "" }, -260, -773, -400, -250, true)
					end
					for i=1, 40 do
					  loadRandomEntity({ "data/biome_impl/hill_pixels/boid.png", "" }, 1647, 4690, -400, -250, true)
					end
				end
				if not ( HasFlagPersistent("ned_llama") and HasFlagPersistent("ned_frog_tiny") ) then
					local entries = {}
					if not HasFlagPersistent("ned_llama") then
						table.insert(entries, "data/biome_impl/hill_pixels/llama.png")
					else
						table.insert(entries, "")
					end
					if not HasFlagPersistent("ned_frog_tiny") then
						table.insert(entries, "data/biome_impl/hill_pixels/frog_tiny.png")
					else
						table.insert(entries, "")
					end
					for i = 1,3 do
						loadRandomEntity(entries, 1647, 2480)
					end
					for i = 1,3 do
						loadRandomEntity(entries, 3132, 4690)
					end
				end
				if not HasFlagPersistent("ned_peasants") then
					local entries = {}
					for i = 1,3 do
						table.insert(entries, "data/biome_impl/hill_pixels/peasant.png")
					end
					table.insert(entries, "")
					for i = 1,16 do
						loadRandomEntity(entries, -260, -773)
					end
				end

				if not HasFlagPersistent("ned_huts") then
					for i = 1,4 do
						loadRandomEntity({ "data/biome_impl/hill_pixels/hut.png", "" }, -260, -773)
					end
				end
				if not ( HasFlagPersistent("ned_mammoths") and HasFlagPersistent("ned_mammoth_baby") ) then
					local entries = {}
					if not HasFlagPersistent("ned_mammoths") then
						table.insert(entries, "data/biome_impl/hill_pixels/mammoth.png")
					else
						table.insert(entries, "")
					end
					if not HasFlagPersistent("ned_mammoth_baby") then
						table.insert(entries, "data/biome_impl/hill_pixels/mammoth_baby.png")
						table.insert(entries, "data/biome_impl/hill_pixels/mammoth_baby.png")
					else
						table.insert(entries, "")
						table.insert(entries, "")
					end
					for i = 1, 6 do
						loadRandomEntity(entries, -2150, -5000)
					end
				end
			end
		end
	end]]
)

--Addition of Underground Train to Vault
if not HasFlagPersistent("ned_vault_enemies") then
	ModLuaFileAppend( "data/scripts/biomes/vault.lua", "data/scripts/biomes/vault_trains.lua" )
end

--Addition of Airship boss to ocarina area
-- ModLuaFileAppend( "data/scripts/biomes/ocarina.lua", "data/scripts/biomes/ocarina_enemies.lua" )
replace_value("data/scripts/biomes/ocarina.lua", 
[[function spawn%_secret%( x%, y %)]], 
[[function spawn_secret( x, y )
	EntityLoad( "data/entities/buildings/windmill_spot.xml", x, y - 64 )]]
)

--Addition of enemy adding lua scripts:
local mode = ModSettingGet( "new_enemies.difficulty_level" )

if mode == "normal" or not mode then
	if not HasFlagPersistent("ned_coalmine_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/coalmine.lua", "data/scripts/biomes/coalmine_enemies.lua" )
	end
	if not HasFlagPersistent("ned_coalmine_alt_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/coalmine_alt.lua", "data/scripts/biomes/coalmine_alt_enemies.lua" )
	end
	if not HasFlagPersistent("ned_excavationsite_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/excavationsite.lua", "data/scripts/biomes/excavationsite_enemies.lua" )
	end
	if not HasFlagPersistent("ned_snowcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/snowcave.lua", "data/scripts/biomes/snowcave_enemies.lua" )
	end
	if not HasFlagPersistent("ned_snowcastle_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/snowcastle.lua", "data/scripts/biomes/snowcastle_enemies.lua" )
	end
	if not HasFlagPersistent("ned_rainforest_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/rainforest.lua", "data/scripts/biomes/rainforest_enemies.lua" )
	end
	if not HasFlagPersistent("ned_vault_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/vault.lua", "data/scripts/biomes/vault_enemies.lua" )
	end
	if not HasFlagPersistent("ned_crypt_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/crypt.lua", "data/scripts/biomes/crypt_enemies.lua" )
	end
	if not HasFlagPersistent("ned_fungicave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/fungicave.lua", "data/scripts/biomes/fungicave_enemies.lua" )
	end
	if not HasFlagPersistent("ned_pyramid_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/pyramid.lua", "data/scripts/biomes/pyramid_enemies.lua" )
	end
	if not HasFlagPersistent("ned_liquidcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/liquidcave.lua", "data/scripts/biomes/liquidcave_enemies.lua" )
	end
	if not HasFlagPersistent("ned_wandcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/wandcave.lua", "data/scripts/biomes/wandcave_enemies.lua" )
	end
	if not HasFlagPersistent("ned_sandcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/sandcave.lua", "data/scripts/biomes/sandcave_enemies.lua" )
	end
	if not HasFlagPersistent("ned_vault_frozen_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/vault_frozen.lua", "data/scripts/biomes/vault_frozen_enemies.lua" )
	end
	if not HasFlagPersistent("ned_wizardcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/wizardcave.lua", "data/scripts/biomes/wizardcave_enemies.lua" )
	end
	if not HasFlagPersistent("ned_rainforest_dark_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/rainforest_dark.lua", "data/scripts/biomes/rainforest_dark_enemies.lua" )
	end
	if not HasFlagPersistent("ned_winter_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/winter.lua", "data/scripts/biomes/winter_enemies.lua" )
	end
	if not HasFlagPersistent("ned_fungiforest_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/fungiforest.lua", "data/scripts/biomes/fungiforest_enemies.lua" )
	end
	if not HasFlagPersistent("ned_robobase_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/robobase.lua", "data/scripts/biomes/robobase_enemies.lua" )
	end
	if not HasFlagPersistent("ned_clouds_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/clouds.lua", "data/scripts/biomes/clouds_enemies.lua" )
	end
	if not HasFlagPersistent("ned_meat_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/meat.lua", "data/scripts/biomes/meat_enemies.lua" )
	end
	if not HasFlagPersistent("ned_the_end_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/the_end.lua", "mods/new_enemies/data/scripts/biomes/the_end_enemies.lua" )
	end
	if not HasFlagPersistent("ned_the_sky_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/the_end.lua", "mods/new_enemies/data/scripts/biomes/the_sky_enemies.lua" )
	end
	
	ModLuaFileAppend( "data/scripts/biomes/desert.lua", "data/scripts/biomes/desert_enemies.lua" )
elseif mode == "easy" then
	if not HasFlagPersistent("ned_coalmine_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/coalmine.lua", "data/scripts/biomes/coalmine_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_coalmine_alt_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/coalmine_alt.lua", "data/scripts/biomes/coalmine_alt_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_excavationsite_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/excavationsite.lua", "data/scripts/biomes/excavationsite_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_snowcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/snowcave.lua", "data/scripts/biomes/snowcave_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_snowcastle_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/snowcastle.lua", "data/scripts/biomes/snowcastle_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_rainforest_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/rainforest.lua", "data/scripts/biomes/rainforest_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_vault_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/vault.lua", "data/scripts/biomes/vault_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_crypt_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/crypt.lua", "data/scripts/biomes/crypt_enemies_easy.lua" )
	end
	
	if not HasFlagPersistent("ned_fungicave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/fungicave.lua", "data/scripts/biomes/fungicave_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_pyramid_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/pyramid.lua", "data/scripts/biomes/pyramid_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_liquidcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/liquidcave.lua", "data/scripts/biomes/liquidcave_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_wandcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/wandcave.lua", "data/scripts/biomes/wandcave_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_sandcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/sandcave.lua", "data/scripts/biomes/sandcave_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_vault_frozen_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/vault_frozen.lua", "data/scripts/biomes/vault_frozen_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_wizardcave_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/wizardcave.lua", "data/scripts/biomes/wizardcave_enemies_easy.lua" )
	end
	--ModLuaFileAppend( "data/scripts/biomes/rainforest_dark.lua", "data/scripts/biomes/rainforest_dark_enemies_easy.lua" )
	--ModLuaFileAppend( "data/scripts/biomes/winter.lua", "data/scripts/biomes/winter_enemies.lua" )
	if not HasFlagPersistent("ned_meat_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/meat.lua", "data/scripts/biomes/meat_enemies.lua" )
	end
	if not HasFlagPersistent("ned_fungiforest_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/fungiforest.lua", "data/scripts/biomes/fungiforest_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_the_end_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/the_end.lua", "mods/new_enemies/data/scripts/biomes/the_end_enemies_easy.lua" )
	end
	if not HasFlagPersistent("ned_the_sky_enemies") then
		ModLuaFileAppend( "data/scripts/biomes/the_end.lua", "mods/new_enemies/data/scripts/biomes/the_sky_enemies_easy.lua" )
	end
end

--Addition of Scenes:
ModLuaFileAppend( "data/scripts/biomes/coalmine.lua", "data/scripts/biomes/coalmine_pixel_scenes.lua" )
ModLuaFileAppend( "data/scripts/biomes/snowcave.lua", "data/scripts/biomes/snowcave_pixel_scenes.lua" )
-- ModLuaFileAppend( "data/scripts/biomes/rainforest.lua", "data/scripts/biomes/rainforest_pixel_scenes.lua" )

--Addition of spawn register functions for surface Passives

ModLuaFileAppend( "data/scripts/biomes/hills.lua", "mods/new_enemies/files/surface_passives_append.lua" )
ModLuaFileAppend( "data/scripts/biomes/desert.lua", "mods/new_enemies/files/surface_passives_append.lua" )
ModLuaFileAppend( "data/scripts/biomes/winter.lua", "mods/new_enemies/files/surface_passives_append.lua" )

--Editing an annoying local in the surface scripts:
-- function fix_overworld_desert()
	-- local content = ModTextFileGetContent("data/scripts/props/overworld_desert_prop_spawner.lua")
	-- content = content:gsub("local props", "props")
	-- ModTextFileSetContent("data/scripts/props/overworld_desert_prop_spawner.lua", content)
-- end
-- fix_overworld_desert()
-- --Addition of surface creatures to surface biomes/LANDING
-- ModLuaFileAppend( "data/scripts/props/overworld_desert_prop_spawner.lua", "data/scripts/biomes/desert_entity_spawner.lua" )

--Add Poly steven to holy mountains:
-- ModLuaFileAppend( "data/scripts/biomes/temple_shared.lua", "data/scripts/biomes/temple_altar_right_necromancer_poly.lua" )

--Secret Mimic:
local biome_scripts_content = ModTextFileGetContent("data/scripts/biome_scripts.lua")
if biome_scripts_content and not HasFlagPersistent("ned_chest_great_mimic") then
  local string_to_look_for = [[local entity%s?=%s?EntityLoad%s?%(%s?"data/entities/animals/chest_mimic.xml"%s?,%s?x,%s?y%s?%)]]
  local insertion_point = string.find(biome_scripts_content, string_to_look_for)
  if insertion_point then
    biome_scripts_content = string.gsub(biome_scripts_content, string_to_look_for, [[
  if Random(1, 100) < 50 then
                  local entity = EntityLoad( "data/entities/animals/chest_mimic.xml", x, y)
                else
                  local entity = EntityLoad( "data/entities/animals/chest_great_mimic.xml", x, y)
                end]])
    ModTextFileSetContent("data/scripts/biome_scripts.lua", biome_scripts_content)
  end
end

--Secret Boss Spawner:
-- ModLuaFileAppend( "data/scripts/biomes/desert.lua", "data/scripts/biomes/desert_skull.lua" )
replace_value("data/scripts/biomes/desert.lua", 
[[function spawn%_secret%_checker%( x%, y %)]], 
[[function spawn_secret_checker( x, y )
	if (GlobalsGetValue("new_enemies_desert_skull_loaded", 0) == "1") then
	  
	else
		local entity = EntityLoad( "data/entities/buildings/desert_skull.xml", x, y )
	end
	
	GlobalsSetValue("new_enemies_desert_skull_loaded", "1")]]
)

--secret1:
-- ModLuaFileAppend( "data/scripts/biomes/mountain_tree.lua", "data/scripts/biomes/mountain_tree_enemies.lua" )
replace_value("data/scripts/biomes/mountain_tree.lua", 
[[function spawn%_ocarina%( x%, y %)]], 
[[function spawn_ocarina( x, y )
	EntityLoad( "data/entities/animals/ent.xml", x, y - 32 )
	
	LoadPixelScene( "data/biome_impl/spliced/tree/zolkarn.png", "", x - 370, y - 40, "data/biome_impl/spliced/tree/zolkarn_background.png", true )
	]]
)

--Option to reduce Jungle Lag
if ModSettingGet("new_enemies.jungle_lag_reducer_enabled") then
	ModLuaFileAppend( "data/scripts/biomes/coalmine.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/coalmine_alt.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/snowcave.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/fungiforest.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/rainforest.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/rainforest_dark.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/temple_altar_left.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/tower.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/wizardcave.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/vault_frozen.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
	ModLuaFileAppend( "data/scripts/biomes/crypt.lua", "data/scripts/biomes/rainforest_lag_reducer.lua" )
end

-- if not ModIsEnabled("particle_life") then
	-- if HasFlagPersistent("nee_ants") then
		-- replace_value("data/scripts/biomes/rainforest.lua", 
		-- [[%-%- spawn_hp_mult%(g_small_enemies]], 
		-- [[
		-- SetRandomSeed( GameGetFrameNum(), x + y )

		-- local random_number = Random(1,4)
		-- if random_number == 1 then
			-- EntityLoad( "data/entities/materials/ant_spawner.xml", x, y )
		-- end
		
		-- -- spawn_hp_mult(g_small_enemies]]
		-- )
		-- replace_value("data/scripts/biomes/excavationsite.lua", 
		-- [[function spawn_small_enemies%(x%, y%)]], 
		-- [[
		-- function spawn_small_enemies(x, y)
		-- SetRandomSeed( GameGetFrameNum(), x + y )

		-- local random_number = Random(1,4)
		-- if random_number == 1 then
			-- EntityLoad( "data/entities/materials/ant_spawner.xml", x, y )
		-- end]]
		-- )
		-- replace_value("data/scripts/biomes/coalmine.lua", 
		-- [[function spawn_small_enemies%(x%, y%, w%, h%, is_open_path%)]], 
		-- [[
		-- function spawn_small_enemies(x, y, w, h, is_open_path)
		-- SetRandomSeed( GameGetFrameNum(), x + y )

		-- local random_number = Random(1,4)
		-- if random_number == 1 then
			-- EntityLoad( "data/entities/materials/ant_spawner.xml", x, y )
		-- end]]
		-- )
		-- replace_value("data/scripts/biomes/coalmine_alt.lua", 
		-- [[function spawn_small_enemies%(x%, y%)]], 
		-- [[
		-- function spawn_small_enemies(x, y)
		-- SetRandomSeed( GameGetFrameNum(), x + y )

		-- local random_number = Random(1,4)
		-- if random_number == 1 then
			-- EntityLoad( "data/entities/materials/ant_spawner.xml", x, y )
		-- end]]
		-- )
	-- end

	-- if ( HasFlagPersistent("nee_spiders") ) or ( HasFlagPersistent("nee_earth_worms") ) or ( HasFlagPersistent("nee_water_bugs") ) then
		-- --particle bugs and creatures
		-- replace_value("data/scripts/biomes/coalmine.lua", 
		-- [[-- this is a special function tweaked for spawning things in coalmine]], 
		-- [[-- this is a special function tweaked for spawning things in coalmine
		
		-- RegisterSpawnFunction(0xffffeedd, "init")
		
		-- function init(x, y, w, h)
			-- EntityLoad("data/entities/materials/material_bug_spawner.xml", x, y)
		-- end]]
		-- )
		
		-- replace_value("data/scripts/biomes/coalmine_alt.lua", 
		-- [[-- this is a special function tweaked for spawning things in coalmine]], 
		-- [[-- this is a special function tweaked for spawning things in coalmine
		
		-- RegisterSpawnFunction(0xffffeedd, "init")
		
		-- function init(x, y, w, h)
			-- EntityLoad("data/entities/materials/material_bug_spawner.xml", x, y)
		-- end]]
		-- )
		
		-- replace_value("data/scripts/biomes/excavationsite.lua", 
		-- [[-- this is a special function tweaked for spawning things in coal mines]], 
		-- [[-- this is a special function tweaked for spawning things in coal mines
		
		-- RegisterSpawnFunction(0xffffeedd, "init")
		
		-- function init(x, y, w, h)
			-- EntityLoad("data/entities/materials/material_bug_spawner.xml", x, y)
		-- end]]
		-- )
		
		-- replace_value("data/scripts/biomes/fungiforest.lua", 
		-- [[function init%(x%, y%, w%, h%)]], 
		-- [[function init(x, y, w, h)
			-- EntityLoad("data/entities/materials/material_bug_spawner.xml", x, y)]]
		-- )
		
		-- replace_value("data/scripts/biomes/fungicave.lua", 
		-- [[function init%(x%, y%, w%, h%)]], 
		-- [[function init(x, y, w, h)
			-- EntityLoad("data/entities/materials/material_bug_spawner.xml", x, y)]]
		-- )
		
		-- replace_value("data/scripts/biomes/rainforest.lua", 
		-- [[function init%(x%, y%, w%, h%)]], 
		-- [[function init(x, y, w, h)
			-- EntityLoad("data/entities/materials/material_bug_spawner.xml", x, y)]]
		-- )
		-- --particle bugs and creatures
	-- end
-- end

--Removing particle life from fungal shifts
replace_value("data/scripts/magic/fungal_shift.lua", 
[[local held_material %= get_held_item_material%( entity %)]], 
[[local held_material = get_held_item_material( entity )
local held_material_name = CellFactory_GetName(held_material)
if held_material_name == "snake_seed" or
held_material_name == "meat_evaporate" or
held_material_name == "meat_slime_bean_pod" or
held_material_name == "meat_banana" or
held_material_name == "rock_hard_wizard" or
held_material_name == "sentient_gas" or
held_material_name == "sentient_gas_tail" or
held_material_name == "very_hard_stone_yikka" or
held_material_name == "tire_rubber" or
held_material_name == "rock_box2d_go_through" or
held_material_name == "aluminium_robot_hard" or
held_material_name == "meat_flopper" or
held_material_name == "meat_flopper_light" or
held_material_name == "ice_static_non_glass2" or
held_material_name == "meat_physicsbody" or
held_material_name == "meat_physicsbody_banana" or
held_material_name == "mountain_eye_neon" or
held_material_name == "rock_box2d_harder_damage" or
held_material_name == "gold_box2d_boss" or
held_material_name == "meat_cursed_mwyah" or
held_material_name == "pollen_gas" or
held_material_name == "meat_slime_static" or
held_material_name == "boss_fungus_gas" or
held_material_name == "boss_fungus_gas_up" or
held_material_name == "boss_fungus_gas_down" or
held_material_name == "rock_static_fungal_white" or
held_material_name == "spore_pod_stalk_purple" or
held_material_name == "rock_box2d_mwyah" or
held_material_name == "steel_go_through_static_boss" or
held_material_name == "new_enemies_fuse_bouncy_up" or
held_material_name == "new_enemies_fuse_bouncy_down" or
held_material_name == "new_enemies_steel_strong" or
held_material_name == "new_enemies_snake_aggregator" or
held_material_name == "new_enemies_snake_box2d" or
held_material_name == "new_enemies_snake_seed" or
held_material_name == "soil_evaporate" or
held_material_name == "jungle_seed" or
held_material_name == "water_health" or
held_material_name == "rock_box2d_hard_damage" or
held_material_name == "blood_static" or
held_material_name == "bone_fading" or
held_material_name == "rock_static_radioactive2" or
held_material_name == "meat_grey" or
held_material_name == "blood_grey" or
held_material_name == "rock_hard_border2" or
held_material_name == "rock_hard_border3" or
held_material_name == "rock_hard_border4" or
held_material_name == "radioactive_gas2" or
held_material_name == "new_enemies_custom_lava" then
	held_material = 0
end
]]
)

--Adding some custom alternate materials to the shifting pool.
-- ModLuaFileAppend( "data/scripts/magic/fungal_shift.lua", "data/scripts/fungal_shift_append.lua" )

replace_value("data/scripts/magic/fungal_shift.lua", 
[[				ConvertMaterialEverywhere%( from%_material%, to%_material %)]], 
[[				ConvertMaterialEverywhere( from_material, to_material )
				if ( from_material == CellFactory_GetType( "magic_liquid_random_polymorph" ) ) then
					ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_random_polymorph_temp" ), to_material )
				elseif ( from_material == CellFactory_GetType( "magic_liquid_polymorph" ) ) then
					ConvertMaterialEverywhere( CellFactory_GetType( "magic_liquid_polymorph_temp" ), to_material )
				elseif ( from_material == CellFactory_GetType( "radioactive_liquid" ) ) then
					ConvertMaterialEverywhere( CellFactory_GetType( "radioactive_liquid_blue" ), to_material )
				end]]
)

--Add surface passive creatures
-- replace_value("data/scripts/director_helpers.lua", 
-- [[-- default biome functions that get called if we can%'t find a a specific biome that works for us]], 
-- [[RegisterSpawnFunction( 0xff123469, "spawn_peasant" )

-- function spawn_peasant(x, y)
	-- EntityLoad("data/entities/animals/peasant.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123468, "spawn_peasant" )

-- function spawn_peasant(x, y)
	-- EntityLoad("data/entities/animals/peasant.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123467, "spawn_peasant" )

-- function spawn_peasant(x, y)
	-- EntityLoad("data/entities/animals/peasant.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123466, "spawn_hut" )

-- function spawn_hut(x, y)
	-- EntityLoad("data/entities/buildings/hut.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123465, "spawn_mammoth" )

-- function spawn_mammoth(x, y)
	-- EntityLoad("data/entities/animals/mammoth.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123464, "spawn_mammoth_baby" )

-- function spawn_mammoth_baby(x, y)
	-- EntityLoad("data/entities/animals/mammoth_baby.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123463, "spawn_camel" )

-- function spawn_camel(x, y)
	-- EntityLoad("data/entities/animals/camel.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123462, "spawn_scorpion" )

-- function spawn_scorpion(x, y)
	-- local sc = EntityLoad("data/entities/animals/scorpion.xml", x, y)
	-- EntityAddComponent2(sc, "LuaComponent", {
	-- script_source_file="data/scripts/animals/snap_to_terrain.lua",
	-- execute_every_n_frame=1,
	-- remove_after_executed=true
	-- })
-- end

-- RegisterSpawnFunction( 0xff123461, "spawn_locust" )

-- function spawn_locust(x, y)
	-- EntityLoad("data/entities/animals/locust.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123460, "spawn_frog_tiny" )

-- function spawn_frog_tiny(x, y)
	-- EntityLoad("data/entities/animals/frog_tiny.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xff123459, "spawn_llama" )

-- function spawn_llama(x, y)
	-- EntityLoad("data/entities/animals/llama.xml", x, y)
-- end

-- RegisterSpawnFunction( 0xffb2e367, "spawn_boids" )

-- function spawn_boids(x, y)
	-- EntityLoad("data/entities/spawn_boids_air_checker.xml", x, y)
-- end

-- -- default biome functions that get called if we can't find a a specific biome that works for us]]
-- )

--Omega Steve
if ( not HasFlagPersistent("ned_necromancer_omega") ) or ( not HasFlagPersistent("ned_jungle_deity") ) or ( not HasFlagPersistent("ned_technomancer") ) or ( not HasFlagPersistent("ned_necromancer_cultist") ) or  ( not HasFlagPersistent("ned_necromancer_ice") ) then
	--ModLuaFileAppend( "data/scripts/biomes/temple_shared.lua", "data/scripts/biomes/temple_shared_new_enemies.lua" )

	replace_value("data/entities/animals/necromancer_super.xml", 
	[[<!%-%- protections %-%->]], 
	[[    <LuaComponent 
			script_death="data/scripts/animals/necromancer_super_death.lua" 
		>
		</LuaComponent>]]
	)
	
	replace_value("data/scripts/animals/necromancer_shop_spawn.lua", 
	[[then]], 
	[[and tonumber(GlobalsGetValue("SKOUDE_DEATHS", 0)) < 6 then]]
	)

	replace_value("data/scripts/animals/necromancer_shop_spawn.lua", 
	[[else]], 
	[[elseif tonumber(GlobalsGetValue("STEVARI_DEATHS", 0)) >= 3 and tonumber(GlobalsGetValue("SKOUDE_DEATHS", 0)) < 6 then]]
	)

	replace_value("data/scripts/animals/necromancer_shop_spawn.lua", 
	[[end]], 
	[[elseif ( tonumber(GlobalsGetValue("SKOUDE_DEATHS", "0")) >= 6 ) then
	
	local biome = BiomeMapGetName( pos_x, pos_y + 512 )

	local has_jungle = HasFlagPersistent("ned_jungle_deity")
	local has_omega = HasFlagPersistent("ned_necromancer_omega")
	local has_tech = HasFlagPersistent("ned_technomancer")
	local has_cultist = HasFlagPersistent("ned_necromancer_cultist")
	local has_ice = HasFlagPersistent("ned_necromancer_ice")

	-- CASES: 2^4 = 16
	if (not has_jungle) and (not has_omega) and (not has_tech) and ( has_cultist )  and ( has_ice ) then
		-- all of them active
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (has_jungle) and (not has_omega) and (not has_tech) and ( has_cultist )  and ( has_ice ) then
		-- only jungle disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (has_omega) and (not has_tech) and ( has_cultist )  and ( has_ice ) then
		-- only omega disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (not has_omega) and (has_tech) and ( has_cultist )  and ( has_ice ) then
		-- only technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (has_jungle) and (has_omega) and (not has_tech) and ( has_cultist )  and ( has_ice ) then
		-- jungle + omega disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (has_jungle) and (not has_omega) and (has_tech) and ( has_cultist )  and ( has_ice ) then
		-- jungle + technomancer disabled
		EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)

	elseif (not has_jungle) and (has_omega) and (has_tech) and ( has_cultist )  and ( has_ice ) then
		-- omega + technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (has_jungle) and (has_omega) and (has_tech) and ( has_cultist ) and ( has_ice ) then
		-- all three disabled
		EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
	elseif (has_jungle) and (has_omega) and (has_tech) and ( not has_cultist ) then
		if ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (not has_jungle) and (not has_omega) and (not has_tech) and ( not has_cultist )  and ( has_ice ) then
		-- all of them active
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (has_jungle) and (not has_omega) and (not has_tech) and ( not has_cultist )  and ( has_ice ) then
		-- only jungle disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (has_omega) and (not has_tech) and ( not has_cultist )  and ( has_ice ) then
		-- only omega disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (not has_omega) and (has_tech) and ( not has_cultist )  and ( has_ice ) then
		-- only technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end
		
	elseif (has_jungle) and (has_omega) and (not has_tech) and ( not has_cultist )  and ( has_ice ) then
		-- jungle + omega disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (has_jungle) and (not has_omega) and (has_tech) and ( not has_cultist )  and ( has_ice ) then
		-- jungle + technomancer disabled
		if ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end
	elseif (not has_jungle) and (has_omega) and (has_tech) and ( not has_cultist )  and ( has_ice ) then
		-- omega + technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	end


	if (not has_jungle) and (not has_omega) and (not has_tech) and ( has_cultist )  and ( not has_ice ) then
		-- all of them active
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (has_jungle) and (not has_omega) and (not has_tech) and ( has_cultist )  and ( not has_ice ) then
		-- only jungle disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (has_omega) and (not has_tech) and ( has_cultist )  and ( not has_ice ) then
		-- only omega disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (not has_omega) and (has_tech) and ( has_cultist )  and ( not has_ice ) then
		-- only technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (has_jungle) and (has_omega) and (not has_tech) and ( has_cultist )  and ( not has_ice ) then
		-- jungle + omega disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (has_jungle) and (not has_omega) and (has_tech) and ( has_cultist )  and ( not has_ice ) then
		-- jungle + technomancer disabled
		if ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (has_omega) and (has_tech) and ( has_cultist )  and ( not has_ice ) then
		-- omega + technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (has_jungle) and (has_omega) and (has_tech) and ( has_cultist ) and ( not has_ice ) then
		-- all three disabled
		EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
	elseif (has_jungle) and (has_omega) and (has_tech) and ( not has_cultist ) and (not has_ice) then
		if ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (not has_jungle) and (not has_omega) and (not has_tech) and ( not has_cultist )  and ( not has_ice ) then
		-- all of them active
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (has_jungle) and (not has_omega) and (not has_tech) and ( not has_cultist )  and ( not has_ice ) then
		-- only jungle disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (has_omega) and (not has_tech) and ( not has_cultist ) and ( not has_ice ) then
		-- only omega disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end

	elseif (not has_jungle) and (not has_omega) and (has_tech) and ( not has_cultist ) and ( not has_ice ) then
		-- only technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end
		
	elseif (has_jungle) and (has_omega) and (not has_tech) and ( not has_cultist ) and ( not has_ice ) then
		-- jungle + omega disabled
		if ( biome == "$biome_vault" ) or ( biome == "The Forge" ) then
			EntityLoad("data/entities/animals/technomancer.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	elseif (has_jungle) and (not has_omega) and (has_tech) and ( not has_cultist ) and ( not has_ice ) then
		-- jungle + technomancer disabled
		if ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_omega.xml", pos_x, pos_y)
		end
	elseif (not has_jungle) and (has_omega) and (has_tech) and ( not has_cultist )  and ( not has_ice ) then
		-- omega + technomancer disabled
		if ( biome == "$biome_rainforest" ) or ( biome == "Underground Swamp" ) then
			EntityLoad("data/entities/animals/jungle_deity.xml", pos_x, pos_y)
		elseif ( biome == "$biome_crypt" ) or ( biome == "Holy Temple" ) then
			EntityLoad("data/entities/animals/necromancer_cultist.xml", pos_x, pos_y)
		elseif ( biome == "$biome_snowcave" ) or ( biome == "Magic Conduit" ) then
			EntityLoad("data/entities/animals/necromancer_ice.xml", pos_x, pos_y)
		else
			EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
		end
	end
	

end]])
end

--secret2:
if not HasFlagPersistent("ned_lemmings") then
	replace_value("data/scripts/biomes/funroom.lua", 
	[[function init%( x, y, w, h %)]], 
	[[function init( x, y, w, h ) 
		EntityLoad("data/entities/animals/lemming.xml", x + 315,y + 300)
		EntityLoad("data/entities/animals/lemming.xml", x + 329,y + 300)
		EntityLoad("data/entities/animals/lemming.xml", x + 347,y + 300)
		EntityLoad("data/entities/animals/lemming.xml", x + 377,y + 300)
	]]
	)
end

--Addition of enemies to Custom biome:
if ModIsEnabled("New Biomes + Secrets") then

	ModLuaFileAppend( "data/scripts/biomes/LANDING.lua", "data/scripts/biomes/landing_enemies.lua" )

end

--Adding a ton of shaders for mirror orbs effect
--This is for Vollux or data/entities/animals/mirror_physics.xml
if not HasFlagPersistent("ned_mirror_physics") then

	dofile_once("mods/new_enemies/files/shader_utilities.lua")

	local s = "uniform vec4 ballpos_#i;"
	local final = ""
	for i=1, 9 do
	  final = final .. s:gsub("#i", i) .. "\n"
	end
	postfx.append(final,
	"uniform sampler2D tex_fog;",
	"data/shaders/post_final.frag"
	)

	local s = [[
	if ( ballpos_#i.w > 0.0 ) {
		vec4 ballpos_#i = vec4(
        (ballpos_#i.x/world_viewport_size.x) - (camera_pos.x/world_viewport_size.x),
        (-ballpos_#i.y/world_viewport_size.y) + (camera_pos.y/world_viewport_size.y) + 1.0,
        ballpos_#i.z,
        ballpos_#i.w
        );
	
		float stretch_#i = world_viewport_size.y/world_viewport_size.x;
		float l_#i = length(vec2((tex_coord.x-ballpos_#i.x)/stretch_#i, tex_coord.y-ballpos_#i.y) - vec2(0.0,0.0)); //distance from pixel to ball center
		float mult_#i = step(l_#i,ballpos_#i.z);

		vec2 edge_#i = vec2( //the outline of the ball
			ballpos_#i.x + ((tex_coord.x-ballpos_#i.x)/l_#i)*ballpos_#i.z,
			ballpos_#i.y + ((tex_coord.y-ballpos_#i.y)/l_#i)*ballpos_#i.z
			);
		vec2 move_#i = vec2(edge_#i.x - ((tex_coord.x-edge_#i.x)/(l_#i*20.0)), edge_#i.y - ((tex_coord.y-edge_#i.y)/(l_#i*20.0))) - tex_coord;
		tex_coord += move_#i*mult_#i*ballpos_#i.w;
		tex_coord_glow += vec2(move_#i.x, -move_#i.y)*mult_#i*ballpos_#i.w;
	}
	]]
	local final = ""
	for i=1, 9 do
	  final = final .. s:gsub("#i", i) .. "\n"
	end

	postfx.append(final,
	  "// sample the original color =================================================================================",
	  "data/shaders/post_final.frag"
	)
	
	-- local s = [[
	-- vec4 ballpos_#i = vec4(
        -- (ballpos_#i.x/world_viewport_size.x) - (camera_pos.x/world_viewport_size.x),
        -- (-ballpos_#i.y/world_viewport_size.y) + (camera_pos.y/world_viewport_size.y) + 1.0,
        -- ballpos_#i.z,
        -- 0.0
        -- );

    -- float stretch_#i = world_viewport_size.y/world_viewport_size.x;
    -- float l_#i = length(vec2((tex_coord.x-ballpos_#i.x)/stretch_#i, tex_coord.y-ballpos_#i.y) - vec2(0.0,0.0)); //distance from pixel to ball center
    -- float mult_#i = step(l_#i,ballpos_#i.z);

    -- vec2 edge_#i = vec2( //the outline of the ball
        -- ballpos_#i.x + ((tex_coord.x-ballpos_#i.x)/l_#i)*ballpos_#i.z,
        -- ballpos_#i.y + ((tex_coord.y-ballpos_#i.y)/l_#i)*ballpos_#i.z
        -- );
	-- vec2 move_#i = vec2(edge_#i.x - ((tex_coord.x-edge_#i.x)/(l_#i*20.0)), edge_#i.y - ((tex_coord.y-edge_#i.y)/(l_#i*20.0))) - tex_coord;
    -- tex_coord += move_#i*mult_#i*ballpos_#i.w;
    -- tex_coord_glow += vec2(move_#i.x, -move_#i.y)*mult_#i*ballpos_#i.w;
	-- ]]
	-- local final = ""
	-- for i=1, 3 do
	  -- final = final .. s:gsub("#i", i) .. "\n"
	-- end

	-- postfx.append(final,
	  -- "// sample the original color =================================================================================",
	  -- "data/shaders/post_final.frag"
	-- )

end

--Adding shader stuff for lighting of corridor boss
if HasFlagPersistent("nee_ear_boss") then
	replace_value("data/shaders/post_final.frag", 
	[[varying vec2 tex_coord_fogofwar%;]], 
	[[varying vec2 tex_coord_fogofwar;
uniform vec4 bossroom_lighting;]]
	)
	
	replace_value("data/shaders/post_final.frag", 
	[[color_fg%.rgb %*%= lights%;]], 
	[[color_fg.rgb *= max(lights, bossroom_lighting.x);]]
	)
end

--Adding shrinking zoom in shader
if not HasFlagPersistent("ned_wizard_tiny") then
	replace_value("data/shaders/post_final.frag", 
	[[varying vec2 tex_coord_fogofwar%;]], 
	[[varying vec2 tex_coord_fogofwar;
uniform vec4 zoom_in_amount;]]
	)

	replace_value("data/shaders/post_final.frag", 
	[[vec2 tex_coord_glow %= tex_coord_glow_%;]], 
	[[vec2 tex_coord_glow = tex_coord_glow_;

// MY ADDITION =================================
	float zoom_screen_amount = 1.0;
	if ( zoom_in_amount.x <= 1.0 ) {
		zoom_screen_amount = zoom_in_amount.x;
	}
	vec2 zoom = vec2(zoom_screen_amount,zoom_screen_amount); //where zoom_in_amount is a number between 0 and 1
	vec2 center = vec2(0.5,0.5);
	tex_coord = (tex_coord*zoom) + (center*(vec2(1.0,1.0)-zoom));
	tex_coord_y_inverted = vec2( (tex_coord_y_inverted.x*zoom.x)+(center.x*(1.0-zoom.x)), (tex_coord_y_inverted.y*zoom.y)+(center.y*(1.0-zoom.y)) );
	tex_coord_glow = (tex_coord_glow*zoom) + (center*(vec2(1.0,1.0)-zoom));]]
	)
GameSetPostFxParameter("zoom_in_amount", 1.0, 0, 0, 0)

end

--Adding Platoon or Titan Tusk to Parallel Worlds

replace_value("data/scripts/biome_scripts.lua", 
[[if %( r %>%= 98 %) then]], 
[[local enemy_table = {}
if not HasFlagPersistent("ned_platoon") then
	table.insert(enemy_table, "platoon")
end
if not HasFlagPersistent("ned_elephant_robot") then
	table.insert(enemy_table, "elephant_robot")
end
local random_val = Random(1, #enemy_table)
local enemy = enemy_table[random_val]
	
if ( r >= 100 ) and ( #enemy_table > 0 ) then
	EntityLoad( "data/entities/animals/" .. enemy .. ".xml", x + rx, y )
elseif ( r >= 98 ) then]]
)

if not HasFlagPersistent("ned_peeper") then
	if not HasFlagPersistent("ned_wandcave_enemies") then
		replace_value("data/scripts/biomes/wandcave.lua", 
		[[function spawn%_lamp%(x%, y%)]], 
		[[function spawn_lamp(x, y)
			-- SetRandomSeed( GameGetFrameNum(), x + y )
			-- if Random(1,2) == 1 then
				EntityLoad( "data/entities/animals/peeper.xml", x, y )
			-- end]]
		)
	end
	if not HasFlagPersistent("ned_pyramid_enemies") then
		replace_value("data/scripts/biomes/pyramid.lua", 
		[[function spawn%_lamp2%(x%, y%)]], 
		[[function spawn_lamp2(x, y)
			-- SetRandomSeed( GameGetFrameNum(), x + y )
			-- if Random(1,3) == 1 then
				EntityLoad( "data/entities/animals/peeper.xml", x, y )
			-- end]]
		)
	end
	if not HasFlagPersistent("ned_crypt_enemies") then
		replace_value("data/scripts/biomes/crypt.lua", 
		[[function spawn%_lamp%(x%, y%)]], 
		[[function spawn_lamp(x, y)
			-- SetRandomSeed( GameGetFrameNum(), x + y )
			-- if Random(1,2) == 1 then
				EntityLoad( "data/entities/animals/peeper.xml", x, y )
			-- end]]
		)
	end
end

--Patching Disc runestone (THIS HAS BEEN FIXED BY NOLLA)

-- Please note that I'm adding % before the ( or ) so that they count as literal characters, not anything related to the code.
-- replace_value("data/scripts/items/runestones/runestone_disc.lua", 
-- [[shoot_projectile_from_projectile%( projectile_id, "data/entities/projectiles/deck/disc_bullet.xml", px, py, vel_x, vel_y %)]], 
-- [[local projectile_component = EntityGetFirstComponent(projectile_id, "ProjectileComponent")
-- mWhoShot = ComponentGetValue2(projectile_component, "mWhoShot")

-- local lua_comps = EntityGetComponent(mWhoShot, "LuaComponent") or {}

-- local found = false

-- for i, comp in ipairs(lua_comps) do
	-- if ComponentGetValue2(comp, "script_shot") ~= "" and ComponentGetValue2(comp, "script_shot") ~= "mods/raksa/files/powers/correct_friendly_fire.lua" then
		-- found = true
		-- break
	-- end        
-- end

-- if found then
	-- shoot_projectile( projectile_id, "data/entities/projectiles/deck/disc_bullet.xml", px, py, vel_x, vel_y )
-- else
	-- shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/disc_bullet.xml", px, py, vel_x, vel_y )
-- end]]
-- )

-- --Patching Fireball runestone
-- replace_value("data/scripts/items/runestones/runestone_fireball.lua", 
-- [[shoot_projectile_from_projectile%( projectile_id, "data/entities/projectiles/deck/fireball.xml", px, py, vel_x, vel_y %)]], 
-- [[local projectile_component = EntityGetFirstComponent(projectile_id, "ProjectileComponent")
-- mWhoShot = ComponentGetValue2(projectile_component, "mWhoShot")

-- local lua_comps = EntityGetComponent(mWhoShot, "LuaComponent") or {}

-- local found = false

-- for i, comp in ipairs(lua_comps) do
	-- if ComponentGetValue2(comp, "script_shot") ~= "" and ComponentGetValue2(comp, "script_shot") ~= "mods/raksa/files/powers/correct_friendly_fire.lua" then
		-- found = true
		-- break
	-- end        
-- end

-- if found then
	-- shoot_projectile( projectile_id, "data/entities/projectiles/deck/fireball.xml", px, py, vel_x, vel_y )
-- else
	-- shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/fireball.xml", px, py, vel_x, vel_y )
-- end]]
-- )

-- --Patching Laser runestone
-- replace_value("data/scripts/items/runestones/runestone_laser.lua", 
-- [[shoot_projectile_from_projectile%( projectile_id, "data/entities/projectiles/deck/laser.xml", px, py, vel_x, vel_y %)]], 
-- [[local projectile_component = EntityGetFirstComponent(projectile_id, "ProjectileComponent")
-- mWhoShot = ComponentGetValue2(projectile_component, "mWhoShot")

-- local lua_comps = EntityGetComponent(mWhoShot, "LuaComponent") or {}

-- local found = false

-- for i, comp in ipairs(lua_comps) do
	-- if ComponentGetValue2(comp, "script_shot") ~= "" and ComponentGetValue2(comp, "script_shot") ~= "mods/raksa/files/powers/correct_friendly_fire.lua" then
		-- found = true
		-- break
	-- end        
-- end

-- if found then
	-- shoot_projectile( projectile_id, "data/entities/projectiles/deck/laser.xml", px, py, vel_x, vel_y )
-- else
	-- shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/laser.xml", px, py, vel_x, vel_y )
-- end]]
-- )

if ModIsEnabled("biome-plus") then
	
	if mode == "normal" or not mode then
	
		--addition of enemies to alternate biomes mod
		if not HasFlagPersistent("ned_coalmine_alt_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/irradiated_mines.lua", "data/scripts/biomes/coalmine_alt_enemies.lua" )
		end
		if not HasFlagPersistent("ned_coalmine_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/floodcave.lua", "data/scripts/biomes/coalmine_enemies.lua" )
		end
		if not HasFlagPersistent("ned_excavationsite_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/blast_pit.lua", "data/scripts/biomes/excavationsite_enemies.lua" )
		end
		if not HasFlagPersistent("ned_snowcave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/frozen_passages.lua", "data/scripts/biomes/snowcave_enemies.lua" )
		end
		if not HasFlagPersistent("ned_the_end_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/the_void.lua", "mods/new_enemies/data/scripts/biomes/the_end_enemies.lua" )
		end
		-- ModLuaFileAppend( "data/scripts/biomes/mod/floating_mountain.lua", "mods/new_enemies/data/scripts/biomes/the_sky_enemies.lua" )
		if not HasFlagPersistent("ned_fungicave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/collapsed_lab.lua", "data/scripts/biomes/fungicave_enemies.lua" )
		end
		if not HasFlagPersistent("ned_wandcave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/catacombs.lua", "data/scripts/biomes/wandcave_enemies.lua" )
		end
		if not HasFlagPersistent("ned_rainforest_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/swamp.lua", "data/scripts/biomes/rainforest_enemies.lua" )
		end
		if not HasFlagPersistent("ned_vault_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/robofactory.lua", "data/scripts/biomes/vault_enemies.lua" )
		end
		if not HasFlagPersistent("ned_crypt_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/holy_temple.lua", "data/scripts/biomes/crypt_enemies.lua" )
		end
		if not HasFlagPersistent("ned_snowcastle_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/snowvillage.lua", "data/scripts/biomes/snowcastle_enemies.lua" )
		end
		if not HasFlagPersistent("ned_sandcave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/tomb.lua", "data/scripts/biomes/sandcave_enemies.lua" )
		end
		if not HasFlagPersistent("ned_rainforest_dark_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/rainforest_wormy.lua", "data/scripts/biomes/rainforest_dark_enemies.lua" )
		end
		if not HasFlagPersistent("ned_fungiforest_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/sulfur_cave.lua", "data/scripts/biomes/fungiforest_enemies.lua" )
		end
	
	elseif mode == "easy" then
		if not HasFlagPersistent("ned_coalmine_alt_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/irradiated_mines.lua", "data/scripts/biomes/coalmine_alt_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_coalmine_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/floodcave.lua", "data/scripts/biomes/coalmine_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_excavationsite_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/blast_pit.lua", "data/scripts/biomes/excavationsite_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_snowcave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/frozen_passages.lua", "data/scripts/biomes/snowcave_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_the_end_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/the_void.lua", "mods/new_enemies/data/scripts/biomes/the_end_enemies_easy.lua" )
		end
		-- ModLuaFileAppend( "data/scripts/biomes/mod/floating_mountain.lua", "mods/new_enemies/data/scripts/biomes/the_sky_enemies_easy.lua" )
		if not HasFlagPersistent("ned_fungicave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/collapsed_lab.lua", "data/scripts/biomes/fungicave_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_wandcave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/catacombs.lua", "data/scripts/biomes/wandcave_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_rainforest_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/swamp.lua", "data/scripts/biomes/rainforest_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_vault_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/robofactory.lua", "data/scripts/biomes/vault_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_crypt_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/holy_temple.lua", "data/scripts/biomes/crypt_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_snowcastle_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/snowvillage.lua", "data/scripts/biomes/snowcastle_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_sandcave_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/tomb.lua", "data/scripts/biomes/sandcave_enemies_easy.lua" )
		end
		if not HasFlagPersistent("ned_fungiforest_enemies") then
			ModLuaFileAppend( "data/scripts/biomes/mod/sulfur_cave.lua", "data/scripts/biomes/fungiforest_enemies_easy.lua" )
		end
	end
	
	--Fixes for the giant runestones so they don't trigger script_shot each frame when enemies with script_shot are in the aura:
	
	--Patching Giga Sawblade Runestone
	replace_value("data/scripts/props/mod/runestone_disc_big.lua", 
	[[shoot_projectile_from_projectile%( projectile_id, "data/entities/projectiles/deck/disc_bullet_big.xml", px, py, vel_x/1.5, vel_y/1.5 %)]], 
    [[local projectile_component = EntityGetFirstComponent(projectile_id, "ProjectileComponent")
    mWhoShot = ComponentGetValue2(projectile_component, "mWhoShot")
    
    local lua_comps = EntityGetComponent(mWhoShot, "LuaComponent") or {}
    
    local found = false
    
    for i, comp in ipairs(lua_comps) do
        if ComponentGetValue2(comp, "script_shot") ~= "" and ComponentGetValue2(comp, "script_shot") ~= "mods/raksa/files/powers/correct_friendly_fire.lua" then
            found = true
            break
        end        
    end
    
    if found then
        shoot_projectile( projectile_id, "data/entities/projectiles/deck/disc_bullet_big.xml", px, py, vel_x, vel_y )
    else
        shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/deck/disc_bullet_big.xml", px, py, vel_x, vel_y )
    end]]
	)
	
	--Patching Plasma beam RuneStone
	replace_value("data/scripts/props/mod/runestone_laser_big.lua", 
	[[shoot_projectile_from_projectile%( projectile_id, "data/entities/projectiles/mod/orb_laseremitter_runestone.xml", px, py, vel_x/2, vel_y/2 %)]], 
    [[local projectile_component = EntityGetFirstComponent(projectile_id, "ProjectileComponent")
    mWhoShot = ComponentGetValue2(projectile_component, "mWhoShot")
    
    local lua_comps = EntityGetComponent(mWhoShot, "LuaComponent") or {}
    
    local found = false
    
    for i, comp in ipairs(lua_comps) do
        if ComponentGetValue2(comp, "script_shot") ~= "" and ComponentGetValue2(comp, "script_shot") ~= "mods/raksa/files/powers/correct_friendly_fire.lua" then
            found = true
            break
        end        
    end
    
    if found then
        shoot_projectile( projectile_id, "data/entities/projectiles/mod/orb_laseremitter_runestone.xml", px, py, vel_x/2, vel_y/2 )
    else
        shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/mod/orb_laseremitter_runestone.xml", px, py, vel_x/2, vel_y/2 )
    end]]
	)
	
	--Patching Meteor Runestone
	replace_value("data/scripts/props/mod/runestone_fireball_big.lua", 
	[[shoot_projectile_from_projectile%( projectile_id, "data/entities/projectiles/mod/meteor_runestone.xml", px, py, vel_x, vel_y %)]], 
    [[local projectile_component = EntityGetFirstComponent(projectile_id, "ProjectileComponent")
    mWhoShot = ComponentGetValue2(projectile_component, "mWhoShot")
    
    local lua_comps = EntityGetComponent(mWhoShot, "LuaComponent") or {}
    
    local found = false
    
    for i, comp in ipairs(lua_comps) do
        if ComponentGetValue2(comp, "script_shot") ~= "" and ComponentGetValue2(comp, "script_shot") ~= "mods/raksa/files/powers/correct_friendly_fire.lua" then
            found = true
            break
        end        
    end
    
    if found then
        shoot_projectile( projectile_id, "data/entities/projectiles/mod/meteor_runestone.xml", px, py, vel_x, vel_y )
    else
        shoot_projectile_from_projectile( projectile_id, "data/entities/projectiles/mod/meteor_runestone.xml", px, py, vel_x, vel_y )
    end]]
	)
end

--Lake Statue
if HasFlagPersistent("nee_lake_statue") then
	ModLuaFileAppend( "data/scripts/biomes/lake_statue.lua", "data/scripts/biomes/lake_statue_append.lua" )
end

--Add New enemies trophy in the work
if not ModIsEnabled("nightmare") then
	replace_value("data/entities/animals/boss_centipede/rewards/spawn_rewards.lua", 
	[[%-%- sun]], 
	[[if( ModIsEnabled("new_enemies") ) and not ( ModIsEnabled("nightmare") ) then
		if( spawned_n <= 0 ) then
			spawned_n = 1
		end
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_ne.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	end

	-- sun]]
	)

--Add New Enemies Trophy in the work if we're on Nightmare mode
elseif ModIsEnabled("nightmare") then
	
	replace_value("data/entities/animals/boss_centipede/rewards/spawn_rewards.lua", 
	[[%-%- sun]], 
    [[if( ModIsEnabled("nightmare") ) then
		if( spawned_n <= 0 ) then
			spawned_n = 1
		end
		entity = EntityLoad( "data/entities/animals/boss_centipede/rewards/reward_ne_nightmare.xml", x + spawned_n * 20, y - spawned_n * 10 )
		spawned_n = spawned_n + 1
	end
	
	-- sun]]
	)
end

-- Addition of enemies to Conjurer Mod:
if ModIsEnabled("raksa") then
  ModLuaFileAppend( "mods/raksa/files/scripts/lists/entity_categories.lua", "data/scripts/conjurer_mod/conjurer_list.lua" )
end

if ModIsEnabled("raksa2") then
  ModLuaFileAppend( "mods/raksa2/files/scripts/lists/entity_categories.lua", "data/scripts/conjurer_mod/conjurer_list.lua" )
end

--5 gold drop for eye bats:

function string.insert(str1, str2, pos)
    return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

function add_goldnugget_5(lua_file)
    local lua_content = ModTextFileGetContent(lua_file)
    if lua_content then
        local insertion_point = string.find(lua_content, "if.health.>.1.0.then")
        local code_to_insert = [[
            if EntityGetName(entity) == "$spider_crawler" or EntityGetName(entity) == "$larva_crawler" or EntityGetName(entity) == "$crawler_bug" or EntityGetName(entity) == "$eye_bat" or EntityGetName(entity) == "Eye Bat Birthday" or EntityGetName(entity) == "Eye Bat Pumpkin" or EntityGetName(entity) == "Eye Bat Valentines" then
                amount = 0.5
				use_goldnugget_5 = true
            end
        ]]
        if insertion_point ~= nil then
            lua_content = string.insert(lua_content, code_to_insert .. "\n", insertion_point-1)
        end

        insertion_point = string.find(lua_content, "local.money")
        code_to_insert = [[
            if EntityGetName(entity) == "$slimeshooter_golden" then
                amount = amount * 1000
            end
            if EntityGetName(entity) == "$gonha" then
                amount = amount * 10
            end
            if EntityGetName(entity) == "$summoner" then
                amount = amount * 2
            end
            if EntityGetName(entity) == "$twig" then
                amount = amount * 2
            end
            if EntityGetName(entity) == "$longleg_big" then
                amount = amount * 2
            end
            if EntityGetName(entity) == "$player_evil" then
                amount = amount * 3
            end
            if EntityGetName(entity) == "$stone_crab" then
                amount = amount * 4
            end
			if EntityGetName(entity) == "Floating Eye" then
				amount = amount / 5
			end
			if EntityGetName(entity) == "$wall_of_flesh" then
				amount = amount / 8
			end
        ]]
        if insertion_point ~= nil then
            lua_content = string.insert(lua_content, code_to_insert .. "\n", insertion_point-1)
        end

        insertion_point = string.find(lua_content, "if..trick_kill")
        code_to_insert = [[
            if EntityGetName(entity) == "Eye Bat Birthday" or EntityGetName(entity) == "Eye Bat Pumpkin" or EntityGetName(entity) == "Eye Bat Valentines" or EntityGetName(entity) == "Valentines Skeleton" or EntityGetName(entity) == "Birthday Skeleton" then
                gold_entity = "data/entities/items/pickup/bloodmoney_"
                drop_first_10 = false
            end
        ]]
        if insertion_point ~= nil then
            lua_content = string.insert(lua_content, code_to_insert .. "\n", insertion_point-1)
        end
        
        insertion_point = string.find(lua_content, "end....function.death")
        code_to_insert = [[
            while use_goldnugget_5 ~= nil and money >= 5 do
                load_gold_entity( gold_entity .. "5.xml", x, y-8, remove_timer )
                money = money - 5
            end  
        ]]
        if insertion_point ~= nil then
            lua_content = string.insert(lua_content, code_to_insert .. "\n", insertion_point-1)
        end
        
        ModTextFileSetContent(lua_file, lua_content)
    end
end
add_goldnugget_5("data/scripts/items/drop_money.lua")

--Make ceiling enemies drop gold from their center:
replace_value("data/scripts/game_helpers.lua", 
[[	local gold%_entity %= EntityLoad%( entity%_filename%, x%, y %)]], 
[[	local ents = EntityGetInRadius( x, y + 8, 100)
	for i, ent in ipairs(ents or {}) do
		if ( EntityGetName(ent) == "$dripper" ) then
			y = y + 19
			break
		elseif EntityGetName(ent) == "$stalker" then
			local variable_component = EntityGetFirstComponentIncludingDisabled(ent, "VariableStorageComponent")
			if ( variable_component ~= nil ) and ( variable_component > 0 ) then
				local value = ComponentGetValue2(variable_component, "value_int")
				if value == 2 then
					y = y + 19
					break
				end
			end
		elseif EntityGetName(ent) == "$mutant_blob" then
			local variable_component = EntityGetFirstComponentIncludingDisabled(ent, "VariableStorageComponent")
			if ( variable_component ~= nil ) and ( variable_component > 0 ) then
				local value = ComponentGetValue2(variable_component, "value_int")
				if value == 2 then
					y = y + 9.5
					break
				end
			end
		end
	end
	local gold_entity = EntityLoad( entity_filename, x, y )]]
)

--Quin 50% chance for spawn:

-- if not GameHasFlagRun( "quin_spawned" ) and not GameHasFlagRun( "quin_excavationsite" ) and not GameHasFlagRun( "quin_snowcave" ) then
    -- local a1, a2, a3, a4, a5, a6 = GameGetDateAndTimeUTC()
    -- SetRandomSeed( a1*a2*a3*a4*a5*a6, a1*a2*a3*a4*a5*a6 )
    -- if Random(1,2) == 1 then
        -- GameAddFlagRun( "quin_excavationsite" )
    -- else
        -- GameAddFlagRun( "quin_snowcave" )
    -- end
-- end

--Materials that damage function:

function add_materials_that_damage(entity_id, materials)
  local damage_model_component = EntityGetFirstComponent(entity_id, "DamageModelComponent")
  if damage_model_component ~= nil then
    -- Store all old values
    local old_values = {}
    local old_damage_multipliers = {}
    for k,v in pairs(ComponentGetMembers(damage_model_component)) do
      if k == "ragdoll_fx_forced" then
        v = ComponentGetValue2(damage_model_component, k)
      end
      old_values[k] = v
      -- print(k, v)
    end
    for k,_ in pairs(ComponentObjectGetMembers(damage_model_component, "damage_multipliers")) do
      old_damage_multipliers[k] = ComponentObjectGetValue(damage_model_component, "damage_multipliers", k)
    end

    -- Rebuild the comma separated string
    for material, damage in pairs(materials) do
      old_values.materials_that_damage = old_values.materials_that_damage .. "," .. material
      old_values.materials_how_much_damage = old_values.materials_how_much_damage .. "," .. damage
    end

    EntityRemoveComponent(entity_id, damage_model_component)
    damage_model_component = EntityAddComponent(entity_id, "DamageModelComponent", old_values)

    ComponentSetValue2(damage_model_component, "ragdoll_fx_forced", old_values.ragdoll_fx_forced)

    for k, v in pairs(old_damage_multipliers) do
      ComponentObjectSetValue(damage_model_component, "damage_multipliers", k, v)
    end
  end
end

--Addition of Freeze Field Materials:

-- local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
-- local xml_content = ModTextFileGetContent("data/entities/misc/perks/freeze_field.xml")
-- local handler = xml2lua.parse(xml_content)
-- handler.root.Entity.MagicConvertMaterialComponent = handler.root.Entity.MagicConvertMaterialComponent or {}
-- table.insert(handler.root.Entity.MagicConvertMaterialComponent, {
  -- _attr = {
	-- from_material="radioactive_liquid_blue",
	-- to_material="ice_radioactive_static",
	-- steps_per_frame="20",
	-- loop="1",
	-- is_circle="1",
	-- radius="20",
  -- }
-- })
-- table.insert(handler.root.Entity.MagicConvertMaterialComponent, {
  -- _attr = {
	-- from_material="radioactive_goo",
	-- to_material="ice_radioactive_static",
	-- steps_per_frame="20",
	-- loop="1",
	-- is_circle="1",
	-- radius="20",
  -- }
-- })
-- local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
-- ModTextFileSetContent("data/entities/misc/perks/freeze_field.xml", xml_output)

--Addition of Tags to some entities:

function add_tags_seamine()

	local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
	local xml_content = ModTextFileGetContent("data/entities/props/physics_seamine.xml")
	local handler = xml2lua.parse(xml_content)
	handler.root.Entity._attr = handler.root.Entity._attr or {}
	if handler.root.Entity._attr.tags then
	  handler.root.Entity._attr.tags = handler.root.Entity._attr.tags .. ",erasable"
	else
	  handler.root.Entity._attr.tags = "erasable"
	end
	local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
	ModTextFileSetContent("data/entities/props/physics_seamine.xml", xml_output)

end

function add_tags_crumbling_earth_projectile()

	local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
	local xml_content = ModTextFileGetContent("data/entities/misc/crumbling_earth_projectile.xml")
	local handler = xml2lua.parse(xml_content)
	handler.root.Entity._attr = handler.root.Entity._attr or {}
	if handler.root.Entity._attr.tags then
	  handler.root.Entity._attr.tags = handler.root.Entity._attr.tags .. ",erasable"
	else
	  handler.root.Entity._attr.tags = "erasable"
	end
	local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
	ModTextFileSetContent("data/entities/misc/crumbling_earth_projectile.xml", xml_output)

end

function add_tags_crumbling_earth()

	local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
	local xml_content = ModTextFileGetContent("data/entities/projectiles/deck/crumbling_earth.xml")
	local handler = xml2lua.parse(xml_content)
	handler.root.Entity._attr = handler.root.Entity._attr or {}
	if handler.root.Entity._attr.tags then
	  handler.root.Entity._attr.tags = handler.root.Entity._attr.tags .. ",erasable"
	else
	  handler.root.Entity._attr.tags = "erasable"
	end
	local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
	ModTextFileSetContent("data/entities/projectiles/deck/crumbling_earth.xml", xml_output)

end

function add_tags_crumbling_earth_effect()

	local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
	local xml_content = ModTextFileGetContent("data/entities/projectiles/deck/crumbling_earth_effect.xml")
	local handler = xml2lua.parse(xml_content)
	handler.root.Entity._attr = handler.root.Entity._attr or {}
	if handler.root.Entity._attr.tags then
	  handler.root.Entity._attr.tags = handler.root.Entity._attr.tags .. ",erasable"
	else
	  handler.root.Entity._attr.tags = "erasable"
	end
	local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
	ModTextFileSetContent("data/entities/projectiles/deck/crumbling_earth_effect.xml", xml_output)

end

-- function add_tags_nuke()

	-- local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
	-- local xml_content = ModTextFileGetContent("data/entities/projectiles/deck/nuke.xml")
	-- local handler = xml2lua.parse(xml_content)
	-- handler.root.Entity._attr = handler.root.Entity._attr or {}
	-- if handler.root.Entity._attr.tags then
	  -- handler.root.Entity._attr.tags = handler.root.Entity._attr.tags .. ",erasable"
	-- else
	  -- handler.root.Entity._attr.tags = "erasable"
	-- end
	-- local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
	-- ModTextFileSetContent("data/entities/projectiles/deck/nuke.xml", xml_output)

-- end

function add_tags_rocks()

	for loop = 1,4 do

		local xml2lua = dofile("mods/new_enemies/files/xml2lua_library/xml2lua.lua")
		local xml_content = ModTextFileGetContent("data/entities/props/physics_stone_0" .. loop .. ".xml")
		local handler = xml2lua.parse(xml_content)
		if handler.root.Entity._attr.tags then
		  handler.root.Entity._attr.tags = handler.root.Entity._attr.tags .. ",erasable"
		else
		  handler.root.Entity._attr.tags = "erasable"
		end
		local xml_output = xml2lua.toXml(handler.root, "Entity", 0)
		ModTextFileSetContent("data/entities/props/physics_stone_0" .. loop .. ".xml", xml_output)
		
	end
	
end

add_tags_seamine()
add_tags_crumbling_earth_projectile()
-- add_tags_crumbling_earth()
-- add_tags_crumbling_earth_effect()
add_tags_rocks()
-- add_tags_nuke()


--Single enemy per biome spawn script:
function add_delete_function(lua_file)
    local lua_content = ModTextFileGetContent(lua_file)
    if lua_content then
        local insertion_point = string.find(lua_content, "return.v")
        local code_to_insert = [[
            if v.delete ~= nil then
                v.delete()
            end
        ]]
        lua_content = string.insert(lua_content, code_to_insert .. "\n", insertion_point-1)    
        ModTextFileSetContent(lua_file, lua_content)
    end
end
add_delete_function("data/scripts/director_helpers.lua")

--Remove muzzle flashes during mwyah Fight

if HasFlagPersistent("nee_mwyah") then
	--This is for mwyah's platforming stage
	--Modify gun.lua a bit for temporary removal of recoil from wands
	ModLuaFileAppend( "data/scripts/gun/gun.lua", "data/scripts/misc/gun_append.lua" )
	
	function remove_muzzle(file_path)
		replace_value(file_path, 
		[[<%/Entity>]], 
		[[<LuaComponent
			script_source_file="data/scripts/misc/muzzle_negate.lua"
			execute_every_n_frame="1"
			execute_on_added="1"
			>
		</LuaComponent>
		</Entity>]]
		)
		
		replace_value(file_path, 
		[[is%_emitting%=%"1%"]], 
		[[is_emitting="0"]]
		)
	end
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_air.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_circular.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_circular_blue.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_circular_large_pink.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_circular_large_pink_reverse.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_circular_pink.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_large.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_large_pink.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_laser.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_laser_green.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_launcher.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_launcher_large.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_large.xml")	
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_launcher.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_launcher_blue.xml")	
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_launcher_holy.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_launcher_large.xml")	
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_launcher_large_blue.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_launcher_trailer.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_medium.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_magic_small.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_medium.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_pink.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_small.xml")
	remove_muzzle("data/entities/particles/muzzle_flashes/muzzle_flash_small_pink.xml")
end

--Infinite power plant chasm boss

if not HasFlagPersistent("ned_mechahub") then
	replace_value("data/scripts/biomes/robobase.lua", 
		[[%-%- actual functions that get called from the wang generator]], 
		[[-- actual functions that get called from the wang generator
	RegisterSpawnFunction( 0xffffeedd, "init" )
	function init(x, y, w, h)
		local world_width, world_height = BiomeMapGetSize()

		local target_x = -16641
		local target_y = 20000

		local w = BiomeMapGetSize()
		local px = GetParallelWorldPosition(x, y)
		local offset_x = target_x + px * (w * 512 )

		if offset_x >= x and offset_x <= (x + 512) and target_y >= y and target_y <= (y + 512) then
			-- Spawn the entity at the target coordinates with an offset if necessary
			EntityLoad("data/entities/buildings/mechahub_spawner.xml", offset_x, target_y)
		end
	end]]
	)
end

local Mask_id = 0
local Downscale = 16

--Hellion heat shimmering effect!
if not HasFlagPersistent("ned_hellion") then

	-- Pass the mask texture to the shader as a parameter
	-- GameSetPostFxTextureParameter("maskTexture", maskTexturePath, 0, 0, false)

	local maskid, w, h = ModImageMakeEditable( "shader_mask.png", 427/Downscale, 242/Downscale)
	Mask_id = maskid
	
	-- GlobalsSetValue("new_enemies_mod_heat_shader_texture_id", mask_id2)

    dofile_once("mods/new_enemies/files/shader_utilities.lua")

    local s = [[uniform sampler2D maskTexture; // Mask texture uniform
uniform vec2 maskTextureSize;
uniform float noise_time;]]
    postfx.append(s .. "\n",
    "uniform sampler2D tex_fog;",
    "data/shaders/post_final.frag"
    )
	
    local s = [[// Sample heat mask
    float heat = texture2D(maskTexture, tex_coord).r;

    vec4 noise_perlin_x = texture2D(tex_perlin_noise, world_pos * 0.0004 + vec2(0.0, noise_time * 0.005));
    vec4 noise_perlin_y = texture2D(tex_perlin_noise, world_pos * 0.0004 + vec2(0.0, (noise_time + 10.0) * 0.005));

    // Calculate UV offset for heat mask
    vec2 uv_offset = vec2(
        heat * sin((noise_perlin_x.g * 120.0) + (time * 12.0)) * 0.0015,
        heat * sin((noise_perlin_y.g * 120.0) + (time * 12.0)) * 0.0015 * (SCREEN_W / SCREEN_H)
	) / camera_inv_zoom_ratio;

    // Change the intensity of the offset based on the heat mask color
    uv_offset = ( uv_offset * 1.4 ) * heat ;]]
	
    postfx.append(s .. "\n",
    [[// sample the original color =================================================================================]],
    "data/shaders/post_final.frag"
    )
	
    postfx.replace([[vec3 color%    %= texture2D%(tex%_bg%, tex%_coord%)%.rgb%;]],
    [[tex_coord += uv_offset;
	vec3 color    = texture2D(tex_bg, tex_coord).rgb;]],
    "data/shaders/post_final.frag"
    )
	
    -- local s = [[    gl_FragColor.r = texture2D(maskTexture, tex_coord_).r;]]
    -- postfx.append(s .. "\n",
    -- [[gl%_FragColor%.rgb  %= color%;]],
    -- "data/shaders/post_final.frag"
    -- )
	
    -- dofile_once("mods/new_enemies/files/shader_utilities.lua")

    -- local s = "    uniform vec4 heatmon_pos; // x, y, radius, intensity"
    -- postfx.append(s .. "\n",
    -- "uniform sampler2D tex_fog;",
    -- "data/shaders/post_final.frag"
    -- )

    -- s = [[
        -- vec4 noise_perlin_x = texture2D(tex_perlin_noise, world_pos * 0.0004 + vec2(0.0, noise_time * 0.005));
        -- vec4 noise_perlin_y = texture2D(tex_perlin_noise, world_pos * 0.0004 + vec2(0.0, (noise_time + 10.0) * 0.005));

        -- // Calculate the distance from the heat monster position
        -- vec2 heatmon_diff = vec2(
            -- (world_pos.x - heatmon_pos.x) / world_viewport_size.x,
            -- (world_pos.y - heatmon_pos.y) / world_viewport_size.y
        -- );
        -- float heatmon_dist = length(heatmon_diff);
        -- float heatmon_radius = heatmon_pos.z;
        -- float heatmon_intensity = heatmon_pos.w;

        -- // Apply heat shimmer effect only if within the radius
        -- if (heatmon_dist < (heatmon_radius / world_viewport_size.x)) {
            -- // Calculate the amount of distortion based on the distance
            -- float distortion_factor = (1.0 - (heatmon_dist / (heatmon_radius / world_viewport_size.x))) * heatmon_intensity;

            -- // Calculate the heat distortion offset
            -- vec2 heat_distortion_offset = vec2(
                -- distortion_factor * sin((noise_perlin_x.g * 120.0) + (time * 12.0)) * 0.0015,
                -- distortion_factor * sin((noise_perlin_y.g * 120.0) + (time * 12.0)) * 0.0015 * (SCREEN_W / SCREEN_H)
            -- ) / camera_inv_zoom_ratio;

            -- // Apply the distortion offset
            -- tex_coord = tex_coord + heat_distortion_offset;
            -- tex_coord_y_inverted += vec2(heat_distortion_offset.x, -heat_distortion_offset.y);
            -- tex_coord_glow += vec2(heat_distortion_offset.x, -heat_distortion_offset.y);
        -- }
    -- ]]

    -- postfx.append(s .. "\n",
      -- "// sample the original color =================================================================================",
      -- "data/shaders/post_final.frag"
    -- )
	
	--Hellion append to lava lake_deep
	replace_value("data/scripts/biomes/hills.lua", 
	[[function init%(x%, y%, w%, h%)]], 
	[[function init(x, y, w, h)
    local biome_name = BiomeMapGetName(x, y)
    if biome_name == "$biome_lava" then
        -- Define the target positions as tables
        local target_positions = {
            {x = -5445, y = 15739},
            {x = -3188, y = 14000}
        }

        -- Define the dimensions of the area
        local area_width = 512
        local area_height = 512

        -- Calculate the world width using the GetParallelWorldPosition function
        local world_width, world_height = BiomeMapGetSize()

        -- Iterate over each target position
        for _, target in ipairs(target_positions) do
            local target_x = target.x
            local target_y = target.y

            -- Check all relevant parallel worlds (normal world, first east, and first west)
			local w = BiomeMapGetSize()
			local px = GetParallelWorldPosition(x, y)
			local offset_x = target_x + px * (w * 512 )

			-- Check if the target coordinates are within the specified area
			if offset_x >= x and offset_x <= (x + area_width) and target_y >= y and target_y <= (y + area_height) then
				-- Spawn the entity at the target coordinates with an offset if necessary
				EntityLoad("data/entities/buildings/hellion_spawner.xml", offset_x, target_y)
				break  -- Exit the loop once the entity is spawned
			end
        end
    end]])
end

--Make hellion spot respawn for ng+
--Reset bosses on registry
replace_value("data/scripts/newgame_plus.lua", 
[[-- Load the actual biome map]], 
[[-- Load the actual biome map
	GlobalsSetValue("new_enemies_hellion_spawned", "")
	local boss_counter = tonumber(GlobalsGetValue("new_enemies_mod_boss_counter", "1"))
	if boss_counter > 0 then
		for i = 1, boss_counter - 1 do
			local val = GlobalsGetValue("new_enemies_mod_boss_"..i)
			if val and val ~= "" then	
				GlobalsSetValue(val, "")
			end
		end
	end
	GlobalsSetValue("new_enemies_mwyah_arena_pos_x", "")
	GlobalsSetValue("new_enemies_mwyah_arena_pos_y", "")
	GlobalsSetValue("new_enemies_mod_boss_counter", "1")
	
	--essences
	GlobalsSetValue("new_enemies_essence_air_boss_spawned", "")
	GlobalsSetValue("new_enemies_essence_earth_boss_spawned", "")
	GlobalsSetValue("new_enemies_essence_alc_boss_spawned", "")
	GlobalsSetValue("new_enemies_essence_hell_boss_spawned", "")
	
	--moons
	GlobalsSetValue("new_enemies_moon_boss_spawned", "")
	GlobalsSetValue("new_enemies_dark_moon_boss_spawned", "")
	
	GlobalsSetValue("new_enemies_mechahub_spawned", "")
	GlobalsSetValue("new_enemies_desert_skull_loaded", "")
	GlobalsSetValue("new_enemies_desert_skull_spawned", "")
	GlobalsSetValue("ne_drill_giant_spawned", "")
	
	--other
	GlobalsSetValue("new_enemies_evil_player_to_follow", "")
	GlobalsSetValue("new_enemies_player_evil_active", "0")
	GlobalsSetValue("new_enemies_mwyah_spawned", "")
	
	GlobalsSetValue("new_enemies_ritualists_spawned", "")
	GlobalsSetValue("new_enemies_peasants_spawned", "")
	GlobalsSetValue("new_enemies_camels_spawned", "")
	GlobalsSetValue("new_enemies_ritualists_pw", "0")
	GlobalsSetValue("new_enemies_peasants_pw", "0")
	GlobalsSetValue("new_enemies_camels_pw", "0")
	
	--orb rooms
	GlobalsSetValue("new_enemies_orb2_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb3_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb4_boss_spawned", "")
	GlobalsSetValue("new_enemies_hydra_head2_spawned", "")
	GlobalsSetValue("new_enemies_hydra_head3_spawned", "")
	GlobalsSetValue("new_enemies_orb5_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb6_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb7_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb8_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb9_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb10_boss_spawned", "")
	GlobalsSetValue("new_enemies_orb_pyramid_boss_spawned", "")
	GlobalsSetValue("new_enemies_fungus_essence_boss_spawned", "")
	GlobalsSetValue("new_enemies_eel_orb_boss_spawned", "")
	GlobalsSetValue("new_enemies_cyclops_orb_boss_spawned", "")
	GlobalsSetValue("new_enemies_ear_orb_boss_spawned", "")
	GlobalsSetValue("new_enemies_pit_boss_spawned", "")]]
)

function clearMask()
  for i = 0, 427/Downscale do
    for j = 0, 242/Downscale do
      ModImageSetPixel( Mask_id, i, j, 0 )
    end
  end
end

function world_to_shader_UV(x, y)
  local  width, height = 427.0, 242.0
  local cam_x, cam_y = GameGetCameraPos()
  local sx = (x - cam_x + width / 2) / width
  local sy = (y - cam_y + height / 2) / height  

  sy = 1 - sy

  return sx, sy
end

local times_executed = 0
local wait_frames = 1
local boss_sync_initialized = false
local peer_count = 0
local rpc = nil

if ModIsEnabled("quant.ew") then
    ModLuaFileAppend("mods/quant.ew/files/api/extra_modules.lua", "mods/new_enemies/files/ew/module.lua")
end

--Mod Settings
function OnWorldPreUpdate()
	local ne_gui_enabled = get_setting("new_enemies.show_button")
	if ne_gui_enabled then
		dofile("data/scripts/enemies_gui/enemies.lua")
	end
	if times_executed == nil then
		times_executed = 0
	end
	times_executed = times_executed + 1
	
	if not HasFlagPersistent("ned_hellion") then
		if times_executed % 30 == 0 then
			-- local cam_x, cam_y = GameGetCameraPos()
			--Shader mask
			-- local sx, sy = math.random(0, 192), math.random(0, 108)
			-- ModImageSetPixel( Mask_id, sx, sy, 4294967295 )
			-- local px, py = math.sin( GameGetFrameNum() / 60 ), math.cos( GameGetFrameNum() / 60 )
			
			local projectiles = EntityGetWithTag("hellion")
			if projectiles ~= nil then
				if ( #projectiles == 0 ) and ( ( lastProjectiles or 0 ) > 0 ) then
					clearMask()
				elseif #projectiles > 0 then
					clearMask()
				end
				
				lastProjectiles = #projectiles

				if #projectiles > 0 then
					hellion_present = true
					-- Radius of effect (in Noita cell units)
					local r = 200 / Downscale

					for k, v in pairs(projectiles) do
						local x, y = EntityGetTransform(v)
						x, y = world_to_shader_UV(x, y)

						x = x * 427/Downscale
						y = y * 242/Downscale

						-- Write white pixels to the mask texture in a circle around the projectile
						for i = -r, r do
							if x + i >= 0 and x + i <= 427/Downscale then
								for j = -r, r do
									if y + j >= 0 and y + j <= 242/Downscale then
										local center_x = math.floor(x + i + 0.5) + 0.5
										local center_y = math.floor(y + j + 0.5) + 0.5
										local dx = x - center_x
										local dy = y - center_y
										local dist = math.sqrt( dx^2 + dy^2 )
										if dist <= r then
											local currentColor = ModImageGetPixel( Mask_id, x + i, y + j )
											if currentColor ~= 255 then
												local newColor = 255 - ((dist/r)^4) * 255
												local color = math.min(currentColor + newColor, 255)
												ModImageSetPixel( Mask_id, x + i, y + j, color )
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	--INSTEAD I WILL USE GLOBALS TO HAVE A BOSS REGISTRY
	if GlobalsGetValue("TEMPLE_SPAWN_GUARDIAN", "0") ~= 1 then
		if ( not HasFlagPersistent("ned_necromancer_omega") ) or ( not HasFlagPersistent("ned_jungle_deity") ) or ( not HasFlagPersistent("ned_technomancer") ) or ( not HasFlagPersistent("ned_necromancer_cultist") ) or  ( not HasFlagPersistent("ned_necromancer_ice") ) then
			local ws = GameGetWorldStateEntity()
			if ( ws ~= nil ) and ( ws > 0 ) then
				if ( tonumber(GlobalsGetValue("SKOUDE_DEATHS", "0")) >= 6 ) then
					GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "1" )
				end
			end
		end
	end
	
	function get_distance_squared(dx, dy, dx2, dy2)
		local dx_ = dx - dx2
		local dy_ = dy - dy2
		return dx_ * dx_ + dy_ * dy_
	end

	local cx, cy = GameGetCameraPos()
	
	if ModIsEnabled("quant.ew") then
		local peers = EntityGetWithTag("ew_peer")
		if ( peers ~= nil ) and ( #peers > 0 ) then
			if peer_count ~= #peers then
				local orb2_global = GlobalsGetValue("new_enemies_orb2_boss_spawned", "")
				if orb2_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb2_boss_spawned", orb2_global)
				end
				local orb3_global = GlobalsGetValue("new_enemies_orb3_boss_spawned", "")
				if orb3_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb3_boss_spawned", orb3_global)
				end
				local orb4_global = GlobalsGetValue("new_enemies_orb4_boss_spawned", "")
				if orb4_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb4_boss_spawned", orb4_global)
				end
				local hydra_head2_global = GlobalsGetValue("new_enemies_hydra_head2_spawned", "")
				if hydra_head2_global ~= "" then
					CrossCall("sync_global", "hydra_head2_global", hydra_head2_global)
				end
				local hydra_head3_global = GlobalsGetValue("new_enemies_hydra_head3_spawned", "")
				if hydra_head3_global ~= "" then
					CrossCall("sync_global", "hydra_head3_global", hydra_head3_global)
				end
				local orb5_global = GlobalsGetValue("new_enemies_orb5_boss_spawned", "")
				if orb5_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb5_boss_spawned", orb5_global)
				end
				local orb6_global = GlobalsGetValue("new_enemies_orb6_boss_spawned", "")
				if orb6_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb6_boss_spawned", orb6_global)
				end
				local orb7_global = GlobalsGetValue("new_enemies_orb7_boss_spawned", "")
				if orb7_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb7_boss_spawned", orb7_global)
				end
				local orb8_global = GlobalsGetValue("new_enemies_orb8_boss_spawned", "")
				if orb8_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb8_boss_spawned", orb8_global)
				end
				local orb9_global = GlobalsGetValue("new_enemies_orb9_boss_spawned", "")
				if orb9_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb9_boss_spawned", orb9_global)
				end
				local orb10_global = GlobalsGetValue("new_enemies_orb10_boss_spawned", "")
				if orb10_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb10_boss_spawned", orb10_global)
				end
				local orb_pyramid_global = GlobalsGetValue("new_enemies_orb_pyramid_boss_spawned", "")
				if orb_pyramid_global ~= "" then
					CrossCall("sync_global", "new_enemies_orb_pyramid_boss_spawned", orb_pyramid_global)
				end
				local fungus_essence_global = GlobalsGetValue("new_enemies_fungus_essence_boss_spawned", "")
				if fungus_essence_global ~= "" then
					CrossCall("sync_global", "new_enemies_fungus_essence_boss_spawned", fungus_essence_global)
				end
				local eel_boss_global = GlobalsGetValue("new_enemies_eel_orb_boss_spawned", "")
				if eel_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_eel_orb_boss_spawned", eel_boss_global)
				end
				
				local cyclops_boss_global = GlobalsGetValue("new_enemies_cyclops_orb_boss_spawned", "")
				if cyclops_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_cyclops_orb_boss_spawned", cyclops_boss_global)
				end
				
				local ear_boss_global = GlobalsGetValue("new_enemies_ear_orb_boss_spawned", "")
				if ear_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_ear_orb_boss_spawned", ear_boss_global)
				end
				
				local hellion_boss_global = GlobalsGetValue("new_enemies_hellion_spawned", "")
				if hellion_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_hellion_spawned", hellion_boss_global)
				end
				
				local essence_air_boss_global = GlobalsGetValue("new_enemies_essence_air_boss_spawned", "")
				if essence_air_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_essence_air_boss_spawned", essence_air_boss_global)
				end
				
				local essence_earth_boss_global = GlobalsGetValue("new_enemies_essence_earth_boss_spawned", "")
				if essence_earth_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_essence_earth_boss_spawned", essence_earth_boss_global)
				end
				
				local essence_alc_boss_global = GlobalsGetValue("new_enemies_essence_alc_boss_spawned", "")
				if essence_alc_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_essence_alc_boss_spawned", essence_alc_boss_global)
				end
				
				local essence_hell_boss_global = GlobalsGetValue("new_enemies_essence_hell_boss_spawned", "")
				if essence_hell_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_essence_hell_boss_spawned", essence_hell_boss_global)
				end
				
				local moon_boss_global = GlobalsGetValue("new_enemies_moon_boss_spawned", "")
				if moon_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_moon_boss_spawned", moon_boss_global)
				end
				
				local dark_moon_boss_global = GlobalsGetValue("new_enemies_dark_moon_boss_spawned", "")
				if dark_moon_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_dark_moon_boss_spawned", dark_moon_boss_global)
				end
				
				local mechahub_boss_global = GlobalsGetValue("new_enemies_mechahub_spawned", "")
				if mechahub_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_mechahub_spawned", mechahub_boss_global)
				end
				
				local desert_skull_global = GlobalsGetValue("new_enemies_desert_skull_loaded", "")
				if desert_skull_global ~= "" then
					CrossCall("sync_global", "new_enemies_desert_skull_loaded", desert_skull_global)
				end
				
				local desert_skull_spawned_global = GlobalsGetValue("new_enemies_desert_skull_spawned", "")
				if desert_skull_spawned_global ~= "" then
					CrossCall("sync_global", "new_enemies_desert_skull_spawned", desert_skull_spawned_global)
				end
				
				
				local val1 = GlobalsGetValue("new_enemies_mwyah_arena_pos_x")
				if val1 and val1 ~= "" then
					CrossCall("sync_global", "new_enemies_mwyah_arena_pos_x", val1)
				end
				local val2 = GlobalsGetValue("new_enemies_mwyah_arena_pos_y")
				if val2 and val2 ~= "" then
					CrossCall("sync_global", "new_enemies_mwyah_arena_pos_y", val2)
				end
				local pit_boss_global = GlobalsGetValue("new_enemies_pit_boss_spawned", "")
				if pit_boss_global ~= "" then
					CrossCall("sync_global", "new_enemies_pit_boss_spawned", pit_boss_global)
				end
				
				local fg1 = GlobalsGetValue("new_enemies_evil_player_to_follow", "")
				if fg1 ~= "" then
					CrossCall("sync_global", "new_enemies_evil_player_to_follow", fg1)
				end
				local fg2 = GlobalsGetValue("new_enemies_player_evil_active", "")
				if fg2 ~= "" then
					CrossCall("sync_global", "new_enemies_player_evil_active", fg2)
				end
				local mwyah = GlobalsGetValue("new_enemies_mwyah_spawned", "")
				if mwyah ~= "" then
					CrossCall("sync_global", "new_enemies_mwyah_spawned", mwyah)
				end
				
				local ritualists = GlobalsGetValue("new_enemies_ritualists_spawned", "")
				if ritualists ~= "" then
					CrossCall("sync_global", "new_enemies_ritualists_spawned", ritualists)
				end
				local peasants = GlobalsGetValue("new_enemies_peasants_spawned", "")
				if peasants ~= "" then
					CrossCall("sync_global", "new_enemies_peasants_spawned", peasants)
				end
				local camels = GlobalsGetValue("new_enemies_camels_spawned", "")
				if camels ~= "" then
					CrossCall("sync_global", "new_enemies_camels_spawned", camels)
				end
				
				peer_count = #peers
			end
		end
	end

	local players = {}
	local player = EntityGetWithName( "DEBUG_NAME:player" )
	if ( player ~= nil ) and ( player > 0 ) then
		players = {player}
	else
		local polymorphed_player = EntityGetClosestWithTag(cx, cy, "polymorphed_player")
		if ( polymorphed_player ~= nil ) and ( polymorphed_player > 0 ) then
			players = {polymorphed_player}
		end
	end
	local px = cx
	local py = cy
	if #players > 0 then
		px, py, prot, psx  = EntityGetTransform(players[1])
	end
	
	local orbcount = GameGetOrbCountThisRun()
	local boss_counter = tonumber(GlobalsGetValue("new_enemies_mod_boss_counter", "1"))

	local bosses = EntityGetWithTag("boss_registry") or {}
	for _, boss in ipairs(bosses) do
		local bx, by = EntityGetTransform(boss)
		local dist = get_distance_squared(bx, by, cx, cy)

		local components = EntityGetComponent(boss, "VariableStorageComponent") or {}
		local boss_id = nil

		for _, comp in ipairs(components) do
			if ComponentGetValue(comp, "name") == "boss_identifier" then
				boss_id = ComponentGetValue2(comp, "value_int")
				break
			end
		end
		local value = 262144
		local name = EntityGetName(boss)
		if ( name == "$boss_eel" ) or ( name == "$hellion" ) or ( name == "$hellion2" ) or ( name == "$drill_giant" ) or ( name == "$skymonster" ) or ( name == "$cthulhu" ) or ( name == "$god_warrior" ) or ( name == "$yikka_host" ) or ( name == "$desert_skull" ) then
			value = 1000000
		end
		--fix ew bug
		local compo = EntityGetFirstComponentIncludingDisabled(boss, "DamageModelComponent")
		if ( compo ~= nil ) and ( compo > 0 ) then
			local hp = ComponentGetValue2(compo, "hp")
			if ( hp <= 1 ) and ( hp > 0 ) then
				local previous_hp = ComponentGetValue2(compo, "mHpBeforeLastDamage")
				ComponentSetValue2(compo, "hp", previous_hp)
			end
		end
		-- Boss is too far, save and despawn
		if dist > value then
			local comp = EntityGetFirstComponentIncludingDisabled(boss, "DamageModelComponent")
			local hp = -90000
			local max_hp = -90000
			if ( comp ~= nil ) and ( comp > 0 ) then
				hp = ComponentGetValue2(comp, "hp")
				max_hp = ComponentGetValue2(comp, "max_hp")
			end
			local file_path = EntityGetFilename(boss)
			local name = EntityGetName(boss)
			if not boss_id then
				if ModIsEnabled("quant.ew") then
					-- local peers = EntityGetWithTag("ew_peer")
					-- if peers ~= nil and #peers > 0 then
						-- CrossCall("increment_boss_counter")
					-- end
				else
					boss_id = boss_counter
					boss_counter = boss_counter + 1
					GlobalsSetValue("new_enemies_mod_boss_counter", tostring(boss_counter))
				end
			end
			
			local has_healthbar = false
			local hb_comp = EntityGetFirstComponentIncludingDisabled(boss, "BossHealthBarComponent")
			if ( hb_comp ~= nil ) and ( hb_comp > 0 ) then
				has_healthbar = true
			end
			local initialized4 = false
			if ( name == "$lukki_dark_huge" ) or ( name == "$giant_boss" ) then
				local damage_model_component = EntityGetFirstComponentIncludingDisabled(boss, "DamageModelComponent")
				if ( damage_model_component ~= nil ) and ( damage_model_component > 0 ) then
					if ComponentGetIsEnabled( damage_model_component ) == true then
						initialized4 = true
					end
				end
			end
			local cooldown = 0
			local state = 0
			local lava_shifted = 0
			local v8 = 0
			
			if ( name == "$hellion" ) or ( name == "$hellion2" ) then
			
				local components = EntityGetComponent( boss, "VariableStorageComponent" )
				if ( components ~= nil ) then
					for _,comp_id in pairs(components) do 
						local var_name = ComponentGetValue( comp_id, "name" )
						if ( var_name == "phase_value") then
							var_comp_phase = comp_id
						end
						if ( var_name == "cooldown") then
							var_comp_cooldown = comp_id
						end
						if ( var_name == "lava_is_shifted_check") then
							var_comp_lava_is_shifted_check = comp_id
						end
					end
				end
				if ( var_comp_cooldown ~= nil ) and ( var_comp_cooldown > 0 ) then
					cooldown = ComponentGetValue2( var_comp_cooldown, "value_int" )
				end
				if ( var_comp_phase ~= nil ) and ( var_comp_phase > 0 ) then
					state = ComponentGetValue2( var_comp_phase, "value_int" )
				end
				if ( var_comp_lava_is_shifted_check ~= nil ) and ( var_comp_lava_is_shifted_check > 0 ) then
					lava_shifted = ComponentGetValue2( var_comp_lava_is_shifted_check, "value_int" )
				end
			end
			
			if ( name == "$drill_giant" )then
			
				local worm_component = EntityGetFirstComponentIncludingDisabled( boss, "WormComponent")
				local velx, vely = ComponentGetValue2(worm_component, "mTargetVec")
				local components = EntityGetComponent( boss, "VariableStorageComponent" )
				if ( components ~= nil ) then
					for _,comp_id in pairs(components) do 
						local var_name = ComponentGetValue( comp_id, "name" )
						if ( var_name == "origin") then
							var_comp_origin = comp_id
						end
					end
				end
				if ( var_comp_origin ~= nil ) and ( var_comp_origin > 0 ) then
					originx = ComponentGetValue2( var_comp_origin, "value_int" )
					originy = ComponentGetValue2( var_comp_origin, "value_float" )
				end
				
				cooldown = velx
				state = vely
				lava_shifted = originx
				v8 = originy
			end
			
			if ( name == "$cthulhu" ) or ( name == "$god_warrior" ) then
				local ax = bx
				local ay = by
				
				local v1 = 0
				local v2 = 0
				local v3 = 2
				local components = EntityGetComponent( boss, "VariableStorageComponent" )
				if ( components ~= nil ) then
					for _,comp_id in pairs(components) do 
						local var_name = ComponentGetValue2( comp_id, "name" )
						if( var_name == "initialized") then
							init_comp =  comp_id
						end
						if ( var_name == "origin") then
							var_comp_origin = comp_id
						end
						if ( var_name == "dead_frames") then
							dead_var_comp = comp_id
						end
						if ( var_name == "is_attacking") then
							is_attack_var_comp = comp_id
						end
						if ( var_name == "previous_attack") then
							prev_attack_var_comp = comp_id
						end
					end
				end
				if ( var_comp_origin ~= nil ) and ( var_comp_origin > 0 ) then
					ax = ComponentGetValue2(var_comp_origin, "value_int" )
					ay = ComponentGetValue2(var_comp_origin, "value_float")
				end
				if ( dead_var_comp ~= nil ) and ( dead_var_comp > 0 ) then
					v1 = ComponentGetValue2(dead_var_comp, "value_int" )
				end
				if ( is_attack_var_comp ~= nil ) and ( is_attack_var_comp > 0 ) then
					v2 = ComponentGetValue2(is_attack_var_comp, "value_int" )
				end
				if ( prev_attack_var_comp ~= nil ) and ( prev_attack_var_comp > 0 ) then
					v3 = ComponentGetValue2(prev_attack_var_comp, "value_int" )
				end
				cooldown = 0
				state = v2
				lava_shifted = v3
				bx = ax
				by = ay
			end
			
			if ( name == "$boss_fungus" ) then
				local child_hoster = EntityGetWithName( "child_hoster" )
				if ( child_hoster ~= nil ) and ( child_hoster > 0 ) then
					local children = EntityGetAllChildren(boss) or {}
					for i, child in ipairs(children) do
						if EntityHasTag( child, "fungal_spawn" ) then
							EntityRemoveFromParent(child)
							EntityAddChild( child_hoster, child )
						end
					end
				else
					local child_hoster = EntityCreateNew()
					EntitySetTransform(child_hoster, px, py)
					EntitySetName( child_hoster, "child_hoster" )
					EntityAddComponent2(child_hoster, "LuaComponent", {
						script_source_file="data/scripts/buildings/keep_near_player.lua",
						execute_every_n_frame=1,
						execute_on_added=true
					} )
					local children = EntityGetAllChildren(boss) or {}
					for i, child in ipairs(children) do
						if EntityHasTag( child, "fungal_spawn" ) then
							EntityRemoveFromParent(child)
							EntityAddChild( child_hoster, child )
						end
					end
				end
			end
			
			if ( name == "$yikka_host" ) then
				local lua_component = EntityGetFirstComponentIncludingDisabled( boss, "LuaComponent", "enabled_in_world")
				if ( lua_component ~= nil ) and ( lua_component > 0 ) then
					ComponentSetValue2(lua_component, "execute_on_removed", false)
				end
			end
			
			-- Save data to global
			
			if ModIsEnabled("quant.ew") then
				local save_string = name..","..file_path..","..tostring(has_healthbar)..","..tostring(initialized4)..","..tostring(bx)..","..tostring(by)..","..tostring(hp)..","..tostring(max_hp)..","..tostring(cooldown)..","..tostring(state)..","..tostring(lava_shifted)..","..tostring(v8)
				local peers = EntityGetWithTag("ew_peer")
				if peers ~= nil and #peers > 0 then
					CrossCall("sync_global", "new_enemies_mod_boss_"..tostring(boss_id), save_string)
					-- local components = EntityGetComponent( boss, "VariableStorageComponent" )
					-- if ( components ~= nil ) then
						-- for _,comp_id in pairs(components) do 
							-- local var_name = ComponentGetValue( comp_id, "name" )
							-- if ( var_name == "ew_gid_lid") then
								-- local var_string = ComponentGetValue( comp_id, "value_string" )
								-- CrossCall("sync_global", "please_kill_this_entity", var_string)
							-- end
						-- end
					-- end
					
					CrossCall("kill_boss", tostring(boss))
				end
			else
				local save_string = name..","..file_path..","..tostring(has_healthbar)..","..tostring(initialized4)..","..tostring(bx)..","..tostring(by)..","..tostring(hp)..","..tostring(max_hp)..","..tostring(cooldown)..","..tostring(state)..","..tostring(lava_shifted)..","..tostring(v8)
				GlobalsSetValue("new_enemies_mod_boss_"..boss_id, save_string)
				EntityKill(boss)
			end

		-- Assign ID if within range but not tagged
		elseif not boss_id then

			if ModIsEnabled("quant.ew") then
				local peers = EntityGetWithTag("ew_peer")
				if peers ~= nil and #peers > 0 then
					CrossCall("increment_boss_counter")
				end
			else
				boss_id = boss_counter
				boss_counter = boss_counter + 1
				GlobalsSetValue("new_enemies_mod_boss_counter", tostring(boss_counter))
			end
			local bobo = EntityAddComponent(boss, "VariableStorageComponent", {
				name = "boss_identifier",
				value_int = boss_id
			})
			EntityAddTag( bobo, "ew_synced_var" )
		end
	end
	
	function move_towards(x1, y1, x2, y2, speed)
		local dx = x2 - x1
		local dy = y2 - y1
		local dist = math.sqrt(dx*dx + dy*dy)
		if dist == 0 then return x1, y1 end
		local norm_dx = dx / dist
		local norm_dy = dy / dist
		return x1 + norm_dx * speed, y1 + norm_dy * speed
	end

	-- Respawn bosses that are close to camera
	for i = 1, boss_counter - 1 do
		local val = GlobalsGetValue("new_enemies_mod_boss_"..i)
		if val and val ~= "" then
			local name, file, hb2, initialized2, x0, y0, hp2, max_hp2, cooldown2, state2, lava_shifted2, v82 = string.match(val, "([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
			local stringtoboolean={ ["true"]=true, ["false"]=false }
			local hb = stringtoboolean[hb2]
			local initialized = stringtoboolean[initialized2]
			local xval = tonumber(x0)
			local yval = tonumber(y0)
			local hp = tonumber(hp2)
			local max_hp = tonumber(max_hp2)
			local cooldown = tonumber(cooldown2)
			local state = tonumber(state2)
			local lava_shifted = tonumber(lava_shifted2)
			local v8 = tonumber(v82)
			
			SetRandomSeed( GameGetFrameNum(), xval + yval )
			
			if ModIsEnabled("quant.ew") then
				local disto = 999999999999999999999999999999999999
				local peers = EntityGetWithTag("ew_peer")
				if ( peers ~= nil ) and ( #peers > 0 ) then
					for _, peer in ipairs(peers) do
						local peex, peey = EntityGetTransform(peer)
						local dist2 = get_distance_squared(xval, yval, peex, peey)
						if dist2 < disto then
							disto = dist2
						end
					end
				end
				local dista = get_distance_squared(px, py, xval, yval)
				if dista ~= disto then
					GlobalsSetValue(val, "")
				end
			end
			
			local value2 = 160000
			if ( name == "$boss_eel" ) or ( name == "$hellion" ) or ( name == "$hellion2" ) then
				value2 = 562500
			elseif ( name == "$drill_giant" ) or ( name == "$god_warrior" ) then
				value2 = 1000000
			elseif ( name == "$desert_skull" ) then
				value2 = 262144
			end

			local dist = get_distance_squared(xval, yval, cx, cy)
			if dist < value2 then
				local new_boss = EntityLoad(file, xval, yval)
				EntitySetTransform(new_boss, xval, yval)
				if ( name == "$boss_fungus" ) or ( name == "$desert_skull" ) or ( name == "$yikka_host" ) or ( name == "$yikka" ) or ( name == "$bird" ) or ( name == "$camel_robot" ) or ( name == "$giant_boss" ) or ( name == "$lukki_dark_huge" ) or ( name == "$cyclops_slime" ) or ( name == "$elephant" ) then
					local comp = EntityGetFirstComponentIncludingDisabled(new_boss, "DamageModelComponent")
					if ( comp ~= nil ) and ( comp > 0 ) then
						ComponentSetValue2(comp, "hp", hp)
						ComponentSetValue2(comp, "max_hp", max_hp)
					end
					local init_comp = nil
					local components = EntityGetComponent( new_boss, "VariableStorageComponent" )
					if ( components ~= nil ) then
						for _,comp_id in pairs(components) do 
							local var_name = ComponentGetValue2( comp_id, "name" )
							if( var_name == "initialized") then
								init_comp =  comp_id
							end
						end
					end
					if ( init_comp ~= nil ) and ( init_comp > 0 ) then
						ComponentSetValue2(init_comp, "value_bool", true)
						ComponentSetValue2(init_comp, "value_int", 1)
					end
					if ( name == "$giant_boss" ) or ( name == "$lukki_dark_huge" ) then
						if initialized == true then
							EntitySetComponentsWithTagEnabled(new_boss, "enable_when_player_seen", true)
						end
					end
					if ( name == "$boss_fungus" ) then
						local boss_child_keeper = EntityGetWithName( "child_hoster" )
						if ( boss_child_keeper ~= nil ) and ( boss_child_keeper > 0 ) then
							local children = EntityGetAllChildren(boss_child_keeper) or {}
							for i, child in ipairs(children) do
								if EntityHasTag( child, "fungal_spawn" ) then
									EntityRemoveFromParent(child)
									EntityAddChild( new_boss, child )
								end
							end
							EntityKill(boss_child_keeper)
						end
					end
				end
				
				if ( name == "$boss_eel" ) or ( name == "$skymonster" ) then
					local comp = EntityGetFirstComponentIncludingDisabled(new_boss, "DamageModelComponent")
					if ( comp ~= nil ) and ( comp > 0 ) then
						ComponentSetValue2(comp, "hp", hp)
						ComponentSetValue2(comp, "max_hp", max_hp)
					end
					local init_comp = nil
					local components = EntityGetComponent( new_boss, "VariableStorageComponent" )
					if ( components ~= nil ) then
						for _,comp_id in pairs(components) do 
							local var_name = ComponentGetValue2( comp_id, "name" )
							if( var_name == "initialized") then
								init_comp =  comp_id
							end
						end
					end
					if ( init_comp ~= nil ) and ( init_comp > 0 ) then
						ComponentSetValue2(init_comp, "value_bool", true)
						ComponentSetValue2(init_comp, "value_int", 1)
					end
					local dragon_component = EntityGetFirstComponentIncludingDisabled(new_boss, "BossDragonComponent")
					if ( dragon_component ~= nil ) and ( dragon_component > 0 ) then
						local dx = px - xval
						local dy = py - yval
						local dist = math.sqrt(dx * dx + dy * dy)
						if dist ~= 0 then
							ComponentSetValue2(dragon_component, "mTargetVec", (dx / dist) * 2, (dy / dist) * 2)
						end
					end
				end

				if ( name == "$hellion" ) or ( name == "$hellion2" ) then
					local comp = EntityGetFirstComponentIncludingDisabled(new_boss, "DamageModelComponent")
					if ( comp ~= nil ) and ( comp > 0 ) then
						ComponentSetValue2(comp, "hp", hp)
						ComponentSetValue2(comp, "max_hp", max_hp)
					end
					local init_comp = nil
					local components = EntityGetComponent( new_boss, "VariableStorageComponent" )
					if ( components ~= nil ) then
						for _,comp_id in pairs(components) do 
							local var_name = ComponentGetValue2( comp_id, "name" )
							if( var_name == "initialized") then
								init_comp =  comp_id
							end
						end
					end
					if ( init_comp ~= nil ) and ( init_comp > 0 ) then
						ComponentSetValue2(init_comp, "value_bool", true)
						ComponentSetValue2(init_comp, "value_int", 1)
					end
					local dragon_component = EntityGetFirstComponentIncludingDisabled(new_boss, "WormComponent")
					if ( dragon_component ~= nil ) and ( dragon_component > 0 ) then
						local dx = px - xval
						local dy = py - yval
						local dist = math.sqrt(dx * dx + dy * dy)
						if dist ~= 0 then
							ComponentSetValue2(dragon_component, "mTargetVec", (dx / dist) * 2, (dy / dist) * 2)
						end
					end
					if state == 2 then
						local lua_components = EntityGetComponent(new_boss, "LuaComponent") or {}
						for i, lua_component in ipairs(lua_components) do
							local file = ComponentGetValue2( lua_component, "script_damage_received" )
							if file == "data/scripts/animals/hellion_phase_checker.lua" then
								EntityRemoveComponent( new_boss, lua_component )
							end
						end
						EntitySetComponentsWithTagEnabled(new_boss, "pitcheck_b", false)
						for i = 1, 10 do
							local bud_entity = EntityLoad("data/entities/animals/hellion_flower.xml", xval, yval)
							EntitySetComponentsWithTagEnabled(bud_entity, "enabled_in_hand", true)
							local sprite_component2 = EntityGetFirstComponent(bud_entity, "SpriteComponent")
							local an = ComponentGetValue2(sprite_component2, "rect_animation")
							if ( an ~= "stand" ) and ( an ~= "open" ) then
								ComponentSetValue2(sprite_component2, "rect_animation", "open")
								ComponentSetValue2(sprite_component2, "next_rect_animation", "stand")
							end
							EntityAddChild(new_boss, bud_entity)
						end
				
						local components = EntityGetComponent( new_boss, "VariableStorageComponent" )
						if ( components ~= nil ) then
							for _,comp_id in pairs(components) do 
								local var_name = ComponentGetValue( comp_id, "name" )
								if ( var_name == "phase_value") then
									var_comp_phase = comp_id
								end
								if ( var_name == "cooldown") then
									var_comp_cooldown = comp_id
								end
							end
						end

						local comp = EntityGetFirstComponentIncludingDisabled( new_boss, "DamageModelComponent" )
						if ( comp ~= nil ) and ( comp > 0 ) then
							ComponentSetValue2( comp, "wait_for_kill_flag_on_death", false )
						end
						local worm_component = EntityGetFirstComponentIncludingDisabled( new_boss, "WormComponent")
						ComponentSetValue2( worm_component, "is_water_worm", false )
						ComponentSetValue2( worm_component, "mSpeed", 2 )
						ComponentSetValue2( worm_component, "gravity", 0 )
						ComponentSetValue2( worm_component, "tail_gravity", 10 )
						ComponentSetValue2( worm_component, "speed", 0.5 )
						ComponentSetValue2( worm_component, "speed_hunt", 0.5 )
						ComponentSetValue2( worm_component, "ground_check_offset", 400 )
						ComponentSetValue2( worm_component, "target_kill_radius", 0 )
						EntitySetComponentsWithTagEnabled(new_boss, "enabled_in_world", true)

						ComponentSetValue2( var_comp_phase, "value_int", state )
						ComponentSetValue2( var_comp_cooldown, "value_int", cooldown )
						
						EntitySetName( new_boss, "$hellion2" )
						
						local children = EntityGetAllChildren(new_boss)
						
						for i, child in ipairs(children) do
							if ( EntityGetName(child) == "face_worm_head" ) then
								local sprite_comp = EntityGetFirstComponent( child, "SpriteComponent" )
								ComponentSetValue2( sprite_comp, "image_file", "data/enemies_gfx/hellion2_flower.xml" )
								EntityRefreshSprite( child, sprite_comp )
								
								local lua_comp = EntityGetFirstComponent( child, "LuaComponent" )
								EntityRemoveComponent( child, lua_comp )
							end
							
							if ( EntityGetName(child) == "body" ) then
								EntityRemoveFromParent(child)
								local damage_model_component = EntityGetFirstComponentIncludingDisabled(child, "DamageModelComponent")
								
								if ( damage_model_component ~= nil ) and ( damage_model_component > 0 ) then
									ComponentSetValue2(damage_model_component, "kill_now", true)
									ComponentSetValue2(damage_model_component, "hp", 0)
									ComponentSetValue2(damage_model_component, "air_needed", true)
									ComponentSetValue2(damage_model_component, "air_in_lungs", 0)
								end
							end
						end
						
						local sprite_components = EntityGetComponent(new_boss, "SpriteComponent") or {}
						for i, sprite_component in ipairs(sprite_components) do
							local image = ComponentGetValue2( sprite_component, "image_file" )
							if image == "data/enemies_gfx/hellion2_body1.png" then
								ComponentSetValue2( sprite_component, "alpha", 1 )
							elseif image == "data/enemies_gfx/hellion2_body2.png" then
								ComponentSetValue2( sprite_component, "alpha", 1 )
							elseif image == "data/enemies_gfx/hellion2_tail.png" then
								ComponentSetValue2( sprite_component, "alpha", 1 )
							end
						end
					end
				end
				
				if name == "$drill_giant" then
					local comp = EntityGetFirstComponentIncludingDisabled(new_boss, "DamageModelComponent")
					if ( comp ~= nil ) and ( comp > 0 ) then
						ComponentSetValue2(comp, "hp", hp)
						ComponentSetValue2(comp, "max_hp", max_hp)
					end
					local init_comp = nil
					local components = EntityGetComponent( new_boss, "VariableStorageComponent" )
					if ( components ~= nil ) then
						for _,comp_id in pairs(components) do 
							local var_name = ComponentGetValue2( comp_id, "name" )
							if( var_name == "initialized") then
								init_comp =  comp_id
							end
						end
					end
					if ( init_comp ~= nil ) and ( init_comp > 0 ) then
						ComponentSetValue2(init_comp, "value_bool", true)
						ComponentSetValue2(init_comp, "value_int", 1)
					end
					local dragon_component = EntityGetFirstComponentIncludingDisabled(new_boss, "WormComponent")
					if ( dragon_component ~= nil ) and ( dragon_component > 0 ) then
						local dx = cooldown
						local dy = state
						local mag = math.sqrt(dx * dx + dy * dy)
						if mag ~= 0 then
							local norm_dx = dx / mag
							local norm_dy = dy / mag
							ComponentSetValue2(dragon_component, "mTargetVec", norm_dx * 0.2, norm_dy * 0.2)
						end
					end
					
					local worm_ai_component = EntityGetFirstComponentIncludingDisabled(new_boss, "WormAIComponent")
					if ( worm_ai_component ~= nil ) and ( worm_ai_component > 0 ) then
						ComponentSetValue2( worm_ai_component, "new_random_target_check_every", 9999 )
					end
					
					local components = EntityGetComponent( new_boss, "VariableStorageComponent" )
					if ( components ~= nil ) then
						for _,comp_id in pairs(components) do 
							local var_name = ComponentGetValue( comp_id, "name" )
							if ( var_name == "origin") then
								var_comp_origin = comp_id
							end
						end
					end

					local comp = EntityGetFirstComponentIncludingDisabled( new_boss, "DamageModelComponent" )
					if ( comp ~= nil ) and ( comp > 0 ) then
						ComponentSetValue2( comp, "wait_for_kill_flag_on_death", false )
					end
					if ( var_comp_origin ~= nil ) and ( var_comp_origin > 0 ) then
						ComponentSetValue2(var_comp_origin, "value_int", lava_shifted)
						ComponentSetValue2(var_comp_origin, "value_float", v8)
					end
				end
				
				if ( name == "$cthulhu" ) or ( name == "$god_warrior" ) then
					local comp = EntityGetFirstComponentIncludingDisabled(new_boss, "DamageModelComponent")
					if ( comp ~= nil ) and ( comp > 0 ) then
						if hp <= 0 then
							local val = ComponentGetValue2(comp, "invincibility_frames")
							if val <= 0 then
								ComponentSetValue2(comp, "kill_now", true)
								ComponentSetValue2(comp, "wait_for_kill_flag_on_death", true)
								ComponentSetValue2(comp, "hp", 0)
								ComponentSetValue2(comp, "max_hp", 0)
							end
						else
							ComponentSetValue2(comp, "hp", hp)
							ComponentSetValue2(comp, "max_hp", max_hp)
						end
					end
					local init_comp = nil
					local components = EntityGetComponent( new_boss, "VariableStorageComponent" )
					if ( components ~= nil ) then
						for _,comp_id in pairs(components) do 
							local var_name = ComponentGetValue2( comp_id, "name" )
							if( var_name == "initialized") then
								init_comp =  comp_id
							end
							if ( var_name == "origin") then
								var_comp_origin = comp_id
							end
							if ( var_name == "dead_frames") then
								dead_var_comp = comp_id
							end
							if ( var_name == "is_attacking") then
								is_attack_var_comp = comp_id
							end
							if ( var_name == "previous_attack") then
								prev_attack_var_comp = comp_id
							end
						end
					end
					if ( init_comp ~= nil ) and ( init_comp > 0 ) then
						ComponentSetValue2(init_comp, "value_bool", true)
						ComponentSetValue2(init_comp, "value_int", 1)
					end
					if ( var_comp_origin ~= nil ) and ( var_comp_origin > 0 ) then
						EntitySetTransform(new_boss, px, py)
						ComponentSetValue2(var_comp_origin, "value_bool", true)
						if ( name == "$cthulhu" ) then
							ComponentSetValue2(var_comp_origin, "value_int", px)
							ComponentSetValue2(var_comp_origin, "value_float", py)
						else
							ComponentSetValue2(var_comp_origin, "value_int", xval)
							ComponentSetValue2(var_comp_origin, "value_float", yval)
						end
					end
					if ( dead_var_comp ~= nil ) and ( dead_var_comp > 0 ) then
						ComponentSetValue2(dead_var_comp, "value_int", cooldown)
					end
					if ( is_attack_var_comp ~= nil ) and ( is_attack_var_comp > 0 ) then
						ComponentSetValue2(is_attack_var_comp, "value_int", state)
					end
					if ( prev_attack_var_comp ~= nil ) and ( prev_attack_var_comp > 0 ) then
						ComponentSetValue2(prev_attack_var_comp, "value_int", lava_shifted)
					end
					local var_comp = EntityGetFirstComponent(new_boss, "VariableStorageComponent")
					if ( var_comp ~= nil ) and ( var_comp > 0 ) then
						ComponentSetValue2(var_comp, "value_bool", true)
					end
				end

				local bobo2 = EntityAddComponent(boss, "VariableStorageComponent", {
					name = "boss_identifier",
					value_int = i
				})
				EntityAddTag( bobo2, "ew_synced_var" )

				-- Clear saved data to avoid respawning again
				if ModIsEnabled("quant.ew") then
					local peers = EntityGetWithTag("ew_peer")
					if peers ~= nil and #peers > 1 then
						CrossCall("sync_global", "new_enemies_mod_boss_"..i, "")
					end
				else
					GlobalsSetValue("new_enemies_mod_boss_"..i, "")
				end
			else
				local value10 = 1440000
				if name == "$lukki_dark_huge" then
					if initialized == true then
						local new_x, new_y = move_towards(xval, yval, px, py, 1.5)
						if dist < 25000000 then
							if times_executed % 30 == 0 then
								LoadPixelScene( "data/biome_impl/boss_holes/hirmukita.png", "", new_x - 59, new_y - 59, "", true, false, "", 50, true )
							end
						end
						local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
						GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
					end
				end
				if name == "$yikka" then
					local new_x, new_y = move_towards(xval, yval, px, py, 4)
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if name == "$yikka_host" then
					local new_x, new_y = move_towards(xval, yval, px, py, 2)
					if dist < 25000000 then
						if times_executed % 15 == 0 then
							LoadPixelScene( "data/biome_impl/boss_holes/80_souls.png", "", new_x - 40, new_y - 40, "", true, false, "", 50, true )
						end
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if name == "$desert_skull" then
					value10 = 1000000
					local new_x, new_y = move_towards(xval, yval, px, py, 4)
					if dist < 25000000 then
						if times_executed % 30 == 0 then
							LoadPixelScene( "data/biome_impl/boss_holes/huge.png", "", new_x - 150, new_y - 150, "", true, false, "", 50, true )
						end
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if name == "$giant_boss" then
					if initialized == true then
						local new_x, new_y = move_towards(xval, yval, px, py, 1)
						if dist < 25000000 then
							if times_executed % 30 == 0 then
								LoadPixelScene( "data/biome_impl/boss_holes/giant.png", "", new_x - 49, new_y - 109, "", true, false, "", 50, true )
							end
						end
						local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
						GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
					end
				end
				if name == "$camel_robot" then
					local new_x, new_y = move_towards(xval, yval, px, py, 2.5)
					if dist < 25000000 then
						if times_executed % 15 == 0 then
							LoadPixelScene( "data/biome_impl/boss_holes/80.png", "", new_x - 40, new_y - 40, "", true, false, "", 50, true )
						end
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if name == "$boss_eel" then
					local new_x, new_y = move_towards(xval, yval, px, py, 10)
					if dist < 25000000 then
						if times_executed % 5 == 0 then
							LoadPixelScene( "data/biome_impl/boss_holes/80.png", "", new_x - 40, new_y - 40, "", true, false, "", 50, true )
						end
					end
					if dist < 625000000 then
						if times_executed % 600 < 200 then
							local dx = xval - px
							local dy = yval - py
							local dist = math.sqrt(dx * dx + dy * dy)
							if dist > 400 then
								local norm_dx = dx / dist
								local norm_dy = dy / dist
								local spawn_x = px + norm_dx * 400
								local spawn_y = py + norm_dy * 400
								EntityLoad("data/entities/projectiles/boss_eel_laser.xml", spawn_x, spawn_y)
							end
						end
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if ( name == "$hellion" ) or ( name == "$hellion2" ) then
					local new_x, new_y = move_towards(xval, yval, px, py, 7)
					if dist < 25000000 then
						if lava_shifted == 1 then
							if times_executed % 5 == 0 then
								LoadPixelScene( "data/biome_impl/boss_holes/lava_shifted.png", "", new_x - 40, new_y - 40, "", true, false, "", 50, true )
							end
						else
							if times_executed % 5 == 0 then
								LoadPixelScene( "data/biome_impl/boss_holes/lava.png", "", new_x - 40, new_y - 40, "", true, false, "", 50, true )
							end
						end
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, cooldown, state, lava_shifted, 0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if ( name == "$drill_giant" ) then
					if dist < 625000000 then
						local new_x, new_y = move_towards(xval, yval, xval + cooldown, yval + state, 1)
						local dist = get_distance_squared(new_x, new_y, lava_shifted, v8)
						if BiomeMapGetName(new_x, new_y) ~= "$biome_desert" then
							local dx = lava_shifted - xval
							local dy = v8 - yval
							local dist_to_target = math.sqrt(dx * dx + dy * dy)
							if dist_to_target ~= 0 then
								cooldown = (dx / dist_to_target)
								state = (dy / dist_to_target)
							else
								cooldown = 0
								state = 0
							end
						elseif dist < 40000 then
							if times_executed % 240 == 0 then
								local dx = Random(-400,400) - xval
								local dy = Random(-400,400) - yval
								local mag = math.sqrt(dx * dx + dy * dy)
								if mag ~= 0 then
									cooldown = dx / mag
									state = dy / mag
								end
							end
						end
						local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, cooldown, state, lava_shifted, v8)
						GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
						value10 = 640000
					end
				end
				if name == "$skymonster" then
					local new_x, new_y = move_towards(xval, yval, px, py, 4)
					if dist < 25000000 then
						if times_executed % 3 == 0 then
							LoadPixelScene( "data/biome_impl/boss_holes/24.png", "", new_x - 12, new_y - 12, "", true, false, "", 50, true )
						end
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0,0,0,0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if ( name == "$cthulhu" ) then
					local new_x, new_y = move_towards(xval, yval, px, py, 20)
					if times_executed % 30 == 0 then
						local cx, cy = GameGetCameraPos()
						EntityLoad("data/entities/projectiles/cthulhu_singularity_deadly.xml", cx + Random (-400, 400), cy + Random (-300, 300) )
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, cooldown, state, lava_shifted, 0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				
				if ( name == "$god_warrior" ) then
					if dist < 625000000 then
						if times_executed % 300 == 0 then
							if hp < max_hp * 0.5 then
								EntityLoad( "data/entities/projectiles/god_warrior_earthquake_spawner.xml", px , py )
								
								GamePlaySound("data/audio/Desktop/animals.bank", "explosions/barrel_oil", px, py)
								GamePlaySound("data/audio/Desktop/animals.bank", "explosions/cocktail", px, py)
							end
						end
					end
				end
				
				if ( name == "$bird" ) then
					if dist < 100000000 then
						dofile_once( "data/scripts/projectiles/overmind.lua" )
						value10 = 512
						if orbcount >= 7 then
							if times_executed % 600 == 0 then
								local dx = xval - px
								local dy = yval - py
								local dist = math.sqrt(dx * dx + dy * dy)
								if dist > 400 then
									local norm_dx = dx / dist
									local norm_dy = dy / dist
									local spawn_x = px + norm_dx * 400
									local spawn_y = py + norm_dy * 400
									local temp = EntityCreateNew()
									EntitySetTransform(temp, spawn_x, spawn_y)
									EntityAddComponent2(temp, "LifetimeComponent", {
										lifetime=1,
									} )
									shoot_at_entity_from_position(temp, spawn_x, spawn_y, players[1], 1, 0, 0, 200, "data/entities/projectiles/bird_flame_formation.xml", 9999999, 99999999)
									local proj = EntityLoad("data/entities/projectiles/ring_explosion.xml", px, py)
									EntitySetTransform(proj, px, py)
									local child_id = EntityLoad("data/entities/projectiles/bird_flame_trail.xml", px, py)
									EntitySetTransform(child_id, px, py)
									local comp = EntityGetFirstComponentIncludingDisabled(child_id, "VariableStorageComponent")
									if ( comp ~= nil ) and ( comp > 0 ) then
										ComponentSetValue2(comp, "value_int", xval)
										ComponentSetValue2(comp, "value_float", yval)
									end
									EntityAddChild(proj, child_id)
									local comp = EntityGetFirstComponentIncludingDisabled(proj, "SpriteComponent")
									if ( comp ~= nil ) and ( comp > 0 ) then
										if xval < px then
											ComponentSetValue2(comp, "special_scale_x", -1)
										else
											ComponentSetValue2(comp, "special_scale_x", 1)
										end
									end
									local function get_direction( x1, y1, x2, y2 )
										local result = math.pi - math.atan2( ( y2 - y1 ), ( x2 - x1 ) )
										return result
									end	
									local angle = get_direction( xval, yval, px, py )
									EntitySetTransform(proj, px, py, -angle - (math.pi/2 ))
								end
							end
						end
					end
				end
				
				if ( name == "$elephant" ) or ( name == "$cyclops_slime" ) then
					if dist < 100000000 then
						value10 = 512
						local max_count_reduction = math.min(30, orbcount)
						if times_executed % ( 300 - ( max_count_reduction * 5 ) ) == 0 then
							local max_count = math.min(33, orbcount)
							local dx = xval - px
							local dy = yval - py
							local dist = math.sqrt(dx * dx + dy * dy)
							if dist > 400 then
								local norm_dx = dx / dist
								local norm_dy = dy / dist
								local spawn_x = px + norm_dx * 400
								local spawn_y = py + norm_dy * 400
								if ( name == "$cyclops_slime" ) then
									for i=1,Random(6, 22) + max_count do
										EntityLoad("data/entities/projectiles/cyclops_slime_shot.xml", spawn_x, spawn_y)
									end
								else
									for i=1,Random(6, 22) + max_count do
										EntityLoad("data/entities/projectiles/elephant_magma_shot.xml", spawn_x, spawn_y)
									end
								end
								GamePlaySound("data/audio/Desktop/animals.bank", "animals/boss_centipede/spawn_minion", spawn_x, spawn_y)
							end
						end
					end
					if ( name == "$cyclops_slime" ) then
						local new_x, new_y = move_towards(xval, yval, px, py, 0.5)
						if dist < 25000000 then
							if times_executed % 60 == 0 then
								LoadPixelScene( "data/biome_impl/boss_holes/40.png", "", new_x - 20, new_y - 20, "", true, false, "", 50, true )
							end
						end
						local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0, 0, 0, 0)
						GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
					end
				end
				
				if ( name == "$boss_fungus" ) then
					if dist < 100000000 then
						if times_executed % 300 == 0 then
							local dx = xval - px
							local dy = yval - py
							local dist = math.sqrt(dx * dx + dy * dy)
							if dist > 400 then
								local norm_dx = dx / dist
								local norm_dy = dy / dist
								local spawn_x = px + norm_dx * 400
								local spawn_y = py + norm_dy * 400
								EntityLoad("data/entities/projectiles/boss_fungus_shot.xml", spawn_x, spawn_y)
								GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/meteor/create", spawn_x, spawn_y)
							end
						end
					end
					local new_x = xval
					if xval < px then
						new_x = xval + 2
					elseif xval >= px then
						new_x = xval - 2
					end
					local new_y = yval
					if yval < py then
						local new_y2 = yval + 0.5
						if new_y2 < 12800 then
							new_y = new_y2
						end
					elseif yval >= py then
						local new_y2 = yval - 0.5
						if new_y2 > 0 then
							new_y = new_y2
						end
					end
					local save_string = string.format("%s,%s,%s,%s,%f,%f,%f,%f,%f,%f,%f,%f",name,file,tostring(hb), tostring(initialized), new_x, new_y, hp, max_hp, 0, 0, 0, 0)
					GlobalsSetValue("new_enemies_mod_boss_"..i, save_string)
				end
				if dist < value10 then
					if hb == true then
						local healthbar = EntityLoad( "data/entities/misc/healthbar_dummy.xml", cx , cy )
						EntitySetName( healthbar, name )
						local comp = EntityGetFirstComponentIncludingDisabled(healthbar, "DamageModelComponent")
						if ( comp ~= nil ) and ( comp > 0 ) then
							ComponentSetValue2(comp, "hp", hp)
							ComponentSetValue2(comp, "max_hp", max_hp)
						end
					end
				end
			end
		end
	end
	
	--Handle Arena Checker
	if not ModIsEnabled("quant.ew") then
		if GlobalsGetValue("new_enemies_arena_active", "0") == "1" then
			local arena_checker = EntityGetClosestWithTag(px, py, "arena_checker")
			if ( arena_checker ~= nil ) and ( arena_checker > 0 ) then
				local ax, ay = EntityGetTransform(arena_checker)
				local name = EntityGetName(arena_checker)
				
				if ModIsEnabled("quant.ew") then
					local peers = EntityGetWithTag("ew_peer")
					if peers ~= nil and #peers > 0 then
						CrossCall("sync_global", "new_enemies_arena_pos", name..","..tostring(ax)..","..tostring(ay))
					end
				else
					GlobalsSetValue("new_enemies_arena_pos", name..","..tostring(ax)..","..tostring(ay))
				end
			end
			local val = GlobalsGetValue("new_enemies_arena_pos")
			if val and val ~= "" then
				local name,x0, y0 = string.match(val, "([^,]+),([^,]+),([^,]+)")
				local xval = tonumber(x0)
				local yval = tonumber(y0)
				local pos_x = px
				local pos_y = py
				if name == "$ear_boss" then
					if ( py > yval + 50 ) then
						pos_y = yval + 50
					end
					if ( py < yval - 270 ) then
						pos_y = yval - 270
					end
				elseif name == "$mechahub" then
					if ( px > xval + 400 ) then
						pos_x = xval + 400
					end
					if ( px < xval - 400 ) then
						pos_x = xval - 400
					end
				elseif name == "golem_arena" then
					if ( px > xval + 240 ) then
						pos_x = xval + 240
					end
					if ( px < xval - 240 ) then
						pos_x = xval - 240
					end
					if ( py > yval + 30 ) then
						pos_y = yval + 30
					end
					if ( py < yval - 370 ) then
						pos_y = yval - 370
					end
				elseif name == "hydra_arena" then
					if ( px > xval + 256 ) then
						pos_x = xval + 256
					end
					if ( px < xval - 256 ) then
						pos_x = xval - 256
					end
					if ( py > yval + 132 ) then
						pos_y = yval + 132
					end
					if ( py < yval - 256 ) then
						pos_y = yval - 256
					end
				elseif name == "mwyah_arena" then
					if ( px > xval + 236 ) then
						pos_x = xval + 236
					end
					if ( px < xval - 236 ) then
						pos_x = xval - 236
					end
					if ( py > yval + 215 ) then
						pos_y = yval + 215
					end
					if ( py < yval - 240 ) then
						pos_y = yval - 240
					end
				elseif name == "magiconstruct_arena" then
					if ( px > xval + 251 ) then
						pos_x = xval + 251
					end
					if ( px < xval - 251 ) then
						pos_x = xval - 251
					end
					if ( py > yval + 211 ) then
						pos_y = yval + 211
					end
					if ( py < yval - 250 ) then
						pos_y = yval - 250
					end
				elseif name == "wraith_arena" then
					if ( px > xval + 250 ) then
						pos_x = xval + 250
					end
					if ( px < xval - 250 ) then
						pos_x = xval - 250
					end
					if ( py > yval + 80 ) then
						pos_y = yval + 80
					end
					if ( py < yval - 370 ) then
						pos_y = yval - 370
					end
				else
					if ( px > xval + 400 ) then
						pos_x = xval + 400
					end
					if ( px < xval - 400 ) then
						pos_x = xval - 400
					end
					if ( py > yval + 400 ) then
						pos_y = yval + 400
					end
					if ( py < yval - 400 ) then
						pos_y = yval - 400
					end
				end
				EntitySetTransform(players[1], pos_x, pos_y)
			end
		end
	end
	
	--Handle Deletable enemies
	-- local enemy_counter = tonumber(GlobalsGetValue("new_enemies_mod_enemy_counter", "1"))
	-- local enemies = EntityGetWithTag("enemy_registry") or {}
	-- for _, enemy in ipairs(enemies) do
		-- local ex, ey = EntityGetTransform(enemy)

		-- local components = EntityGetComponent(enemy, "VariableStorageComponent") or {}
		-- local enemy_id = nil

		-- for _, comp in ipairs(components) do
			-- if ComponentGetValue(comp, "name") == "enemy_identifier" then
				-- enemy_id = ComponentGetValue2(comp, "value_int")
				-- break
			-- end
		-- end
		-- local value = 90000
		-- local dist = get_distance_squared(ex, ey, cx, cy)
		-- if dist > value then
			
			-- local comp = EntityGetFirstComponentIncludingDisabled(enemy, "DamageModelComponent")
			-- local hp = -90000
			-- local max_hp = -90000
			-- if ( comp ~= nil ) and ( comp > 0 ) then
				-- hp = ComponentGetValue2(comp, "hp")
				-- max_hp = ComponentGetValue2(comp, "max_hp")
			-- end
			-- local file_path = EntityGetFilename(enemy)
			-- local name = EntityGetName(enemy)
			-- if not enemy_id then
				-- enemy_id = enemy_counter
				-- enemy_counter = enemy_counter + 1
				-- GlobalsSetValue("new_enemies_mod_enemy_counter", tostring(enemy_counter))
				-- if enemy_counter > 51 then
					-- local file, x0, y0, hp2, max_hp2 = string.match("new_enemies_mod_enemy_"..enemy_counter - 50, "([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
					-- local xval = tonumber(x0)
					-- local yval = tonumber(y0)
					-- local hp = tonumber(hp2)
					-- local max_hp = tonumber(max_hp2)
					-- if file and xval and yval then
						-- local new_enemy = EntityLoad(file, xval, yval)
						-- EntitySetTransform(new_enemy, xval, yval)
						-- local comp = EntityGetFirstComponentIncludingDisabled(new_enemy, "DamageModelComponent")
						-- if ( comp ~= nil ) and ( comp > 0 ) then
							-- ComponentSetValue2(comp, "hp", hp)
							-- ComponentSetValue2(comp, "max_hp", max_hp)
						-- end

						-- GlobalsSetValue("new_enemies_mod_enemy_"..enemy_counter - 50, "")
					-- end
				-- end
			-- end

			-- local save_string = file_path..","..tostring(ex)..","..tostring(ey)..","..tostring(hp)..","..tostring(max_hp)
			-- GlobalsSetValue("new_enemies_mod_enemy_"..enemy_id, save_string)
			
			-- EntityKill(enemy)
		-- elseif not enemy_id then
			-- enemy_id = enemy_counter
			-- enemy_counter = enemy_counter + 1
			-- GlobalsSetValue("new_enemies_mod_enemy_counter", tostring(enemy_counter))
			-- EntityAddComponent(enemy, "VariableStorageComponent", {
				-- name = "enemy_identifier",
				-- value_int = enemy_id
			-- })
		-- end
	-- end
	-- for i = 1, enemy_counter - 1 do
		-- local val = GlobalsGetValue("new_enemies_mod_enemy_"..i)
		-- if val and val ~= "" then
			-- local file, x0, y0, hp2, max_hp2 = string.match(val, "([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)")
			-- local xval = tonumber(x0)
			-- local yval = tonumber(y0)
			-- local hp = tonumber(hp2)
			-- local max_hp = tonumber(max_hp2)
			-- local value2 = 62500
			-- local dist = get_distance_squared(xval, yval, cx, cy)
			-- if dist < value2 then
				-- local new_enemy = EntityLoad(file, xval, yval)
				-- EntitySetTransform(new_enemy, xval, yval)
				-- local comp = EntityGetFirstComponentIncludingDisabled(new_enemy, "DamageModelComponent")
				-- if ( comp ~= nil ) and ( comp > 0 ) then
					-- ComponentSetValue2(comp, "hp", hp)
					-- ComponentSetValue2(comp, "max_hp", max_hp)
				-- end
				-- EntityAddComponent(new_enemy, "VariableStorageComponent", {
					-- name = "enemy_identifier",
					-- value_int = i
				-- })
				-- GlobalsSetValue("new_enemies_mod_enemy_"..i, "")
			-- end
		-- end
	-- end
end

local ne_gui_enabled = ModSettingGet("new_enemies.show_button")

function OnPausedChanged( is_paused, is_inventory_pause )
  if not is_paused then
    ne_gui_enabled = ModSettingGet("new_enemies.show_button")
  end
end

function OnWorldPostUpdate()
	GameSetPostFxTextureParameter( "maskTexture", "shader_mask.png", 1, 0, true )
end

--Adding orb room bosses to apotheosis
if ModIsEnabled("Apotheosis") then
	--Infinitely Looping Corridor Boss Fight
	-- path = "mods/apotheosis/files/scripts/biomes/newbiome/orbroom_15.lua"
	-- content = ModTextFileGetContent(path)
	-- content = content:gsub("EntityLoad%( \"mods/Apotheosis/files/entities/items/orbs/custom/orb_15.xml\", x, y %)", "if not HasFlagPersistent(\"nee_ear_boss\") then EntityLoad( \"mods/Apotheosis/files/entities/items/orbs/custom/orb_15.xml\", x, y ) else EntityLoad( \"data/entities/buildings/ear_boss_spot.xml\", x, y ) end")
	-- content = content:gsub("EntityLoad%( \"mods/Apotheosis/files/entities/items/books/orbrooms/book_15.xml\", x %- 30, y %- 30 %)", "if not HasFlagPersistent(\"nee_ear_boss\") then EntityLoad( \"mods/Apotheosis/files/entities/items/books/orbrooms/book_15.xml\", x - 30, y - 30 ) end")
	-- ModTextFileSetContent(path, content)
	
	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/orbroom_15.lua", 
	[[EntityLoad%( %"mods%/Apotheosis%/files%/entities%/items%/orbs%/custom%/orb%_15%.xml%"%, x%, y %)]], 
	[[if ModIsEnabled("quant.ew") then
		-- Utility function to split a string by delimiter and return a table
		function split(str, delimiter)
			local result = {}
			for match in (str..delimiter):gmatch("(.-)"..delimiter) do
				table.insert(result, match)
			end
			return result
		end

		-- Utility function to join a table into a string with a delimiter
		function join(tbl, delimiter)
			return table.concat(tbl, delimiter)
		end
		
		local entity_id = GetUpdatedEntityID()
		local pos_x, pos_y = EntityGetTransform(entity_id)

		-- Retrieve the global value storing the spawned worlds
		local spawned_worlds = GlobalsGetValue("new_enemies_ear_orb_boss_spawned", "")

		-- Convert the global value to a table
		local spawned_worlds_table = split(spawned_worlds, ",")

		-- Function to check if a value exists in a table
		function table_contains(tbl, val)
			for _, v in ipairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end

		-- Get the current parallel world index
		local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
		local current_world_index = tostring(current_world_x)
		
		local current_world_occupied = table_contains(spawned_worlds_table, tostring(current_world_x))

		-- Check if the boss has already been spawned in the current world
		if current_world_occupied == false then
			-- Add the current world index to the table and update the global value
			table.insert(spawned_worlds_table, current_world_index)
			CrossCall("sync_global", "new_enemies_ear_orb_boss_spawned", join(spawned_worlds_table, ","))

			if not HasFlagPersistent("nee_ear_boss") then
				EntityLoad("mods/Apotheosis/files/entities/items/orbs/custom/orb_15.xml", x, y)
			else
				EntityLoad("data/entities/buildings/ear_boss_spot.xml", x, y)
			end
		end
	else
		if not HasFlagPersistent("nee_ear_boss") then
			EntityLoad("mods/Apotheosis/files/entities/items/orbs/custom/orb_15.xml", x, y)
		else
			EntityLoad("data/entities/buildings/ear_boss_spot.xml", x, y)
		end
	end]]
)

	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/orbroom_15.lua", 
	[[EntityLoad%( %"mods%/Apotheosis%/files%/entities%/items%/books%/orbrooms%/book_15%.xml%"%, x %- 30%, y %- 30 %)]], 
	[[if not HasFlagPersistent("nee_ear_boss") then
    EntityLoad("mods/Apotheosis/files/entities/items/books/orbrooms/book_15.xml", x - 30, y - 30)
end]]
)

	--Sludge Monkey Boss Fight
	-- path = "mods/apotheosis/files/scripts/biomes/newbiome/orbroom_14.lua"
	-- content = ModTextFileGetContent(path)
	-- content = content:gsub("LoadPixelScene%( \"data/biome_impl/orbroom_noxioussludge.png\", \"data/biome_impl/orbroom_visual.png\", x, y, \"data/biome_impl/orbroom_background.png\", true %)", "if not HasFlagPersistent(\"nee_cyclops_slime\") then LoadPixelScene( \"data/biome_impl/orbroom_noxioussludge.png\", \"data/biome_impl/orbroom_visual.png\", x, y, \"data/biome_impl/orbroom_background.png\", true ) else LoadPixelScene( \"data/biome_impl/apotheosis/orbroom_slime.png\", \"data/biome_impl/apotheosis/orbroom_visual_slime.png\", x, y, \"data/biome_impl/orbroom_background.png\", true ) end")
	-- content = content:gsub("EntityLoad%( \"mods/Apotheosis/files/entities/items/orbs/custom/orb_14.xml\", x, y %)", "if not HasFlagPersistent(\"nee_cyclops_slime\") then EntityLoad( \"mods/Apotheosis/files/entities/items/orbs/custom/orb_14.xml\", x, y ) else EntityLoad( \"data/entities/buildings/cyclops_slime_spot.xml\", x, y + 25 ) end")
	-- content = content:gsub("EntityLoad%( \"mods/Apotheosis/files/entities/items/books/orbrooms/book_14.xml\", x %- 30, y %- 30 %)", "if not HasFlagPersistent(\"nee_cyclops_slime\") then EntityLoad( \"mods/Apotheosis/files/entities/items/books/orbrooms/book_14.xml\", x - 30, y - 30 ) end")
	-- ModTextFileSetContent(path, content)
	
	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/orbroom_14.lua", 
	[[LoadPixelScene%( %"data%/biome%_impl%/orbroom%_noxioussludge%.png%"%, %"data%/biome%_impl%/orbroom%_visual%.png%"%, x%, y%, %"data%/biome%_impl%/orbroom%_background%.png%"%, true %)]], 
	[[if not HasFlagPersistent("nee_cyclops_slime") then
    LoadPixelScene("data/biome_impl/orbroom_noxioussludge.png", "data/biome_impl/orbroom_visual.png", x, y, "data/biome_impl/orbroom_background.png", true)
else
    LoadPixelScene("data/biome_impl/apotheosis/orbroom_slime.png", "data/biome_impl/apotheosis/orbroom_visual_slime.png", x, y, "data/biome_impl/orbroom_background.png", true)
end]]
)
	
	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/orbroom_14.lua", 
	[[EntityLoad%( %"mods%/Apotheosis%/files%/entities%/items%/orbs%/custom%/orb%_14%.xml%"%, x%, y %)]], 
	[[if ModIsEnabled("quant.ew") then
		-- Utility function to split a string by delimiter and return a table
		function split(str, delimiter)
			local result = {}
			for match in (str..delimiter):gmatch("(.-)"..delimiter) do
				table.insert(result, match)
			end
			return result
		end

		-- Utility function to join a table into a string with a delimiter
		function join(tbl, delimiter)
			return table.concat(tbl, delimiter)
		end
		
		local entity_id = GetUpdatedEntityID()
		local pos_x, pos_y = EntityGetTransform(entity_id)

		-- Retrieve the global value storing the spawned worlds
		local spawned_worlds = GlobalsGetValue("new_enemies_cyclops_orb_boss_spawned", "")

		-- Convert the global value to a table
		local spawned_worlds_table = split(spawned_worlds, ",")

		-- Function to check if a value exists in a table
		function table_contains(tbl, val)
			for _, v in ipairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end

		-- Get the current parallel world index
		local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
		local current_world_index = tostring(current_world_x)
		
		local current_world_occupied = table_contains(spawned_worlds_table, tostring(current_world_x))

		-- Check if the boss has already been spawned in the current world
		if current_world_occupied == false then
			-- Add the current world index to the table and update the global value
			table.insert(spawned_worlds_table, current_world_index)
			CrossCall("sync_global", "new_enemies_cyclops_orb_boss_spawned", join(spawned_worlds_table, ","))

			if not HasFlagPersistent("nee_cyclops_slime") then
				EntityLoad("mods/Apotheosis/files/entities/items/orbs/custom/orb_14.xml", x, y)
			else
				EntityLoad("data/entities/buildings/cyclops_slime_spot.xml", x, y + 25)
			end
		end
	else
		if not HasFlagPersistent("nee_cyclops_slime") then
			EntityLoad("mods/Apotheosis/files/entities/items/orbs/custom/orb_14.xml", x, y)
		else
			EntityLoad("data/entities/buildings/cyclops_slime_spot.xml", x, y + 25)
		end
	end]]
)

	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/orbroom_14.lua", 
	[[EntityLoad%( %"mods%/Apotheosis%/files%/entities%/items%/books%/orbrooms%/book_14%.xml%"%, x %- 30%, y %- 30 %)]], 
	[[if not HasFlagPersistent("nee_cyclops_slime") then
    EntityLoad("mods/Apotheosis/files/entities/items/books/orbrooms/book_14.xml", x - 30, y - 30)
end]]
)

	--Basilisk Eel Boss Fight
	-- path = "mods/apotheosis/files/scripts/biomes/newbiome/orbroom_13.lua"
	-- content = ModTextFileGetContent(path)
	-- content = content:gsub("EntityLoad%( \"mods/Apotheosis/files/entities/items/orbs/custom/orb_13.xml\", x, y %)", "if not HasFlagPersistent(\"nee_boss_eel\") then EntityLoad( \"mods/apotheosis/files/entities/items/orbs/custom/orb_13.xml\", x, y ) else EntityLoad( \"data/entities/buildings/boss_eel_spot.xml\", x, y + 25 ) end")
	-- content = content:gsub("EntityLoad%( \"mods/Apotheosis/files/entities/items/books/orbrooms/book_13.xml\", x %- 30, y %- 30 %)", "if not HasFlagPersistent(\"nee_boss_eel\") then EntityLoad( \"mods/Apotheosis/files/entities/items/books/orbrooms/book_13.xml\", x - 30, y - 30 ) end")
	-- ModTextFileSetContent(path, content)
	
	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/orbroom_13.lua", 
	[[EntityLoad%( %"mods%/Apotheosis%/files%/entities%/items%/orbs%/custom%/orb%_13%.xml%"%, x%, y %)]], 
	[[if ModIsEnabled("quant.ew") then
		-- Utility function to split a string by delimiter and return a table
		function split(str, delimiter)
			local result = {}
			for match in (str..delimiter):gmatch("(.-)"..delimiter) do
				table.insert(result, match)
			end
			return result
		end

		-- Utility function to join a table into a string with a delimiter
		function join(tbl, delimiter)
			return table.concat(tbl, delimiter)
		end
		
		local entity_id = GetUpdatedEntityID()
		local pos_x, pos_y = EntityGetTransform(entity_id)

		-- Retrieve the global value storing the spawned worlds
		local spawned_worlds = GlobalsGetValue("new_enemies_eel_orb_boss_spawned", "")

		-- Convert the global value to a table
		local spawned_worlds_table = split(spawned_worlds, ",")

		-- Function to check if a value exists in a table
		function table_contains(tbl, val)
			for _, v in ipairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end

		-- Get the current parallel world index
		local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
		local current_world_index = tostring(current_world_x)
		
		local current_world_occupied = table_contains(spawned_worlds_table, tostring(current_world_x))

		-- Check if the boss has already been spawned in the current world
		if current_world_occupied == false then
			-- Add the current world index to the table and update the global value
			table.insert(spawned_worlds_table, current_world_index)
			CrossCall("sync_global", "new_enemies_eel_orb_boss_spawned", join(spawned_worlds_table, ","))

			if not HasFlagPersistent("nee_boss_eel") then
				EntityLoad("mods/apotheosis/files/entities/items/orbs/custom/orb_13.xml", x, y)
			else
				EntityLoad("data/entities/buildings/boss_eel_spot.xml", x, y + 25)
			end
		end
	else
		if not HasFlagPersistent("nee_boss_eel") then
			EntityLoad("mods/apotheosis/files/entities/items/orbs/custom/orb_13.xml", x, y)
		else
			EntityLoad("data/entities/buildings/boss_eel_spot.xml", x, y + 25)
		end
	end]]
)

	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/orbroom_13.lua", 
	[[EntityLoad%( %"mods%/Apotheosis%/files%/entities%/items%/books%/orbrooms%/book%_13%.xml%"%, x %- 30%, y %- 30 %)]], 
	[[if not HasFlagPersistent("nee_boss_eel") then
    EntityLoad("mods/Apotheosis/files/entities/items/books/orbrooms/book_13.xml", x - 30, y - 30)
end]]
)
	
	--Fungal Guardian Boss Fight
	-- path = "mods/apotheosis/files/scripts/biomes/newbiome/essenceroom_fungus.lua"
	-- content = ModTextFileGetContent(path)
	-- content = content:gsub("LoadPixelScene%( \"data/biome_impl/essenceroom.png\", \"data/biome_impl/essenceroom_visual.png\", x, y, \"data/biome_impl/essenceroom_background_with_diamond.png\"%, true %)", "if not HasFlagPersistent(\"nee_boss_fungus\") then LoadPixelScene%( \"data/biome_impl/essenceroom.png\", \"data/biome_impl/essenceroom_visual.png\", x, y, \"data/biome_impl/essenceroom_background_with_diamond.png\", true %) else LoadPixelScene( \"data/biome_impl/apotheosis/secret_lab.png\", \"data/biome_impl/apotheosis/secret_lab_visual.png\", x, y, \"data/biome_impl/apotheosis/secret_lab_background.png\", true ) end")
	-- content = content:gsub("EntityLoad%( \"mods/Apotheosis/files/entities/items/pickups/essence_fungus.xml\", x, y %)", "if not HasFlagPersistent(\"nee_boss_fungus\") then EntityLoad( \"mods/Apotheosis/files/entities/items/pickups/essence_fungus.xml\", x, y ) else EntityLoad( \"data/entities/buildings/boss_fungus_sleep.xml\", x, y + 20 ) end")
	-- ModTextFileSetContent(path, content)
	
	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/essenceroom_fungus.lua", 
	[[LoadPixelScene%( %"data%/biome%_impl%/essenceroom%.png%"%, %"data%/biome%_impl%/essenceroom%_visual%.png%"%, x%, y%, %"data%/biome%_impl%/essenceroom%_background%_with%_diamond%.png%"%, true %)]], 
	[[if not HasFlagPersistent("nee_boss_fungus") then
    LoadPixelScene("data/biome_impl/essenceroom.png", "data/biome_impl/essenceroom_visual.png", x, y, "data/biome_impl/essenceroom_background_with_diamond.png", true)
else
    LoadPixelScene("data/biome_impl/apotheosis/secret_lab.png", "data/biome_impl/apotheosis/secret_lab_visual.png", x, y, "data/biome_impl/apotheosis/secret_lab_background.png", true)
end]]
)
	
	replace_value("mods/Apotheosis/files/scripts/biomes/newbiome/essenceroom_fungus.lua", 
	[[EntityLoad%( %"mods%/Apotheosis%/files%/entities%/items%/pickups%/essence%_fungus%.xml%"%, x%, y %)]], 
	[[if ModIsEnabled("quant.ew") then
		-- Utility function to split a string by delimiter and return a table
		function split(str, delimiter)
			local result = {}
			for match in (str..delimiter):gmatch("(.-)"..delimiter) do
				table.insert(result, match)
			end
			return result
		end

		-- Utility function to join a table into a string with a delimiter
		function join(tbl, delimiter)
			return table.concat(tbl, delimiter)
		end
		
		local entity_id = GetUpdatedEntityID()
		local pos_x, pos_y = EntityGetTransform(entity_id)

		-- Retrieve the global value storing the spawned worlds
		local spawned_worlds = GlobalsGetValue("new_enemies_fungus_essence_boss_spawned", "")

		-- Convert the global value to a table
		local spawned_worlds_table = split(spawned_worlds, ",")

		-- Function to check if a value exists in a table
		function table_contains(tbl, val)
			for _, v in ipairs(tbl) do
				if v == val then
					return true
				end
			end
			return false
		end

		-- Get the current parallel world index
		local current_world_x, current_world_y = GetParallelWorldPosition(x, y)
		local current_world_index = tostring(current_world_x)
		
		local current_world_occupied = table_contains(spawned_worlds_table, tostring(current_world_x))

		-- Check if the boss has already been spawned in the current world
		if current_world_occupied == false then
			-- Add the current world index to the table and update the global value
			table.insert(spawned_worlds_table, current_world_index)
			CrossCall("sync_global", "new_enemies_fungus_essence_boss_spawned", join(spawned_worlds_table, ","))

			-- Spawn the boss and kill the spawner entity
			if not HasFlagPersistent("nee_boss_fungus") then
				EntityLoad("mods/Apotheosis/files/entities/items/pickups/essence_fungus.xml", x, y)
			else
				EntityLoad("data/entities/buildings/boss_fungus_sleep.xml", x, y + 20)
			end
		end
	else
		if not HasFlagPersistent("nee_boss_fungus") then
			EntityLoad("mods/Apotheosis/files/entities/items/pickups/essence_fungus.xml", x, y)
		else
			EntityLoad("data/entities/buildings/boss_fungus_sleep.xml", x, y + 20)
		end
	end]]
)
	
	--TOTAL HAX> NO IDEA WHY THIS works
	--Just trying to only enable progress icons for this if apotheosis is enabled
	-- content = ModTextFileGetContent("data/ui_gfx/animal_icons/_list.txt")
	-- content = content .. "\n\\extras/ear_boss.png\n\\extras/cyclops_slime.png\n\\extras/boss_eel.png\n\\extras/boss_fungus.png"
	-- ModTextFileSetContent("data/ui_gfx/animal_icons/_list.txt", content)
	-- content = ModTextFileGetContent("data/ui_gfx/animal_icons/_list.txt")
end

--God spawner function:
--REMEMBER THAT I DISABLED THESE IN CONJURER BECAUSE THEY GIVE OUT AN ERROR!!!
-- function OnMagicNumbersAndWorldSeedInitialized() 
	-- if ModIsEnabled("raksa") == false then
		if HasFlagPersistent("nee_god_warrior") then
			local path = "data/biome/_pixel_scenes.xml"
			local content = ModTextFileGetContent(path)
			local xml = nxml.parse(content)
			xml:first_of("mBufferedPixelScenes"):add_child(nxml.parse([[
			  <PixelScene pos_x="256" pos_y="-25856" just_load_an_entity="data/entities/buildings/god_spot.xml" />]]))
			ModTextFileSetContent(path, tostring(xml))
			
			
			local path = "data/biome/_pixel_scenes_newgame_plus.xml"
			local content = ModTextFileGetContent(path)
			local xml = nxml.parse(content)
			xml:first_of("mBufferedPixelScenes"):add_child(nxml.parse([[
			  <PixelScene pos_x="256" pos_y="-25856" just_load_an_entity="data/entities/buildings/god_spot.xml" />]]))
			ModTextFileSetContent(path, tostring(xml))
			-- print(tostring(xml))
			-- replace_value("data/biome/_pixel_scenes.xml", 
			-- [[%<%!%-%- music machines have copies on both directly adjacent parallel worlds %-%-%>]], 
			-- [[<PixelScene pos_x="256" pos_y="-25856" just_load_an_entity="data/entities/buildings/god_spot.xml" /> 
			-- <!-- music machines have copies on both directly adjacent parallel worlds -->]]
			-- )
		end

		--Anti God spawner function:
		if HasFlagPersistent("nee_cthulhu") then
			local path = "data/biome/_pixel_scenes.xml"
			local content = ModTextFileGetContent(path)
			local xml = nxml.parse(content)
			xml:first_of("mBufferedPixelScenes"):add_child(nxml.parse([[
			  <PixelScene pos_x="265" pos_y="37769" just_load_an_entity="data/entities/buildings/cthulhu_spot.xml" />]]))
			ModTextFileSetContent(path, tostring(xml))
			
			
			local path2 = "data/biome/_pixel_scenes_newgame_plus.xml"
			local content2 = ModTextFileGetContent(path2)
			local xml2 = nxml.parse(content2)
			xml2:first_of("mBufferedPixelScenes"):add_child(nxml.parse([[
			  <PixelScene pos_x="265" pos_y="37769" just_load_an_entity="data/entities/buildings/cthulhu_spot.xml" />]]))
			ModTextFileSetContent(path2, tostring(xml2))
			-- print(tostring(xml))
			
			-- replace_value("data/biome/_pixel_scenes.xml", 
			-- [[%<%!%-%- music machines have copies on both directly adjacent parallel worlds %-%-%>]], 
			-- [[<PixelScene pos_x="265" pos_y="37769" just_load_an_entity="data/entities/buildings/cthulhu_spot.xml" /> 
			-- <!-- music machines have copies on both directly adjacent parallel worlds -->]]
			-- )
		end
		-- if not HasFlagPersistent("ned_hellion") then
			-- local path = "data/biome/_pixel_scenes.xml"
			-- local content = ModTextFileGetContent(path)
			-- local xml = nxml.parse(content)
			-- xml:first_of("mBufferedPixelScenes"):add_child(nxml.parse([[
			  -- <PixelScene pos_x="-5445" pos_y="15739" just_load_an_entity="data/entities/buildings/hellion_spawner.xml" />]]))
			-- xml:first_of("mBufferedPixelScenes"):add_child(nxml.parse([[
			  -- <PixelScene pos_x="-3188" pos_y="14000" just_load_an_entity="data/entities/buildings/hellion_spawner.xml" />]]))
			-- ModTextFileSetContent(path, tostring(xml))
			-- -- print(tostring(xml))
			-- -- replace_value("data/biome/_pixel_scenes.xml", 
			-- -- [[%<%!%-%- music machines have copies on both directly adjacent parallel worlds %-%-%>]], 
			-- -- [[<PixelScene pos_x="256" pos_y="-25856" just_load_an_entity="data/entities/buildings/god_spot.xml" /> 
			-- -- <!-- music machines have copies on both directly adjacent parallel worlds -->]]
			-- -- )
		-- end
	-- end
-- end

-- function add_god_spot_spawner_script(player_entity)
    -- local lua_components = EntityGetComponent(player_entity, "LuaComponent") or {}
    -- local god_spot_spawner_found = false
    -- for i, comp in ipairs(lua_components) do
        -- local script_source_file = ComponentGetValue(comp, "script_source_file")
        -- if script_source_file == "data/scripts/god_spot_spawner.lua" then
            -- god_spot_spawner_found = true
            -- break
        -- end
    -- end
    -- if not god_spot_spawner_found and not GameHasFlagRun("god_spot_spawned") then
        -- EntityAddComponent(player_entity, "LuaComponent", {
            -- script_source_file="data/scripts/god_spot_spawner.lua",
            -- execute_times="-1",
            -- execute_every_n_frame="61",
        -- })
		-- GameAddFlagRun("god_spot_spawned")
    -- end
-- end


--Add New Enemies to Tower:
if not HasFlagPersistent("ned_tower_enemies") then
	if mode == "normal" or not mode then

		-- Specify the enemy name and flag name in this format: {enemy_name = enemy_flag_name}
		local enemies_to_check = {
		  slimer = "slimer",
		  yoyoer_shaman = "yoyoer_shaman",
		  chainsawer = "chainsawer",
		  -- brain2 = "brain2",
		  -- hand2 = "hand2",
		  -- head2 = "head2",
		  -- fleshclops2 = "fleshclops2",
		  -- tentacle_monster2 = "tentacle_monster2",
		  worm_saw = "worm_saw",
		  lukki_saw = "lukki_saw",
		  yoyoer = "yoyoer",
		  player_evil_green_sleep = "player_evil",
		  manticore = "manticore",
		  mexxi = "mexxi",
		  worm_portal = "worm_portal",
		  coffin_mummy = "mummy",
		  hell_door = "hell_door",
		  corpse_lily = "corpse_lily",
		  beehive = "beehive",
		  fireworkman = "fireworkman",
		  skullspider = "skullspider",
		  phantom_boss = "phantom_boss",
		  plant_boss = "plant_boss",
		  mule_sleep = "mule",
		  bloodmage_enlightened = "bloodmage_enlightened",
		  gold_face_physics = "gold_face_physics",
		  chameleon = "chameleon",
		  mantis = "mantis",
		  scorpio = "scorpio",
		  crawler_bug = "crawler_bug",
		  larva_crawler = "larva_crawler",
		  spider_crawler = "spider_crawler",
		  flopper_mother_giant = "flopper_mother_giant",
		  shield_physics = "shield_physics",
		  kiwiki = "kiwiki",
		  jungle_flower = "jungle_flower",
		  oruai = "oruai",
		  flopper_mother = "flopper_mother",
		  wizard_tiny = "wizard_tiny",
		  minabomination = "minabomination",
		  scarab = "scarab",
		  beanpodupine = "beanpodupine",
		  skullspider = "skullspider",
		  cryogen = "cryogen",
		  welder = "welder",
		  flutterpede = "flutterpede",
		  hurpa = "hurpa",
		  manus = "manus",
		  polyp_gas = "polyp_gas",
		  conduit = "conduit",
		  drone_trail = "drone_trail",
		  irtokki = "irtokki",
		  tank_fire2 = "tank_fire2",
		  scavenger_poison_immunity = "scavenger_poison_immunity",
		  sporeling_tiny = "sporeling_tiny",
		  sporeling = "sporeling",
		  sporeling_large = "sporeling_large",
		  wizard_madness = "wizard_madness",
		  eradicator = "eradicator",
		  mirror_physics = "mirror_physics",
		  drone_beam = "drone_beam",
		  hazmat = "hazmat",
		  radiobot = "radiobot",
		  electrobot = "electrobot",
		  cargobot = "cargobot",
		  commander = "commander",
		  sawbot = "sawbot",
		  singularitor = "singularitor",
		  wraith_void2 = "wraith_void2",
		  -- blob_giant = "blob_giant",
		  -- giantfirebug = "giantfirebug",
		  alien = "alien",
		  mutant2 = "mutant2",
		  smoke_bot = "smoke_bot",
		  lukki_swamp2 = "lukki_swamp2",
		  fungus_swamp2 = "fungus_swamp2",
		  scavenger_electrocuter2 = "scavenger_electrocuter2",
		  drone_face2 = "drone_face2",
		  valkyrie2 = "valkyrie2",
		  wandmaster2 = "wandmaster2",
		  void_mask2 = "void_mask2",
		  phantom_trapper = "phantom_trapper",
		  potionmaster2 = "potionmaster2",
		  toxicmage_acid2 = "toxicmage_acid2",
		  toxicmage2 = "toxicmage2",
		  lost_soul_big = "lost_soul_big",
		  lost_soul = "lost_soul",
		  twig_grower = "twig",
		  player_ai = "player_ai",
		  menhir = "menhir",
		  knight = "knight",
		  wizard_trip = "wizard_trip",
		  -- worm_fungal = "worm_fungal",
		  igu = "igu",
		  chest_great_mimic = "chest_great_mimic",
		  hybrid = "hybrid",
		  scavenger_undercover = "scavenger_undercover",
		  zombie_giant = "zombie_giant",
		  head_statue_physics = "head_statue_physics",
		  fallen_alchemist = "fallen_alchemist",
		  icemage_big2 = "icemage_big2",
		  cyborg = "cyborg",
		  scavenger_laser = "scavenger_laser",
		  icicle_king = "icicle_king",
		  corrupt_alchemist = "corrupt_alchemist",
		  longleg_big = "longleg_big",
		  forgotten_alchemist = "forgotten_alchemist",
		  eldari_big = "eldari_big",
		  firemage_big = "firemage_big",
		  -- desulitor = "desulitor",
		  alchaos = "alchaos",
		  bloodmage_greater = "bloodmage_greater",
		  fire_crawler = "fire_crawler",
		  gazer_laser = "gazer_laser",
		  -- menace = "menace",
		  giant_energy = "giant_energy",
		  giant_alt = "giant_alt",
		  bloodmage_lesser = "bloodmage_lesser",
		  thou = "thou",
		  giant_old = "giant_old",
		  wizard_time = "wizard_time",
		  -- flesh_monster = "flesh_monster",
		  wizard_earthquake = "wizard_earthquake",
		  nova = "nova",
		  ghuu = "ghuu",
		  gonha = "gonha",
		  miner_alcohol = "miner_alcohol",
		  scavenger_alcohol = "scavenger_alcohol",
		  -- worm_eel = "worm_eel",
		  -- worm_robot = "worm_robot",
		  -- jellyfish = "jellyfish",
		  scavenger_radiolava = "scavenger_radiolava",
		  scavenger_compressor_robot = "scavenger_compressor_robot",
		  scavenger_turbo_robot = "scavenger_turbo_robot",
		  scavenger_gas_robot = "scavenger_gas_robot",
		  slime_turret = "slime_turret",
		  enigma = "enigma",
		  -- flesh_wall = "flesh_wall",
		  frog_bot = "frog_bot",
		  eye_bat = "eye_bat",
		  snowman2 = "snowman",
		  wraith_speed = "wraith_speed",
		  phan = "phan",
		  ooion = "ooion",
		  moal = "moal",
		  mutant_blob = "mutant_blob",
		  stone_crab = "stone_crab",
		  -- stalker_ceiling = "stalker_ceiling",
		  dripper = "dripper",
		  -- driller = "driller",
		  vine_monster = "vine_monster",
		  sneeker = "sneeker",
		  ground_terror = "ground_terror",
		  bouncer = "bouncer",
		  fungus_spore = "fungus_spore",
		  stalker = "stalker",
		  monkey = "monkey",
		  invisiman = "invisiman",
		  eye_monster = "eye_monster",
		  scavenger_robot = "scavenger_robot",
		  scavenger_compressor = "scavenger_compressor",
		  scavenger_turbo = "scavenger_turbo",
		  scavenger_gas = "scavenger_gas",
		  scavenger_oiler = "scavenger_oiler",
		  -- hairling = "hairling",
		  goomonster = "goomonster",
		  goomonster_giant = "goomonster_giant",
		  goomonster_giant_alt = "goomonster_giant_alt",
		  -- face_worm = "face_worm",
		  shapeshifter = "shapeshifter",
		  lukki_white = "lukki_white",
		  draghoul = "draghoul",
		  imp = "imp",
		  lukki_blue = "lukki_blue",
		  lukki_red = "lukki_red",
		  scavenger_trigger = "scavenger_trigger",
		  crawler = "crawler",
		  bot = "bot",
		  laserbot = "laserbot",
		  robot = "robot",
		  bluemancer = "bluemancer",
		  lavashooter = "lavashooter",
		  gigashooter = "gigashooter",
		  archer = "archer",
		  axeman = "axeman",
		  bigfly = "bigfly",
		  -- bloodskull = "bloodskull",
		  drone = "drone2",
		  earthskull = "earthskull",
		  --electricskull = "electricskull",
		  earthmage = "earthmage",
		  polyshooter = "polyshooter",
		  chaoticpolyshooter = "chaoticpolyshooter",
		  watermonster = "watermonster",
		  acidmonster = "acidmonster",
		  bloodmonster = "bloodmonster",
		  scavenger_plasma = "scavenger_plasma",
		  creeper = "creeper",
		  bloom_ceiling = "ceiling_bloom",
		  -- ceilingflower = "ceilingflower",
		  landflower = "landflower",
		  book = "book",
		  darkghost2 = "darkghost",
		  ent = "ent",
		  eyeling = "eyeling",
		  ghostling = "ghostling",
		  icemage = "icemage",
		  jungle_worm = "jungle_worm",
		  long_ghost = "long_ghost",
		  nautilus = "nautilus",
		  nightmare = "nightmare",
		  skeleton = "skeleton",
		  skullmage = "skullmage",
		  spider = "spider",
		  spooky_ghost = "spooky_ghost",
		  -- stone_physics = "stone_physics",
		  summoner = "summoner"
		  -- Add more enemies here
		}

		local creature_table = {}

		-- Check for the flag for each enemy
		for enemy_name, enemy_flag_name in pairs(enemies_to_check) do
		  if not HasFlagPersistent("ned_" .. enemy_flag_name) then
		    if enemy_name == "bloom_ceiling" then
				table.insert(creature_table, "normal_bloom/bloom")
			else
				table.insert(creature_table, enemy_name)
			end
		  end
		end

		local concat_table = table.concat(creature_table, "\",\"")

		local path = "data/scripts/biomes/tower.lua"
		local content = ModTextFileGetContent(path)
		content = content:gsub([[local enemy_list = { "acidshooter", "alchemist", "ant",]], table.concat({[[enemy_list = { "acidshooter", "alchemist", "ant","]],concat_table,"\","}))
		ModTextFileSetContent(path, content)
		
	elseif mode == "easy" then
		-- Specify the enemy name and flag name in this format: {enemy_name = enemy_flag_name}
		local enemies_to_check = {
		  slimer = "slimer",
		  chainsawer = "chainsawer",
		  yoyoer_shaman = "yoyoer_shaman",
		  yoyoer = "yoyoer",
		  beehive = "beehive",
		  fireworkman = "fireworkman",
		  crawler_bug = "crawler_bug",
		  larva_crawler = "larva_crawler",
		  spider_crawler = "spider_crawler",
		  jungle_flower = "jungle_flower",
		  wizard_tiny = "wizard_tiny",
		  beanpodupine = "beanpodupine",
		  cryogen = "cryogen",
		  welder = "welder",
		  conduit = "conduit",
		  slime_ghoul = "slime_ghoul",
		  hazmat = "hazmat",
		  radiobot = "radiobot",
		  electrobot = "electrobot",
		  cargobot = "cargobot",
		  commander = "commander",
		  sawbot = "sawbot",
		  alien = "alien",
		  mutant2 = "mutant2",
		  lukki_swamp2 = "lukki_swamp2",
		  fungus_swamp2 = "fungus_swamp2",
		  scavenger_electrocuter2 = "scavenger_electrocuter2",
		  drone_face2 = "drone_face2",
		  valkyrie2 = "valkyrie2",
		  phantom_trapper = "phantom_trapper",
		  potionmaster2 = "potionmaster2",
		  toxicmage2 = "toxicmage2",
		  lost_soul = "lost_soul",
		  twig = "twig_grower",
		  menhir = "menhir",
		  knight = "knight",
		  wizard_trip = "wizard_trip",
		  hybrid = "hybrid",
		  scavenger_undercover = "scavenger_undercover",
		  zombie_giant = "zombie_giant",
		  head_statue_physics = "head_statue_physics",
		  fallen_alchemist = "fallen_alchemist",
		  cyborg = "cyborg",
		  scavenger_laser = "scavenger_laser",
		  corrupt_alchemist = "corrupt_alchemist",
		  longleg_big = "longleg_big",
		  forgotten_alchemist = "forgotten_alchemist",
		  eldari_big = "eldari_big",
		  firemage_big = "firemage_big",
		  -- desulitor = "desulitor",
		  fire_crawler = "fire_crawler",
		  giant_energy = "giant_energy",
		  giant_alt = "giant_alt",
		  bloodmage_lesser = "bloodmage_lesser",
		  giant_old = "giant_old",
		  wizard_time = "wizard_time",
		  wizard_earthquake = "wizard_earthquake",
		  gonha = "gonha",
		  miner_alcohol = "miner_alcohol",
		  scavenger_alcohol = "scavenger_alcohol",
		  enigma = "enigma",
		  frog_bot = "frog_bot",
		  eye_bat = "eye_bat",
		  snowman2 = "snowman",
		  ooion = "ooion",
		  moal = "moal",
		  mutant_blob = "mutant_blob",
		  -- stalker_ceiling = "stalker_ceiling",
		  dripper = "dripper",
		  -- driller = "driller",
		  vine_monster = "vine_monster",
		  sneeker = "sneeker",
		  bouncer = "bouncer",
		  stalker = "stalker",
		  monkey = "monkey",
		  invisiman = "invisiman",
		  eye_monster = "eye_monster",
		  scavenger_compressor = "scavenger_compressor",
		  scavenger_gas = "scavenger_gas",
		  scavenger_oiler = "scavenger_oiler",
		  goomonster = "goomonster",
		  goomonster_giant = "goomonster_giant",
		  goomonster_giant_alt = "goomonster_giant_alt",
		  shapeshifter = "shapeshifter",
		  draghoul = "draghoul",
		  imp = "imp",
		  scavenger_trigger = "scavenger_trigger",
		  crawler = "crawler",
		  bot = "bot",
		  laserbot = "laserbot",
		  bluemancer = "bluemancer",
		  gigashooter = "gigashooter",
		  archer = "archer",
		  axeman = "axeman",
		  bigfly = "bigfly",
		  -- bloodskull = "bloodskull",
		  drone2 = "drone2",
		  earthmage = "earthmage",
		  scavenger_plasma = "scavenger_plasma",
		  creeper = "creeper",
		  darkghost2 = "darkghost",
		  ent = "ent",
		  eyeling = "eyeling",
		  ghostling = "ghostling",
		  icemage = "icemage",
		  icicle = "icicle",
		  long_ghost = "long_ghost",
		  nautilus = "nautilus",
		  nightmare = "nightmare",
		  skeleton = "skeleton",
		  skullmage = "skullmage",
		  spider = "spider",
		  summoner = "summoner"
		  -- Add more enemies here
		}

		local creature_table = {}

		-- Check for the flag for each enemy
		for enemy_name, enemy_flag_name in pairs(enemies_to_check) do
		  if not HasFlagPersistent("ned_" .. enemy_flag_name) then
			table.insert(creature_table, enemy_name)
		  end
		end

		local concat_table = table.concat(creature_table, "\",\"")

		local path = "data/scripts/biomes/tower.lua"
		local content = ModTextFileGetContent(path)
		content = content:gsub([[local enemy_list = { "acidshooter", "alchemist", "ant",]], table.concat({[[local enemy_list = { "acidshooter", "alchemist", "ant","]],concat_table,"\","}))
		ModTextFileSetContent(path, content)
	end
end

if ModSettingGet("new_enemies.poly_expansion_enabled") then
	if ModSettingGet("new_enemies.poly_only_player_enabled") then
	-- replace_value("data/entities/misc/effect_polymorph_random.xml", 
	-- [[POLYMORPH_RANDOM]], 
	-- [[NONE]]
	-- )
	
	-- replace_value("data/entities/misc/effect_polymorph_random.xml", 
	-- [[polymorph%_target%=%"%[RANDOM%]%"]], 
	-- [[]]
	-- )
	
	replace_value("data/entities/misc/effect_polymorph_random.xml", 
	[[%<%/AudioComponent%>]], 
	[[</AudioComponent>

	<LuaComponent 
		_enabled="1" 
		script_source_file="data/scripts/misc/morpher_player_only.lua" 
		execute_every_n_frame="-1"
		execute_times="1"
		remove_after_executed="1"
		execute_on_added="1">
   </LuaComponent>]]
)
	end
end

--On Player Spawned
function OnPlayerSpawned(player_entity)
    if (GlobalsGetValue("new_enemies_mod_load_done", 0) == "1") then
      return
    end
	--Another Shader Check Just In Case
	if not HasFlagPersistent("ned_wizard_tiny") then
		GameSetPostFxParameter("zoom_in_amount", 1.0, 0, 0, 0)
	end
	
	--Addition of custom polymorph enemies
	if ModSettingGet("new_enemies.poly_expansion_enabled") then
		if ModSettingGet("new_enemies.poly_only_player_enabled") == false then
			--PolymorphTableAddEntity( entity_xml:string, is_rare:bool = false, add_only_one_copy:bool = true )
			PolymorphTableAddEntity( "data/entities/animals/acidmonster.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/alchaos.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/alien.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/alligator_temple.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/alligator_temple_small.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/angler.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/archer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/axeman.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/babon.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/beanpodupine.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/blob_giant.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bloodmage_greater.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bloodmage_lesser.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bloodmonster.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bloodskull.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/normal_bloom/bloom.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/bloom_ceiling.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bluemancer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/book.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bouncer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/camel.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/cargobot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/landflower.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/ceilingflower.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/chaoticpolyshooter.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/chest_great_boss.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/cobra.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/commander.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/conduit.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/copter.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/corrupt_alchemist.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/crawler.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/creeper.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/cyborg.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/darkghost2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/flutterpede.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/cryogen.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/desulitor.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/desulitor_fly.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/doom_bringer.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/poly/drake_snake.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/driller.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/dripper.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/drone_beam.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/drone_face2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/drone_trail.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/drone2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/earthmage.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/earthskull.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/eldari_big.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/electrobot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/draghoul.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/enigma.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/ent.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/eradicator.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/eye.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/eye_bat.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/eye_bat_birthday.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/eye_bat_easter.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/eye_bat_pumpkin.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/eye_bat_valentines.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/eye_monster.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/eyeling.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/face_worm.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/poly/fallen_alchemist.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/fire_crawler.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/firemage_big.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/fish_angler2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/flesh_monster.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/flutterpede.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/forgotten_alchemist.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/frog_bot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/frog_tiny.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/fungus_spore.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/fungus_swamp2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/gazer_laser.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/ghostling.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/ghuu.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/giant_alt.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/giant_energy.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/giant_old.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/giant_squid.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/giantfirebug.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/gigashooter.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/gonha.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/goomonster.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/goomonster_giant.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/goomonster_giant_alt.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/ground_terror.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/hairling.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/hazmat.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/head_statue_physics.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/hurpa.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/hybrid.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/icemage_big2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/icemage2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/icicle.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/icicle_ceiling.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/icicle_king.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/igu.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/imp.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/invisiman.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/irtokki.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/jellyfish.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/jungle_worm.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/junkbot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/knight.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/landflower.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/laserbot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lavashooter.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lightling.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/llama.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/locust.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/long_ghost.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/longleg_big.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lost_soul.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lost_soul_big.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lukki_blue.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lukki_ominous.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lukki_red.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lukki_swamp2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lukki_weird.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lukki_white.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mammoth.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mammoth_baby.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/manus.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/menace.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/menhir.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/minabomination.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/miner_alcohol.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mirror_physics.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/moal.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/monkey.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mutant2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/nautilus.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/nightmare.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/nova.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/ooion.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/peasant.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/phan.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/phantom_trapper.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/phantom_boss.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mutant_blob.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/player_ai.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/player_clone.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/player_decoy.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/player_evil.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/polyp_gas.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/polyshooter.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/potionmaster2.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/quin.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/radiobot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/robot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/sawbot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scarab.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_alcohol.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_civilian.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_compressor.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_compressor_robot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_electrocuter2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_gas.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_gas_robot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_laser.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_monster.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_oiler.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_plasma.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_poison_immunity.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_radiolava.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_robot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_trigger.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_turbo.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_turbo_robot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_undercover.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/serpentor.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/shark.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/singularitor.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_4th_july.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_4th_july_firework.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_antlorz.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_beer.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_birthday.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_bull_fighting.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_candy.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_carnevale.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_carnival.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_champagne.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_christmas.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_diwalli.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_easter_bunny.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_green.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_lunar_new_year.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_guitar.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_guitar2.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_guitarron.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_guitarron2.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_harp.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_harp2.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_maraca.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_maraca2.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_trumpet.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_trumpet2.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_violin.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_mariachi_violin2.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_oriental.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_present.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_pride.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_pumpkin.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_thanksgiving.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_valentines.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_vampire.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skeleton_vader.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skullmage.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/skullspider.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/slime_ghoul.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/slime_roller.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/slimer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/slime_turret.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/slimeshooter_golden.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/smoke_bot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/sneeker.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/snowman2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/spider.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/spooky_ghost.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/sporeling.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/sporeling_large.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/sporeling_tiny.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/stalker.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/stalker_ceiling.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/stingray.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/stone_crab.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/stone_physics.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/summoner.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/tank_fire2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/thou.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/toxicmage_acid2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/toxicmage2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/trumpet.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/twig.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/valkyrie2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/vine_monster.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/void_mask2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wandmaster2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/watermonster.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/welder.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wizard_earthquake.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wizard_madness.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wizard_random.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wizard_time.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wizard_trip.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wizard_twin.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wizard_tiny.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/worm_eel.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/worm_fungal.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/worm_robot.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/worm_skull_old.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wraith_speed.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/wraith_void2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/zap_eel2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/zombie_giant.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/zombie3.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/flopper_mother.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/oruai.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/jungle_flower.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/kiwiki.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/shield_physics.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/flopper_mother_giant.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/scorpio.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mantis.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/chameleon.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/corpse_lily.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/fireworkman.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mexxi.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/mummy.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/beehive.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/larva_crawler.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/crawler_bug.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/spider_crawler.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/fire_crawler.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/poly/worm_portal.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/manticore.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/puffer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/yoyoer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/lukki_saw.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/tentacle_monster2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/head2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/hand2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/brain2.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/chainsawer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/chainsawer_hell.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/yoyoer_shaman.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/worm_saw.xml", false, true )
			--PolymorphTableAddEntity( "data/entities/animals/boid.xml", false, true )
			
			--Minibosses
			PolymorphTableAddEntity( "data/entities/animals/gold_face_physics.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/bloodmage_enlightened.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/gazer_necromancer.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/blood_teddy.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/cerebracle.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/dragon_ice.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/khulu.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/lempo.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/medusa.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/miner_boss.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/mother_nature.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/necromancer_omega.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/jungle_deity.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/technomancer.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/necromancer_cultist.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_king.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/scavenger_king_robot.xml", true, true )
			--PolymorphTableAddEntity( "data/entities/animals/shiva.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/skull_abomination.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/slimeshooter_mega.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/sochaos.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/tardigrade.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/tank_boss.xml", true, true )
			PolymorphTableAddEntity( "data/entities/animals/terminator.xml", true, true )
			
			--Colossi
			-- PolymorphTableAddEntity( "data/entities/animals/aquatitan.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/hell_overseer.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/devourer.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/stork.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/whale.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/piranha.xml", false, true )
			
			--Bosses
			PolymorphTableAddEntity( "data/entities/animals/bird.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/camel_robot.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/cthulhu.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/desert_mage.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/desert_skull.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/elephant.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/giant_boss.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/god_warrior.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/golem.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/hydra.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/lake_statue.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/lukki_dark_huge.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/mwyah.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/mwyah_face.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/seamonster.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/skymonster.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/windmill.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/wraith_boss.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/yikka.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/yikka_ghost.xml", false, true )

			--Removed enemies
			-- PolymorphTableAddEntity( "data/entities/animals/fireflower.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/glyptodillo.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/lurker2.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/mysterious_wanderer.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/necromancer_polymorph.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/sneeker_weak.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/temple_skeleton.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/wanderer.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/wizard_toxic.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/wizard_water.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/wraith_old.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/wyrm.xml", false, true )
			
			--Removed mini bosses
			-- PolymorphTableAddEntity( "data/entities/animals/boss_rock_spirit.xml", true, true )
			
			--Removed Bosses
			-- PolymorphTableAddEntity( "data/entities/animals/fury1.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/fury2.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/fury3.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/god.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/harpy1.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/harpy2.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/harpy3.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/lava_monster.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/naga.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/skeleboss.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/sorceress.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/ghust.xml", false, true )
			-- PolymorphTableAddEntity( "data/entities/animals/temple_creep_skull.xml", true, true )
			
			--Easter Eggs
			PolymorphTableAddEntity( "data/entities/animals/lemming.xml", false, true )
			PolymorphTableAddEntity( "data/entities/animals/tank_propane.xml", false, true )
		end
	end

	--Addition of God spot in moon
	
	-- if HasFlagPersistent("nee_god") then
		-- add_god_spot_spawner_script(player_entity)
	-- end
	
	--Addition of materials that damage to player
	
    add_materials_that_damage(player_entity, {
	  new_enemies_custom_lava = 0.003,
	  boss_fungus_gas = 0.0006,
      cloud_acid = 0.005,
      acid_weak = 0.00075,
      rock_static_cursed_green2 = 0.001,
	  rock_box2d_hard_damage = 0.0003,
	  rock_box2d_harder_damage = 0.001,
	  radioactive_goo = 0.000001
    })
	
	--Addition of position tracker to player
	
	-- EntityAddComponent(player_entity, "VariableStorageComponent", {
		-- name="position_tracker",
		-- value_string=""
	-- })
					
	-- EntityAddComponent(player_entity, "LuaComponent", {
		-- script_source_file="data/scripts/misc/position_tracker.lua",
		-- execute_every_n_frame=2,
		-- execute_on_added=0,
	-- }) 
	
	--flag reset:
	
	-- EntityAddComponent(player_entity, "LuaComponent", {
		-- script_source_file="data/scripts/misc/flag_reset.lua",
		-- execute_every_n_frame=-1,
		-- execute_on_added=0,
		-- execute_on_removed=1,
	-- })
	if ModSettingGet("new_enemies.disable_offscreen_attacks_enabled") then
		EntityAddComponent2(player_entity, "LuaComponent", {
			script_source_file="mods/new_enemies/files/disable_offscreen_attacks.lua",
			execute_every_n_frame=1,
			execute_on_added=false,
		})
	end
	
	-- EntityAddComponent2(player_entity, "LuaComponent", {
		-- script_biome_entered="mods/new_enemies/files/log_pw.lua",
		-- execute_every_n_frame=-1,
		-- execute_on_added=false
	-- })
	
	GlobalsSetValue("new_enemies_mod_load_done", "1")
	
end

--print(ModTextFileGetContent("data/shaders/post_final.frag"))