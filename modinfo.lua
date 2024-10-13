author = "幕夜之下"
-- from stringutil.lua

----------------------------------------------------------------------------
--- 版本号管理（暂定）：最后一位为内部开发版本号，或者修复小bug的时候进行增量。
---                   倒数第二位为对外发布的内容量版本号，有新内容的时候进行增量。
---                   第二位为大版本号，进行主题更新、大DLC发布的时候进行增量。
---                   第一位暂时预留。 
----------------------------------------------------------------------------
local the_version = "0.00.00.00000"

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- 语言相关的基础API  ---- 参数表： loc.lua 里面的localizations 表，code 为 这里用的index
  local function IsChinese()
      if locale == nil then
          return true
      else
          return locale == "zh" or locate == "zht" or locate == "zhr" or false
      end
  end
  local function ChooseTranslationTable_Test(_table)
      if ChooseTranslationTable then
          return ChooseTranslationTable(_table)
      else
          return _table["zh"]
      end
  end
--------------------------------------------------------------------------------------------------------------------------------------------------------
-- from stringutil.lua
  local function tostring(arg)
      if arg == true then
          return "true"
      elseif arg == false then
          return "false"
      elseif arg == nil then
          return "nil"
      end
      return arg .. ""
  end
  local function ipairs(tbl)
      return function(tbl, index)
          index = index + 1
          local next = tbl[index]
          if next then
              return index, next
          end
      end, tbl, 0
  end
--------------------------------------------------------------------------------------------------------------------------------------------------------
----
  local function GetName()
      local temp_table = {
          "Takanashi Hoshino", ----- 默认情况下(英文)
          ["zh"] = "小鸟游星野" ----- 中文
      }
      return ChooseTranslationTable_Test(temp_table)
  end

  local function GetDesc()
      local temp_table = {
          [[

  Takanashi Hoshino

  ]],
          ["zh"] = [[

  小鸟游星野

  ]]
      }
      local ret = the_version .. "  \n\n" .. ChooseTranslationTable_Test(temp_table)
      return ret
  end

--------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------

name = GetName()
description = GetDesc()

version = the_version ------ MOD版本，上传的时候必须和已经在工坊的版本不一样

api_version = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
forumthread = ""
dont_starve_compatible = true
dst_compatible = true
all_clients_require_mod = true

priority = 0 -- MOD加载优先级 影响某些功能的兼容性，比如官方Com 的 Hook

--------------------------------------------------------------------------------------------------------------------------------------------------------
--- OPTIONS
  local function Create_Number_Setting(start_num, stop_num, delta_num)
      local temp_options = {}
      local temp_index = 1
      delta_num = delta_num or 1
      local i = start_num

      -- 使用 while 循环代替 for 循环
      while i <= stop_num do
          temp_options[temp_index] = {
              description = tostring(i),
              data = i
          }
          temp_index = temp_index + 1
          i = i + delta_num
      end

      return temp_options
  end
  local function Create_Percent_Setting_With_1000_Mult(start_num, stop_num, delta_num) --- 百分比设置（1000倍扩大）
      local temp_options = Create_Number_Setting(start_num, stop_num, delta_num)
      for i, option in ipairs(temp_options) do
          option.description = (option.data / 10) .. "%"
      end
      return temp_options
  end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--- title 分隔符长度自适应函数
  local function GetTitle(name)
      -- 定义原始字符串的长度和填充字符
      local origin_length = 65 -- 原始字符串的总长度
      local padding_char = ' ' -- 用于填充的字符

      -- 获取 name 的长度
      local length = 0
      for _ in name:gmatch(".") do
          length = length + 1
      end

      -- 计算右边需要的空格数量
      local right_padding = origin_length - length

      -- 创建右侧的填充
      local right_padding_str = padding_char:rep(right_padding)

      -- 返回格式化后的字符串
      return name .. right_padding_str
  end
--------------------------------------------------------------------------------------------------------------------------------------------------------
--- 快捷键
  local keys_option = {
    {description = "KEY_A", data = "KEY_A"},
    {description = "KEY_B", data = "KEY_B"},
    {description = "KEY_C", data = "KEY_C"},
    {description = "KEY_D", data = "KEY_D"},
    {description = "KEY_E", data = "KEY_E"},
    {description = "KEY_F", data = "KEY_F"},
    {description = "KEY_G", data = "KEY_G"},
    {description = "KEY_H", data = "KEY_H"},
    {description = "KEY_I", data = "KEY_I"},
    {description = "KEY_J", data = "KEY_J"},
    {description = "KEY_K", data = "KEY_K"},
    {description = "KEY_L", data = "KEY_L"},
    {description = "KEY_M", data = "KEY_M"},
    {description = "KEY_N", data = "KEY_N"},
    {description = "KEY_O", data = "KEY_O"},
    {description = "KEY_P", data = "KEY_P"},
    {description = "KEY_Q", data = "KEY_Q"},
    {description = "KEY_R", data = "KEY_R"},
    {description = "KEY_S", data = "KEY_S"},
    {description = "KEY_T", data = "KEY_T"},
    {description = "KEY_U", data = "KEY_U"},
    {description = "KEY_V", data = "KEY_V"},
    {description = "KEY_W", data = "KEY_W"},
    {description = "KEY_X", data = "KEY_X"},
    {description = "KEY_Y", data = "KEY_Y"},
    {description = "KEY_Z", data = "KEY_Z"},
    {description = "KEY_F1", data = "KEY_F1"},
    {description = "KEY_F2", data = "KEY_F2"},
    {description = "KEY_F3", data = "KEY_F3"},
    {description = "KEY_F4", data = "KEY_F4"},
    {description = "KEY_F5", data = "KEY_F5"},
    {description = "KEY_F6", data = "KEY_F6"},
    {description = "KEY_F7", data = "KEY_F7"},
    {description = "KEY_F8", data = "KEY_F8"},
    {description = "KEY_F9", data = "KEY_F9"},
  }
--------------------------------------------------------------------------------------------------------------------------------------------------------
configuration_options = {
------------------------------------------------------------------------------------------------------------------------------------------------------
  -- {
  --   name = "LANGUAGE",
  --   label = "Language/语言",
  --   hover = "Set Language/设置语言",
  --   options = {
  --     {        description = "Auto/自动",        data = "auto"    }, 
  --     {        description = "English",        data = "en"    }, 
  --     {        description = "中文",        data = "ch"    }
  --   },
  --   default = "auto"
  -- }, 
  {name = "AAAA",label = IsChinese() and GetTitle("角色") or GetTitle("Character"),hover = "",options = {{description = "",data = 0}},default = 0},

------------------------------------------------------------------------------------------------------------------------------------------------------
  {
    name = "DIFFICULTY_MODE",
    label = IsChinese() and "游玩难度" or "Difficulty Mode",
    hover = IsChinese() and "游玩难度" or "Difficulty Mode",
    options = {
      {description = "OFF",data = false},
      {description = "ON",data = true},
    },
    default = false
  },
------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
  {name = "AAAA",label = IsChinese() and GetTitle("快捷键") or GetTitle("Hotkeys"),hover = "",options = {{description = "",data = 0}},default = 0},
  {
    name = "SPELL_RING_HOTKEY",
    label = IsChinese() and "技能环快捷键" or "Spell Ring Hotkey",
    hover = IsChinese() and "技能环快捷键" or "Spell Ring Hotkey",
    options = keys_option,
    default = "KEY_R",
  },
  {
    name = "SPECIAL_EQUIPMENT_SHOES_HOTKEY",
    label = IsChinese() and "鞋子快捷键" or "Shoes Hotkey",
    hover = IsChinese() and "鞋子快捷键" or "Shoes Hotkey",
    options = keys_option,
    default = "KEY_Z"
  },
------------------------------------------------------------------------------------------------------------------------------------------------------
  {name = "AAAA",label = IsChinese() and GetTitle("其他设置") or GetTitle("Other Settings"),hover = "",options = {{description = "",data = 0}},default = 0},
  {
    name = "PLAYER_REROLL_DATA_SAVE",
    label = IsChinese() and "角色重选数据保存" or "Player Reroll Data Save",
    hover = IsChinese() and "角色重选数据保存" or "Player Reroll Data Save",
    options = {
      {description = "OFF",data = false}, 
      {description = "ON",data = true}},
    default = true
  },
  {
    name = "DEBUGGING_MOD",
    label = "开发者模式",
    hover = "开发者模式",
    options = {
      {description = "OFF",data = false}, 
      {description = "ON",data = true}},
    default = false
  },


------------------------------------------------------------------------------------------------------------------------------------------------------
}
