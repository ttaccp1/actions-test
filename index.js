const bodyParser = require('body-parser')
const cookieParser = require('cookie-parser')
const app = require('express')()

app.use(bodyParser.json())
app.use(cookieParser())

app.get('/*', (req, res) => {
  res.send('Hello World!')
})

const port = 3200
app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
