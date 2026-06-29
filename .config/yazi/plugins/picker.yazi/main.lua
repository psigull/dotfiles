local get_selected_files = ya.sync(function()
    local paths = {}
    if cx.active.selected then
        for _, url in pairs(cx.active.selected) do
            table.insert(paths, tostring(url))
        end
    end
    return paths
end)

local get_hovered_file = ya.sync(function()
    local h = cx.active.current.hovered
    return h and tostring(h.url) or nil
end)

return {
    entry = function()
        local selected = get_selected_files()
        if #selected == 0 then
            local hovered = get_hovered_file()
            if hovered then table.insert(selected, hovered) end
        end

        local file = io.open("/tmp/yazi-picker", "w")
        if file then
            for _, path in ipairs(selected) do
                file:write(path .. "\n")
            end
            file:close()
        end
    end,
}
