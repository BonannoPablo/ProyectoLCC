import React from 'react';

function Square({ value, onClick }) {
    let valueAux;
    switch(value){
        case '#': valueAux = 'X'
            break;
        case 'X': valueAux = '.'
            break;
    }
    return (
        <button className="square" onClick={onClick}>
            {value !== '_' ? valueAux : null}
        </button>
    );
}

export default Square;