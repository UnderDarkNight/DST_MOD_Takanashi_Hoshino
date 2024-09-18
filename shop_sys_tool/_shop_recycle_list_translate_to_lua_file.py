# -*- coding: utf-8 -*-

"""
    本文件是将指定的recycle_items_list.xlsx 文件，转换成指定的 商品数据 lua 文件。

    输出的lua文件，需要放到 /key_modules_for_hoshino/10_shop_items_pool 文件夹中。

    05_recycle_items.lua


"""

import pandas as pd
import openpyxl
import os
import sys
import time


output_file_name = "05_recycle_items.lua"

# 读取excel文件
xlsx_file_name = "recycle_items_list.xlsx"
xlsx_file_front_addr = "shop_sys_tool/"
xlsx_file = ""
# 进行路径测试，如果直接读取文件不存在，则在前面加上路径,使用 两重 try 语句
try:
    xlsx_file = pd.read_excel(xlsx_file_name)
except:
    try:
        xlsx_file = pd.read_excel(xlsx_file_front_addr + xlsx_file_name)
    except:
        print(" recycle_items_list.xlsx 文件不存在")
        time.sleep(30)
        exit(0)

"""

    # 先读取全部数据，并分类好 那些是 string ，哪些是 标记位替换，哪些是 数值
    # 从第二行开始读取。第一行是标题行

    第A列参数为名字，无视丢弃。
    第B列参数为商品prefab，直接作为index
    第C列参数为商品价格，强制转换成数字并向上取整。


"""


data_rows_count = len(xlsx_file) # 获取行数
data = []

for i in range(data_rows_count):
    try:
        # name = xlsx_file.iloc[i, 0]
        prefab = xlsx_file.iloc[i, 1]
        num = int(xlsx_file.iloc[i, 2])
        
        row_data = {
            # 'name': name,
            'prefab': prefab,
            'num': num
        }
        data.append(row_data)
        
    except Exception as e:
        print(f"Error processing row {i + 2}: {e}")  # 加2是因为Excel的行号是从1开始的

# print(data)


"""

    以下是单个lua文件生成后的样式。根据这个样式进行分类合并。以text写入的形式，写入到lua文件中。


    TUNING.HOSHINO_SHOP_ITEMS_RECYCLE_LIST = {
        ["default"] = 1,
        ["log"] = 1,
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

...
# 输出文件的完整路径
output_file_path = os.path.join(output_folder, output_file_name)

# 开始写入Lua文件
with open(output_file_path, 'w', encoding='utf-8') as lua_file:
    lua_file.write("TUNING.HOSHINO_SHOP_ITEMS_RECYCLE_LIST = {\n")

    for index, row in enumerate(data):
        lua_file.write(f'    ["{row["prefab"]}"] = {row["num"]}')
        
        # 只有不是最后一行才添加逗号
        if index != len(data) - 1:
            lua_file.write(',\n')
        else:
            lua_file.write('\n')  # 最后一行不带逗号
        
    lua_file.write("}\n")

print(f"Lua文件已成功生成至：{output_file_path}")