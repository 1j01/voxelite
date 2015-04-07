
express = require 'express'
app = express()

app.use express.static "."

app.listen 3333
console.log 'listening on port 3333'

# chokidar = require 'chokidar'
# 
# watcher = chokidar.watch 'file, dir, or glob',
# 	ignored: /[\/\\]\./
# 	persistent: yes
# 
# watcher.on 'any', (path, stats)->
# 	if stats
# 		console.log 'File', path, 'changed size to', stats.size

