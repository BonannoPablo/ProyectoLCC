import React from 'react';
const estilos= ['clue', 'clueSatisfecha'];
function Clue({ clue, satisfecha }) {
    return (
        <div className={estilos[satisfecha]} >
            {clue.map((num, i) =>
                <div key={i}>
                    {num}
                </div>
            )}
        </div>
    );
}



export default Clue;