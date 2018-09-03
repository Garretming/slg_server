root = "./skynet/"
thread = 8
harbor = 0
logger = nil
logpath = "."
start = "main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
luaservice = root.."service/?.lua;"..root.."test/?.lua;"..root.."examples/?.lua"
lualoader = root .. "lualib/loader.lua"
lua_path = "./mjlib/?.lua;"..root.."lualib/?.lua;"..root.."lualib/?/init.lua"
lua_cpath = root .. "luaclib/?.so"
-- preload = "./examples/preload.lua"	-- run preload.lua before every lua service run
snax = root.."examples/?.lua;"..root.."test/?.lua"
-- snax_interface_g = "snax_g"
cpath = root.."cservice/?.so"
-- daemon = "./skynet.pid"

--our path
luaservice = "./login/?.lua;./login/?/main.lua;"..luaservice
lua_path = "./lualib/?.lua;"..lua_path
lua_cpath = "./luaclib/?.so;"..lua_cpath

LOGIN_WEB_PORT = 2017
