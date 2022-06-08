import React from "react";

import APIClient from "lib/APIClient";

export default function({ authToken, savedCandidateId, parameterName, initialValue }) {
  function handleChange(event) {
    APIClient.updateSavedCandidate(authToken, savedCandidateId, { [parameterName]: event.target.value });
  };

  return (
    <textarea rows={5}
              cols={40}
              defaultValue={initialValue}
              onChange={handleChange} />
  );
};