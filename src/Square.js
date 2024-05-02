import React from 'react';
export default Square;
function Square({ value, onClick }) {
    function crearDesmarcado() {
        return (
            <button className='square' onClick={onClick}> {value = ''} </button>
        );
    }

    function crearMarcado() {
        return (
            <button className='square' onClick={onClick}> {value = ''}
                <div className='squareMarcado'> </div>
            </button>
        );
    }

    function crearCruzado() {
        return (
            <button className='square' onClick={onClick}> {value = 'X'} </button>
        );
    }

    function crearCuadrado() {
        switch (value) {
            case '#': return crearMarcado();
            case 'X': return crearCruzado();
            default: return crearDesmarcado();
        }

    }

    return crearCuadrado();
}