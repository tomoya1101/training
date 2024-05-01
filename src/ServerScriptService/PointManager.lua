local PointManager = {}

--タグを使用する為にCollectionServiceを取得
local CollectionService = game:GetService("CollectionService")
--タグの付いているものを取得
local Point = CollectionService:GetTagged("Point")

--PointにNPCの通った回数を数える属性を追加
for i, point in ipairs(Point) do
	--触れた時にイベントが起きるようにする
	point.CanTouch = true
	--NPC通った回数を追加
	point:SetAttribute("count", 0)
end

--PointのもつNPCの通った回数を増やす
function PointManager.PointCount(hit)
	--回数をもっていなければ
	if hit:GetAttribute("count") == nil  then
		return
	end
	--回数を１増やす
	hit:SetAttribute("count", hit:GetAttribute("count") + 1)
end

--ポイントの通った回数の最小値を探す
local function MinPointFind()
	--通った回数が少ない値を入れる
	local min_count = 0
	--通った回数が最小の値を探す
	for i, point in ipairs(Point) do
		if min_count >= point:GetAttribute("count") then
			min_count = point:GetAttribute("count")
		end
	end
	
	return min_count
end

--ポイントを通った回数が最小値のポジションを返す
function PointManager.MinPassedPosition()
	--ポイントの通った回数の最小値
	local point_count = MinPointFind()
	--ポイントのポジションを入れる
	local min_position = {}
	--min_positionの配列の長さ
	local count = 1
	--通った数が最小の値と同じPointのポジションを取得
	for i, point in ipairs(Point) do
		if point_count == point:GetAttribute("count") then
			min_position[count] = point.Position
			count = count + 1
		end
	end

	return min_position
end

--通った回数が最小値より多いポジションを返す
function PointManager.ManyPassedPosition ()
	--ポイントの通った回数の最小値
	local point_count = MinPointFind()
	--ポイントのポジションを入れる
	local many_position = {}
	--many_positionの配列の長さ
	local count = 1
	--通った数が最小の値と同じPointのポジションを取得
	for i, point in ipairs(Point) do
		if point_count < point:GetAttribute("count") then
			many_position[count] = point.Position
			count = count + 1
		end
	end
	
	--向かうポイントが存在するポイントの数の半分より少なければ
	if #many_position < #Point / 2  then
		--ポイントを通った回数が最小値のポジションを入れる
		many_position = PointManager.MinPassedPosition()
	end

	return many_position
end

return PointManager

