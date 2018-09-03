#!/bin/bash

#根目录
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
echo "$SHELL_FOLDER"
#skynet目录
SKYNET_PATH="./skynet/"

#运行脚本
run()
{	
	#检查启动程序
	if [ ! -x "${2}" ]; then
		echo "你妹啊，启动程序没有,${2} "
		exit
	fi
	#关闭程序
	if [ -a "${TMP_PATH}kill_${1}.sh" ]; then
		echo "关闭程序："
		sh ${TMP_PATH}kill_${1}.sh
	fi
	#设置日志存储
	DATA_DAY=`date +%Y-%m-%d`
	DATA_SECOND=`date +%Y-%m-%d-%H-%M-%S`

	LOG_NAME="${LOG_PATH}${1}_${DATA_DAY}.log"

	# BACKUP_LOG_NAME="${LOG_PATH}${1}_${DATA_SECOND}_old.log"
	# echo "$LOG_NAME"
	#备份日志
	if [ -a "${LOG_NAME}" ]; then
		# mv ${LOG_NAME} ${BACKUP_LOG_NAME}
		rm -rf ${LOG_NAME}
	fi
	
	# 保存配置到config文件
	# echo "logger = '${1}_${DATA_DAY}.log'"> ${4} 2>&1 &
	# echo "logpath = './log'">> ${4} 2>&1 &
	# echo "logpath = '${LOG_PATH}'">> ${4} 2>&1 &
	echo "logger = '${LOG_NAME}'"> ${4} 2>&1 &

	
	
	#后台启动
	# nohup ${2} ${3} >> ${LOG_NAME} 2>&1 &
	nohup ${2} ${3} &



	# #生成关闭的程序
	echo "#!/bin/bash" > ${TMP_PATH}kill_${1}.sh
	echo "echo 'run: ${2} ${3} pid: $!'" >> ${TMP_PATH}kill_${1}.sh	

	echo "kill -9 $!" >> ${TMP_PATH}kill_${1}.sh
	chmod 777 ${TMP_PATH}kill_${1}.sh

			#显示运行的程序
	echo "运行程序："
	echo "run:$2 $3  pid:$!  log:${LOG_NAME} "
	# #打印启动错误
	sleep 3
	if [ -s "${LOG_NAME}" ]; then
		echo "启动日志："
		cat ${LOG_NAME}
	fi
	sleep 1
}

echo "  >>---------- 开始 ----------"

# 初始化子项目
git submodule update --init
# git submodule update --init --recursive

echo "  >>---------- 处理protocbuf ----------"

# mv ./3rd/pbc/Makefile ./3rd/pbc/Makefile.bak
mv ./3rd/pbc/binding/lua53/Makefile ./3rd/pbc/binding/lua53/Makefile.bak
# cp ./3rd/pbcMakefile ./3rd/pbc/Makefile
cp ./3rd/mypbcluaMakefile ./3rd/pbc/binding/lua53/Makefile
echo "  >>---------- 编译pbc库 ----------"
cd ./3rd/pbc/ && make && cd ./binding/lua53/ && make && cd ../../../../

echo "  >>---------- 拷贝协议so模块 ----------"
cp -f ./3rd/pbc/binding/lua53/protobuf.so ./luaclib/ && cp -f ./3rd/pbc/binding/lua53/protobuf.lua ./lualib/


# 生成协议
echo "  >>---------- 生成协议----------"
protoc -o ./proto/wegame.pb ./proto/wegame.proto



echo "  >>---------- 进入skynet目录 ----------"
echo ""
cd ${SKYNET_PATH};

echo ""
echo "  >>---------- 编译 ----------"
echo ""
make macosx;
echo ""
cd ..
#日志目录
LOG_PATH="./log/"
if [ ! -x "$LOG_PATH" ]; then
	mkdir "$LOG_PATH"
fi

#tmp目录
TMP_PATH="./tmp/"
if [ ! -x "$TMP_PATH" ]; then
	mkdir "$TMP_PATH"
fi


echo ""
echo "  >>---------- 执行 ---------"
echo ""
run a ./skynet/skynet config logpath

echo ""
echo "  >>---------- 结束 ----------"
