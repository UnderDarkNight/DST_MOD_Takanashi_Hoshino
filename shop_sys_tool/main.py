import time

print("欢迎使用商店系统工具！")
print("正在转换商品列表")
import _shop_items_list_translate_to_lua_file
print("商品列表文件转换完毕")

print("正在转换回收商品信息")
import _shop_recycle_list_translate_to_lua_file
print("回收列表转换完毕")


print("输出的lua文件在output牡蛎里，请复制替换到 ../key_modules_for_hoshino/10_shop_items_pool/ 文件夹中")
print("本工具运行完毕，可以直接退出，或者稍后自行退出")
time.sleep(15)

