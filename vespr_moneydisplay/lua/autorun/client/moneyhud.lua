local radius = 500
local lineHeight = 300
local squareHeight = 15
local money = {}
local money_cheque = {}

print("MoneyHud 1.0.1")
print("By Vespr")

CreateConVar("moneyhud_enabled", 1, FCVAR_ARCHIVE, "Enables money hud new UI")

local fontHeight = 100
surface.CreateFont("MoneyhudCashFont", {
    font = "Arial",
    extended = false,
    size = fontHeight,
    weight = 1000,
})

local function FindMoney()
    if GetConVar("moneyhud_enabled"):GetInt() == 0 then return end

    if not IsValid(LocalPlayer()) then return end
    local found = ents.FindInSphere(LocalPlayer():GetPos(), radius)
    money = {}
    for I = 1, #found do
        if found[I]:GetClass() == "spawned_money" then
            table.insert(money, found[I])
        elseif found[I]:GetClass() == "darkrp_cheque" then
            table.insert(money, found[I])
        end
    end
end

hook.Add("Initialize", "MoneyhudInit", function()
    timer.Create("MoneyhudTimer", 0.1, 0,
        function()
            FindMoney()
        end
    )
end)

hook.Add("PostDrawTranslucentRenderables", "MoneyhudDrawing", function()
    if GetConVar("moneyhud_enabled"):GetInt() == 0 then return end
    for I = 1, #money do
        local ent = money[I]
        if not IsValid(ent) then return end
        local pos = ent:GetPos() + ent:OBBCenter() + Vector(0, 0, ent:OBBMaxs().z)
        dY = pos.y - LocalPlayer():GetPos().y
        dX = pos.x - LocalPlayer():GetPos().x
        local ang = Angle(0, math.atan2(dY, dX) * 180 / math.pi, 0)
        ang:RotateAroundAxis(ang:Right(), 90)
        ang:RotateAroundAxis(ang:Up(), -90)
        local scale = 0.1
        cam.Start3D2D(pos, ang, scale)
            local x, y, w, h = -squareHeight / 2, squareHeight, squareHeight, squareHeight
            surface.SetDrawColor(Color(0, 0, 0, 255))
            surface.DrawRect(x, -y, w, h)
            local lineWidth = 4
            x, y, w, h = -lineWidth / 2, squareHeight, lineWidth, -lineHeight - 5
            surface.DrawRect(x, -y, w, h)
            local str = DarkRP.formatMoney(ent:Getamount())
            surface.SetFont("MoneyhudCashFont")
            x, y = -(surface.GetTextSize(str)) / 2, lineHeight + squareHeight + fontHeight + 15
            surface.SetTextPos(x, -y)
            surface.SetTextColor(Color(255, 255, 255, 255))
            surface.DrawText(str)
        cam.End3D2D()
    end
end)
