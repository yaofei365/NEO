LUA_INC := lua\src
LUA_LIB := lua\src 
MYSQL_INC := mysql\include
MYSQL_LIB := mysql\lib
CFLAG = -Wall -O2 -shared
CC = gcc

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

all: \
	lua \
	mysql \
	luasocket

lua : lua/src/lua.exe

mysql : mysql.dll

luasocket : luasocket/src/socket.dll

luasocket/src/socket.dll : lua
	cd luasocket; \
	make mingw DEBUG=DEBUG LUAINC_mingw=$(CURRENT_DIR)/lua/src/ LUALIB_mingw=$(CURRENT_DIR)/lua/src/lua53.dll; \

mysql.dll : luasql/src/luasql.c luasql/src/ls_mysql.c
	$(CC) $(CFLAG) -I$(LUA_INC) -L$(LUA_LIB) -I$(MYSQL_INC) -L$(MYSQL_LIB) -o $@ $^ -llua53 -lmysql

lua/src/lua.exe :
	cd lua && make mingw MYCFLAGS="-g -DNO_STDATOMIC"

clean:
	rm -rf mysql.dll
