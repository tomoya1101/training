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

--Pointの座標を渡す
function PointManager.PointPosition(position)
	for i, point in ipairs(Point) do	
		--pointの座標を取得
		position[i] = point.Position
	end
end

--Pointを通った回数が少ないポジションを返す
function PointManager.MinCountPosition ()
	--通った回数が少ない値を入れる
	local min_count = 100
	--通った回数が最小の値を探す
	for i, point in ipairs(Point) do
		if min_count > point:GetAttribute("count") then
			min_count = point:GetAttribute("count")
		--通った回数が100回以上なら	
		elseif point:GetAttribute("count") >= 100 then
			--通った回数をリセット
			point:SetAttribute("count",0)
		end
	end
	
	--Pointのポジションを入れる
	local min_position = {}
	--min_positionの配列の長さ
	local count = 1
	--通った数が最小の値と同じPointのポジションを取得
	for i, point in ipairs(Point) do
		if min_count == point:GetAttribute("count") then
			min_position[count] = point.Position
			print(min_position[count])
			count = count + 1
		end
	end
	
	return min_position
end

return PointManager

