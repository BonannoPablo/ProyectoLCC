import React, { useState } from 'react';

export default function ToggleButton({onClick}) {
    const [isToggled, setIsToggled] = useState(false);
  
    const handleChange = () => {
        setIsToggled(!isToggled);
        if (onClick) {
            onClick();
        }
    };

    function crearBotonMarcarX() {
        return (
            <button onClick={handleChange} className={`toggle-button on`}> {'X'} </button>
        );
    }

    function crearBotonMarcarNumeral() {
        return (
            <button onClick={handleChange} className={`toggle-button off`}>
                <div className='squareMarcado'> </div>
            </button>
        );
    }

    function crearBoton() {
        if (isToggled) {
            return crearBotonMarcarX();
        }
        else {
            return crearBotonMarcarNumeral();
        }
    }
  
    return crearBoton();
  }