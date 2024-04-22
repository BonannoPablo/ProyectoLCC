import React, { useEffect, useState } from 'react';
import PengineClient from './PengineClient';
import Board from './Board';
import ToggleButton from './ToggleButton';

let pengine;

function Game() {

// State
const [grid, setGrid] = useState(null);
const [rowsClues, setRowsClues] = useState(null);
const [colsClues, setColsClues] = useState(null);
const [waiting, setWaiting] = useState(false);
const [rowsSat, setRowsSat] = useState(new Array(5).fill(0));
const [colsSat, setColsSat] = useState(new Array(5).fill(0));

useEffect(() => {
  // Creation of the pengine server instance.    
  // This is executed just once, after the first render.    
  // The callback will run when the server is ready, and it stores the pengine instance in the pengine variable. 
    PengineClient.init(handleServerReady);
}, []);

function handleServerReady(instance) {
  pengine = instance;
  const queryS = 'init(RowClues, ColumClues, Grid)';
  pengine.query(queryS, (success, response) => {
    if (success) {
      setGrid(response['Grid']);
      setRowsClues(response['RowClues']);
      setColsClues(response['ColumClues']);
    }
  });
}

function handleClick(i, j) {
  // No action on click if we are waiting.
  if (waiting) {
    return;
  }
  // Build Prolog query to make a move and get the new satisfacion status of the relevant clues.    
  const squaresS = JSON.stringify(grid).replaceAll('"_"', '_'); // Remove quotes for variables. squares = [["X",_,_,_,_],["X",_,"X",_,_],["X",_,_,_,_],["#","#","#",_,_],[_,_,"#","#","#"]]
  const content = '#'; // Content to put in the clicked square.
  const rowsCluesS = JSON.stringify(rowsClues);
  const colsCluesS = JSON.stringify(colsClues);
  const queryS = `put("${content}", [${i},${j}], ${rowsCluesS}, ${colsCluesS}, ${squaresS}, ResGrid, RowSat, ColSat)`; // queryS = put("#",[0,1],[], [],[["X",_,_,_,_],["X",_,"X",_,_],["X",_,_,_,_],["#","#","#",_,_],[_,_,"#","#","#"]], GrillaRes, FilaSat, ColSat)
  setWaiting(true);
  pengine.query(queryS, (success, response) => {
    if (success) {
      setGrid(response['ResGrid']);
      const rowSat = response['RowSat'];
      const colSat = response['ColSat'];
      const rowsSatAux = rowsSat.slice();
      const colsSatAux = colsSat.slice();

      rowsSatAux[i] = rowSat;
      setRowsSat(rowsSatAux)
      colsSatAux[j] = colSat;
      setColsSat(colsSatAux);
  }
    setWaiting(false);
  });
}

if (!grid) {
  return null;
}

const statusText = 'Keep playing!';
return (
  <div className="game">
    <Board
     grid={grid}
     rowsClues={rowsClues}
     colsClues={colsClues}
     onClick={(i, j) => handleClick(i, j)}
     rowsSat = {rowsSat}
     colsSat = {colsSat}
    />
    <div className="game-info">
      {statusText}
    </div><ToggleButton/>
  </div>
);
}

export default Game;