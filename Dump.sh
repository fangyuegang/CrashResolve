#！/ban/bash
read -p "请输入项目所在的绝对路径:" local_path
ramparse_dir=$local_path/vendor/qcom/opensource/tools/linux_ramdump_parser_v2
ramdump=$local_path/vendor/qcom/opensource/tools/Dump_raw/
out=$local_path/vendor/qcom/opensource/tools/out
gdb=$local_path/prebuilts/gdb/linux_x86/bin/gdb
nm=$local_path/prebuilts/gcc/linux_x86/aarch64/aarch64_linux_android-4.9/bin/aarch64_linux_android_nm
objump=$local_path/prebuilts/gcc/linux_x86/aarch64/aarch64_linux_android-4.9/bin/aarch_linux_android_objump
get_addr_line=$local_path/prebuilts/gcc/linux_x86/aarch64/aarch64_linux_android-4.9/bin/aarch64_linux_android_addr2line

ResolveDump(){
	echo 1.脚本所在目录已经存在chipset_symbol_file文件
	echo 2.脚本所在目录不存在chipset_symbol_file
	echo "如果不存在,请先将转测试版本目录Bidding Doc\base_package\chipset_symbol_file.tar.gz文件移到脚本所在目录,再输入选择!"
	read -p "再输入您的选择:" chipset_symbol_is_existence
	
	if [ $chipset_symbol_is_existence -eq 1 ];
		then cp ./chipset_symbol_file/ap_symbol_file/root_img/vmlinux $vmlinux
	elif [ $chipset_symbol_is_existence -eq 2 ];
		then tar -zxvf chipset_symbol_file.tar.gz
		cp ./chipset_symbol_file/ap_symbol_file/root_img/vmlinux $vmlinux
	fi
	read -p "请将抓取的Dump文件移动到脚本所在目录，并输入文件夹名称(例如:Port_COM154):" Port_Com_file_name
	mkdir $local_path/vendor/qcom/opensource/tools/Dump_raw
	echo "正在移动过程中,请耐心等待!"
	cp ./$Port_Com_file_name/* $ramdump
	echo "正在移动过程中,请耐心等待!"
	cp $ramparse_dir
	echo ""
	touch local_settings.py
	echo -e "python ramparse.py -v $vmlinux -g $gdb -n $nm -j $objump -a $ramdump -o $out -x"
	echo ""
	read -p "请输入项目名称(例如:bengal):" Project_name
	echo "解析完成，请查看"$out"中解析的dmesg_TZ.txt文件"
}
GetSymbolTable(){
	echo 1.脚本所在目录已经存在chipset_symbol_file文件
	echo 2.脚本所在目录不存在chipset_symbol_file
	echo "如果不存在,请先将转测试版本目录Bidding Doc\base_package\chipset_symbol_file.tar.gz文件移到脚本所在目录,再输入选择!"
	read -p "再输入您的选择:" chipset_symbol_is_existence
	
	if [ $chipset_symbol_is_existence -eq 1 ];
		then cp ./chipset_symbol_file/ap_symbol_file/obj/KERNEL_OBJ/vmlinux $vmlinux
	elif [ $chipset_symbol_is_existence -eq 2 ];
		then tar -zxvf chipset_symbol_file.tar.gz
		cp ./chipset_symbol_file/ap_symbol_file/obj/KERNEL_OBJ/vmlinux $vmlinux
	fi
	$objump -t &vmlinux > $local_path/vendor/qcom/opensource/tools/symbol.txt
	echo "转化完成，文件存放在"$local_path/vendor/qcom/opensource/tools/symbol.txt
}
GetFilLine(){
	echo 1.脚本所在目录已经存在chipset_symbol_file文件
	echo 2.脚本所在目录不存在chipset_symbol_file
	echo "如果不存在,请先将转测试版本目录Bidding Doc\base_package\chipset_symbol_file.tar.gz文件移到脚本所在目录,再输入选择!"
	read -p "再输入您的选择:" chipset_symbol_is_existence
	
	if [ $chipset_symbol_is_existence -eq 1 ];
		then cp ./chipset_symbol_file/ap_symbol_file/obj/KERNEL_OBJ/vmlinux $vmlinux
	elif [ $chipset_symbol_is_existence -eq 2 ];
		then tar -zxvf chipset_symbol_file.tar.gz
		cp ./chipset_symbol_file/ap_symbol_file/obj/KERNEL_OBJ/vmlinux $vmlinux
	fi
	read -p "请输入发生crash的地址(system.map文件中查找基地址加偏移地址即Crash地址):" local_addr
	$get_addr_line -Cfe $vmlinux $local_addr
	echo "以上即问题发生位置"
}
GetAssembledFile(){
	read -p "请本地编译产生Crash文件二进制文件,并输入其二进制文件地址:" local_assembled_addr
	$objump -d $local_assembled_addr > $local_path/vendor/qcom/opensource/tools/que_mgt.s
	echo "汇编文件产生的位置:"$local_path/vendor/qcom/opensource/tools/que_mgt.s
}
echo 1.解析Dump文件
echo 2.反汇编vmlinux到符号表
echo 3.反汇编vmlinux得到指定位置
echo 4.反汇编二进制文件得到汇编文件
echo "作者:FangYueGang 邮箱:2251858097@qq.com"
echo ""
read -p "请输入您的选择:" CommandSelect
if [ $CommandSelect -eq 1 ];
	then ResolveDump
elif [ $CommandSelect -eq 2 ];
	then GetSymbolTable
elif [ $CommandSelect -eq 3 ];
	then GetFilLine
elif [ $CommandSelect -eq 4 ];
	then GetAssembledFile
fi
