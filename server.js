const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 5000;

console.log("Servidor arrancando...");

app.use(express.static(path.join(__dirname, 'build/web')));

app.get('/*', function (req, res) {
    res.sendFile(path.resolve(__dirname, 'build/web', 'index.html'));
});

app.listen(port, () => {
  console.log(`Servidor corriendo en el puerto ${port}`);
});
