-- Indian_XP2.lua
-- Author: blkbutterfly74
-- DateCreated: 3/7/2021 3:14:31 PM
-- Creates a Huge map shaped like real-world Indian Ocean
-- based off Scrambled SEA and Australia map scripts
-- Thanks to Firaxis
-----------------------------------------------------------------------------

include "MapEnums"
include "MapUtilities"
include "MountainsCliffs"
include "RiversLakes"
include "FeatureGenerator"
include "TerrainGenerator"
include "NaturalWonderGenerator"
include "ResourceGenerator"
include "CoastalLowlands"
include "AssignStartingPlots"

local g_iW, g_iH;
local g_iFlags = {};
local g_continentsFrac = nil;
local g_iNumTotalLandTiles = 0; 
local g_CenterX = 57;
local g_CenterY = 27;
local featuregen = nil;

local landStrips = {
		{0, 0, 10},
		{0, 17, 20},
		{0, 22, 103},
		{1, 0, 11},
		{1, 23, 103},
		{2, 0, 11},
		{2, 13, 13},
		{2, 20, 20},
		{2, 28, 29},
		{2, 36, 103},
		{3, 0, 11},
		{3, 13, 13},
		{3, 19, 20},
		{3, 37, 103},
		{4, 0, 13},
		{4, 17, 21},
		{4, 39, 103},
		{5, 0, 24},
		{5, 42, 72},
		{5, 74, 103},
		{6, 0, 25},
		{6, 40, 44},
		{6, 46, 72},
		{6, 74, 103},
		{7, 0, 24},
		{7, 41, 43},
		{7, 46, 66},
		{7, 74, 103},
		{8, 0, 23},
		{8, 45, 66},
		{8, 76, 103},
		{9, 0, 22},
		{9, 45, 65},
		{9, 77, 98},
		{9, 101, 103},
		{10, 0, 22},
		{10, 45, 63},
		{10, 78, 97},
		{10, 102, 102},
		{11, 0, 22},
		{11, 46, 62},
		{11, 79, 95},
		{12, 0, 20},
		{12, 46, 61},
		{12, 79, 95},
		{12, 101, 103},
		{13, 0, 18},
		{13, 46, 60},
		{13, 80, 96},
		{13, 101, 103},
		{14, 0, 17},
		{14, 46, 58},
		{14, 78, 82},
		{14, 84, 97},
		{14, 102, 102},
		{15, 0, 14},
		{15, 47, 56},
		{15, 79, 81},
		{15, 84, 97},
		{16, 0, 13},
		{16, 47, 56},
		{16, 84, 98},
		{17, 0, 12},
		{17, 48, 56},
		{17, 84, 100},
		{18, 0, 11},
		{18, 48, 56},
		{18, 85, 100},
		{19, 0, 8},
		{19, 49, 56},
		{19, 77, 77},
		{19, 85, 101},
		{20, 0, 7},
		{20, 48, 56},
		{20, 76, 76},
		{20, 86, 87},
		{20, 89, 101},
		{21, 0, 5},
		{21, 15, 16},
		{21, 50, 56},
		{21, 76, 76},
		{21, 86, 87},
		{21, 89, 101},
		{22, 0, 2},
		{22, 50, 56},
		{22, 85, 87},
		{22, 92, 101},
		{23, 0, 1},
		{23, 10, 11},
		{23, 51, 55},
		{23, 76, 76},
		{23, 86, 86},
		{23, 93, 101},
		{24, 7, 11},
		{24, 51, 54},
		{24, 57, 57},
		{24, 86, 86},
		{24, 93, 101},
		{25, 5, 11},
		{25, 52, 53},
		{25, 57, 58},
		{25, 86, 86},
		{25, 95, 100},
		{26, 0, 0},
		{26, 3, 10},
		{26, 56, 58},
		{26, 85, 87},
		{26, 96, 98},
		{27, 0, 10},
		{27, 56, 59},
		{27, 85, 87},
		{27, 95, 97},
		{28, 0, 10},
		{28, 56, 59},
		{28, 78, 78},
		{28, 87, 88},
		{29, 0, 9},
		{29, 57, 59},
		{29, 87, 88},
		{30, 0, 9},
		{30, 88, 90},
		{31, 0, 8},
		{31, 81, 81},
		{31, 89, 91},
		{32, 0, 8},
		{32, 81, 83},
		{32, 89, 92},
		{33, 0, 7},
		{33, 82, 84},
		{33, 89, 92},
		{34, 0, 6},
		{34, 83, 85},
		{34, 89, 92},
		{35, 0, 6},
		{35, 81, 81},
		{35, 84, 87},
		{35, 90, 92},
		{36, 0, 5},
		{36, 84, 87},
		{36, 91, 92},
		{37, 0, 4},
		{37, 86, 89},
		{37, 92, 93},
		{38, 0, 4},
		{38, 84, 84},
		{38, 86, 90},
		{39, 0, 3},
		{39, 87, 92},
		{39, 94, 94},
		{39, 102, 102},
		{40, 0, 1},
		{40, 85, 85},
		{40, 86, 92},
		{40, 101, 103},
		{41, 0, 0},
		{41, 88, 93},
		{41, 101, 103},
		{42, 0, 0},
		{42, 86, 86},
		{42, 88, 92},
		{42, 101, 103},
		{43, 89, 94},
		{43, 102, 103},
		{44, 89, 94},
		{44, 96, 96},
		{44, 102, 103},
		{45, 90, 94},
		{45, 97, 97},
		{45, 103, 103},
		{46, 91, 95},
		{46, 99, 99},
		{46, 103, 103},
		{47, 90, 96},
		{47, 103, 103},
		{48, 92, 96},
		{49, 94, 95},
		{51, 96, 97},
		{52, 95, 99},
		{53, 96, 100},
		{53, 103, 103},
		{54, 99, 103},
		{55, 102, 103},
		{61, 2, 2},
		{61, 10, 11},
		{62, 10, 11},
		{63, 9, 12},
		{64, 9, 12},
		{65, 9, 11},
		{66, 8, 11},
		{67, 6, 12},
		{68, 5, 12},
		{69, 5, 12},
		{70, 5, 12},
		{71, 5, 11},
		{71, 24, 24},
		{72, 5, 11},
		{73, 6, 11},
		{74, 6, 11},
		{75, 6, 11},
		{76, 5, 11},
		{77, 5, 11},
		{78, 5, 11},
		{79, 6, 11},
		{79, 103, 103},
		{80, 6, 11},
		{80, 103, 103},
		{81, 7, 10},
		{81, 102, 103},
		{82, 8, 9},
		{82, 102, 103},
		{83, 101, 103},
		{84, 101, 103},
		{85, 101, 103},
		{86, 101, 103},
		{87, 101, 103},
		{88, 101, 103},
		{89, 102, 103},
		{90, 102, 103},
		{91, 101, 103},
		{92, 101, 103},
		{93, 101, 103},
		{94, 101, 103},
		{95, 101, 103},
		{96, 100, 103},
		{97, 99, 103}}; 

-------------------------------------------------------------------------------
function GenerateMap()
	print("Generating Southeast Asia Map");
	local pPlot;

	-- Set globals
	g_iW, g_iH = Map.GetGridSize();
	g_iFlags = TerrainBuilder.GetFractalFlags();
	local temperature = 0;

	--	local world_age
	local world_age_new = 5;
	local world_age_normal = 3;
	local world_age_old = 2;

	local world_age = MapConfiguration.GetValue("world_age");
	if (world_age == 1) then
		world_age = world_age_new;
	elseif (world_age == 3) then
		world_age = world_age_old;
	else
		world_age = world_age_normal;	-- default
	end
	
	plotTypes = GeneratePlotTypes(world_age);
	terrainTypes = GenerateTerrainTypesSoutheastAsia(plotTypes, g_iW, g_iH, g_iFlags, true);
	ApplyBaseTerrain(plotTypes, terrainTypes, g_iW, g_iH);

	AreaBuilder.Recalculate();
	--[[ blackbutterfly74 - Why this additional AnalyzeChockepoint()? Commenting out for now:
	TerrainBuilder.AnalyzeChokepoints(); --]]
	TerrainBuilder.StampContinents();

	local iContinentBoundaryPlots = GetContinentBoundaryPlotCount(g_iW, g_iH);
	local biggest_area = Areas.FindBiggestArea(false);
	print("After Adding Hills: ", biggest_area:GetPlotCount());
	AddTerrainFromContinents(plotTypes, terrainTypes, world_age, g_iW, g_iH, iContinentBoundaryPlots);

	AreaBuilder.Recalculate();

	-- Place lakes before rivers to allow them to be sources.
	AddLakes();

	-- River generation is affected by plot types, originating from highlands and preferring to traverse lowlands.
	AddRivers();

	AddFeatures();

	TerrainBuilder.AnalyzeChokepoints();
	
	print("Adding cliffs");
	AddCliffs(plotTypes, terrainTypes);
	
	local args = {
		numberToPlace = GameInfo.Maps[Map.GetMapSize()].NumNaturalWonders,
	};

	local nwGen = NaturalWonderGenerator.Create(args);

	AddFeaturesFromContinents();
	MarkCoastalLowlands();
	
	resourcesConfig = MapConfiguration.GetValue("resources");
	local startConfig = MapConfiguration.GetValue("start");-- Get the start config
	local args = {
		resources = resourcesConfig,
		iWaterLux = 4,
		START_CONFIG = startConfig,
	}
	local resGen = ResourceGenerator.Create(args);

	print("Creating start plot database.");
	-- START_MIN_Y and START_MAX_Y is the percent of the map ignored for major civs' starting positions.
	local args = {
		MIN_MAJOR_CIV_FERTILITY = 85,
		MIN_MINOR_CIV_FERTILITY = 5, 
		MIN_BARBARIAN_FERTILITY = 1,
		START_MIN_Y = 15,
		START_MAX_Y = 15,
		WATER = true,
		START_CONFIG = startConfig,
	};
	local start_plot_database = AssignStartingPlots.Create(args)

	local GoodyGen = AddGoodies(g_iW, g_iH);
end

-- Input a Hash; Export width, height, and wrapX
function GetMapInitData(MapSize)
	local Width = 104;
	local Height = 97;
	local WrapX = false;
	return {Width = Width, Height = Height, WrapX = WrapX,}
end
-------------------------------------------------------------------------------
function GeneratePlotTypes(world_age)
	print("Generating Plot Types");
	local plotTypes = {};

	-- Start with it all as water
	for x = 0, g_iW - 1 do
		for y = 0, g_iH - 1 do
			local i = y * g_iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			plotTypes[i] = g_PLOT_TYPE_OCEAN;
			TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_OCEAN);
		end
	end

	-- Each land strip is defined by: Y, X Start, X End
	local xOffset = 0;
	local yOffset = 0;
		
	for i, v in ipairs(landStrips) do
		local y = g_iH - (v[1] + yOffset);   -- inverted
		local xStart = v[2] + xOffset;
		local xEnd = v[3] + xOffset; 
		for x = xStart, xEnd do
			local i = y * g_iW + x;
			local pPlot = Map.GetPlotByIndex(i);
			plotTypes[i] = g_PLOT_TYPE_LAND;
			TerrainBuilder.SetTerrainType(pPlot, g_TERRAIN_TYPE_GRASS);  -- temporary setting so can calculate areas
			g_iNumTotalLandTiles = g_iNumTotalLandTiles + 1;
		end
	end
		
	AreaBuilder.Recalculate();

	local args = {};
	args.world_age = world_age;
	args.iW = g_iW;
	args.iH = g_iH
	args.iFlags = g_iFlags;
	args.blendRidge = 10;
	args.blendFract = 1;
	args.extra_mountains = 4;
	plotTypes = ApplyTectonics(args, plotTypes);

	return plotTypes;
end

function InitFractal(args)

	if(args == nil) then args = {}; end

	local continent_grain = args.continent_grain or 2;
	local rift_grain = args.rift_grain or -1; -- Default no rifts. Set grain to between 1 and 3 to add rifts. - Bob
	local invert_heights = args.invert_heights or false;
	local polar = args.polar or true;
	local ridge_flags = args.ridge_flags or g_iFlags;

	local fracFlags = {};
	
	if(invert_heights) then
		fracFlags.FRAC_INVERT_HEIGHTS = true;
	end
	
	if(polar) then
		fracFlags.FRAC_POLAR = true;
	end
	
	if(rift_grain > 0 and rift_grain < 4) then
		local riftsFrac = Fractal.Create(g_iW, g_iH, rift_grain, {}, 6, 5);
		g_continentsFrac = Fractal.CreateRifts(g_iW, g_iH, continent_grain, fracFlags, riftsFrac, 6, 5);
	else
		g_continentsFrac = Fractal.Create(g_iW, g_iH, continent_grain, fracFlags, 6, 5);	
	end

	-- Use Brian's tectonics method to weave ridgelines in to the continental fractal.
	-- Without fractal variation, the tectonics come out too regular.
	--
	--[[ "The principle of the RidgeBuilder code is a modified Voronoi diagram. I 
	added some minor randomness and the slope might be a little tricky. It was 
	intended as a 'whole world' modifier to the fractal class. You can modify 
	the number of plates, but that is about it." ]]-- Brian Wade - May 23, 2009
	--
	local MapSizeTypes = {};
	for row in GameInfo.Maps() do
		MapSizeTypes[row.MapSizeType] = row.PlateValue;
	end
	local sizekey = Map.GetMapSize();

	local numPlates = MapSizeTypes[sizekey] or 4

	-- Blend a bit of ridge into the fractal.
	-- This will do things like roughen the coastlines and build inland seas. - Brian

	g_continentsFrac:BuildRidges(numPlates, {}, 1, 2);
end

function AddFeatures()
	print("Adding Features");

	-- Get Rainfall setting input by user.
	local rainfall = MapConfiguration.GetValue("rainfall");
	if rainfall == 4 then
		rainfall = 1 + TerrainBuilder.GetRandomNumber(3, "Random Rainfall - Lua");
	end

	local args = {rainfall = rainfall, iJunglePercent = 65, iMarshPercent = 10, iForestPercent = 7, iReefPercent = 12}	-- jungle & marsh max coverage
	featuregen = FeatureGenerator.Create(args);

	featuregen:AddFeatures(true, false);  --second parameter is whether or not rivers start inland);

	-- add rainforest more densely at center
	for iX = 0, g_iW - 1 do
		for iY = 0, g_iH - 1 do
			local index = (iY * g_iW) + iX;
			local plot = Map.GetPlot(iX, iY);
			local iDistanceFromCenter = Map.GetPlotDistance (iX, iY, g_CenterX, g_CenterY);

			if (plot:GetFeatureType() == g_FEATURE_FLOODPLAINS) then
				-- 50/50 chance to add floodplains when get 20 tiles out.  Linear scale out to there
				if (TerrainBuilder.GetRandomNumber(40, "Resource Placement Score Adjust") >= iDistanceFromCenter) then
					TerrainBuilder.SetFeatureType(plot, -1);
				end
			else
				-- add rainforest more densely at center. Inverse of floolplain logic
				if (TerrainBuilder.GetRandomNumber(45, "Resource Placement Score Adjust") >= iDistanceFromCenter) then
					featuregen:AddJunglesAtPlot(plot, iX, iY);
				-- add forest more densely at center. Inverse of floolplain logic
				elseif (TerrainBuilder.GetRandomNumber(55, "Resource Placement Score Adjust") >= iDistanceFromCenter) then
					featuregen:AddForestsAtPlot(plot, iX, iY);
				end
			end
		end
	end
end
------------------------------------------------------------------------------
function GenerateTerrainTypesSoutheastAsia(plotTypes, iW, iH, iFlags, bNoCoastalMountains)
	print("Generating Terrain Types");
	local terrainTypes = {};

	local fracXExp = -1;
	local fracYExp = -1;
	local grain_amount = 3;

	deserts = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);

	grass = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);
									
	iGrassTop = grass:GetHeight(100);

	plains = Fractal.Create(iW, iH, 
									grain_amount, iFlags, 
									fracXExp, fracYExp);
																		
	iPlainsTop = plains:GetHeight(100);

	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;
			if (plotTypes[index] == g_PLOT_TYPE_OCEAN) then
				if (IsAdjacentToLand(plotTypes, iX, iY)) then
					terrainTypes[index] = g_TERRAIN_TYPE_COAST;
				else
					terrainTypes[index] = g_TERRAIN_TYPE_OCEAN;
				end
			end
		end
	end

	if (bNoCoastalMountains == true) then
		plotTypes = RemoveCoastalMountains(plotTypes, terrainTypes);
	end

	for iX = 0, iW - 1 do
		for iY = 0, iH - 1 do
			local index = (iY * iW) + iX;

			local iDistanceFromCenter = Map.GetPlotDistance(iX, iY, g_CenterX, g_CenterY);

			local lat = (iY - iH/2)/(iH/2);
			local long = (iX - iW/2)/(iW/2);

			local iGrassBottom = grass:GetHeight(math.abs(lat) * 100);
			local iPlainsBottom = plains:GetHeight(math.abs(lat) * 100);

			local desertVal = deserts:GetHeight(iX, iY);
			local plainsVal = plains:GetHeight(iX, iY);

			-- Australia, Arabia & Africa
			if ((lat < -0.65 and long > 0.8) or
				(lat > 0 and long < 0.5)) then
				local iDesertTop = deserts:GetHeight(iDistanceFromCenter/iW * 100);
				local iDesertBottom = deserts:GetHeight(0);

				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_DESERT_MOUNTAIN;

				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
				
					if ((desertVal >= iDesertBottom) and (desertVal <= iDesertTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT;
					elseif ((plainsVal >= iPlainsBottom) and (plainsVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					end
				end

			-- SA, SEA & Madagascar
			else 
				local iDesertTop = deserts:GetHeight(math.abs(lat) * 100);
				local iDesertBottom = deserts:GetHeight(55);

				if (plotTypes[index] == g_PLOT_TYPE_MOUNTAIN) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS_MOUNTAIN;

					if ((plainsVal >= iPlainsBottom) and (plainsVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS_MOUNTAIN;
					elseif ((desertVal >= iDesertBottom) and (desertVal <= iDesertTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT_MOUNTAIN;
					end

				elseif (plotTypes[index] ~= g_PLOT_TYPE_OCEAN) then
					terrainTypes[index] = g_TERRAIN_TYPE_GRASS;
		
					if ((plainsVal >= iPlainsBottom) and (plainsVal <= iPlainsTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_PLAINS;
					elseif ((desertVal >= iDesertBottom) and (desertVal <= iDesertTop)) then
						terrainTypes[index] = g_TERRAIN_TYPE_DESERT;
					end
				end
			end
		end
	end

	local bExpandCoasts = true;

	if bExpandCoasts == false then
		return
	end

	print("Expanding coasts");
	for iI = 0, 2 do
		local shallowWaterPlots = {};
		for iX = 0, iW - 1 do
			for iY = 0, iH - 1 do
				local index = (iY * iW) + iX;
				if (terrainTypes[index] == g_TERRAIN_TYPE_OCEAN) then
					-- Chance for each eligible plot to become an expansion is 1 / iExpansionDiceroll.
					-- Default is two passes at 1/4 chance per eligible plot on each pass.
					if (IsAdjacentToShallowWater(terrainTypes, iX, iY) and TerrainBuilder.GetRandomNumber(4, "add shallows") == 0) then
						table.insert(shallowWaterPlots, index);
					end
				end
			end
		end
		for i, index in ipairs(shallowWaterPlots) do
			terrainTypes[index] = g_TERRAIN_TYPE_COAST;
		end
	end
	
	return terrainTypes; 
end
------------------------------------------------------------------------------
function FeatureGenerator:AddIceToMap()
	return false, 0;
end

------------------------------------------------------------------------------
function FeatureGenerator:AddReefAtPlot(plot, iX, iY)
	--Reef Check. First see if it can place the feature.
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_REEF)) then
		self.iNumReefablePlots = self.iNumReefablePlots + 1;
		if(math.ceil(self.iReefCount * 100 / self.iNumReefablePlots) <= self.iReefMaxPercent) then
				--Weight based on adjacent plots
				local iScore  = math.abs(iY - self.iNumEquator);
				local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_REEF);

				if(iAdjacent == 0 ) then
					iScore = iScore + 100;
				elseif(iAdjacent == 1) then
					iScore = iScore + 125;
				elseif (iAdjacent == 2) then
					iScore = iScore  + 150;
				elseif (iAdjacent == 3 or iAdjacent == 4) then
					iScore = iScore + 175;
				else
					iScore = iScore + 10000;
				end

				if(TerrainBuilder.GetRandomNumber(200, "Resource Placement Score Adjust") >= iScore) then
					TerrainBuilder.SetFeatureType(plot, g_FEATURE_REEF);
					self.iReefCount = self.iReefCount + 1;
				end
		end
	end
end

------------------------------------------------------------------------------
function AddFeaturesFromContinents()
	print("Adding Features from Continents");

	featuregen:AddFeaturesFromContinents();
end

-- override: northern forest bias
function FeatureGenerator:AddForestsAtPlot(plot, iX, iY)
	--Forest Check. First see if it can place the feature.
	
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_FOREST)) then
		if(math.ceil(self.iForestCount * 100 / self.iNumLandPlots) <= self.iForestMaxPercent) then
			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 300 * (iY + 1);    -- co-ordinate system starts at zero
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_FOREST);

			if(iAdjacent == 0 ) then
				iScore = iScore;
			elseif(iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end
				
			if(TerrainBuilder.GetRandomNumber(300, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_FOREST);
				self.iForestCount = self.iForestCount + 1;
			end
		end
	end
end

-- override: more southern jungle
function FeatureGenerator:AddJunglesAtPlot(plot, iX, iY)
	--Jungle Check. First see if it can place the feature.
	if(TerrainBuilder.CanHaveFeature(plot, g_FEATURE_JUNGLE)) then
		if(math.ceil(self.iJungleCount * 100 / self.iNumLandPlots) <= self.iJungleMaxPercent) then

			--Weight based on adjacent plots if it has more than 3 start subtracting
			local iScore = 350 * (1 - iY/g_iH);
			local iAdjacent = TerrainBuilder.GetAdjacentFeatureCount(plot, g_FEATURE_JUNGLE);

			if(iAdjacent == 0 ) then
				iScore = iScore;
			elseif(iAdjacent == 1) then
				iScore = iScore + 50;
			elseif (iAdjacent == 2 or iAdjacent == 3) then
				iScore = iScore + 150;
			elseif (iAdjacent == 4) then
				iScore = iScore - 50;
			else
				iScore = iScore - 200;
			end

			if(TerrainBuilder.GetRandomNumber(100, "Resource Placement Score Adjust") <= iScore) then
				TerrainBuilder.SetFeatureType(plot, g_FEATURE_JUNGLE);
				local terrainType = plot:GetTerrainType();

				if(terrainType == g_TERRAIN_TYPE_PLAINS_HILLS or terrainType == g_TERRAIN_TYPE_GRASS_HILLS) then
					TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS_HILLS);
				else
					TerrainBuilder.SetTerrainType(plot, g_TERRAIN_TYPE_PLAINS);
				end

				self.iJungleCount = self.iJungleCount + 1;
				return true;
			end

		end
	end

	return false
end