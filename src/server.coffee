
express = require 'express'
app = express()

app.use express.static "."
# app.get '/', (req, res)->

app.listen 3333
console.log "listening on port 3333"

# chokidar = require 'chokidar'
# 
# watcher = chokidar.watch 'file, dir, or glob',
# 	ignored: /[\/\\]\./
# 	persistent: yes
# 
# watcher.on 'change', (path, stats)->
# 	if stats
# 		console.log 'File', path, 'changed size to', stats.size

