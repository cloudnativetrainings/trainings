const express = require('express')
const app = express()
const message = 'Hello K8s from JS'

app.get('/', (req, res) => {
  res.send(message)
})

app.listen(80, () => {
  console.log(`Example app listening at http://localhost:80`)
})