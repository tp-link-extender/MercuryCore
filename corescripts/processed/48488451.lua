local a=Instance.new'Frame'a.Position=UDim2.new(0.5,-165,0.5,-175)a.Size=UDim2.
new(0,330,0,350)a.Style=Enum.FrameStyle.RobloxRound a.ZIndex=4 a.Name='Popup'a.
Visible=false a.Parent=script.Parent local b=a:clone()b.Size=UDim2.new(1,16,1,16
)b.Position=UDim2.new(0,-8,0,-8)b.Name='Darken'b.ZIndex=1 b.Parent=a local c=
Instance.new'TextButton'c.Position=UDim2.new(0,20,0,270)c.Size=UDim2.new(0,100,0
,50)c.Font=Enum.Font.ArialBold c.FontSize=Enum.FontSize.Size24 c.Style=Enum.
ButtonStyle.RobloxButton c.TextColor3=Color3.new(0.9725490196078431,
0.9725490196078431,0.9725490196078431)c.Text='Yes'c.ZIndex=5 c.Name=
'AcceptButton'c.Parent=a local d=c:clone()d.Position=UDim2.new(1,-120,0,270)d.
Text='No'd.Name='DeclineButton'd.Parent=a local e=c:clone()e.Name='OKButton'e.
Text='OK'e.Position=UDim2.new(0.5,-50,0,270)e.Visible=false e.Parent=a local f=
Instance.new'ImageLabel'f.BackgroundTransparency=1 f.Position=UDim2.new(0.5,-140
,0,0)f.Size=UDim2.new(0,280,0,280)f.ZIndex=3 f.Name='PopupImage'f.Parent=a local
g=Instance.new'ImageLabel'g.BackgroundTransparency=1 g.Size=UDim2.new(1,0,1,0)g.
Image='http://www.roblox.com/asset/?id=47574181'g.Name='Backing'g.ZIndex=2 g.
Parent=f local h=Instance.new'TextLabel'h.Name='PopupText'h.Size=UDim2.new(1,0,
0.8,0)h.Font=Enum.Font.ArialBold h.FontSize=Enum.FontSize.Size36 h.
BackgroundTransparency=1 h.Text="Hello I'm a popup"h.TextColor3=Color3.new(
0.9725490196078431,0.9725490196078431,0.9725490196078431)h.TextWrap=true h.
ZIndex=5 h.Parent=a script:remove()