-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-08-31 03:02:22
-- Luau version 6, Types version 3
-- Time taken: 0.011714 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LuckyBlocks = require(ReplicatedStorage:WaitForChild("Datas").LuckyBlocks)
local Updates_upvr = require(ReplicatedStorage:WaitForChild("Shared").Updates)
local module = {
	["Noobini Pizzanini"] = {
		DisplayName = "Noobini Pizzanini";
		Rarity = "Common";
		Price = 25;
		Generation = 1;
		RoadWeight = 100;
	};
	["Liril\xEC Laril\xE0"] = {
		DisplayName = "Liril\xEC Laril\xE0";
		Rarity = "Common";
		Price = 250;
		Generation = 3;
		RoadWeight = 55;
	};
	["Tim Cheese"] = {
		DisplayName = "Tim Cheese";
		Rarity = "Common";
		Price = 500;
		Generation = 5;
		RoadWeight = 50;
	};
	Fluriflura = {
		DisplayName = "Fluriflura";
		Rarity = "Common";
		Price = 750;
		Generation = 7;
		RoadWeight = 45;
	};
	["Svinina Bombardino"] = {
		DisplayName = "Svinina Bombardino";
		Rarity = "Common";
		Price = 1250;
		Generation = 10;
		RoadWeight = 40;
	};
	["Talpa Di Fero"] = {
		DisplayName = "Talpa Di Fero";
		Rarity = "Common";
		Price = 1000;
		Generation = 9;
		RoadWeight = 43;
	};
	["Pipi Kiwi"] = {
		DisplayName = "Pipi Kiwi";
		Rarity = "Common";
		Price = 1500;
		Generation = 13;
		RoadWeight = 37;
	};
	["Pipi Corni"] = {
		DisplayName = "Pipi Corni";
		Rarity = "Common";
		Price = 1750;
		Generation = 14;
	};
	["Raccooni Jandelini"] = {
		DisplayName = "Raccooni Jandelini";
		Rarity = "Common";
		Price = 1350;
		Generation = 12;
		IgnoreIndexCounter = true;
	};
	["Trippi Troppi"] = {
		DisplayName = "Trippi Troppi";
		Rarity = "Rare";
		Price = 2000;
		Generation = 15;
		RoadWeight = 30;
	};
	["Tung Tung Tung Sahur"] = {
		DisplayName = "Tung Tung Tung Sahur";
		Rarity = "Rare";
		Price = 3000;
		Generation = 25;
		RoadWeight = 27;
	};
	["Gangster Footera"] = {
		DisplayName = "Gangster Footera";
		Rarity = "Rare";
		Price = 4000;
		Generation = 30;
		RoadWeight = 25;
	};
	["Boneca Ambalabu"] = {
		DisplayName = "Boneca Ambalabu";
		Rarity = "Rare";
		Price = 5000;
		Generation = 40;
		RoadWeight = 20;
	};
	["Ta Ta Ta Ta Sahur"] = {
		DisplayName = "Ta Ta Ta Ta Sahur";
		Rarity = "Rare";
		Price = 7500;
		Generation = 55;
		RoadWeight = 17;
	};
	["Tric Trac Baraboom"] = {
		DisplayName = "Tric Trac Baraboom";
		Rarity = "Rare";
		Price = 9000;
		Generation = 65;
		RoadWeight = 15;
	};
	["Bandito Bobritto"] = {
		DisplayName = "Bandito Bobritto";
		Rarity = "Rare";
		Price = 4500;
		Generation = 35;
		RoadWeight = 22.5;
	};
	["Cacto Hipopotamo"] = {
		DisplayName = "Cacto Hipopotamo";
		Rarity = "Rare";
		Price = 6500;
		Generation = 50;
		RoadWeight = 18.5;
	};
	["Pipi Avocado"] = {
		DisplayName = "Pipi Avocado";
		Rarity = "Rare";
		Price = 9500;
		Generation = 70;
	};
	["Cappuccino Assassino"] = {
		DisplayName = "Cappuccino Assassino";
		Rarity = "Epic";
		Price = 10000;
		Generation = 75;
		RoadWeight = 13;
	};
	["Brr Brr Patapim"] = {
		DisplayName = "Brr Brr Patapim";
		Rarity = "Epic";
		Price = 15000;
		Generation = 100;
		RoadWeight = 10;
	};
	["Trulimero Trulicina"] = {
		DisplayName = "Trulimero Trulicina";
		Rarity = "Epic";
		Price = 20000;
		Generation = 125;
		RoadWeight = 7;
	};
	["Bananita Dolphinita"] = {
		DisplayName = "Bananita Dolphinita";
		Rarity = "Epic";
		Price = 25000;
		Generation = 150;
		RoadWeight = 5;
	};
	["Brri Brri Bicus Dicus Bombicus"] = {
		DisplayName = "Brri Brri Bicus Dicus Bombicus";
		Rarity = "Epic";
		Price = 30000;
		Generation = 175;
		RoadWeight = 3.5;
	};
	["Bambini Crostini"] = {
		DisplayName = "Bambini Crostini";
		Rarity = "Epic";
		Price = 22500;
		Generation = 135;
		RoadWeight = 6;
	};
	["Perochello Lemonchello"] = {
		DisplayName = "Perochello Lemonchello";
		Rarity = "Epic";
		Price = 27500;
		Generation = 160;
		RoadWeight = 4.5;
	};
	["Avocadini Guffo"] = {
		DisplayName = "Avocadini Guffo";
		Rarity = "Epic";
		Price = 35000;
		Generation = 225;
		RoadWeight = 3;
	};
	["Salamino Penguino"] = {
		DisplayName = "Salamino Penguino";
		Rarity = "Epic";
		Price = 40000;
		Generation = 250;
		RoadWeight = 2.5;
	};
	["Ti Ti Ti Sahur"] = {
		DisplayName = "Ti Ti Ti Sahur";
		Rarity = "Epic";
		Price = 37500;
		Generation = 225;
	};
	["Penguino Cocosino"] = {
		DisplayName = "Penguino Cocosino";
		Rarity = "Epic";
		Price = 45000;
		Generation = 300;
	};
}
local tbl_3 = {
	DisplayName = "Avocadini Antilopini";
	Rarity = "Epic";
	Price = 17500;
	Generation = 115;
	RoadWeight = 8.5;
}
local function IsEnabled() -- Line 268
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_3.IsEnabled = IsEnabled
module["Avocadini Antilopini"] = tbl_3
module["Burbaloni Loliloli"] = {
	DisplayName = "Burbaloni Loliloli";
	Rarity = "Legendary";
	Price = 35000;
	Generation = 200;
	RoadWeight = 1;
}
module["Chimpanzini Bananini"] = {
	DisplayName = "Chimpanzini Bananini";
	Rarity = "Legendary";
	Price = 50000;
	Generation = 300;
	RoadWeight = 0.75;
}
module["Ballerina Cappuccina"] = {
	DisplayName = "Ballerina Cappuccina";
	Rarity = "Legendary";
	Price = 100000;
	Generation = 500;
	RoadWeight = 0.55;
}
module["Chef Crabracadabra"] = {
	DisplayName = "Chef Crabracadabra";
	Rarity = "Legendary";
	Price = 150000;
	Generation = 600;
	RoadWeight = 0.5;
}
module["Glorbo Fruttodrillo"] = {
	DisplayName = "Glorbo Fruttodrillo";
	Rarity = "Legendary";
	Price = 200000;
	Generation = 750;
	RoadWeight = 0.45;
}
module["Blueberrinni Octopusini"] = {
	DisplayName = "Blueberrinni Octopusini";
	Rarity = "Legendary";
	Price = 250000;
	Generation = 1000;
	RoadWeight = 0.4;
}
module["Lionel Cactuseli"] = {
	DisplayName = "Lionel Cactuseli";
	Rarity = "Legendary";
	Price = 175000;
	Generation = 650;
	RoadWeight = 0.47;
}
module["Pandaccini Bananini"] = {
	DisplayName = "Pandaccini Bananini";
	Rarity = "Legendary";
	Price = 300000;
	Generation = 1250;
	RoadWeight = 0.35;
}
module["Strawberrelli Flamingelli"] = {
	DisplayName = "Strawberrelli Flamingelli";
	Rarity = "Legendary";
	Price = 275000;
	Generation = 1150;
	RoadWeight = 0.37;
}
module["Cocosini Mama"] = {
	DisplayName = "Cocosini Mama";
	Rarity = "Legendary";
	Price = 285000;
	Generation = 1200;
}
module["Pi Pi Watermelon"] = {
	DisplayName = "Pi Pi Watermelon";
	Rarity = "Legendary";
	Price = 315000;
	Generation = 1300;
}
module["Sigma Boy"] = {
	DisplayName = "Sigma Boy";
	Rarity = "Legendary";
	Price = 325000;
	Generation = 1350;
	RoadWeight = 0.3;
}
module["Pipi Potato"] = {
	DisplayName = "Pipi Potato";
	Rarity = "Legendary";
	Price = 265000;
	Generation = 1100;
	RoadWeight = 0.385;
}
local tbl = {
	DisplayName = "Quivioli Ameleonni";
	Rarity = "Legendary";
	Price = 225000;
	Generation = 900;
	RoadWeight = 0.425;
}
local function IsEnabled() -- Line 381
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl.IsEnabled = IsEnabled
module["Quivioli Ameleonni"] = tbl
module["Frigo Camelo"] = {
	DisplayName = "Frigo Camelo";
	Rarity = "Mythic";
	Price = 350000;
	Generation = 1400;
	RoadWeight = 0.2;
}
module["Orangutini Ananassini"] = {
	DisplayName = "Orangutini Ananassini";
	Rarity = "Mythic";
	Price = 400000;
	Generation = 1750;
	RoadWeight = 0.18;
}
module["Bombardiro Crocodilo"] = {
	DisplayName = "Bombardiro Crocodilo";
	Rarity = "Mythic";
	Price = 500000;
	Generation = 2500;
	RoadWeight = 0.15;
}
module["Bombombini Gusini"] = {
	DisplayName = "Bombombini Gusini";
	Rarity = "Mythic";
	Price = 1000000;
	Generation = 5000;
	RoadWeight = 0.14;
}
module["Rhino Toasterino"] = {
	DisplayName = "Rhino Toasterino";
	Rarity = "Mythic";
	Price = 450000;
	Generation = 2150;
	RoadWeight = 0.16;
}
module["Cavallo Virtuoso"] = {
	DisplayName = "Cavallo Virtuoso";
	Rarity = "Mythic";
	Price = 2500000;
	Generation = 7500;
	RoadWeight = 0.1;
}
module["Spioniro Golubiro"] = {
	DisplayName = "Spioniro Golubiro";
	Rarity = "Mythic";
	Price = 750000;
	Generation = 3500;
}
module["Zibra Zubra Zibralini"] = {
	DisplayName = "Zibra Zubra Zibralini";
	Rarity = "Mythic";
	Price = 1500000;
	Generation = 6000;
}
module["Tigrilini Watermelini"] = {
	DisplayName = "Tigrilini Watermelini";
	Rarity = "Mythic";
	Price = 1750000;
	Generation = 6500;
}
module["Gorillo Watermelondrillo"] = {
	DisplayName = "Gorillo Watermelondrillo";
	Rarity = "Mythic";
	Price = 3000000;
	Generation = 8000;
	RoadWeight = 0.08;
}
module.Avocadorilla = {
	DisplayName = "Avocadorilla";
	Rarity = "Mythic";
	Price = 2000000;
	Generation = 7000;
}
module["Ganganzelli Trulala"] = {
	DisplayName = "Ganganzelli Trulala";
	Rarity = "Mythic";
	Price = 3750000;
	Generation = 9000;
}
module["Tob Tobi Tobi"] = {
	DisplayName = "Tob Tobi Tobi";
	Rarity = "Mythic";
	Price = 3250000;
	Generation = 8500;
}
module["Te Te Te Sahur"] = {
	DisplayName = "Te Te Te Sahur";
	Rarity = "Mythic";
	Price = 4000000;
	Generation = 9500;
	RoadWeight = 0.07;
}
module["Tracoducotulu Delapeladustuz"] = {
	DisplayName = "Tracoducotulu Delapeladustuz";
	Rarity = "Mythic";
	Price = 4250000;
	Generation = 12000;
	RoadWeight = 0.06;
}
module.Lerulerulerule = {
	DisplayName = "Lerulerulerule";
	Rarity = "Mythic";
	Price = 3500000;
	Generation = 8750;
	RoadWeight = 0.75;
}
module.Carloo = {
	DisplayName = "Carloo";
	Rarity = "Mythic";
	Price = 4500000;
	Generation = 13500;
	IgnoreIndexCounter = true;
}
local tbl_4 = {
	DisplayName = "Carrotini Brainini";
	Rarity = "Mythic";
	Price = 4750000;
	Generation = 15000;
}
local function IsEnabled() -- Line 521
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_4.IsEnabled = IsEnabled
module["Carrotini Brainini"] = tbl_4
module["Cocofanto Elefanto"] = {
	DisplayName = "Cocofanto Elefanto";
	Rarity = "Brainrot God";
	Price = 5000000;
	Generation = 17500;
	RoadWeight = 0.05;
}
module["Tralalero Tralala"] = {
	DisplayName = "Tralalero Tralala";
	Rarity = "Brainrot God";
	Price = 10000000;
	Generation = 50000;
	RoadWeight = 0.01;
}
module["Odin Din Din Dun"] = {
	DisplayName = "Odin Din Din Dun";
	Rarity = "Brainrot God";
	Price = 15000000;
	Generation = 75000;
	RoadWeight = 0.007;
}
module["Girafa Celestre"] = {
	DisplayName = "Girafa Celestre";
	Rarity = "Brainrot God";
	Price = 7500000;
	Generation = 20000;
	RoadWeight = 0.03;
}
module["Trenostruzzo Turbo 3000"] = {
	DisplayName = "Trenostruzzo Turbo 3000";
	Rarity = "Brainrot God";
	Price = 25000000;
	Generation = 150000;
	RoadWeight = 0.005;
}
module.Matteo = {
	DisplayName = "Matteo";
	Rarity = "Brainrot God";
	Price = 10000000;
	Generation = 50000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Matteo";
	SpawnDelay = 3;
}
module["Tigroligre Frutonni"] = {
	DisplayName = "Tigroligre Frutonni";
	Rarity = "Brainrot God";
	Price = 14000000;
	Generation = 60000;
}
module["Orcalero Orcala"] = {
	DisplayName = "Orcalero Orcala";
	Rarity = "Brainrot God";
	Price = 25000000;
	Generation = 100000;
}
module["Unclito Samito"] = {
	DisplayName = "Unclito Samito";
	Rarity = "Brainrot God";
	Price = 20000000;
	Generation = 75000;
	IgnoreIndexCounter = true;
}
module["Gattatino Nyanino"] = {
	DisplayName = "Gattatino Nyanino";
	Rarity = "Brainrot God";
	Price = 7500000;
	Generation = 35000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Gattatino Nyanino";
	SpawnDelay = 9;
}
module["Espresso Signora"] = {
	DisplayName = "Espresso Signora";
	Rarity = "Brainrot God";
	Price = 25000000;
	Generation = 70000;
	IgnoreIndexCounter = true;
}
module["Ballerino Lololo"] = {
	DisplayName = "Ballerino Lololo";
	Rarity = "Brainrot God";
	Price = 35000000;
	Generation = 200000;
	RoadWeight = 0.0001;
}
module["Piccione Macchina"] = {
	DisplayName = "Piccione Macchina";
	Rarity = "Brainrot God";
	Price = 40000000;
	Generation = 225000;
	RoadWeight = 0.0008;
}
module["Los Crocodillitos"] = {
	DisplayName = "Los Crocodillitos";
	Rarity = "Brainrot God";
	Price = 12500000;
	Generation = 55000;
}
module["Los Crocodillitos"] = {
	DisplayName = "Los Crocodillitos";
	Rarity = "Brainrot God";
	Price = 12500000;
	Generation = 55000;
}
module["Tukanno Bananno"] = {
	DisplayName = "Tukanno Bananno";
	Rarity = "Brainrot God";
	Price = 22500000;
	Generation = 100000;
}
module["Trippi Troppi Troppa Trippa"] = {
	DisplayName = "Trippi Troppi Troppa Trippa";
	Rarity = "Brainrot God";
	Price = 30000000;
	Generation = 175000;
	RoadWeight = 0.0035;
}
module["Los Tungtungtungcitos"] = {
	DisplayName = "Los Tungtungtungcitos";
	Rarity = "Brainrot God";
	Price = 37500000;
	Generation = 210000;
}
module["Agarrini la Palini"] = {
	DisplayName = "Agarrini la Palini";
	Rarity = "Brainrot God";
	Price = 80000000;
	Generation = 425000;
}
module["Bulbito Bandito Traktorito"] = {
	DisplayName = "Bulbito Bandito Traktorito";
	Rarity = "Brainrot God";
	Price = 35000000;
	Generation = 205000;
	IgnoreIndexCounter = true;
}
module["Los Orcalitos"] = {
	DisplayName = "Los Orcalitos";
	Rarity = "Brainrot God";
	Price = 45000000;
	Generation = 235000;
}
module["Tipi Topi Taco"] = {
	DisplayName = "Tipi Topi Taco";
	Rarity = "Brainrot God";
	Price = 20000000;
	Generation = 75000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Taco";
	SpawnDelay = 3;
}
module["Bombardini Tortinii"] = {
	DisplayName = "Bombardini Tortinii";
	Rarity = "Brainrot God";
	Price = 50000000;
	Generation = 225000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Taco";
	SpawnDelay = 3;
}
module["Tralalita Tralala"] = {
	DisplayName = "Tralalita Tralala";
	Rarity = "Brainrot God";
	Price = 20000000;
	Generation = 100000;
	RoadWeight = 0.006;
}
module["Urubini Flamenguini"] = {
	DisplayName = "Urubini Flamenguini";
	Rarity = "Brainrot God";
	Price = 30000000;
	Generation = 150000;
	IgnoreIndexCounter = true;
}
module.Alessio = {
	DisplayName = "Alessio";
	Rarity = "Brainrot God";
	Price = 17500000;
	Generation = 85000;
	IgnoreIndexCounter = true;
}
module.Pakrahmatmamat = {
	DisplayName = "Pakrahmatmamat";
	Rarity = "Brainrot God";
	Price = 37500000;
	Generation = 215000;
	RoadWeight = 0.0009;
}
module["Los Bombinitos"] = {
	DisplayName = "Los Bombinitos";
	Rarity = "Brainrot God";
	Price = 42500000;
	Generation = 220000;
	IgnoreIndexCounter = true;
}
module["Brr es Teh Patipum"] = {
	DisplayName = "Brr es Teh Patipum";
	Rarity = "Brainrot God";
	Price = 40000000;
	Generation = 225000;
}
module["Tartaruga Cisterna"] = {
	DisplayName = "Tartaruga Cisterna";
	Rarity = "Brainrot God";
	Price = 45000000;
	Generation = 250000;
}
local tbl_2 = {
	DisplayName = "Cacasito Satalito";
	Rarity = "Brainrot God";
	Price = 45000000;
	Generation = 240000;
	RoadWeight = 0.0006;
}
local function IsEnabled() -- Line 770
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_2.IsEnabled = IsEnabled
module["Cacasito Satalito"] = tbl_2
local tbl_7 = {
	DisplayName = "Mastodontico Telepiedone";
	Rarity = "Brainrot God";
	Price = 47500000;
	Generation = 275000;
}
local function IsEnabled() -- Line 780
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_7.IsEnabled = IsEnabled
module["Mastodontico Telepiedone"] = tbl_7
local tbl_9 = {
	DisplayName = "Crabbo Limonetta";
	Rarity = "Brainrot God";
	Price = 46000000;
	Generation = 235000;
	IgnoreIndexCounter = true;
}
local function IsEnabled() -- Line 791
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_9.IsEnabled = IsEnabled
module["Crabbo Limonetta"] = tbl_9
module["La Vacca Saturno Saturnita"] = {
	DisplayName = "La Vacca Saturno Saturnita";
	Rarity = "Secret";
	Price = 50000000;
	Generation = 300000;
	RoadWeight = 0.0005;
}
module["Los Tralaleritos"] = {
	DisplayName = "Los Tralaleritos";
	Rarity = "Secret";
	Price = 100000000;
	Generation = 500000;
	RoadWeight = 0.0001;
}
module["Graipuss Medussi"] = {
	DisplayName = "Graipuss Medussi";
	Rarity = "Secret";
	Price = 250000000;
	Generation = 1000000;
	RoadWeight = 0.000001;
}
module["La Grande Combinasion"] = {
	DisplayName = "La Grande Combinasion";
	Rarity = "Secret";
	OverheadYOffsetModifier = 0.8;
	Price = 1000000000;
	Generation = 10000000;
	RoadWeight = 1e-08;
}
module["Sammyni Spyderini"] = {
	DisplayName = "Sammyni Spyderini";
	Rarity = "Secret";
	Price = 75000000;
	Generation = 325000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Los Spyderinis";
	SpawnDelay = 3.5;
}
module["Garama and Madundung"] = {
	DisplayName = "Garama and Madundung";
	Rarity = "Secret";
	Price = 10000000000;
	Generation = 50000000;
	RoadWeight = 1e-10;
}
module["Torrtuginni Dragonfrutini"] = {
	DisplayName = "Torrtuginni Dragonfrutini";
	Rarity = "Secret";
	Price = 125000000;
	Generation = 350000;
}
module["Las Tralaleritas"] = {
	DisplayName = "Las Tralaleritas";
	Rarity = "Secret";
	Price = 150000000;
	Generation = 650000;
	RoadWeight = 0.00007;
}
module["Pot Hotspot"] = {
	DisplayName = "Pot Hotspot";
	Rarity = "Secret";
	Price = 600000000;
	Generation = 2500000;
}
module["Nuclearo Dinossauro"] = {
	DisplayName = "Nuclearo Dinossauro";
	Rarity = "Secret";
	Price = 2500000000;
	Generation = 15000000;
	RoadWeight = 1e-10;
}
module["Las Vaquitas Saturnitas"] = {
	DisplayName = "Las Vaquitas Saturnitas";
	Rarity = "Secret";
	Price = 200000000;
	Generation = 750000;
}
module["Chicleteira Bicicleteira"] = {
	DisplayName = "Chicleteira Bicicleteira";
	Rarity = "Secret";
	Price = 750000000;
	Generation = 3500000;
	RoadWeight = 1e-07;
}
module["Agarrini la Palini"] = {
	DisplayName = "Agarrini la Palini";
	Rarity = "Secret";
	Price = 80000000;
	Generation = 425000;
}
module["Los Combinasionas"] = {
	DisplayName = "Los Combinasionas";
	Rarity = "Secret";
	Price = 2000000000;
	Generation = 15000000;
}
module["Karkerkar Kurkur"] = {
	DisplayName = "Karkerkar Kurkur";
	Rarity = "Secret";
	Price = 100000000;
	Generation = 300000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Karkerkar Kurkur";
	SpawnDelay = 3;
}
module["Dragon Cannelloni"] = {
	DisplayName = "Dragon Cannelloni";
	Rarity = "Secret";
	Price = 100000000000;
	Generation = 100000000;
	RoadWeight = 1e-12;
}
module["Los Hotspotsitos"] = {
	DisplayName = "Los Hotspotsitos";
	Rarity = "Secret";
	Price = 3000000000;
	Generation = 20000000;
	IgnoreIndexCounter = true;
}
module["Esok Sekolah"] = {
	DisplayName = "Esok Sekolah";
	Rarity = "Secret";
	Price = 3500000000;
	Generation = 30000000;
	IgnoreIndexCounter = true;
}
module["Nooo My Hotspot"] = {
	DisplayName = "Nooo My Hotspot";
	Rarity = "Secret";
	Price = 500000000;
	Generation = 1500000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Taco";
	SpawnDelay = 3;
}
module["Los Matteos"] = {
	DisplayName = "Los Matteos";
	Rarity = "Secret";
	Price = 100000000;
	Generation = 300000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Matteo";
	SpawnDelay = 3;
}
module["Job Job Job Sahur"] = {
	DisplayName = "Job Job Job Sahur";
	Rarity = "Secret";
	Price = 175000000;
	Generation = 700000;
	RoadWeight = 0.000005;
}
module["Dul Dul Dul"] = {
	DisplayName = "Dul Dul Dul";
	Rarity = "Secret";
	Price = 150000000;
	Generation = 375000;
	IgnoreIndexCounter = true;
}
module["Blackhole Goat"] = {
	DisplayName = "Blackhole Goat";
	Rarity = "Secret";
	Price = 75000000;
	Generation = 400000;
	IgnoreIndexCounter = true;
}
module["Los Spyderinis"] = {
	DisplayName = "Los Spyderinis";
	Rarity = "Secret";
	Price = 125000000;
	Generation = 425000;
	IgnoreIndexCounter = true;
	SpawnVFX = "Los Spyderinis";
	SpawnDelay = 3.5;
}
module["Ketupat Kepat"] = {
	DisplayName = "Ketupat Kepat";
	Rarity = "Secret";
	Price = 5000000000;
	Generation = 35000000;
	RoadWeight = 5e-11;
}
module["La Supreme Combinasion"] = {
	DisplayName = "La Supreme Combinasion";
	Rarity = "Secret";
	Price = 7000000000;
	Generation = 40000000;
}
module["Bisonte Giuppitere"] = {
	DisplayName = "Bisonte Giuppitere";
	Rarity = "Secret";
	Price = 75000000;
	Generation = 300000;
	IgnoreIndexCounter = true;
}
local tbl_8 = {
	DisplayName = "Guerriro Digitale";
	Rarity = "Secret";
	Price = 120000000;
	Generation = 550000;
	IgnoreIndexCounter = true;
}
local function IsEnabled() -- Line 1023
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_8.IsEnabled = IsEnabled
module["Guerriro Digitale"] = tbl_8
local tbl_6 = {
	DisplayName = "Ketchuru and Musturu";
	Rarity = "Secret";
	Price = 7500000000;
	Generation = 42500000;
	RoadWeight = 2.5e-11;
}
local function IsEnabled() -- Line 1034
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_6.IsEnabled = IsEnabled
module["Ketchuru and Musturu"] = tbl_6
local tbl_5 = {
	DisplayName = "Spaghetti Tualetti";
	Rarity = "Secret";
	Price = 15000000000;
	Generation = 60000000;
}
local function IsEnabled() -- Line 1044
	--[[ Upvalues[1]:
		[1]: Updates_upvr (readonly)
	]]
	return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
end
tbl_5.IsEnabled = IsEnabled
module["Spaghetti Tualetti"] = tbl_5
module["Strawberry Elephant"] = {
	DisplayName = "Strawberry Elephant";
	Rarity = "OG";
	Price = 500000000000;
	Generation = 250000000;
	TriggerEvent = "Strawberry";
	SpawnVFX = "Strawberry";
	SpawnDelay = 3.5;
	IgnoreIndexCounter = true;
	IsEnabled = function() -- Line 1058, Named "IsEnabled"
		--[[ Upvalues[1]:
			[1]: Updates_upvr (readonly)
		]]
		return Updates_upvr.Methods.IsEnabled("Update-08/30/2025")
	end;
}
module["Mythic Lucky Block"] = {
	DisplayName = "Lucky Block";
	Rarity = "Mythic";
	Price = 2500000;
	Generation = 0;
	RoadWeight = 0.05;
	LuckyBlock = LuckyBlocks["Mythic Lucky Block"];
	HideFromIndex = true;
}
module["Brainrot God Lucky Block"] = {
	DisplayName = "Lucky Block";
	Rarity = "Brainrot God";
	Price = 25000000;
	Generation = 0;
	RoadWeight = 0.001;
	LuckyBlock = LuckyBlocks["Brainrot God Lucky Block"];
	HideFromIndex = true;
}
module["Secret Lucky Block"] = {
	DisplayName = "Lucky Block";
	Rarity = "Secret";
	Price = 750000000;
	Generation = 0;
	RoadWeight = 7e-07;
	LuckyBlock = LuckyBlocks["Secret Lucky Block"];
	HideFromIndex = true;
}
module["Admin Lucky Block"] = {
	DisplayName = "Lucky Block";
	Rarity = "Admin";
	Price = 100000000;
	Generation = 0;
	LuckyBlock = LuckyBlocks["Admin Lucky Block"];
	HideFromIndex = true;
}
if game:GetService("RunService"):IsServer() then
	for i, v in require(game:GetService("ServerStorage").Modules.ServerRoadWeights), nil do
		if module[i] then
			module[i].RoadWeight = v
		end
	end
end
return module
