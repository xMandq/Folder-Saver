desktopPath = os.getenv("USERPROFILE") .. "\\Desktop\\whatsapp data\\" -- put any folder name here
cachePath = os.getenv("USERPROFILE") .. "\\AppData\\Local\\Microsoft\\Windows\\INetCache\\IE\\" -- put any directory name here

os.execute('mkdir "' .. desktopPath .. '"')

function createFolderIfNotExist(folder)
    os.execute('mkdir "' .. folder .. '"')
end

function listFilesAndDirectories(folder)
    entries = {}
    p = io.popen('dir "' .. folder .. '" /b /s')
    for entry in p:lines() do
        table.insert(entries, entry)
    end
    p:close()
    return entries
end

function copyFileWithStructure(file, sourceBase, destBase)
    relativePath = file:sub(#sourceBase + 1)
    folderStructure = relativePath:match("(.*\\)")

    if folderStructure then
        createFolderIfNotExist(destBase .. folderStructure)
    end

    success = os.execute('copy "' .. file .. '" "' .. destBase .. relativePath .. '"')
    if success then
        print("Copied: " .. relativePath)
    else
        print("Failed to copy (file in use or locked): " .. relativePath)
    end
end

allEntries = listFilesAndDirectories(cachePath)

for _, entry in ipairs(allEntries) do
    copyFileWithStructure(entry, cachePath, desktopPath)
end
