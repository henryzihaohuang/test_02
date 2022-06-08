import React, { useState } from "react";

import APIClient from "lib/APIClient";
import PipelineForm from "components/PipelineForm";

const SaveToPipeline = ({ authToken, candidate, existingPipelines }) => {
  const [saved, setSaved] = useState(candidate.saved);
  const [pipelines, setPipelines] = useState(existingPipelines);
  const [formVisible, setFormVisible] = useState(false);
  const [listVisible, setListVisible] = useState(false);

  const handleSaveClick = async (event) => {
    event.preventDefault();

    if (!listVisible) {
      const pipelines = await APIClient.getPipelines(authToken);

      setPipelines(pipelines);
    }

    setListVisible(!listVisible);
  };

  const handlePipelineClick = async (pipelineId, event) => {
    event.preventDefault();

    await APIClient.saveToPipeline(authToken, candidate.id, pipelineId);

    setSaved(true);
    setListVisible(false);
  };

  const handleAddClick = (event) => {
    event.preventDefault();

    setFormVisible(!formVisible);
  };

  const handleSubmitPipeline = async (name) => {
    const pipeline = await APIClient.createPipeline(authToken, name);

    setPipelines(pipelines.concat([pipeline]));
    setFormVisible(false);
  };

  const handleCancelSavePipeline = () => {
    setFormVisible(false);
  };

  const handleOverlayClick = (event) => {
    event.preventDefault();

    setListVisible(false);
  };

  return (
    <div className="dropdown">
      <div className="dropdown__anchor">
        <a onClick={handleSaveClick}
           className={["button", "button--small", saved ? "button--active" : ""].join(" ")}>{saved ? "Saved" : "Save"}</a>
      </div>

      {listVisible && (
        <>
          <div className="dropdown__overlay"
               onClick={handleOverlayClick}></div>

          <div className="dropdown__content">
            <ul className="pipeline-list">
              {pipelines.length > 0 && pipelines.map((pipeline) => {
                return (
                  <li key={pipeline.id}>
                    <a onClick={handlePipelineClick.bind(null, pipeline.id)}>{pipeline.name}</a>
                  </li>
                );
              })}
              <li>
                <a onClick={handleAddClick}>+ Create a new pipeline</a>
              </li>
            </ul>
          </div>
        </>
      )}

      {formVisible && (
        <PipelineForm onSubmit={handleSubmitPipeline}
                      onCancel={handleCancelSavePipeline} />
      )}
    </div>
  );
};

export default SaveToPipeline;