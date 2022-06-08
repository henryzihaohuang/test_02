import React, { useState } from "react";

import Popup from "components/Popup";

const PipelineForm = ({ pipeline, onSubmit, onCancel }) => {
  const [name, setName] = useState(pipeline ? pipeline.name : "");

  const handleNameChange = (event) => {
    setName(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();

    if (pipeline) {
      onSubmit(pipeline, name);
    } else {
      onSubmit(name);
    }
  };

  const handleCancelClick = (event) => {
    event.preventDefault();

    onCancel();
  };

  return (
    <Popup title="Add a new pipeline"
           onOverlayClick={handleCancelClick}>
      <form onSubmit={handleSubmit}>
        <div className="field">
          <label>Name</label>

          <input type="text"
                 value={name}
                 onChange={handleNameChange} />
        </div>

        <div className="popup__popup__actions">
          <ul className="actions">
            <li>
              <a onClick={handleCancelClick}>Cancel</a>
            </li>
            <li>
              <input type="submit"
                     value="Save pipeline"
                     className="button" />
            </li>
          </ul>
        </div>
      </form>
    </Popup>
  );
};

export default PipelineForm;