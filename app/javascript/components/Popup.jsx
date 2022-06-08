import React from "react";

const Popup = ({ title, children, onOverlayClick }) => {
  const handleBackgroundClick = (event) => {
    if (event.target.type !== "submit") {
      event.preventDefault();
    };
  };

  return (
    <div className="popup"
         onClick={handleBackgroundClick}>
      <div className="popup__overlay"
           onClick={onOverlayClick}></div>

      <div className="popup__popup">
        <div className="popup__popup__title">{title}</div>

        <div className="popup__popup__content">
          {children}
        </div>
      </div>
    </div>
  );
};

export default Popup;