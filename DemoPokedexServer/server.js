const express = require('express');
const path = require('path');
const fs = require('fs');
const app = express();
const port = 8000;

app.use(express.json());

// Serve the pokemons.json file on /api/pokemon
app.get('/api/pokemon', (req, res) => {
    const filePath = path.join(__dirname, 'resources', 'pokemons.json');

    const queryParams = req.query;
    const desiredStatusCode = queryParams.statusCode;
    
    // Read the pokemons.json file
    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading the file:', err);
            res.status(desiredStatusCode ?? 500).send('Error reading the file');
            return;
        }

        // Send the file content with status 200
        res.status(desiredStatusCode ?? 200).json(JSON.parse(data));
    });
});

// Server a specific Pokemon by ID
app.get('/api/pokemon/:id', (req, res) => {
    const filePath = path.join(__dirname, 'resources', 'pokemons.json');
    const id = parseInt(req.params.id, 10);

    const queryParams = req.query;
    const desiredStatusCode = queryParams.statusCode;

    // Read the pokemons.json file
    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading the file:', err);
            res.status(desiredStatusCode ?? 500).send('Error reading the file');
            return;
        }

        try {
            const pokemons = JSON.parse(data);
            const pokemon = pokemons.find(p => p.id === id);

            if (pokemon) {
                res.status(desiredStatusCode ?? 200).json(pokemon);
            } else {
                // Pokémon not found
                res.status(desiredStatusCode ?? 404).send(`Pokemon with ID ${id} not found`);
            }
        } catch (parseErr) {
            console.error('Error parsing JSON:', parseErr);
            res.status(desiredStatusCode ?? 500).send('Error parsing the file');
        }
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
