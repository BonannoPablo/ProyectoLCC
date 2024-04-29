import React, { useState } from 'react';

export default function ToggleButton({onClick}) {
    const [isToggled, setIsToggled] = useState(false);
  
    const handleChange = () => {
        setIsToggled(!isToggled);
        if (onClick) {
            onClick();
        }
    };
  
    return (
      <button onClick={handleChange} className={`toggle-button ${isToggled ? 'on' : 'off'}`}>
            {isToggled ? '.' : 'X'}
      </button>
    );
  }