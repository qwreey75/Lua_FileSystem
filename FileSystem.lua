local Module = {}

function Split(String, Pattern)
	local Pattern = Pattern or "%s"
	local ReturnTable = {}
	for Part in string.gmatch(String, "([^"..Pattern.."]+)") do
		table.insert(ReturnTable, Part)
	end
	return ReturnTable
end

--// 하위 파일들 얻기(nt 계열 os 전용) => table
function Module:GetFiles(StringDir)
	return io.popen(([[dir "%s" /b /a-d]]):format(StringDir)):lines()
end

--// 하위 폴더들 얻기(nt 계열 os 전용) => table
function Module:GetFolders(StringDir)
	return io.popen(([[dir "%s" /b /ad]]):format(StringDir)):lines()
end

--// 하위 파일/폴더들 얻기(nt 계열 os 전용) => table
function Module:GetChildren(StringDir)
	return io.popen(([[dir "%s" /b]]):format(StringDir)):lines()
end

--// 상위 디렉터리 얻기 => Dir:string
function Module:GetParent(StringDir)
	local SplitDir = Split(StringDir,"/")
	local FileNameLen = #SplitDir[#SplitDir]
	local StringDir = string.sub(StringDir,#StringDir-FileNameLen-1,#StringDir)
	return StringDir
end

--// 파일의 확장자 얻기 => Ext:string
function Module:GetExtension(StringDir)
	if not string.find(StringDir,"%.") then
		return ""
	end
	local SplitDir = Split(StringDir,"%.")
	return SplitDir[#SplitDir]
end

--// 파일/폴더 지우기 => nil
function Module:Remove(StringDir)
	os.remove(StringDir)
	return nil
end

--// 파일/폴더 옴기기 => Dir:string
function file:Move(StringDir, ToDir)
	local FileName do
		local SplitDir = Split(StringDir,"/")
		local FileName = SplitDir[#SplitDir]
	end
	
	local ToDir = ToDir .. "/" .. FileName
	os.rename(StringDir,ToDir)
	
	return ToDir
end

--// 이름 바꾸기(파일의 경우 확장자 포함) => Dir:string
function file:Rename(StringDir,Name)
	local ToDir = Module:GetParent(StringDir) .. "/" .. Name
	os.rename(StringDir,ToDir)
	return ToDir
end


return Module