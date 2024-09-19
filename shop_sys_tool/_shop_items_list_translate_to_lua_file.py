# -*- coding: utf-8 -*-

"""
    本文件是将指定的shop_items_list.xlsx 文件，转换成指定的 商品数据 lua 文件。

    输出的lua文件，需要放到 /key_modules_for_hoshino/10_shop_items_pool 文件夹中。

    拆分成4个lua 文件：
        01_gray_items.lua
        02_blue_items.lua
        03_golden_items.lua
        04_colourful_items.lua

    【重要】需要使用 pandas 和 openpyxl 库。 使用命令：      pip install pandas openpyxl

"""

import pandas as pd
import openpyxl
import os
import sys
import time

#分裂成4个文件名：
output_file_names = {}
output_file_names["gray"] = "01_gray_items.lua"
output_file_names["blue"] = "02_blue_items.lua"
output_file_names["golden"] = "03_golden_items.lua"
output_file_names["colourful"] = "04_colourful_items.lua"


# 读取excel文件
xlsx_file_name = "shop_items_list.xlsx"
xlsx_file_front_addr = "shop_sys_tool/"
xlsx_file = ""
# 进行路径测试，如果直接读取文件不存在，则在前面加上路径,使用 两重 try 语句
try:
    xlsx_file = pd.read_excel(xlsx_file_name)
except:
    try:
        xlsx_file = pd.read_excel(xlsx_file_front_addr + xlsx_file_name)
    except:
        print(" shop_items_list.xlsx 文件不存在")
        time.sleep(30)
        exit(0)


    



# xlsx_file = pd.read_excel(xlsx_file_name)
# print(xlsx_file)

"""

    # 先读取全部数据，并分类好 那些是 string ，哪些是 标记位替换，哪些是 数值
    # 从第二行开始读取。第一行是标题行

    第A列参数为名字，无视丢弃。
    第B列为物品prefab ，为文本。index 为 prefab
    第C列为物品稀有类型，为文本。需要自动进行合并， "item_slot_" + item_type ".tex"  。index 为 bg 。同时为今后分裂成4个文件做准备。 gray blue golden colourful
    第D列为货币类型，为文本。暂时只有【信用币 credit_coins】【 青辉石 laplite 】。index 为 price_type
    第E列为货币数量，为数值。向上取整，不能有小数点。 index 为 price
    第F列为单次购买数量，为数值。向上取整，不能有小数点。 index 为 num_to_give
    第G列为商店等级，为数值。向上取整，不能有小数点。 index 为 level
    第H列为物品标签归属，为文本。暂时只有【 特殊资源 special 】   【 基础物资 normal 】 。index 为 type
    第I列为物品贴图atlas 。为文本。如果字段为official，则按照prefab 合并成 文本 'GetInventoryItemAtlas("log.tex")' 。index 为 atlas
    第J列为物品贴图tex。为文本。index 为 image。如果字段是 official 则进行prefab合并:  prefab + ".tex" 。
    第K列为常驻标记位，强制转换为文本。并且如果是 yes 则为 true ，否则为 false 。index 为 is_permanent

    额外归类 index 为 belong 。直接读取C列，为文本，不进行任何合并。

"""

data_rows_count = len(xlsx_file) # 获取行数(pandas已经默认排除掉首行了。得到的有效数据0位为execl里的第二行)
print(data_rows_count)
data = []
for i in range(0, data_rows_count):
    # print(i)
    try:
        row_data = {}
        row_data["prefab"] = xlsx_file.iloc[i, 1]
        row_data["bg"] = "item_slot_" + xlsx_file.iloc[i, 2] + ".tex"
        row_data["price_type"] = xlsx_file.iloc[i, 3]
        row_data["price"] = int(xlsx_file.iloc[i, 4])
        row_data["num_to_give"] = int(xlsx_file.iloc[i, 5])
        row_data["level"] = int(xlsx_file.iloc[i, 6])
        row_data["type"] = xlsx_file.iloc[i, 7]
        atlas = xlsx_file.iloc[i, 8]
        if atlas == "official":
            row_data["atlas"] = 'GetInventoryItemAtlas("' + row_data["prefab"] + '.tex")'
        else:
            row_data["atlas"] = atlas

        image = xlsx_file.iloc[i, 9]
        if image == "official":
            row_data["image"] = row_data["prefab"] + ".tex"
        else:
            row_data["image"] = image

        is_permanent = str(xlsx_file.iloc[i, 10])
        if is_permanent == "yes":
            row_data["is_permanent"] = True
        else:
            row_data["is_permanent"] = False


        row_data["belong"] = xlsx_file.iloc[i, 2]

        data.append(row_data)
    except Exception as e:
        print(f"Error processing row {i}: {e}")

# print(data)

# 分类成4个文件
# gray blue golden colourful
data_departed = {}
data_departed["gray"] = []
data_departed["blue"] = []
data_departed["golden"] = []
data_departed["colourful"] = []

for single_data in data:
    # print(single_data)
    belong = single_data["belong"]
    data_departed[belong].append(single_data)

"""

    以下是单个lua文件生成后的样式。根据这个样式进行分类合并。以text写入的形式，写入到lua文件中。


    TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}
    TUNING.HOSHINO_SHOP_ITEMS_POOL["blue"] = {        
        ------------------------------------------------------------------
        --- 示例物品 木头
            {
                prefab = "log",
                bg = "item_slot_blue.tex",
                icon = {atlas = GetInventoryItemAtlas("log.tex"),image = "log.tex"},
                price = 1, --- 价格
                num_to_give = 1, --- 单次购买的数量。【注意】nil 自动处理为1。
                price_type = "credit_coins",  -- 货币需求。
                level = 0, --- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。
                type = "normal", --- 类型。normal  special  。这个可以不下发。
            },
        ------------------------------------------------------------------
    }


"""
# 获取当前脚本所在的目录
# script_dir = os.path.dirname(os.path.abspath(__file__))
#--------------------------------------------------------------------------------------------------
def get_resource_path(relative_path):
    """
    获取资源文件的绝对路径。这个函数会根据程序是作为一个.py文件还是一个.exe文件来调整路径。
    
    参数:
    relative_path (str): 相对于.py文件或.exe文件的相对路径。
    
    返回:
    str: 资源文件的绝对路径。
    """
    if hasattr(sys, '_MEIPASS'):
        # 我们是在使用 PyInstaller 创建的 .exe 文件环境下运行
        base_path = sys._MEIPASS
    else:
        # 我们是在普通的.py文件环境下运行
        base_path = os.path.abspath(".")

    return os.path.join(base_path, relative_path)

def get_current_dir():
    """
    获取当前工作目录的绝对路径。这个函数会返回程序（无论是.py还是.exe）的目录。
    
    返回:
    str: 当前工作目录的绝对路径。
    """
    if getattr(sys, 'frozen', False):
        # 如果我们是冻结的应用程序，则使用 sys.executable
        application_path = os.path.dirname(sys.executable)
    elif __file__:
        # 否则，使用包含当前脚本的目录
        application_path = os.path.dirname(__file__)
    
    return application_path

resource_path = get_resource_path('example.txt')
print(f"资源文件的位置: {resource_path}")

current_dir = get_current_dir()
print(f"当前工作目录的位置: {current_dir}")
#--------------------------------------------------------------------------------------------------

script_dir = current_dir

# 设置输出文件夹路径为当前脚本所在目录下的output文件夹
output_folder = os.path.join(script_dir, 'output')

# 如果output文件夹不存在，则创建它
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 确保输出文件夹存在
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 根据分类后的数据data_departed，分割成4个lua文件，逐行进行写入
for rarity, items in data_departed.items():
    output_file_path = os.path.join(output_folder, output_file_names[rarity])
    print("Writing to file: ", output_file_path)
    with open(output_file_path, 'w', encoding='utf-8') as f:
        # 写入头部信息
        f.write('TUNING.HOSHINO_SHOP_ITEMS_POOL = TUNING.HOSHINO_SHOP_ITEMS_POOL or {}\n')
        f.write('TUNING.HOSHINO_SHOP_ITEMS_POOL["{}"] = {{\n'.format(rarity))
        
        for item in items:
            f.write('-----------------------------------------------------------\n')  # 分隔符
            f.write('--  {}\n'.format(item["prefab"]))  # 物品名称
            f.write('{\n')  # 开始物品描述
            
            f.write('  prefab = "{}",\n'.format(item["prefab"]))
            f.write('  bg = "{}",\n'.format(item["bg"]))
            f.write('  icon = {{atlas = {}, image = "{}"}},\n'.format(item["atlas"], item["image"]))
            f.write('  price = {}, -- 价格\n'.format(item["price"]))
            f.write('  num_to_give = {}, -- 单次购买的数量。【注意】nil 自动处理为1。\n'.format(item["num_to_give"]))
            f.write('  price_type = "{}", -- 货币需求。\n'.format(item["price_type"]))
            f.write('  level = {}, -- 等级限制。这个可以不下发。用来解锁。 【注意】做nil 自动处理为0。\n'.format(item["level"]))
            f.write('  type = "{}", -- 类型。normal special 。这个可以不下发。\n'.format(item["type"]))
            f.write('  is_permanent = {}, -- 是否永久。0 非永久 1 永久\n'.format("true" if item["is_permanent"] else "false"))
            
            f.write('},\n')  # 结束物品描述
        
        f.write('-----------------------------------------------------------\n')  # 最后一个分隔符
        f.write('}\n')  # 结束数组定义

